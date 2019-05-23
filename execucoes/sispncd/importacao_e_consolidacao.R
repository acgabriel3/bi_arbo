#***
#exploratorio geral dos bancos de dados envolvidos no contexto (no caso agora, o sispncd)

library(foreign)

source("CRISPDM.r")

#***
#Potencialidades atuais identificadas nos dados:
#-Indicadores acerca da qualidade do trabalho sendo realizado em territorio nacional
#- indicadores acerca do vetor 

#***
#Em uma exploracao inicial, me parece que os dados de localidades do sispncd, quando dessa importacao dos dados puro, possui grande potencial informacional, apesar
#de possuir cerca de 23 variaveis totalmente vazias, as quais ainda nao conheco o significado
#porem nao existem dados de latitude e longitude para tais localidades, talvez seja necessario buscar em fontes alternativas como o ibge
nomesTabelas <- leitura_automatica_por_tipo_arquivo(formatoArquivo = ".dbf", funcao_de_leitura = "read.dbf", diretorioAlvo = "dados/SISPNCD/localidades/original")

consolidada_localidades_sispncd <- uneTabelas(nomeTabelas = nomesTabelas, formatoArquivos = "LOC_SVS_", remover = TRUE)

observacoesTabelas <- verificaNas(consolidada_localidades_sispncd)

limpa <- consolidada_localidades_sispncd

limpa <- limpa[, as.vector(observacoesTabelas != nrow(limpa))]

limpa$ibge6 <- substring(limpa$ID_LOC, 1, 6)
limpa$ibge7 <- substring(limpa$ID_LOC, 1, 7)

#***
#exploracao inicial para resumo semanal
#parece conter uma completude interessante, no entanto, nao existem dados de latitude e longitude
nomesTabelas <- leitura_automatica_por_tipo_arquivo(formatoArquivo = ".dbf", funcao_de_leitura = "read.dbf", diretorioAlvo = "dados/SISPNCD/resumoSemanal/original")

consolidada_resumo_semanal <- uneTabelas(nomeTabelas = nomesTabelas, formatoArquivos = "FAD_SEM", remover = TRUE)

library(data.table)

#***
#Antivetorial
#***
#Necessita de dados acerca de lat e lon para ser utilizado a nivel de localidade ---> Mas faz sentido utilizar os dados a nivel de localidade?
#como navegar pelo dado de acordo com o dicionario?
consolidado_anti_vetorial <- fread("dados/SISPNCD/resumo_semanal_antivetorial/consolidado/antivetorial.csv") 


#***
#Vigilancia entomologica ---> Mas isso eh acerca de dengue somente, correto?

consolidado_vigilancia_ento_prefixo1 <- fread("dados/SISPNCD/vigilanciaEntomologica/consolidado/vigilanciaEnt_.csv") 
consolidado_vigilancia_ento_prefixo2 <- fread("dados/SISPNCD/vigilanciaEntomologica/consolidado/vigilanciaEntomo.csv") 
