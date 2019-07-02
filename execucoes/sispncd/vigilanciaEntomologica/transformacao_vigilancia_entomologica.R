#***
#CAMINHO

#***
#script para tratar de dados/SISPNCD/vigilanciaEntomologica

library(data.table)
library(stringi)
library(stringr)
library(lubridate)

source("CRISPDM.R")

vigilanciaEnt_ <- fread("dados/SISPNCD/vigilanciaEntomologica/consolidado/vigilanciaEnt_.csv")
vigilanciaEntomo <- fread("dados/SISPNCD/vigilanciaEntomologica/consolidado/vigilanciaEntomo.csv")

#***
#passos a seguir adiante:
#-pegar codigo da micro area ---> Apos mineracao nos dados parece que o dado nao vai de acordo com o ID_DES da tabela de resumo semanal
#-Formatar ID_LOC segundo padrao em resumo semanal

ibgeEnt_ <- substring(vigilanciaEnt_$CO_VIGIL, 1, 6)
ibgeEntomo <- substring(vigilanciaEntomo$CO_VIGIL, 1, 6)

#Em resumo semanao o dado estah com 5, no entanto no dicionario eh especificado para possuir 10 digitos
codLocal <- str_pad(vigilanciaEntomo$NU_LOCAL, 5, pad = "0")

ID_LOC_ENTOMO <- paste(ibgeEntomo, codLocal, sep = "")

vigilanciaEntomo$ID_LOC <- ID_LOC_ENTOMO

#***
#preencher vigilanciaEnt_ por meio da chave com codigo da localidade formatado

encontro <- match(vigilanciaEnt_$CO_VIGIL, vigilanciaEntomo$CO_VIGIL)

vigilanciaEnt_$ID_LOC <- ID_LOC_ENTOMO[encontro]

ano <- substring(vigilanciaEnt_$CO_VIGIL, 12, 15)

vigilanciaEnt_$NU_ANO <- ano

#***
#criando data para semana epidemiologica e para semana mes aonde for possivel 

aux <- cria_data_padrao_fator_peso(coluna = paste(vigilanciaEntomo$NU_ANO, str_pad(vigilanciaEntomo$NU_SEMAN, 2, pad ="0"), sep = ""),
                                  posAno = c(1,4), posFator = c(5,6), tipoFator = "week")

vigilanciaEntomo$data_sem_epd <- aux

aux <- cria_data_padrao_fator_peso(coluna = paste(vigilanciaEntomo$NU_ANO, str_pad(vigilanciaEntomo$NU_MES_C, 2, pad ="0"), sep = ""),
                                   posAno = c(1,4), posFator = c(5,6), tipoFator = "month")

vigilanciaEntomo$data_mes_epd <- aux

vigilanciaEntomo$fonte <- "SISPNCD/ vigilancia entomologica"
vigilanciaEnt_$fonte <- "SISPNCD/ vigilancia entomologica"

ordena_vigilancia_entomo <- c("fonte","data_sem_epd", "data_mes_epd", "ID_LOC","CO_VIGIL", "CO_ATIVI", "TP_ARMAD", "TO_QUART", "TO_IMOV", "TO_ARMAD", "TO_POSIT", "TO_TUBPA", "TO_OVO",
                              "TO_LARVA", "TO_AEGYP", "TO_ALBOP", "TO_OUTRO")

#***
#Obs: Deve-se encontrar um padrao para estas datar 
ordena_vigilancia_ent <- c( "fonte","DT_INST", "NU_ANO", "ID_LOC", "DS_ENDER", "NU_QUART", "NU_ARMAD", "DT_INST", "DT_COLET", "DS_LOCAL", "TP_OCORR", "QT_TUBPA", "QT_OVO", "QT_LARVA",
                           "QT_AEGYP", "QT_ALBOP", "QT_OUTRO")

vigilancia_entomo_consolidada <- vigilanciaEntomo[,..ordena_vigilancia_entomo]
vigilancia_ent_consolidada <- vigilanciaEnt_[,..ordena_vigilancia_ent]

colnames(vigilancia_ent_consolidada) <- c("fonte", "DT_INST", "NU_ANO", "ID_LOC", "DS_ENDER", "NU_QUART", "NU_ARMAD", "DT_INST", "DT_COLET", "DS_LOCAL", "TP_OCORR", "TO_TUBPA", "TO_OVO", "TO_LARVA",
   "TO_AEGYP", "TO_ALBOP", "TO_OUTRO")

vigilancia_ent_consolidada$ID_LOC <- as.character(vigilancia_ent_consolidada$ID_LOC)
vigilancia_entomo_consolidada$ID_LOC <- as.character(vigilancia_entomo_consolidada$ID_LOC)


iguais_vigilancia_ent <- c(
  "TO_TUBPA" = "QT_TUBPA",
  "TO_OVO" = "QT_OVO",
  "TO_LARVA" = "QT_LARVA",
  "TO_AEGYP" = "QT_AEGYP",
  "TO_ALBOP" = "QT_ALBOP",
  "TO_OUTRO" = "QT_OUTRO"
)






