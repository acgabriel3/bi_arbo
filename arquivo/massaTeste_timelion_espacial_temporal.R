library(dplyr)
library(data.table)
library(lubridate)
library(elastic)
library(EnvStats)

source("CRISPDM.R")

#Declarando o operador %% para concatenar strings
'%%' <- function(x, y) paste0(x,y) 

dias <- 1:364

#Definindo data inicial para construir um vetor com todos os dias do ano, para cada ano escolhido
dataInicial <- "2013-01-01"

dataInicial <- as.Date(dataInicial)

#Criando um vetor com 364 elementos, todos preenchidos com a data inicial. Este serah usado para calcular cada dia do ano a partir da data inicial
colunaData <- rep(dataInicial, 364)

#construidos os dias 02 ao 365 do ano por meio da soma do vetor de dias com a data inicial, utilizando a funcao "day" que faz operacoes no dominio dos dias
day(colunaData) <- day(colunaData) + dias

#Criando um vetor com os 365 dias do ano, por meio da adicao da data inicial ao vetor, que seria o primeiro dia do ano
colunaData <- c(dataInicial, colunaData)


coluna_data_2013 <- colunaData
aux <- colunaData

#Criado vetor de anos para nomear variaveis de coluna_data_[ano], por meio de meta programacao
anos <- c(2014, 2015, 2016, 2017, 2018, 2019)

#Cria as colunas para os restantes dias do ano, o valor eh calculado por "aux" e a variavel eh salva globalmente com o nome dado pelo parse da metaprogramacao
for(i in 1:length(anos)) {
  
  year(aux) <- year(aux) + 1
  
  eval(parse(text = 
               "coluna_data_" %% anos[i] %% "<- aux"               
             
  ))
  
}

#***
#Criar valores aleatorio para cada uma das colunas de anos, que tenham a ver com pluviosidade
#nomear colunas com nomes entendiveis
#Definido local em que chove em aproximadamente 50 % do ano

#Criado vetor com todos os anos disponiveis
anos <- c(2013, anos)

#***
#Eh possivel que os Estados nao devam ser aleatorios, mas que seja definido um vetor de pluviosidade aleatorio para cada um dos Estados 
#Criar aleatoriamente estados (4 regioes) para cada um dos dados encontrados

ufs <- c("DF", "AC", "RJ", "SP")


#criado um data frame (df) para cada ano, com dados aleatorio de pluviosidade, ao mesmo tempo estes data frames sao unificados em um soh denomiado "pluviosidade"
popula_variavel_detalhe_dias(fatoresDetalhe = ufs, 
                             intervaloMedia = c(1,4), 
                             intervaloSd = c(1, 4), 
                             nomeFator = "UF", 
                             intervaloTruncado = c(0,60),
                             anos = anos, 
                             nomeVariavel = "pluviosidade")

pluviosidade <- resultado

popula_variavel_detalhe_dias(fatoresDetalhe = ufs, 
                             intervaloMedia = c(1,4), 
                             intervaloSd = c(1, 4), 
                             nomeFator = "UF", 
                             intervaloTruncado = c(0,60),
                             anos = anos, 
                             nomeVariavel = "evaporacao")

pluviosidade <- pluviosidade %>%
                  inner_join(resultado)



municipios <- c("GuarulhosSP", "CampinasSP", "OsascoSP", "SorocabaSP", "NiteroiRJ", "PetropolisRJ")

popula_variavel_detalhe_dias(fatoresDetalhe = municipios, 
                             intervaloMedia = c(0.2,0.4), 
                             intervaloSd = c(0.3, 0.7), 
                             nomeFator = "municipio", 
                             intervaloTruncado = c(0,60),
                             anos = anos, 
                             nomeVariavel = "pluviosidade")

pluviosidadeMun <- resultado

popula_variavel_detalhe_dias(fatoresDetalhe = municipios, 
                             intervaloMedia = c(0.2,0.4), 
                             intervaloSd = c(0.3, 0.7), 
                             nomeFator = "municipio", 
                             intervaloTruncado = c(0,60),
                             anos = anos, 
                             nomeVariavel = "evaporacao")

pluviosidadeMun <- pluviosidadeMun %>%
                      inner_join(resultado)


