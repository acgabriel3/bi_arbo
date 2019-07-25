#CAMINHO
#CRISPDM/transformacao/cria_data_padrao_fator_peso.R

library(stringi)
library(lubridate)

#***
#Pensar em definir mais de um operador para unir caracteres de modo que aumenta-se a legibilidade (no entanto dificulta a escrita do codigo)
#pensar a respeito

#-Recebe coluna = coluna de datas especificas com determinado detalhamento, posAno = vetor com dois elementos, o inicio do ano na string coluna e o final da string ano na string coluna,
#posFator = vetor com dois elementos, o inicio da string do fator (quantos segundos, minutos, horas) e o final da string fator, tipoFator = o nome da função lubridate que lida com o nive de detalhamento especifico (segundo, minutos, dias)
#-inclui a ultima data do detalhe (a ultima hora do dia) a coluna, calcula cada observacao segundo o fator
#-Retorna coluna de datas formatada segundo o elasticsearch, podendo ser advinda de uma agregacao de group_by
cria_data_padrao_fator_peso <- function(coluna, posAno = NULL, posFator = NULL, tipoFator = NULL, datas_finais_semanas = NULL) {

  '%%' <- function(x,y) paste0(x,y)
  
  if(is.data.frame(coluna)) {
    return(print("coluna deve ser um vetor"))
  }
  
  if(is.null(datas_finais_semanas) && (tipoFator == "week")) {
    return(print("tipoFator deve ser week"))
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
  
  #***
  # Concertar posteriormente a padronizacao de acordo com o nivel de detalhamento, o problema de fato eh que nem todo mes possui 31 dias 
  
  if(tipoFator == "month") {

    dataInicial <- paste(ano, "-01-01", sep = "")
    

  } else if(tipoFator == "year") {

    dataInicial <- paste(ano, "-12-31", sep = "")

  } else if(tipoFator == "week") {
    
    dataInicial <- datas_finais_semanas[ano]
    
  } else {
  
    dataInicial <- paste(ano, "-01-01", sep = "")
  
  }
  
  dataInicial <- as.Date(dataInicial)
  
  fator <- as.numeric(fator)
  
  if (tipoFator != "month") {
  
      eval(parse(text = 
                 
                 tipoFator%%"(dataInicial) <-"%% tipoFator%%"(dataInicial)" %%"+ fator - 1"
               
    )
    ) 
    
  } else {
    
    eval(parse(text = 
                 
                 tipoFator%%"(dataInicial) <-"%% tipoFator%%"(dataInicial)" %%"+ fator"
               
    )
    ) 
    
    day(dataInicial) <- day(dataInicial) - 1
    
  }
  
  dataFinal <- paste(dataInicial, "23:59:59", sep = "T")
  
  return(dataFinal)
  
} 

