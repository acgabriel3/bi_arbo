library(dplyr)
library(data.table)
library(lubridate)
library(elastic)
library(EnvStats)
library(ISOweek)

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

#Atualizado vetor com todos os anos disponiveis
anos <- c(2013, anos)

#***
#Eh possivel que os Estados nao devam ser aleatorios, mas que seja definido um vetor de pluviosidade aleatorio para cada um dos Estados 
#Criar aleatoriamente estados (4 regioes) para cada um dos dados encontrados

ufs <- c("DF", "AC", "RJ", "SP")

pluviosidade <- NULL

distribuicoesNormais <- NULL 

#criado um data frame (df) para cada ano, com uma distribuição normal truncada para pluviosidade e evaporação em cada ano de cada Estado, ao mesmo tempo estes data frames sao unificados em um soh denomiado "pluviosidade"
for(estado in ufs) {
  
  #Define medias e desvios padroes para a pluviosidade e evaporacao de cada estado
  meanPluv <- round(runif(1, 1, 4))
  sdPluv <- round(runif(1, 1, 4))  
  
  meanEvap <- round(runif(1, 1, 4))
  sdEvap <- round(runif(1, 1, 4))
  
  distribuicoesNormais <- rbind(distribuicoesNormais, data.frame(estado = estado, meanPluv = meanPluv, sdPluv = sdPluv, meanEvap = meanEvap, sdEvap = sdEvap))
  
  for(i in 1:length(anos)) {
  
    #constroi vetores d epluviosidade e evaporacao seguindo a distribuicao normal com os parametro de cada estado para cada ano
    valorPluv <- rnormTrunc(365, mean = meanPluv, sd = sdPluv, min = 0, max = 60)
    
    valorEvap <- rnormTrunc(365, mean = meanEvap, sd = sdEvap, min = 0, max = 60)
    
    #Cria os dados para cada ano, e os junta por meio de uma junção por linhas, para gerar o data frame final "pluviosidade" que contem todos os dados diarios para cada uma das 4 regioes
    df_aux <- data.frame(data = eval(as.symbol("coluna_data_" %% anos[i])), 
                         pluviosidade = valorPluv, 
                         evaporacao = valorEvap,
                         UF = rep(estado, 365))
    
    pluviosidade <- rbind(pluviosidade, df_aux)
  
    rm(df_aux)
  
  }
  
}


#***
#como realizar as agregacoes por ano? Segue o exemplo abaixo

#A funcao setDT cria um data frame a partir das colunas, agregando os valores por determinada caracteristica (fator) nas colunas escolhidas. O funcionamento eh semelhante ao group_by do dplyr ou do SQL comum
#Abaixo a pluviosidade e a evaporacao sao agregadas por soma, para semana, mes e ano. 
dfSemana <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = substring(date2ISOweek(data), 1, 4), fator = substring(date2ISOweek(data), 7, 8), UF = UF)]
dfMes <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = year(data), fator = month(data), UF = UF)]
dfAno <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), evaporacao = sum(evaporacao)), by = .(yr = year(data), UF = UF)]

#Aqui os dados de semana, mes e dia sao formatados para o formato elasticsearch definido pelo SVDados yyyy-mm-ddTHH:MM:SS, por meio da funcao do pacote CRISPDM. 
#As colunas sao reordenadas para o padrao definido no SVDados

fim_primeiras_semanas <- c("2013" = "2013-01-13", "2014" = "2014-01-05", "2015" = "2015-01-11", "2016" = "2016-01-10", 
                           "2017" = "2017-01-08", "2018" = "2018-01-06", "2019" = "2019-01-01") 

dfSemana$dataSemanal <- paste(dfSemana$yr, dfSemana$fator, sep = "")
dfSemana$dataSemanal <- cria_data_padrao_fator_peso(dfSemana$dataSemanal, posAno = c(1,4), posFator = c(5,6), tipoFator = "week", 
                                                    datas_finais_semanas = fim_primeiras_semanas)
dfSemana <- dfSemana[,c("dataSemanal", "UF", "pluviosidade", "evaporacao")]

dfMes$dataMensal <- paste(dfMes$yr, dfMes$fator, sep = "")
dfMes$dataMensal <- cria_data_padrao_fator_peso(dfMes$dataMensal, posAno = c(1,4), posFator = c(5,6), tipoFator = "month")
dfMes <- dfMes[,c("dataMensal", "UF", "pluviosidade", "evaporacao")]

dfAno$dataAnual <- paste(dfAno$yr, "-12-31T23:59:59", sep = "")
dfAno <- dfAno[,c("dataAnual", "UF", "pluviosidade", "evaporacao")]

pluviosidade <- pluviosidade[,c("data", "UF", "pluviosidade", "evaporacao")]
colnames(pluviosidade) <- c("dataDiaria", "UF", "pluviosidade", "evaporacao")
pluviosidade$dataDiaria <- paste(pluviosidade$dataDiaria, "T23:59:59", sep = "")

#Aqui sao mapeados todas as coluna disponiveis, o formato da tabela final definido pelo SVDados eh assim definido, as colunas de data estao sendo separadas, enquanto que as de outras observacoes, permanecem uma soh
tipos <- c(dataDiaria = "character", dataSemanal = "character", dataMensal = "character", dataAnual = "character", UF = "character", pluviosidade = "numeric",
           evaporacao = "numeric")

#***
#Essa parte eh desnecessaria, parece que a funcao eh apenas necessario passar um vetor de caracteres
pluviosidadeFinal <- data.frame(dataDiaria = NA, dataSemanal = NA, dataMensal = NA, dataAnual = NA, UF = NA, 
                                pluviosidade = NA, evaporacao = NA)



#A todas as tabelas sao adicionadas as colunas que nao possuem, de modo que fiquem no formato padrao da tabela final, para que sejam posteriormente unificadas em uma tabela soh
pluviosidade <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = pluviosidade, mapeamento_de_tipos = tipos)
dfSemana <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfSemana, mapeamento_de_tipos = tipos)
dfMes <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfMes, mapeamento_de_tipos = tipos)
dfAno <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfAno, mapeamento_de_tipos = tipos)

pluviosidadeFinal <- rbind(pluviosidade, dfSemana, dfMes, dfAno)

#Para testar no timelion se as aggregations estao somando apenas no dominio correto temporal, cada dominio recebe um marcador com uma grandeza diferente. Um dos objetivos deste script eh possibilitar esta validacao
pluviosidadeFinal$colunaMarcadora <- 1
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataDiaria)] <- 10^0
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataSemanal)] <- 10^2
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataMensal)] <- 10^3
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataAnual)] <- 10^4


#Aqui a conexao com o elasticsearch eh estabelecida, o index no elasticsearch para a massa de teste eh criado, e os dados da tabela final sao enviados ao indice
TPconexao <- connect(host = "localhost", port = "9200")

conexao <- connect()

index_delete(conn = conexao, index = "massapluviosidade")
index_create(conn = conexao, index = "massapluviosidade")


docs_bulk(conexao, pluviosidadeFinal,index = "massapluviosidade", type = "massapluviosidade")

#Registra as medias e variancia que foram utilizadas para as distribuicoes normais que foram enviadas ao elasticsearch para cada Estado
library(data.table)
fwrite(distribuicoesNormais, "arquivo/distribuicoesNormais.csv")
