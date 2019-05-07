#***
#Script entendido como "main" 

library(jsonlite)

dados_piloto_2018 <- jsonlite::stream_in(file("dados/dados-piloto-arbo-novembro-2018.json"), verbose=FALSE, pagesize=10000)

#Pode ser uma visualizacao acerca dos tipos de deposito da regiao
#Pode ser um georeferenciamento entre equipes (poderia ateh ser utilizada a ideia da rede social se existissem os dados)


library(foreign)
source("CRISPDM.R")

sinamDados <- read.dbf("dados/ubv/Consolidado 2013_2017.dbf")

sinam_dados_a <- read.dbf("dados/ubv/Consolidado 2013_2017_a.dbf")


str(sinamDados)
#Os dados parecem estar com qualidade

verificaNas(sinamDados) #Apenas a coluna CO_VEIC apresenta valores vazios

for(i in 1:length(sinamDados)) {
  
  print(paste("Valores unicos coluna : ", colnames(sinamDados)[i], " " ,sep = ""))
  print(calcula_observacoes_unicas_ordenadas(sinamDados[[i]]))
  
} #os dados parecem apresentar boa qualidade informacional

str(sinam_dados_a)

verificaNas(sinam_dados_a) #Todas as colunas estao cheias (sem valores vazios)


for(i in 1:length(sinam_dados_a)) {
  
  print(paste("Valores unicos coluna : ", colnames(sinam_dados_a)[i], " " ,sep = ""))
  print(calcula_observacoes_unicas_ordenadas(sinam_dados_a[[i]]))
  
} #os dados parecem apresentar boa qualidade informacional 

#***
#PERGUNTAS
#-O que eh possivel construir de visualizacoes acerca destes dados
  #Eh possivel fazer observacoes por ciclo (mas qual o padrao deste dado)
  #Parecem haverem quantidades de consumo, as mesmas tambem poderiam ser utilizadas para construir observacoes
  #Parecem haverem localizacoes, talvez seja possivel obter visualizacoes acima dos padroes presentes para localizacoes 
  #Existem dados temporais que poderiam ser utilizados para construir evolucoes historicas
  #O mesmo para municipios
  #Hah a possibilidade de visualizar tambem dados de localizacao presentes, mas devera haver um entendimento mais profundo sobre o dado 

#-Quais indicadores podemos construir
  #

library(data.table)

municipios_lat_lon <- fread("lat_lon_municipios.csv")

tabela %>%
  group_by("IBGE") %>%
  summarise(coluna = sum(coluna), outraColuna = sum(outraColuna))

#OBs: Faltou a variavel uf na tabela objetivo


