
library(readxl)

armadilhas2013 <- read_excel("dados/armadilha/2013.xlsx")
armadilhas2014 <- read_excel("dados/armadilha/2014.xlsx")
armadilhas2015 <- read_excel("dados/armadilha/2015.xlsx")
armadilhas2016 <- read_excel("dados/armadilha/2016.xlsx")
armadilhas2017 <- read_excel("dados/armadilha/2017.xlsx")

armadilhas2017 <- armadilhas2017[,-20:-41]


#***
#Este codigo abaixo eh apenas um exemplo de meta programacao, para treino pessoal do autor
armadilhasConsolidado <- armadilhas2013
for(ano in 2014:2017) {
  eval(parse(text = paste("armadilhasConsolidado", "<-", "rbind(armadilhas", ano, ", armadilhasConsolidado)", sep = "")))
}

#***
#Codigo funcional de fato: 
armadilhasConsolidado <- rbind(armadilhas2013, armadilhas2014, armadilhas2015, armadilhas2016, armadilhas2017)

colunasChave <- c("NU_ANO", "NU_SEMAN", "CO_MUNIC")

consolidado <- armadilhasConsolidado %>%
                  group_by(colunasChave) %>%
  summarise(
 "CO_VIGIL" "NU_ANO"   "NU_SEMAN" "NU_MES_C" "CO_CONTR" "CO_MUNIC" "NU_LOCAL" "CO_ATIVI" "TP_ARMAD" "TO_QUART" 
 TO_IMOV = sum(TO_IMOV, na.rm = TRUE), 
 "TO_ARMAD" "TO_POSIT" "TO_TUBPA" "TO_OVO"   "TO_LARVA"
"TO_AEGYP" "TO_ALBOP" "TO_OUTRO" )

