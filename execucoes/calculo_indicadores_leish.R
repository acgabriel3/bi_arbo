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