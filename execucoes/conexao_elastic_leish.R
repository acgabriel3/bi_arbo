#***
#CAMINHO
#execucoes/conexao_elastic_leish.R

library(elastic)
library(jsonlite)

#***
#conectado ao pipe_leish
#source(pipeLeishmaniose.R)
#es_data <- elastic("http://localhost:9200")
es_produto <- connect(es_host="localhost", es_port = "9200")
connect()

index_delete("leishmaniose")
index_create("leishmaniose")

docs_bulk(consolidada, index='leishmaniose',type='leish') #Realiza o envio com mapeamento automatico