#***
#como realizar as agregacoes por ano? Segue o exemplo abaixo

#A funcao setDT cria um data frame a partir das colunas, agregando os valores por determinada caracteristica (fator) nas colunas escolhidas. O funcionamento eh semelhante ao group_by do dplyr ou do SQL comum
#Abaixo a pluviosidade eh agregada por soma, para semana, mes e ano. 
dfSemana <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = year(data), fator = week(data), UF = UF)]
dfMes <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = year(data), fator = month(data), UF = UF)]
dfAno <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = year(data), UF = UF)]

#Aqui os dados de semana, mes e dia sao formatados para o formato elasticsearch definido pelo SVDados yyyy-mm-ddTHH-MM-SS, por meio da funcao do pacote CRISPDM. As colunas sao reordenadas para o padrao definido no SVDados
dfSemana$dataSemanal <- paste(dfSemana$yr, dfSemana$fator, sep = "")
dfSemana$dataSemanal <- cria_data_padrao_fator_peso(dfSemana$dataSemanal, posAno = c(1,4), posFator = c(5,6), tipoFator = "week")
dfSemana <- dfSemana[,c("dataSemanal", "UF", "pluviosidade", "evaporacao")]

dfMes$dataMensal <- paste(dfMes$yr, dfMes$fator, sep = "")
dfMes$dataMensal <- cria_data_padrao_fator_peso(dfMes$dataMensal, posAno = c(1,4), posFator = c(5,6), tipoFator = "month")
dfMes <- dfMes[,c("dataMensal", "UF", "pluviosidade", "evaporacao")]

dfAno$dataAnual <- paste(dfAno$yr, "-12-31T23:59:59", sep = "")
dfAno <- dfAno[,c("dataAnual", "UF", "pluviosidade", "evaporacao")]

pluviosidade <- pluviosidade[,c("data", "UF", "pluviosidade", "evaporacao")]
colnames(pluviosidade) <- c("dataDiaria", "UF", "pluviosidade", "evaporacao")
pluviosidade$dataDiaria <- paste(pluviosidade$dataDiaria, "T23:59:59", sep = "")


#**********************************************************************************************AGREGACOES PARA MUNICIPIO*********************************************************************************************
#********************************************************************************************************************************************************************************************************************
df_semana_mun <- setDT(pluviosidadeMun)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = year(data), fator = week(data), municipio = municipio)]
df_mes_mun <- setDT(pluviosidadeMun)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = year(data), fator = month(data), municipio = municipio)]
df_ano_mun <- setDT(pluviosidadeMun)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = year(data), municipio = municipio)]

#Aqui os dados de semana, mes e dia sao formatados para o formato elasticsearch definido pelo SVDados yyyy-mm-ddTHH-MM-SS, por meio da funcao do pacote CRISPDM. As colunas sao reordenadas para o padrao definido no SVDados
df_semana_mun$dataSemanal <- paste(df_semana_mun$yr, df_semana_mun$fator, sep = "")
df_semana_mun$dataSemanal <- cria_data_padrao_fator_peso(df_semana_mun$dataSemanal, posAno = c(1,4), posFator = c(5,6), tipoFator = "week")
df_semana_mun <- df_semana_mun[,c("dataSemanal", "municipio", "pluviosidade", "evaporacao")]

df_mes_mun$dataMensal <- paste(df_mes_mun$yr, df_mes_mun$fator, sep = "")
df_mes_mun$dataMensal <- cria_data_padrao_fator_peso(df_mes_mun$dataMensal, posAno = c(1,4), posFator = c(5,6), tipoFator = "month")
df_mes_mun <- df_mes_mun[,c("dataMensal", "municipio", "pluviosidade", "evaporacao")]

df_ano_mun$dataAnual <- paste(df_ano_mun$yr, "-12-31T23:59:59", sep = "")
df_ano_mun <- df_ano_mun[,c("dataAnual", "municipio", "pluviosidade", "evaporacao")]

pluviosidadeMun <- pluviosidadeMun[,c("data", "municipio", "pluviosidade", "evaporacao")]
colnames(pluviosidadeMun) <- c("dataDiaria", "municipio", "pluviosidade", "evaporacao")
pluviosidadeMun$dataDiaria <- paste(pluviosidadeMun$dataDiaria, "T23:59:59", sep = "")

