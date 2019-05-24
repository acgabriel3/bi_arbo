#***
#CAMINHO

#***
#script de transformacao para resumo semanal

#***
#Me parece que a divisao serah em dados entomologicos, 
#Esse dados sao soh entomologicos? Ou sao entomologicos e operacionais? nesse caso, podemos dividir os dados operacionais do entomologicos, poderia ter a 
#divisao, tambem, para os dados de laboratorio?

#Os ciclos representam qual periodo de tempo? Como eles dividem o ano? 
#O que significa ser um mes de competencia?

#a "sede" se configura como um dado operacional? 

library(data.table)
library(lubridate)
source("CRISPDM.R")


consolidada_resumo_semanal$SEM_EPID <- cria_data_padrao_fator_peso(consolidada_resumo_semanal$SEM_EPID, posAno = c(1,4), posFator = c(5,6), tipoFator = "day")
consolidada_resumo_semanal$COMPET <- cria_data_padrao_fator_peso(consolidada_resumo_semanal$COMPET, posAno = c(1,4), posFator = c(5,6), tipoFator = "month")

consolidada_resumo_semanal$fonte <- NA

#***
#O ciclo tambem precisa ser tratado para datas?
#Os dados operacionais tambem devem receber todas as datas abaixo?
#Duvidas: QUART_CONC ---> operacional ou entomologico
ordenaEntomologiocos <- c("fonte", "SEM_EPID", "COMPET", "CICLO", "ID_LOC", "ID_DES", "SEDE", "QUART_CONC", "RESID_TRAB", "COM_TRAB", "TB_TRAB", "PE_TRAB",
                          "OUT_TRAB", "IMOV_TRAB", "TRAT_FOC", "TRAT_PER", "AMOS_COL", "DEPINS_A1", "DEPINS_A2", "DEPINS_B", "DEPINS_C", 
                          "DEPINS_D1", "DEPINS_D2", "DEPINS_E", "DEPINS_TOT", "DEP_TRATM", "DEP_TRAT1", "DEP_TRAT2", "IMOV_INSP", "TRAB_INSP",
                          "RECUSA", "FECHADO", "RECUPERADO", "PENDENCIA", "QPOS_AEG", "QPOS_ALB", "QPOS_AGAB", "DEP_AG_A1", "DEP_AG_A2",
                          "DEP_AG_B", "DEP_AG_C", "DEP_AG_D1", "DEP_AG_D2", "DEP_AG_E", "DEP_AG_TOT", "RES_AG", "COM_AG", "TB_AG", "PE_AG",
                          "OUTRO_AG", "IMOV_AG", "LARV_AG", "ADULT_AG", "PUPA_AG", "EXUV_AG", "RES_XX", "COM_XX", "TB_XX", "PE_XX", "OUTRO_XX", "IMOV_XX", "LARV_XX",
                          "ADULT_XX", "PUPA_XX")

#***
#o banco parece nao possuir as colunas para albopictus
albopictus <- c("DEP_AB_A1", "DEP_AB_A2", "DEP_AB_B", "DEP_AB_C", "DEP_AB_D1", "DEP_AB_D2", "DEP_AB_E", "DEP_AB_TOT", 
                "RES_AB", "COM_AB", "TB_AB", "PE_AB", "OUTRO_AB", "LARV_AB", "ADULT_AB", "PUPA_AB", "ENXUV_AB")

#***
#o banco nao possui o dado enxuv
enxuv <- "ENXUV_XX"

ordenaOperacionais <- c("fonte", "SEM_EPID", "COMPET", "CICLO", "ID_LOC", "ID_DES", "CP", "CONTROLE",  "ID_LARV1", "LARV1_CONS", "ID_LARV2", "LARV2_CONS",
                        "ID_ADULT", "ADULT_CONS", "AGENT_TRAB", "ACS")

for(i in ordenaEntomologiocos) {
  print(i)
  consolidada_resumo_semanal[i]
} #Estah eh uma funcao util para estah tarefa


resumo_semanal_entomologia <- consolidada_resumo_semanal[ordenaEntomologiocos]
resumo_semanal_operacionais <- consolidada_resumo_semanal[ordenaOperacionais]

fwrite(resumo_semanal_entomologia, "dados/SISPNCD/resumoSemanal/consolidado/entomologia.csv")
fwrite(resumo_semanal_operacionais, "dados/SISPNCD/resumoSemanal/consolidado/operacionais.csv")
