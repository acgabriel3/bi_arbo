#***
#Agregando vigilancia entomologica para posterior avaliacao

deszipaTabelas()
library(foreign)
#source("CRISPDM.R")

nomesTabelas <- leitura_automatica_por_tipo_arquivo(formatoArquivo = ".dbf", funcao_de_leitura = "read.dbf")

consolidadaEnto <- uneTabelas(nomeTabelas = nomesTabelas, formatoArquivos = "VIGILANCIA_ENT_", remover = TRUE)

consolidada_ento_maior <- uneTabelas(nomeTabelas = nomesTabelas, formatoArquivos = "VIGILANCIA_ENTO", remover = TRUE)


#***
#Agregando resumo antivetorial

deszipaTabelas()

nomesTabelas <- leitura_automatica_por_tipo_arquivo(formatoArquivo = ".dbf", funcao_de_leitura = "read.dbf")

consolidadaAntivetorial <- uneTabelas(nomeTabelas = nomesTabelas, formatoArquivos = "RESUMO", remover = TRUE)

library(data.table)

fwrite(consolidadaAntivetorial, file = "antivetorial.csv")

#***
#Agregando reusumo semanal

deszipaTabelas()

nomesTabelas <- leitura_automatica_por_tipo_arquivo(formatoArquivo = ".dbf", funcao_de_leitura = "read.dbf")

consolidadaSemanal <- uneTabelas(nomeTabelas = nomesTabelas, formatoArquivos = "FAD", remover = TRUE)

fwrite(consolidadaSemanal, file = "semanal.csv")

#***
#Agregando localidades

deszipaTabelas()

nomesTabelas <- leitura_automatica_por_tipo_arquivo(formatoArquivo = ".dbf", funcao_de_leitura = "read.dbf")

consolidadaLocalidades <- uneTabelas(nomeTabelas = nomesTabelas, formatoArquivos = "LOC", remover = TRUE)

verificaNas(tabela = consolidadaLocalidades) #Muitas coisas estavam vazias

fwrite(consolidadaLocalidades, file = "localidades.csv")

