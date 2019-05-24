#***
#CAMINHO
#

library(data.table)
library(lubridate)
source("CRISPDM.R")

#***
#Script para resumo semanal antivetorial 


#***
#como primeiro passo vamos formatar as datas

#***
#Semanas epidemiologicas
aux <- paste("0", consolidado_anti_vetorial$NU_SEMAN, sep = "")

aux[nchar(aux) == 3] <- substring(aux[nchar(aux) == 3], 2, 3)

teste <- paste(consolidado_anti_vetorial$NU_ANO, aux, sep = "")

resultado <- cria_data_padrao_fator_peso(coluna = teste, posAno = c(1,4), posFator = c(5,6), tipoFator = "day")

consolidado_anti_vetorial$NU_SEMAN <- resultado


#***
#Mes de competencia
aux <- paste("0", consolidado_anti_vetorial$NU_MES_C, sep = "")

aux[nchar(aux) == 3] <- substring(aux[nchar(aux) == 3], 2, 3)

teste <- paste(consolidado_anti_vetorial$NU_ANO, aux, sep = "")

resultado <- cria_data_padrao_fator_peso(coluna = teste, posAno = c(1,4), posFator = c(5,6), tipoFator = "month")

consolidado_anti_vetorial$NU_MES_C <- resultado

#***
#Ateh o momento esta sendo considerado que esta tabela inteira eh uma tabela somente de dados operacionais


#***
#CO_MICRO apresenta-se sem nenhum preenchimento

ordena <- c("NU_SEMAN", "NU_MES_C", "NU_CICLO", "NU_ANO", "NU_LOCAL", "CO_MUNIC", "CO_RESUM", "CO_CONTR", "CO_ATIVI", "ST_ACS",   "QT_Q_CON", "QT_IT_RE", "QT_IT_CO", "QT_IT_TB",
            "QT_IT_PE", "QT_IT_OU", "QT_I_FOC", "QT_I_PER", "QT_I_INS", "QT_AMOST", "QT_P_RCS", "QT_P_FEC", "QT_P_REC", "QT_DE_A1", "QT_DE_A2", "QT_DE_B", "QT_DE_C",  
            "QT_DE_D1", "QT_DE_D2",  "QT_DE_E",  "QT_DE_EL", "CO_PR_D1", "QT_PR_D1", "QT_DT_D1", "CO_PR_D2", "QT_PR_D2", "QT_DT_D2", "CO_PR_AD", "QT_CA_AD", "QT_AG_DT")

anti_vetorial_operacionais <- consolidado_anti_vetorial[, ..ordena]

fwrite(anti_vetorial_operacionais, "dados/SISPNCD/resumo_semanal_antivetorial/consolidado/anti_vetorial_operacionais.csv")
