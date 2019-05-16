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
conexaoElastic <- connect()

index_delete(conn = conexaoElastic, "leishmaniose")
index_create(conn = conexaoElastic, "leishmaniose")

docs_bulk(conn = conexaoElastic, consolidada, index='leishmaniose',type='leish') #Realiza o envio com mapeamento automatico

#***
#construir mapping de modo que lat e lon sejam referenciados no formato correto, quando da passagem para o elsaticsearch