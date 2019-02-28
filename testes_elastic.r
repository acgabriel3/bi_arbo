#install.packages('foreign')
library(foreign)

df <- read.dbf('dados/larva-pulpa/2013.dbf')

atividades <- read.dbf('tabelas-auxiliares/ATIVIDADE658874_00.dbf')

produtos <- read.dbf('tabelas-auxiliares/PRODUTO658876_00.dbf')

library(xlsx)

armadilhas <- read.csv('dados/armadilha/2013.csv')

library(rjson)
splitdf <- split(df,nrow(df))

library(jsonlite)
jsondf <- toJSON(df)

install.packages('elastic')
library(elastic)

es_data <- elastic("http://localhost:9200", "sispncd", "data")

es_produto <- connect(es_host="localhost", es_port = "9200")
connect()

#es_produto %index% produtos

ping()
count()
index_settings()
count(index='larvaspupas')
count()
ping()
index_delete('larvaspupas')
index_create('sispncd')

docs_bulk(armadilhas[11:59352,],index='sispncd',type='armadilha')
docs_bulk(atividades,index='sispncd',type='atividades')
docs_bulk(produtos,index='sispncd',type='produtos')
docs_bulk(df,index='sispncd',type='visitas')

delete(splitd)
remove(splitdf)
remove(jsondf)
remove(df)
names(armadilhas)
body_armadilhas <- strwrap(
'{"mappings": 
  {"armadilha": 
   { "properties": { 
      "CO_VIGIL" : {"type" : "text"},
      "NU_ANO"   : {"type" : "date", "format": "yyyy"},
      "NU_SEMAN" : {"type": "integer"},
      "NU_MES_C" : {"type": "date", "format": "MM"},
      "CO_CONTR" : {"type": "integer"}, 
      "CO_MUNIC" : {"type": "text"},
      "NU_LOCAL" : {"type": "integer"}, 
      "CO_ATIVI" : {"type": "integer"}, 
      "TP_ARMAD" : {"type": "integer"}, 
      "TO_QUART" : {"type": "integer"}, 
      "TO_IMOV"  : {"type": "integer"},  
      "TO_ARMAD" : {"type": "integer"},
      "TO_POSIT" : {"type": "integer"}, 
      "TO_TUBPA" : {"type": "integer"},
      "TO_OVO"   : {"type": "integer"},   
      "TO_LARVA"  : {"type": "integer"}, 
      "TO_AEGYP"  : {"type": "integer"}, 
      "TO_ALBOP" : {"type": "integer"},
      "TO_OUTRO" : {"type": "integer"}
    }
  }
}')

library(jsonlite)
j <- toJSON(body_armadilhas)


body <- '{
"mappings": {
"record": {
"properties": {
"location" : {"type" : "geo_point"}
}
}
}
}'

mapping_create('sispncd',body=body_armadilhas)
mapping_create('sispncd',body=body)
index_delete('sispncd')


lavas_pupas <- read.csv('dados/larva_pupa_consolidado.csv')
names(lavas_pupas)

lavas_pupas$lat_long<-paste(lavas_pupas$lat,',',lavas_pupas$lon)

'
put larvaspupas
{
  "mappings": {
    "record": { 
      "properties": { 
        "UF"       : {"type": "keyword"},
        "CO_MUNIC" : {"type": "keyword"},
        "NU_ANO"   : {"type" : "date", "format": "yyyy"},
        "NU_SEMAN" : {"type": "integer"},
        "QT_ATIV_1": {"type": "integer"}, 
        "QT_ATIV_2": {"type": "integer"},  
        "QT_ATIV_4": {"type": "integer"}, 
        "QT_ATIV_5": {"type": "integer"}, 
        "QT_ATIV_6": {"type": "integer"},  
        "QT_ATIV_8": {"type": "integer"},  
        "AT_ATIV_1": {"type": "integer"}, 
        "QT_AMOST" : {"type": "integer"},  
        "QT_DE_A1" : {"type": "integer"},   
        "QT_DE_A2" : {"type": "integer"},  
        "QT_DE_B"  : {"type": "integer"},   
        "QT_DE_D1" : {"type": "integer"}, 
        "QT_DE_D2" : {"type": "integer"},  
        "QT_DE_EL" : {"type": "integer"}, 
        "QT_P_REC" : {"type": "integer"}, 
        "QT_P_RCS" : {"type": "integer"}, 
        "QT_I_INS" : {"type": "integer"}, 
        "QT_IT_PER": {"type": "integer"}, 
        "QT_IT_CO" : {"type": "integer"}, 
        "QT_IT_OU" : {"type": "integer"}, 
        "QT_IT_PE" : {"type": "integer"}, 
        "QT_IT_TB" : {"type": "integer"}, 
        "QT_IT_RE" : {"type": "integer"}, 
        "lat": {"type": "float"}, 
        "lon": {"type": "float"},       
        "data": {"type": "date"},
        "lat_long": {"type": "geo_point"}
      }
    }
  }
}
'

index_delete('larvaspupas')
index_create('larvaspupas')
docs_bulk(lavas_pupas,index='larvaspupas',type='record')

# https://form.jotformeu.com/90498605314359
# https://www.elastic.co/guide/en/elasticsearch/reference/6.5/search-request-script-fields.html
# https://www.elastic.co/guide/en/elasticsearch/reference/6.5/search-aggregations.html#_values_source
