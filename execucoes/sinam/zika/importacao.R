#***
#SCRIPT INICIAL PARA IMPORT??O E CONTATO COM OS DADOS

library(readxl)
library(xlsx)
library(foreign)
library(dplyr)
library(elastic)

source("CRISPDM.R")


zika_2016 <- read.dbf("dados/sinam/zika/ZIKA 2016.dbf")
zika_03_01_2018 <- read.dbf("dados/sinam/zika/Zika_03.01.2018.dbf")
zikaSE17_excel <- read_excel("dados/sinam/zika/SE17_Zika.xlsx", sheet = 1)



#***
#colunas que deve-se excluir:

colunas_sem_informacoes <- c("ID_AGRAVO", "CS_SUSPEIT", "IN_VINCULA", "FONETICA_N", "NU_LOTE_H", "MIGRADO_W")

#***
#colunas que possuem informacoes interessantes:
colunas_que_devem_ser_observadas <- c("ID_REGIONA", "ID_BAIRRO", "NM_BAIRRO", "ID_GEO1", "CLASSI_FIN", "DOENCA_TRA")

#Para verificar os dados vazios utilizar verificaNA, e utilizar o vetor resultado para pegar as colunas onde nao hah preenchimento 

colunas_vazias_2016 <- verificaNas(zika_2016)
colunas_vazias_2016 <- names(colunas_vazias_2016[colunas_vazias_2016 == nrow(zika_2016)])

colunas_vazias_2017 <- verificaNas(zikaSE17_excel)
colunas_vazias_2017 <- names(colunas_vazias_2017[colunas_vazias_2017 == nrow(zikaSE17_excel)])

colunas_vazias_2018 <- verificaNas(zika_03_01_2018)
colunas_vazias_2018 <- names(colunas_vazias_2018[colunas_vazias_2018 == nrow(zika_03_01_2018)])


colunas <- colnames(zika_03_01_2018)

#***
#Parece que ID_REGIONA e ID_RG_REGIONA estao duplicados 
#O que eh a zona e ela estah em um nivel de detalhamento abaixo de regional? a regional esta acima de municipio?
#ID_OCUPA_N, CO_USUALT nao constam no dicionario de dados

ordemColunas <- c("DT_NOTIFIC", "ID_MN_RESI", "NU_CEP", "ID_DISTRIT", "ID_BAIRRO",  "NM_BAIRRO",  "ID_LOGRADO", "NM_LOGRADO", "NU_NUMERO", "NM_COMPLEM",
                         "ID_GEO1", "ID_GEO2", "ID_UNIDADE", "CS_ZONA", "ID_MUNICIP", "ID_REGIONA", "ID_RG_RESI", "ID_PAIS", "SG_UF_NOT", "NU_NOTIFIC", "TP_NOT", "ID_AGRAVO",  
                         "CS_SUSPEIT", "IN_AIDS", "CS_MENING",  "SEM_NOT", "NU_ANO", "DT_SIN_PRI", "SEM_PRI", "NM_PACIENT", "DT_NASC", "FONETICA_N", "SOUNDEX", "NU_IDADE_N",
                         "CS_SEXO", "CS_GESTANT", "CS_RACA", "CS_ESCOL_N", "ID_CNS_SUS", "NM_MAE_PAC", "SG_UF", "NM_REFEREN", "NU_DDD_TEL", "NU_TELEFON", "NDUPLIC_N",
                         "IN_VINCULA", "DT_INVEST",  "ID_OCUPA_N", "CLASSI_FIN", "CRITERIO", "TPAUTOCTO", "COUFINF", "COPAISINF", "COMUNINF", "CODISINF", "CO_BAINFC", "NOBAIINF",
                         "DOENCA_TRA", "EVOLUCAO", "DT_OBITO", "DT_ENCERRA", "DT_DIGITA", "DT_TRANSUS", "DT_TRANSDM", "DT_TRANSSM", "DT_TRANSRM", "DT_TRANSRS", "DT_TRANSSE", "NU_LOTE_V",
                         "NU_LOTE_H",  "CS_FLXRET",  "FLXRECEBI", "IDENT_MICR", "MIGRADO_W",  "CO_USUCAD",  "CO_USUALT",  "TP_SISTEMA", "TPUNINOT")