#********************************************************************************************************************************************************************************************************************
#********************************************************************************************************************************************************************************************************************

#Aqui sao mapeados todas as coluna disponiveis, o formato da tabela final definido pelo SVDados eh assim definido, as colunas de data estao sendo separadas, enquanto que as de outras observacoes, permanecem uma soh
tipos <- c(dataDiaria = "character", dataSemanal = "character", dataMensal = "character", dataAnual = "character", UF = "character", municipio = "character", pluviosidade = "numeric",
           evaporacao = "numeric")

#***
#Essa parte eh desnecessaria, parece que a funcao eh apenas necessario passar um vetor de caracteres
pluviosidadeFinal <- data.frame(dataDiaria = NA, dataSemanal = NA, dataMensal = NA, dataAnual = NA, UF = NA, municipio = NA, 
                                pluviosidade = NA, evaporacao = NA)



#A todas as tabelas sao adicionadas as colunas que nao possuem, de modo que fiquem no formato padrao da tabela final, para que sejam posteriormente unificadas em uma tabela soh
pluviosidade <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = pluviosidade, mapeamento_de_tipos = tipos)
dfSemana <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfSemana, mapeamento_de_tipos = tipos)
dfMes <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfMes, mapeamento_de_tipos = tipos)
dfAno <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfAno, mapeamento_de_tipos = tipos)
pluviosidadeMun <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = pluviosidadeMun, mapeamento_de_tipos = tipos)
df_semana_mun <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = df_semana_mun, mapeamento_de_tipos = tipos)
df_mes_mun <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = df_mes_mun, mapeamento_de_tipos = tipos)
df_ano_mun <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = df_ano_mun, mapeamento_de_tipos = tipos)

pluviosidadeFinal <- rbind(pluviosidade, dfSemana, dfMes, dfAno, pluviosidadeMun, df_semana_mun, df_mes_mun, df_ano_mun)

#Para testar no timelion se as aggregations estao somando apenas no dominio correto temporal, cada dominio recebe um marcador com uma grandeza diferente. Um dos objetivos deste script eh possibilitar esta validacao
pluviosidadeFinal$colunaMarcadora <- 1
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataDiaria) & !is.na(pluviosidadeFinal$municipio)] <- 10^0
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataSemanal) & !is.na(pluviosidadeFinal$municipio)] <- 10^2
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataMensal) & !is.na(pluviosidadeFinal$municipio)] <- 10^3
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataAnual) & !is.na(pluviosidadeFinal$municipio)] <- 10^4
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataDiaria) & !is.na(pluviosidadeFinal$UF)] <- 10^5
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataSemanal) & !is.na(pluviosidadeFinal$UF)] <- 10^6
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataMensal) & !is.na(pluviosidadeFinal$UF)] <- 10^7
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataAnual) & !is.na(pluviosidadeFinal$UF)] <- 10^8

#Aqui a conexao com o elasticsearch eh estabelecida, o index no elasticsearch para a massa de teste eh criado, e os dados da tabela final sao enviados ao indice
TPconexao <- connect(host = "localhost", port = "9200")

conexao <- connect()

index_delete(conn = conexao, index = "massapluespacial")
index_create(conn = conexao, index = "massapluespacial")


docs_bulk(conexao, pluviosidadeFinal,index = "massapluespacial", type = "massapluespacial")

#Registra as medias e variancia que foram utilizadas para as distribuicoes normais que foram enviadas ao elasticsearch para cada Estado
library(data.table)
fwrite(distribuicoes_normais_UF_evaporacao, "arquivo/distribuicoes_normais_UF_evaporacao.csv")
fwrite(distribuicoes_normais_UF_pluviosidade, "arquivo/distribuicoes_normais_UF_pluviosidade.csv")
fwrite(distribuicoes_normais_municipio_evaporacao, "arquivo/distribuicoes_normais_municipio_evaporacao.csv")
fwrite(distribuicoes_normais_municipio_pluviosidade, "arquivo/distribuicoes_normais_municipio_pluviosidade.csv")


