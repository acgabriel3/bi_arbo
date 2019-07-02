#***
#Criando uma selecao aleatoria dos dados da tabela, com cerca de 20000 linhas (vamos testar)

#library(dplyr)
#massaTeste <- sample_n(tabela_final_entomologia, 500)

#library(elastic)

#TPconexao <- connect(host = "localhost", port = "9200")

#conexao <- connect()

#index_delete(conn = conexao, index = "massateste")
#index_create(conn = conexao, index = "massateste")


#docs_bulk(conexao, massaTeste ,index = "massateste", type = "massateste")

#***
#Agora criando uma micro tabela para trabalhar com tempo, relacionado a detalhamento: 

#source("CRISPDM.R")

#***
#Elucidacoes:
# A informacao sempre estara vinculada a um detalhamento de data. De modo que a mesma nao poderia ser atribuida a um menor detalhamento. No entanto, este detalhamento poderia
#ser indormado (se voce possui o dia, voce tambem possui o mes e o ano)

#Criar dados referentes a pluviosidade. Estes dados devem possuir correlacao (diaria, semanal, mensal, anual), correlacao espacial (4 regioes ufs)

#um problema encontrado: Repetir todas as linhas para uma unica observacao da coluna ano (criar cerca de 4 anos)

set.seed(10)
dados <- round(runif(40,0,12))
dados[dados == 0] <- 1

ano <- rep(2019, 10)

detalhamentoDia <- sample(dados, size = 10)
detalhamentoSemana <-  sample(dados, size = 10)
detalhamentoMes <-  sample(dados, size = 10)
detalhamentoAno <-  sample(dados, size = 10)

anoDia <- paste(ano, detalhamentoDia, sep = "")
anoSemana <- paste(ano, detalhamentoSemana, sep = "")
anoMes <- paste(ano, detalhamentoMes, sep = "")
anoAno <- paste(ano, detalhamentoAno, sep = "")

dfDia <- data.frame(dia = cria_data_padrao_fator_peso(anoDia, posAno = c(1,4), posFator = c(5,6), tipoFator = "day"), valorDia = detalhamentoDia)
dfSemana <- data.frame(semana = cria_data_padrao_fator_peso(anoSemana, posAno = c(1,4), posFator = c(5,6), tipoFator = "week"), valorSemana = detalhamentoSemana)
dfMes <- data.frame(mes = cria_data_padrao_fator_peso(anoMes, posAno = c(1,4), posFator = c(5,6), tipoFator = "month"), valorMes = detalhamentoMes)
dfAno <- data.frame(ano = cria_data_padrao_fator_peso(anoAno, posAno = c(1,4), posFator = c(5,6), tipoFator = "year"), valorAno = detalhamentoAno)

tipos <- c(dia = "character", valorDia = "numeric", semana = "character", valorSemana = "numeric", mes = "character", valorMes = "numeric",
           ano = "character", valorAno = "numeric") 
  
tabelaFinal <- data.frame(dia = NA, valorDia = NA, semana = NA, valorSemana = NA, mes = NA, valorMes = NA,
                 ano = NA, valorAno = NA)

dfDia <- formata_tabela_basica_formato_final(ordemFinal = colnames(tabelaFinal), tabela = dfDia, mapeamento_de_tipos = tipos)
dfSemana <- formata_tabela_basica_formato_final(ordemFinal = colnames(tabelaFinal), tabela = dfSemana, mapeamento_de_tipos = tipos)
dfMes <- formata_tabela_basica_formato_final(ordemFinal = colnames(tabelaFinal), tabela = dfMes, mapeamento_de_tipos = tipos)
dfAno <- formata_tabela_basica_formato_final(ordemFinal = colnames(tabelaFinal), tabela = dfAno, mapeamento_de_tipos = tipos)

tabelaFinal <- rbind(dfDia, dfSemana, dfMes, dfAno)

TPconexao <- connect(host = "localhost", port = "9200")

conexao <- connect()

index_delete(conn = conexao, index = "massateste")
index_create(conn = conexao, index = "massateste")


docs_bulk(conexao, tabelaFinal,index = "massateste", type = "massateste")


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
