#***
#CAMINHO
#FLORESTA

#***
#execucao pipe entomologia do sispncd

source("execucoes/sispncd/resumoSemanal/transformacao_resumo_semanal.R")
source("execucoes/sispncd/vigilanciaEntomologica/transformacao_vigilancia_entomologica.R")
source("execucoes/pipe_entomologia_sispncd.R")



#***
#conexao elastic

library(elastic)
library(jsonlite)

es_produto <- connect(es_host="localhost", es_port = "9200")
conexaoElastic <- connect()


index_delete(conn = conexaoElastic, "entomologia")
index_create(conn = conexaoElastic, "entomologia")


#***
#nao esta sendo possivel usar o timeline
docs_bulk(conn = conexaoElastic, tabela_final_entomologia, index='entomologia', type = "entomologia") #Realiza o envio com mapeamento automatico

body <- '
{
  "mappings": {
    "properties": {
      "data_sem_epd": { 
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
      }
    }
  }
}'

  
  
mapping_create(conn = conexaoElastic, index = "entomologia", type = "entomologia", body = body, update_all_types = TRUE)
