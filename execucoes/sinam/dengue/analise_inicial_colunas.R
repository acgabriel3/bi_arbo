
colnames2017 <- colnames(dengue2017)
colnames2016 <- colnames(dengue2016)
colnames2015 <- colnames(dengue2015)
colnames2014 <- colnames(dengue2014)
colnames2013 <- colnames(dengue2013)

match2015_2016 <- match(colnames2015, colnames2016)
match2017_2016 <- match(colnames2017, colnames2016)
match2014_2015 <- match(colnames2014, colnames2015)
match2013_2015 <- match(colnames2013, colnames2015)


colunas_distintas_2014 <- colnames2014[which(is.na(match2015_2014))]
colunas_distintas_2013 <- colnames2013[which(is.na(match2013_2015))]


#Com esse metodo, seria possivel conseguir realizar o encontro total de todas as variaveis das colunas, disfazendo o processo manual que estava sendo realizado anteriormente
#A concentracao seria na investigacao dos proprios dados. No entanto, este caso so funcionaria para um mesmo nivel de detalhamento, e para colunas semelhantes
#As colunas distintas nao dao garantia alguma de serem realmente distintas das outras, podem ter apenas nomes diferentes. Estas, devem ser atacadas, para se 
#investigar as diferencas


#usar append

