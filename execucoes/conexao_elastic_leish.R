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

#***
#eh possivel que a biblioteca elastic esteja desatualizada da versao 7.0 do elasticsearch
body <- 
  '{
  "mappings": {
      "properties": {
        "DT_NOTIFIC": {
          "type": "date",
          "format": "yyyy-mm-dd"
        },
        "SG_UF_NOT": {
          "type": "keyword"
        },
        "ibge": {
          "type": "keyword"
        },
        "ID_UNIDADE": {
          "type": "keyword"
        },
        "DT_SIN_PRI": {
          "type": "date",
          "format": "yyyy-mm-dd"
        },
        "DT_NASC": {
          "type": "date",
          "format": "yyyy-mm-dd"
        },
        "IDADE": {
          "type": "integer"
        },
        "CS_SEXO": {
          "type": "text"
        },
        "CS_GESTANT": {
          "type": "text"
        },
        "CS_RACA": {
          "type": "text"
        },
        "CS_ESCOL_N": {
          "type": "text"
        },
        "UF_RESIDENCIA": {
          "type": "keyword"
        },
        "MUNICIPIO_RESIDENCIA": {
          "type": "keyword"
        },
        "CS_ZONA": {
          "type": "text"
        },
        "ID_PAIS": {
          "type": "keyword"
        },
        "DT_INVEST": {
          "type": "date",
          "format": "yyyy-mm-dd"
        },
        "ID_OCUPA_N": {
          "type": "keyword"
        },
        "FEBRE": {
          "type": "text"
        },
        "FRAQUEZA": {
          "type": "text"
        },
        "EDEMA": {
          "type": "text"
        },
        "EMAGRA": {
          "type": "text"
        },
        "TOSSE": {
          "type": "text"
        },
        "PALIDEZ": {
          "type": "text"
        },
        "BACO": {
          "type": "text"
        },
        "INFECCIOSO": {
          "type": "text"
        },
        "FEN_HEMORR": {
          "type": "text"
        },
        "FIGADO": {
          "type": "text"
        },
        "ICTERICIA": {
          "type": "text"
        },
        "OUTROS": {
          "type": "text"
        },
        "OUTROS_ESP": {
          "type": "text"
        },
        "HIV": {
          "type": "text"
        },
        "DIAG_PAR_N": {
          "type": "text"
        },
        "IFI": {
          "type": "text"
        },
        "OUTRO": {
          "type": "text"
        },
        "ENTRADA": {
          "type": "text"
        },
        "TRATAMENTO": {
          "type": "text"
        },
        "DROGA": {
          "type": "text"
        },
        "PESO": {
          "type": "integer"
        },
        "FALENCIA": {
          "type": "text"
        },
        "CLASSI_FIN": {
          "type": "text"
        },
        "CRITERIO": {
          "type": "text"
        },
        "AUTOCTONE": {
          "type": "text"
        },
        "LPI_UF": {
          "type": "text"
        },
        "LPI_PAIS": {
          "type": "text"
        },
        "LPI_MUNI": {
          "type": "text"
        },
        "DOENCA_RELACIONADA_TRABALHO": {
          "type": "text"
        },
        "EVOLUCAO": {
          "type": "text"
        },
        "DT_OBITO": {
          "type": "date",
          "format": "yyyy-mm-dd"
        },
        "DT_ENCERRA": {
          "type": "date",
          "format": "yyyy-mm-dd"
        },
        "extratificacaoIdades": {
          "type": "text"
        },
        "lat": {
          "type": "float"
        },
        "lon": {
          "type": "float"
        },
        "pop_2010": {
          "type": "integer"
        },
        "pop_2011": {
          "type": "integer"
        },
        "pop_2012": {
          "type": "integer"
        },
        "pop_2013": {
          "type": "integer"
        },
        "pop_2014": {
          "type": "integer"
        },
        "pop_2015": {
          "type": "integer"
        },
        "pop_2016": {
          "type": "integer"
        },
        "pop_2017": {
          "type": "integer"
        },
        "municipio": {
          "type": "text"
        },
        "lat_long": {
          "type": "geo_point"
        }
      }
    }
  }
'

body <-'{
 "mappings": {
     "properties": {
       "lat_long" : {"type":"geo_point"}
      }
   }
 }
'

index_delete(conn = conexaoElastic, "leishmaniose")
index_create(conn = conexaoElastic, "leishmaniose")



docs_bulk(conn = conexaoElastic, consolidada, index='leishmaniose', type = "leish") #Realiza o envio com mapeamento automatico

mapping <- mapping_get(conn = conexaoElastic, index = "leishmaniose")

mapping_create(conn = conexaoElastic, index = "leishmaniose", type = "leish", body = body, update_all_types = TRUE)


nossoMapping <- mapping
#***
#construir mapping de modo que lat e lon sejam referenciados no formato correto, quando da passagem para o elsaticsearch

