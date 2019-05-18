#***
# CAMINHO
# execucoes/

library(dplyr)
library(ggplot2)
#***
#incidencia e um tipo de indicador que deve ser calculado antes da aggregation, pois possui caracteristica de conservar a soma.
#desse modo calculamos a incidencia por observacao, como se segue abaixo.
consolidada <- consolidada %>%
  mutate(incidencia = 100000 * (as.numeric(ENTRADA == 1) / as.numeric(populacao)))
#***
# visualizando a variavel incidencia em relação a pop. 
consolidada %>% filter(!is.na(incidencia)) %>%
  ggplot(aes(x = incidencia, y = as.numeric(populacao))) +
  geom_point()

anos <- year(strptime(leish_2010_2017$DT_NOTIFIC, format = "%Y-%m-%d"))

aux <- data.frame(consolidada, anos)

aux["chave"] <- paste(aux$anos, aux$ibge, aux$populacao, sep = '')

var_aux <- aux %>%
  group_by(chave) %>%
  summarize(total_casos = sum(ENTRADA == 1, na.rm = TRUE), incidencia = sum(incidencia, na.rm = TRUE)) %>%
  arrange(chave)

for (ano in 2010:2015) {
  ano_1 <- var_aux[var_aux$anos == ano, ]
  ano_2 <- var_aux[var_aux$anos == ano + 1, ]
  ano_3 <- var_aux[var_aux$anos == ano + 2, ]
  
#***
# visualizando a variavel incidencia em relação a pop. 
var_aux %>% filter(!is.na(incidencia)) %>%
  ggplot(aes(x = incidencia, y = as.numeric(populacao))) +
  geom_point()
