#***
#Apenas um ensaio acerca do formato de "tempo" para todas as tabelas inseridas no data lake...
#Lembrando que de fato o data lake eh "baguncado" pois nao eh necessario que se limpe todos os dados que serao inseridos la


#***
#Um exemplo de formatacao do dado
library(lubridate)

dadoFormato <- as.POSIXct("21/06/1998 12:35:25", tryFormats = c("%d/%m/%Y %H:%M:%OS"))

View(head(larva_pulpa_2013, 500))

inicio_periodo_2013 <- as.Date("2013-01-01")
larva_pulpa_2013$data <- inicio_periodo_2013

larva_pulpa_2013$data <- (larva_pulpa_2013$data + (larva_pulpa_2013$NU_SEMAN * 7)) - 1

data_larva_pulpa <- paste(larva_pulpa_2013$data, "23:59:59",  sep = " ")

#***
#O que eh o ultimo valor que esta aparecendo ao gerar essas datas
data_larva_pulpa_formatado <- as.POSIXct(data_larva_pulpa, tz = "America/Fortaleza" ,tryFormats = c("%Y-%m-%d %H:%M:%S"))


