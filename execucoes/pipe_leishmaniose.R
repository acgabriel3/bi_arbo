#CAMINHO

#***
#Pipeline para projeto leishmaniose ---> Enviando para o elastic.

library(readxl)
library(elastic)

source("CRISPDM.R")
source("biblioteca.R")
source("execucoes.R")

#***
#importacao do dado

leish_2010_2017 <- read_excel("dados/leishmaniose/LV2010_2017_NaoNominal.xlsx")
colnames(leish_2010_2017)[colnames(leish_2010_2017) == "ID_MUNICIP"] <- "ibge"
completitude_variaveis_de_uma_tabela(leish_2010_2017)

quantidade_para_cada_observacao(leish_2010_2017$ENTRADA)
quantidade_para_cada_observacao(leish_2010_2017$CS_RACA)

#***
#refatorar funco para calcular completitude relacionada, com mais de um valor padrao e de maneira correta.
#conversar com Marcela para verificar se a mesma efetivou uso da funcao, pois poderia gerar analises erradas
for(i in c("M", "F")) {
    print(
      paste(i, 
      completitude_relacionada(variavel_de_referencia = leish_2010_2017$CS_SEXO, variavel_para_avaliacao = leish_2010_2017$ENTRADA, valoresPadrao = c(i))
      ,sep = " ")  
    )
}

for(i in c("1", "2", "3", "4", "5", "9")) {
  print(
    paste(i, 
          completitude_relacionada(variavel_de_referencia = leish_2010_2017$CS_RACA, variavel_para_avaliacao = leish_2010_2017$ENTRADA, valoresPadrao = c(i))
          ,sep = " ")  
  )
}

for(i in c("1", "2", "9")) {
  print(
    paste(i, 
          completitude_relacionada(variavel_de_referencia = leish_2010_2017$HIV, variavel_para_avaliacao = leish_2010_2017$ENTRADA, valoresPadrao = c(i))
          ,sep = " ")  
  )
}

for(i in c("1", "2")) {
  print(
    paste(i, 
          completitude_relacionada(variavel_de_referencia = leish_2010_2017$CRITERIO, variavel_para_avaliacao = leish_2010_2017$ENTRADA, valoresPadrao = c(i))
          ,sep = " ")  
  )
}

for(i in c("1", "2", "3", "4", "5")) {
  print(
    paste(i, 
          completitude_relacionada(variavel_de_referencia = leish_2010_2017$EVOLUCAO, variavel_para_avaliacao = leish_2010_2017$ENTRADA, valoresPadrao = c(i))
          ,sep = " ")  
  )
}


#***
#Pensar a respeito da analise de consistencia

#***
#pensar se alguma limpeza sera efetivada antes do envio ao elasticsearch
#***
#terminar analise de consistencia 

#***
#transformacao 

library(dplyr)
library(stringi)
library(data.table)

latLon<-fread("dados/demograficos/lat_lon_municipios.csv")
populacaoMuni<-fread("dados/demograficos/populacao_municipios_2010X2017.csv", encoding = "UTF-8")
municipios <- read_excel("dados/leishmaniose/municipios.xlsx")

municipios <- municipios[,c("IBGE","Município")]

colnames(municipios) <- c("ibge","municipio")
colnames(populacaoMuni)<-c("ibge", "pop_2010", "pop_2011", "pop_2012", "pop_2013", "pop_2014", "pop_2015", "pop_2016", "pop_2017")
colnames(latLon)[1] <- "ibge"

leish_2010_2017$ibge <- as.character(leish_2010_2017$ibge)
latLon$ibge <- as.character(latLon$ibge)
municipios$ibge <- as.character(municipios$ibge)

populacaoMuni<-populacaoMuni[-1,]

populacaoMuni$ibge<-substring(populacaoMuni$ibge,1,6)
latLon$ibge <- substring(latLon$ibge,1,6)

#***
#talvez incluir o nome do municipio seja necessario para o georeferenciamento

idade <- year(strptime(leish_2010_2017$DT_NOTIFIC, format = "%Y-%m-%d"))-
  year(strptime(leish_2010_2017$DT_NASC, format = "%Y-%m-%d"))

leish_2010_2017 <- extratificacaoIdade(tabela = leish_2010_2017, 
                                       coluna = idade,
                                       nomeNovaColuna = "extratificacaoIdades")


consolidada<-leish_2010_2017 %>%
                  inner_join(latLon) %>% 
                  inner_join(municipios)

consolidada["lat_long"] <- paste(consolidada$lat, consolidada$lon, sep = "," )

#*** 
#passo temporario, depois refinar 
test <- paste(substring(consolidada$DT_OBITO,7,11), substring(consolidada$DT_OBITO,4,5),substring(consolidada$DT_OBITO,1,2),sep = "-")

test[test=="NA-NA-NA"] <- NA
consolidada$DT_OBITO <- test

test <- as.factor(consolidada$CS_RACA) 
levels(test) <- c("BRANCA","PRETA","AMARELA","PARDA","INDIGENA","IGNORADO")
consolidada$CS_RACA <- test


anos <- year(strptime(leish_2010_2017$DT_NOTIFIC, format = "%Y-%m-%d"))

encontro <- match(consolidada$ibge, populacaoMuni$ibge)

consolidada["populacao"] <- NA
for (i in 1:length(encontro)) {
  pos <- substring(anos[i], 4,4)
  consolidada$populacao[i] <- populacaoMuni[[as.numeric(pos) + 2]][encontro[i]]
}

source("biblioteca.R")

nova_aux <- quantidade_para_cada_observacao(leish_2010_2017$ibge, valoresPadrao = unique(leish_2010_2017$ibge)) %>% arrange(desc(Freq))
nova_aux["pop"] = match(nova_aux$observacoes, populacaoMuni$ibge)
median(nova_aux$Freq)
## a mediana para a freq esperada tem que ser no minimo o numero de anos, ou seja, 8. e foi obtido 3. Portanto
# o dado nao possui cobertura para calcular o indice composto de trienio.