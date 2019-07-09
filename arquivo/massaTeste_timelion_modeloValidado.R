library(dplyr)
library(data.table)
library(lubridate)
library(elastic)

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

pluviosidade <- NULL

#criado um data frame (df) para cada ano, com dados aleatorio de pluviosidade, ao mesmo tempo estes data frames sao unificados em um soh denomiado "pluviosidade"
for(estado in ufs) {
  
  for(i in 1:length(anos)) {
  
    valor <- rep(0, 365)
    
    #Cria 180 valores aleatorios, entre 1 e 365 (ou seja, serao preenchidas 180 ou menos linhas aleatoriamente), cada linha recebe um valor aleatorio entre 1 e 45 (180 valores)
    #pode haver sobreposicao de valores (dois valores aleatorios irem para a mesma linha, o valor que vai ficar eh o de posicao maior no vetor)
    valor[round(runif(180, 1, 365))] <- round(runif(180, 1, 45))
    
    #Criado um data frame para cada ano com respectivos dados aleatorios de pluviosidade
    eval(parse(text = 
                 
                 "df_" %% anos[i] %% "_" %% estado %%  "<- data.frame(data = coluna_data_" %% anos[i] %% ",pluviosidade = valor, UF = rep(estado, 365))
               
                  pluviosidade <-"  %% "rbind( pluviosidade, "%% "df_" %% anos[i] %% "_" %% estado %% ") 
               
                  rm(df_" %% anos[i] %% "_" %% estado %% ")"
                 
                 ))

  }
  
}



#***
#Deve ser criada outra variavel pluviometrica, pesquisar acerca disso. 
#obs: Tambem foi pedido que os dados reais fossem utilizados para validar o modelo, entao a tarefa eh colocar os dados no modelo correto
pluviosidade$ImoveisPositivos <- round(pluviosidade$pluviosidade * 0.04) +   round(runif(nrow(pluviosidade), 0, 3))


#***
#como realizar as agregacoes por ano? Segue o exemplo abaixo

#A funcao setDT cria um data frame a partir das colunas, agregando os valores por determinada caracteristica (fator) nas colunas escolhidas. O funcionamento eh semelhante ao group_by do dplyr ou do SQL comum
#Abaixo a pluviosidade eh agregada por soma, para semana, mes e ano. 
dfSemana <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), ImoveisPositivos = sum(ImoveisPositivos)), by = .(yr = year(data), fator = week(data), UF = UF)]
dfMes <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), ImoveisPositivos = sum(ImoveisPositivos)), by = .(yr = year(data), fator = month(data), UF = UF)]
dfAno <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), ImoveisPositivos = sum(ImoveisPositivos)), by = .(yr = year(data), UF = UF)]

#Aqui os dados de semana, mes e dia sao formatados para o formato elasticsearch definido pelo SVDados yyyy-mm-ddTHH-MM-SS, por meio da funcao do pacote CRISPDM. As colunas sao reordenadas para o padrao definido no SVDados
dfSemana$dataSemanal <- paste(dfSemana$yr, dfSemana$fator, sep = "")
dfSemana$dataSemanal <- cria_data_padrao_fator_peso(dfSemana$dataSemanal, posAno = c(1,4), posFator = c(5,6), tipoFator = "week")
dfSemana <- dfSemana[,c("dataSemanal", "UF", "pluviosidade", "ImoveisPositivos")]

dfMes$dataMensal <- paste(dfMes$yr, dfMes$fator, sep = "")
dfMes$dataMensal <- cria_data_padrao_fator_peso(dfMes$dataMensal, posAno = c(1,4), posFator = c(5,6), tipoFator = "month")
dfMes <- dfMes[,c("dataMensal", "UF", "pluviosidade", "ImoveisPositivos")]

dfAno$dataAnual <- paste(dfAno$yr, "-12-31T23:59:59", sep = "")
dfAno <- dfAno[,c("dataAnual", "UF", "pluviosidade", "ImoveisPositivos")]

pluviosidade <- pluviosidade[,c("data", "UF", "pluviosidade", "ImoveisPositivos")]
colnames(pluviosidade) <- c("dataDiaria", "UF", "pluviosidade", "ImoveisPositivos")
pluviosidade$dataDiaria <- paste(pluviosidade$dataDiaria, "T23:59:59", sep = "")

#Aqui sao mapeados todas as coluna disponiveis, o formato da tabela final definido pelo SVDados eh assim definido, as colunas de data estao sendo separadas, enquanto que as de outras observacoes, permanecem uma soh
tipos <- c(dataDiaria = "character", dataSemanal = "character", dataMensal = "character", dataAnual = "character", UF = "character", pluviosidade = "numeric",
           ImoveisPositivos = "numeric")

#***
#Essa parte eh desnecessaria, parece que a funcao eh apenas necessario passar um vetor de caracteres
pluviosidadeFinal <- data.frame(dataDiaria = NA, dataSemanal = NA, dataMensal = NA, dataAnual = NA, UF = NA, 
                                pluviosidade = NA, ImoveisPositivos = NA)


formata_tabela_basica_formato_final <- function(ordemFinal, tabela, mapeamento_de_tipos) {
  
  colunasTabela <- colnames(tabela)
  
  encontro <- match(colunasTabela, ordemFinal)
  
  colunas_nao_pertencentes <- ordemFinal[-encontro[!is.na(encontro)]]
  
  for(coluna in colunas_nao_pertencentes) {
    
    print(coluna)
    print(mapeamento_de_tipos[coluna])
    
    tabela[,coluna] <- as(rep(NA, nrow(tabela)), mapeamento_de_tipos[coluna])
    
  }
  
  tabela <- tabela[,..ordemFinal] #Isto esta dando conflito entre os scripts no windows e no linux, verificar e pesquisar o motivo e pesquisar uma solucao que funcione em ambas as maquinas
  
  return(tabela)
  
  
}

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
