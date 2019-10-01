#***
#Teste de importacao de dados populacionais
#fonte: http://www2.datasus.gov.br/DATASUS/index.php?area=0901&item=1&acao=36

library(foreign)
library(mefa)
library(withr)
library(elastic)

source("CRISPDM.R")

deszipaTabelas(diretorioAlvo = "dados/demograficos/populacionais", formato = ".zip")

arquivos_1 <- leitura_automatica_por_tipo_arquivo(diretorioAlvo = "dados/demograficos/populacionais/", formatoArquivo = ".DBF", funcao_de_leitura = "read.dbf")
arquivos_2 <- leitura_automatica_por_tipo_arquivo(diretorioAlvo = "dados/demograficos/populacionais/", formatoArquivo = ".dbf", funcao_de_leitura = "read.dbf")

POPTBR18.dbf <- POPTBR18.dbf[,c(1,2,3)]

arquivos <- c(arquivos_1, arquivos_2)

populacoesMunicipios <- uneTabelas(arquivos, formatoArquivos = "POP", remover = TRUE)

populacoesMunicipios <- populacoesMunicipios[which(populacoesMunicipios$ANO %in% c(2013:2019)),] #filtrando neste ponto para objetivos do tratamento de dados de ZIKA

colnames(populacoesMunicipios) <- c("ID_MUNICIP", "NU_ANO", "POPULACAO")

populacoesMunicipios$ID_MUNICIP <- as.character(populacoesMunicipios$ID_MUNICIP)
populacoesMunicipios$NU_ANO <- as.character(populacoesMunicipios$NU_ANO)
populacoesMunicipios$ID_MUNICIP <- substring(populacoesMunicipios$ID_MUNICIP, 1, 6) 

vector <- sort(as.numeric(paste(populacoesMunicipios$ID_MUNICIP, populacoesMunicipios$NU_ANO, sep = "")))

match <- match(vector, paste(populacoesMunicipios$ID_MUNICIP, populacoesMunicipios$NU_ANO, sep = ""))

populacoesMunicipios <- populacoesMunicipios[match,]

populacional <- rep(populacoesMunicipios, each=52)

semanas <- rep(c(1:52), nrow(populacoesMunicipios))

semanas <- stri_pad(semanas, width = 2, pad = "0")

populacional$NU_ANO <- paste(populacional$NU_ANO, semanas, sep = "")

#Aqui os dados de semana, mes e dia sao formatados para o formato elasticsearch definido pelo SVDados yyyy-mm-ddTHH-MM-SS, por meio da funcao do pacote CRISPDM. As colunas sao reordenadas para o padrao definido no SVDados
fim_primeiras_semanas <- c("2013" = "2013-01-12", "2014" = "2014-01-04", "2015" = "2015-01-10", "2016" = "2016-01-09", 
                         "2017" = "2017-01-07", "2018" = "2018-01-06", "2019" = "2019-01-01") 


populacional$NU_ANO <- cria_data_padrao_fator_peso(populacional$NU_ANO, posAno = c(1,4), posFator = c(5,6), tipoFator = "week", datas_finais_semanas = fim_primeiras_semanas)

populacional$UF <- substring(populacional$ID_MUNICIP, 1, 2)

#***
#reduzindo espaco de memoria RAM utilizado

rm(populacoesMunicipios)
rm(match)
rm(semanas)
rm(vector)

#***
#Populando elastic search
# 
#  conn <- connect(es_host = "localhost", es_port = "9200")
#  
#  connect()  
#  
#  index_delete(conn = conn, "populacional")
#  
#  index_create(conn = conn, "populacional")
#  
#  docs_bulk(populacional, conn = conn ,index = "populacional")  
