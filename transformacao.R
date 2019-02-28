#***
#TRANSFORMACAO

library(dplyr)
library(data.table)
library(foreign)
library(jsonlite)
library(readxl)
library(xlsx)
library(stringi)

source("CRISPDM.R")

populacao <- fread("dados/populacao_municipios_2010X2017.csv") #verificar encoding
populacao_nomes_colunas <- as.vector(populacao[1,])
populacao <- populacao[-1,]
colnames(populacao) <- as.character(populacao_nomes_colunas)

municipios_lat_lon <- fread("dados/lat_lon_municipios.csv")

municipios_lat_lon$codIbge <- substr(municipios_lat_lon$codIbge, 1, 6)

armadilhas2013 <- read_excel("dados/armadilha/2013.xlsx") #Faltara unir todos os anos
larva_pulpa_2013 <- read.dbf("dados/larva-pulpa/2013.dbf") 
larva_pulpa_2014 <- read.dbf("dados/larva-pulpa/2014.dbf") 
larva_pulpa_2015 <- read.dbf("dados/larva-pulpa/2015.dbf") 
larva_pulpa_2016 <- read.xlsx("dados/larva-pulpa/2016.xlsx", sheetIndex = 1) 


larva_pulpa_consolidado <- larva_pulpa_2015

#***
#Tratamento para larva-pulpa

consolidado <- NULL
colunasChave <- c("NU_ANO", "NU_SEMAN", "CO_MUNIC")

for(i in 1:8) {
  
  if(i != 7) {
    
    #***
    #Realizar rbind nas colunas de larva-pulpa
    aux <- calculaQuantidade_fator_coluna_por_variaveis(tabela = larva_pulpa_2015, 
                                                        coluna = "CO_ATIVI", 
                                                        fator = i,
                                                        colunasChave = colunasChave, 
                                                        nome_nova_coluna = paste("QT_ATIV_", i, sep = ""))
    
    if(i == 1) {
      consolidado <- aux
    } else {
      consolidado <- consolidado %>%
                        inner_join(aux)
    }
    
  }
      
}

#***

aux <- larva_pulpa_consolidadoModificado %>%
  group_by(NU_ANO, NU_SEMAN, CO_MUNIC) %>%
  summarise(QT_AMOST = sum(QT_AMOST, na.rm = TRUE), QT_DE_A1 = sum(QT_DE_A1, na.rm = TRUE),
            QT_DE_A1 = sum(QT_DE_A1, na.rm = TRUE), QT_DE_EL = sum(QT_DE_EL, na.rm = TRUE),
            QT_DE_D2 = sum(QT_DE_D2, na.rm = TRUE), QT_DE_D1 = sum(QT_DE_D1, na.rm = TRUE),
            QT_DE_A1 = sum(QT_DE_A1, na.rm = TRUE), QT_DE_A2 = sum(QT_DE_A2, na.rm = TRUE),
            QT_DE_B = sum(QT_DE_B, na.rm = TRUE), QT_P_REC = sum(QT_P_REC, na.rm = TRUE),
            QT_P_RCS = sum(QT_P_RCS, na.rm = TRUE), QT_I_INS = sum(QT_I_INS, na.rm = TRUE),
            QT_IT_PER = sum(QT_IT_PE, na.rm = TRUE), 
            QT_IT_CO = sum(QT_IT_CO, na.rm = TRUE), QT_IT_OU = sum(QT_IT_OU, na.rm = TRUE),
            QT_IT_PE = sum(QT_IT_PE, na.rm = TRUE), QT_IT_TB = sum(QT_IT_TB, na.rm = TRUE),
            QT_IT_RE = sum(QT_IT_RE, na.rm = TRUE), QT_IT_CO = sum(QT_IT_CO, na.rm = TRUE)
            )

consolidado <- consolidado %>%
  inner_join(aux)

inicio_periodo <- as.Date("2015-01-01")
consolidado["data"] <- inicio_periodo

for(i in 1:length(consolidado$NU_SEMAN)) {
  
  consolidado$data[i] <- (consolidado$data[i] + (consolidado$NU_SEMAN[i] * 7)) - 1
    
}

municipios <- read.dbf("dados/tb_uf.dbf")

encontro <- match(substring(consolidado$CO_MUNIC, 1, 2), municipios$CO_UF)

consolidado["UF"] <- municipios$DS_SIGLA[encontro]

teste <- toJSON(consolidado)
write_json(consolidado, "dados/larva_pulpa_consolidado.json")
fwrite(consolidado, "dados/larva_pulpa_consolidado.csv")

#***
#Deu certo, o procedimento sera esse para praticamente todas as variaveis
