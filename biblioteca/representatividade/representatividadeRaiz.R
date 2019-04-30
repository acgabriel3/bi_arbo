
#-Esta funcao recebe uma coluna de uma tabela, e uma lista e valores que representa valores possiveis na coluna
#-retorna a porcentagem de observacoes da coluna que sao iguais aos valores setados 
representatividade <- function(variavel, valoresPadrao) {#variavel = n, valoresPadrao = m
  
  variavel <- valores_em_branco_para_NA(variavel = variavel) #complexidade n(chao de 2n)
  
  variavelFiltrada <- subset(variavel, variavel %in% valoresPadrao) #complexidade nm
  
  quantidadeDado <- length(variavelFiltrada) #complexidade n(chao de 2n)
  total <- length(variavel) #complexidade n
  
  retorno <- (quantidadeDado/total) * 100 #complexidade n
  return(paste("representatividade: ", retorno, "%", sep = ""))
  
} #complexidade nm