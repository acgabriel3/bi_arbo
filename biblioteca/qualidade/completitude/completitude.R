#***
#CAMINHO
#biblioteca/qualidade/completitude/completitude.R


#-Esta funcao recebe uma coluna referente a alguma variavel de uma tabela
#-Retorna a proporcao de valores vazios dessa coluna pelo total de linhas da coluna
#-Variavel deve ser uma coluna de um data frame, ou um vetor
completitude <- function(variavel) { #variavel = n
  
  variavel <- valores_em_branco_para_NA(variavel = variavel) #complexidade n(chao de 2n)
  
  linhasVazias <- sum(is.na(variavel)) #complexidade n
  totalLinhas <- length(variavel) #complexidade n
  
  resultado <- (linhasVazias/totalLinhas) * 100 #complexidade n(chao de 2n)
  
  return(resultado)
  
} #complexidade n(chao de 2n)
