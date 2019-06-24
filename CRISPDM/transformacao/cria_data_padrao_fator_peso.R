#CAMINHO
#CRISPDM/transformacao/cria_data_padrao_fator_peso.R

library(stringi)

#***
#encaixar funcao abaixo em alguma interface em CRISPDM
#***
#Pensar em definir mais de um operador para unir caracteres de modo que aumenta-se a legibilidade (no entanto dificulta a escrita do codigo)
#pensar a respeito
cria_data_padrao_fator_peso <- function(coluna, posAno = NULL, posFator = NULL, tipoFator = NULL) {
  
  '%%' <- function(x,y) paste0(x,y)
  
  if(is.data.frame(coluna)) {
    return(print("coluna deve ser um vetor"))
  }
  
  if(is.null(posAno)) {
    
    ano <- substring(coluna, 1, 4)
    
  } else{
    
    ano <- substring(coluna, posAno[1], posAno[2])
    
  }
  
  if(is.null(posFator)) {
    
    fator <- substring(coluna, 5, 6)
    
  } else {
    
    fator <- substring(coluna, posFator[1], posFator[2])
    
  }
  
  dataEpidemiologica <- paste(ano, "-01-01", sep = "")
  
  dataEpidemiologica <- as.Date(dataEpidemiologica)
  
  fator <- as.numeric(fator)
  
  eval(parse(text = 
               
               tipoFator%%"(dataEpidemiologica) <-"%% tipoFator%%"(dataEpidemiologica)" %%"+ fator - 1"
             
  )
  )
  
  dataEpidemiologica <- paste(dataEpidemiologica, "23:59:59", sep = "T")
  
  return(dataEpidemiologica)
  
} 
