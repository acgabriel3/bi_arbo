#***
#TRANSFORMACAO

#***
#Os fors abaixo podem ser substituidos pela seguinte abordagem: Construcao de um vetor ou hash 
#com as colunas em que serao aplicadas as funcoes, e aplicacao de um for para percorrer esse vetor. 
#Provavelmente o codigo seria reduzido em muitas linhas ao utilizar essa abordagem, no entanto iria
#diminuir em parte a legibilidade, mas ficaria menos verborragico. 

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
larva_pulpa_2013 <- read.dbf("dados/SISPNCD/larva-pulpa/2013.dbf") 
larva_pulpa_2014 <- read.dbf("dados/larva-pulpa/2014.dbf") 
larva_pulpa_2015 <- read.dbf("dados/larva-pulpa/2015.dbf") 
larva_pulpa_2016 <- read.xlsx("dados/larva-pulpa/2016.xlsx", sheetIndex = 1) 


larva_pulpa_consolidado <- rbind(larva_pulpa_2013, larva_pulpa_2014, larva_pulpa_2015)

#***
#Tratamento para larva-pulpa

consolidado <- NULL
colunasChave <- c("NU_ANO", "NU_SEMAN", "CO_MUNIC")

for(i in 1:8) {
  
  if(i != 7) {
    
    #***
    #Realizar rbind nas colunas de larva-pulpa
    aux <- calculaQuantidade_fator_coluna_por_variaveis(tabela = larva_pulpa_consolidado, 
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

for(i in unique(larva_pulpa_consolidado$CO_PR_D1)) {
  
  
  aux <- calcula_quantidade_fator_peso_variavelFatorPeso(tabela = larva_pulpa_consolidado,
                                                         colunaFator = "CO_PR_D1",
                                                         colunaPeso = "QT_PR_D1",
                                                         fator = i, 
                                                         colunasChave = colunasChave,
                                                         nome_nova_coluna = paste("QT_PR_D1_T", i, sep = ""))
  
    consolidado <- consolidado %>%
                      inner_join(aux)
  
}

for(i in unique(larva_pulpa_consolidado$CO_PR_D1)) {
  
  
  aux <- calcula_quantidade_fator_peso_variavelFatorPeso(tabela = larva_pulpa_consolidado,
                                                         colunaFator = "CO_PR_D1",
                                                         colunaPeso = "QT_DT_D1",
                                                         fator = i, 
                                                         colunasChave = colunasChave,
                                                         nome_nova_coluna = paste("QT_PR_D1__DT_T", i, sep = ""))
  
  consolidado <- consolidado %>%
    inner_join(aux)
  
}

for(i in unique(larva_pulpa_consolidado$CO_PR_D2)) {
  
  
  aux <- calcula_quantidade_fator_peso_variavelFatorPeso(tabela = larva_pulpa_consolidado,
                                                         colunaFator = "CO_PR_D2",
                                                         colunaPeso = "QT_PR_D2",
                                                         fator = i, 
                                                         colunasChave = colunasChave,
                                                         nome_nova_coluna = paste("QT_PR_D2_T", i, sep = ""))
  
  consolidado <- consolidado %>%
    inner_join(aux)
  
}

for(i in unique(larva_pulpa_consolidado$CO_PR_D2)) {
  
  
  aux <- calcula_quantidade_fator_peso_variavelFatorPeso(tabela = larva_pulpa_consolidado,
                                                         colunaFator = "CO_PR_D2",
                                                         colunaPeso = "QT_DT_D2",
                                                         fator = i, 
                                                         colunasChave = colunasChave,
                                                         nome_nova_coluna = paste("QT_PR_D2_DT_T", i, sep = ""))
  
  consolidado <- consolidado %>%
    inner_join(aux)
  
}

for(i in unique(larva_pulpa_consolidado$CO_PR_AD)) {
  
  
  aux <- calcula_quantidade_fator_peso_variavelFatorPeso(tabela = larva_pulpa_consolidado,
                                                         colunaFator = "CO_PR_AD",
                                                         colunaPeso = "QT_CA_AD",
                                                         fator = i, 
                                                         colunasChave = colunasChave,
                                                         nome_nova_coluna = paste("QT_CA_AD_T", i, sep = ""))
  
  consolidado <- consolidado %>%
    inner_join(aux)
  
}

for(i in unique(larva_pulpa_consolidado$CO_PR_AD)) {
  
  
  aux <- calcula_quantidade_fator_peso_variavelFatorPeso(tabela = larva_pulpa_consolidado,
                                                         colunaFator = "CO_PR_AD",
                                                         colunaPeso = "QT_AG_DT",
                                                         fator = i, 
                                                         colunasChave = colunasChave,
                                                         nome_nova_coluna = paste("QT_AG_DT_T", i, sep = ""))
  
  consolidado <- consolidado %>%
    inner_join(aux)
  
}

#***

aux <- larva_pulpa_consolidado %>%
  group_by(NU_ANO, NU_SEMAN, CO_MUNIC) %>%
  summarise(QT_AMOST = sum(QT_AMOST, na.rm = TRUE), QT_DE_A1 = sum(QT_DE_A1, na.rm = TRUE),
            QT_DE_EL = sum(QT_DE_EL, na.rm = TRUE), QT_Q_CON = sum(QT_Q_CON, na.rm = TRUE),
            QT_DE_D2 = sum(QT_DE_D2, na.rm = TRUE), QT_DE_D1 = sum(QT_DE_D1, na.rm = TRUE),
            QT_DE_A1 = sum(QT_DE_A1, na.rm = TRUE), QT_DE_A2 = sum(QT_DE_A2, na.rm = TRUE),
            QT_DE_B = sum(QT_DE_B, na.rm = TRUE), QT_P_REC = sum(QT_P_REC, na.rm = TRUE),
            QT_P_RCS = sum(QT_P_RCS, na.rm = TRUE), QT_I_INS = sum(QT_I_INS, na.rm = TRUE),
            QT_IT_CO = sum(QT_IT_CO, na.rm = TRUE), QT_IT_OU = sum(QT_IT_OU, na.rm = TRUE),
            QT_IT_PE = sum(QT_IT_PE, na.rm = TRUE), QT_IT_TB = sum(QT_IT_TB, na.rm = TRUE),
            QT_IT_RE = sum(QT_IT_RE, na.rm = TRUE), QT_IT_CO = sum(QT_IT_CO, na.rm = TRUE),
            QT_I_FOC = sum(QT_I_FOC, na.rm = TRUE), QT_I_PER = sum(QT_I_PER, na.rm = TRUE),
            QT_P_FEC = sum(QT_P_FEC, na.rm = TRUE), QT_DE_C = sum(QT_DE_C, na.rm = TRUE),
            QT_DE_E = sum(QT_DE_E, na.rm = TRUE)
            )

consolidado <- consolidado %>%
  inner_join(aux)

rm(aux)
#Mudar isso para cada ano
consolidado["data"] <- NA

inicio_periodo_2013 <- as.Date("2013-01-01")
inicio_periodo_2014 <- as.Date("2014-01-01")
inicio_periodo_2015 <- as.Date("2015-01-01")

vetorPosicoes <- 1:length(consolidado$NU_ANO)
periodo_2013 <- vetorPosicoes[consolidado$NU_ANO == 2013] 
periodo_2014 <- vetorPosicoes[consolidado$NU_ANO == 2014]
periodo_2015 <- vetorPosicoes[consolidado$NU_ANO == 2015]

consolidado$data[periodo_2013] <- inicio_periodo_2013

#***
#Executar etapas e verificar se comando abaixo substitui o loop, que esta extremamente lento

consolidado$data[periodo_2013] <- (consolidado$data[periodo_2013] + (consolidado$NU_SEMAN[inicio_periodo_2013] * 7)) - 1

for(i in periodo_2013) {
  
  consolidado$data[i] <- (consolidado$data[i] + (consolidado$NU_SEMAN[i] * 7)) - 1
    
}

consolidado$data[periodo_2014] <- inicio_periodo_2014

for(i in periodo_2014) {
  
  consolidado$data[i] <- (consolidado$data[i] + (consolidado$NU_SEMAN[i] * 7)) - 1
  
}

consolidado$data[periodo_2015] <- inicio_periodo_2015

for(i in periodo_2015) {
  
  consolidado$data[i] <- (consolidado$data[i] + (consolidado$NU_SEMAN[i] * 7)) - 1
  
}

municipios <- read.dbf("dados/tb_uf.dbf")

encontro <- match(substring(consolidado$CO_MUNIC, 1, 2), municipios$CO_UF)

consolidado["UF"] <- municipios$DS_SIGLA[encontro]

#***
#pequena limpeza nos dados de populacao eh necessaria e estah sendo realizada abaixo

colnames(populacao)[1] <- "ibge"
populacao$populacao <- substring(populacao$ibge, 1, 6)

encontro <- match(consolidado$CO_MUNIC, populacao$ibge)

for(i in 2013:2015) {

  encontro[consolidado$NU_ANO == i] <- populacao$`2013`[encontro[consolidado$NU_ANO == i]]

}

consolidado["populacao"] <- encontro


fwrite(consolidado, "dados/processados/larva_pulpa_transformado.csv")

#teste <- toJSON(consolidado)
#write_json(consolidado, "dados/larva_pulpa_consolidado.json")


#***
#Todas as variaveis exigidas em larva-pulpa foram aqui construidas, o procedimento devera ser muito parecido para os retantes processos