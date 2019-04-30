#CAMINHO
#biblioteca/funcionais/quantidade_de_observacoes.R


# -Recebe uma variavel de uma tabela e valoresPadrao
# -Retorna a quantidade de vezes que a totalidade de valores padroes aparecem na tabela, 
#ou o total de observacoes na tabela (por padrao)
quantidade_de_observacoes <- function(variavel, valoresPadrao = NULL) { #variavel = n, valoresPadrao = m
  
  if(!is.null(valoresPadrao)) {
  
    variavel <- subset(variavel, variavel %in% valoresPadrao)  
    
  } 
    
  fatores <- as.factor(variavel)
  categorias <- levels(fatores)
  total <- 0
  
  for(i in 1:length(categorias)) {
    total <- total + sum(fatores == categorias, na.rm = TRUE) 
  } #complexidade mn
    
  return(total)
  
} #complexidade mn