mapeamento_de_tipos <- c("DT_NOTIFIC" = "character", "ID_MN_RESI" = "character", "NU_CEP" = "character", "ID_DISTRIT" = "character", "ID_BAIRRO" = "character",  "NM_BAIRRO" = "character",
                         "ID_LOGRADO" = "character", "NM_LOGRADO" = "character", "NU_NUMERO" = "character", "NM_COMPLEM" = "character", "ID_GEO1" = "character", "ID_GEO2" = "character", 
                         "ID_UNIDADE" = "character", "CS_ZONA" = "character", "ID_MUNICIP" = "character", "ID_REGIONA" = "character", "ID_RG_RESI" = "character", "ID_PAIS" = "character", "SG_UF_NOT" = "character", 
                         "NU_NOTIFIC" = "character", "TP_NOT" = "character", "ID_AGRAVO" = "character", "CS_SUSPEIT" = "character", "IN_AIDS" = "character", "CS_MENING" = "character", 
                         "SEM_NOT" = "character", "NU_ANO" = "character", "DT_SIN_PRI" = "character", "SEM_PRI" = "character", "NM_PACIENT" = "character", "DT_NASC" = "character", "FONETICA_N" = "character",
                         "SOUNDEX" = "character", "NU_IDADE_N" = "character", "CS_SEXO" = "character", "CS_GESTANT" = "character", "CS_RACA" = "character", "CS_ESCOL_N" = "character", "ID_CNS_SUS" = "character",
                         "NM_MAE_PAC" = "character", "SG_UF" = "character", "NM_REFEREN" = "character", "NU_DDD_TEL" = "character", "NU_TELEFON" = "character", "NDUPLIC_N" = "character",
                          "IN_VINCULA" = "character", "DT_INVEST" = "character",  "ID_OCUPA_N" = "character", "CLASSI_FIN" = "character", "CRITERIO" = "character", "TPAUTOCTO" = "character",
                          "COUFINF" = "character", "COPAISINF" = "character", "COMUNINF" = "character", "CODISINF" = "character", "CO_BAINFC" = "character", "NOBAIINF" = "character",
                          "DOENCA_TRA" = "character", "EVOLUCAO" = "character", "DT_OBITO" = "character", "DT_ENCERRA" = "character", "DT_DIGITA" = "character", "DT_TRANSUS" = "character", 
                          "DT_TRANSDM" = "character", "DT_TRANSSM" = "character", "DT_TRANSRM" = "character", "DT_TRANSRS" = "character", "DT_TRANSSE" = "character", "NU_LOTE_V" = "character",
                          "NU_LOTE_H" = "character",  "CS_FLXRET" = "character",  "FLXRECEBI" = "character", "IDENT_MICR" = "character", "MIGRADO_W" = "character",  "CO_USUCAD" = "character", 
                          "CO_USUALT" = "character",  "TP_SISTEMA" = "character", "TPUNINOT" = "character")


teste <- formata_tabela_basica_formato_final(ordemFinal = ordemColunas, zika_03_01_2018, mapeamento_de_tipos = mapeamento_de_tipos)
teste_zika_2016 <- formata_tabela_basica_formato_final(ordemFinal = ordemColunas, zika_2016, mapeamento_de_tipos = mapeamento_de_tipos)
teste_zika_2017 <- formata_tabela_basica_formato_final(ordemFinal = ordemColunas, zikaSE17_excel, mapeamento_de_tipos = mapeamento_de_tipos)


teste_integracao <- rbind(teste_zika_2016, teste_zika_2017, teste)

teste_integracao$DT_NOTIFIC <- paste(teste_integracao$DT_NOTIFIC, "23:59:59", sep = "T")

#***
#Deu certo, avaliar as variaveis e preparar para o envio ao kibana
#Pesquisar como observar outliers
# 
# conn <- connect(es_host="localhost", es_port = "9200")
# 
# connect()
# 
# index_delete(conn = conn, index = "sinamzika")
# 
# index_create(conn = conn, index = "sinamzika")
# 
# docs_bulk(teste_integracao, conn = conn, index = "sinamzika")
# 
# 

