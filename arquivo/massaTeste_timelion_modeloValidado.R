library(dplyr)
library(data.table)
library(lubridate)
library(elastic)

source("CRISPDM.R")

'%%' <- function(x, y) paste0(x,y) 

dias <- 1:364

dataInicial <- "2013-01-01"

dataInicial <- as.Date(dataInicial)

colunaData <- rep(dataInicial, 364)

day(colunaData) <- day(colunaData) + dias

colunaData <- c(dataInicial, colunaData)
 
coluna_data_2013 <- colunaData
aux <- colunaData

anos <- c(2014, 2015, 2016, 2017, 2018, 2019)

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
anos <- c(2013, anos)

for(i in 1:7) {

  valor <- rep(0, 365)
  valor[round(runif(180, 1, 365))] <- round(runif(180, 1, 45))
  
  eval(parse(text = 
               
               "df_" %% anos[i] %% "<- data.frame(data = coluna_data_" %% anos[i] %% ",pluviosidade = valor)"
               
               ))
  
}

pluviosidade <- rbind(df_2013, df_2014, df_2015, df_2016, df_2017, df_2018, df_2019)

pluviosidade$ImoveisPositivos <- round(pluviosidade$pluviosidade * 0.04) +   round(runif(nrow(pluviosidade), 0, 3))

#Criar aleatoriamente estados (4 regioes) para cada um dos dados encontrados

ufs <- c("DF", "AC", "RJ", "SP")

indice_aleatorio_estados <- round(runif(nrow(df_2013) * 7, 1, 4))

pluviosidade["UF"] <- NA
pluviosidade$UF <- ufs[indice_aleatorio_estados]

#***
#como realizar as agregacoes por ano? Segue o exemplo abaixo

dfSemana <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), ImoveisPositivos = sum(ImoveisPositivos)), by = .(yr = year(data), fator = week(data), UF = UF)]
dfMes <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), ImoveisPositivos = sum(ImoveisPositivos)), by = .(yr = year(data), fator = month(data), UF = UF)]
dfAno <- setDT(pluviosidade)[, .(pluviosidade = sum(pluviosidade), ImoveisPositivos = sum(ImoveisPositivos)), by = .(yr = year(data), UF = UF)]

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

tipos <- c(dataDiaria = "character", dataSemanal = "character", dataMensal = "character", dataAnual = "character", UF = "character", pluviosidade = "numeric",
           ImoveisPositivos = "numeric")

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
  
  tabela <- tabela[,..ordemFinal]
  
  return(tabela)
  
  
}

pluviosidade <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = pluviosidade, mapeamento_de_tipos = tipos)
dfSemana <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfSemana, mapeamento_de_tipos = tipos)
dfMes <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfMes, mapeamento_de_tipos = tipos)
dfAno <- formata_tabela_basica_formato_final(ordemFinal = colnames(pluviosidadeFinal), tabela = dfAno, mapeamento_de_tipos = tipos)

pluviosidadeFinal <- rbind(pluviosidade, dfSemana, dfMes, dfAno)

pluviosidadeFinal$colunaMarcadora <- 1
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataDiaria)] <- 10^0
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataSemanal)] <- 10^2
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataMensal)] <- 10^3
pluviosidadeFinal$colunaMarcadora[!is.na(pluviosidadeFinal$dataAnual)] <- 10^4



TPconexao <- connect(host = "localhost", port = "9200")

conexao <- connect()

index_delete(conn = conexao, index = "massapluviosidade")
index_create(conn = conexao, index = "massapluviosidade")


docs_bulk(conexao, pluviosidadeFinal,index = "massapluviosidade", type = "massapluviosidade")
