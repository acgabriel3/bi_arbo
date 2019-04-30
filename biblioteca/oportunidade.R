#***
#Funcoes irmas
source("biblioteca/funcionais.R")

#***
#OPORTUNIDADE

#-Esta funcao recebe duas colunas de uma mesma tabela referente a datas que devem estar no formato %aaaa%mm%dd (ano, mes e dia)
#-Recebe uma lista de valores padrao e uma coluna que servira para filtrar de acordo com determinado valor padrao.
#-retorna a media do intervalo de tempo entre as observacoes de uma mesma linha das colunas de datas filtradas de acordo com o escolhido.
duracao_em_dias <- function(coluna_data_x = NULL, coluna_data_y = NULL, mediana = FALSE
                            ,quantidade_dias_referencia = NULL, valoresPadrao = NULL
                            ,variavel_identificador = NULL, formato = NULL) { # coluna_data_x = n = coluna_data_y, valoresPadrao = m
  
  
  if(xor(is.null(valoresPadrao), is.null(variavel_identificador))) {
    
    return("valoresPadrao ou variavel de valoresPadrao nao indicados")
    
  } else if(is.null(coluna_data_x) || is.null(coluna_data_y)) {
    
    return("As duas colunas devem ser preenchidas")
    
  } else{
    
    coluna_data_x <- valores_em_branco_para_NA(variavel = coluna_data_x) #complexidade n(chao de 2n)
    coluna_data_y <- valores_em_branco_para_NA(variavel = coluna_data_y) #complexidade n(chao de 2n)
    
  }
  
  if(!is.null(formato)) {
    
    coluna_data_x <- as.Date(coluna_data_x, format = formato) #complexidade n>>
    coluna_data_y <- as.Date(coluna_data_y, format = formato) #complexidade n>>
    
  } else {
    
    coluna_data_x <- as.Date(coluna_data_x) #complexidade n>>
    coluna_data_y <- as.Date(coluna_data_y) #complexidade n>>
    
  }
  
  #equivalente ao "difftime" funcao do R.
  diferenca_de_dias <- coluna_data_x - coluna_data_y # complexidade n(chao de 2n)
  
  if(!is.null(quantidade_dias_referencia)) {
    #diferencaInferior <- diferenca_de_dias[diferenca_de_dias < quantidade_dias_referencia] #complexidade 2n
    #diferencaSuperior <- diferenca_de_dias[diferenca_de_dias > quantidade_dias_referencia] #complexidade 2n
    
    
    #Segundo o cliente sao necessarios somentes os calculos referentes as limpezas
    #total_diferenca_inferior <- length(diferencaInferior)
    #total_diferenca_superior <- length(diferencaSuperior)
    
    #Precisa da proporcao?
    #print(paste(total_diferenca_inferior, " registros abaixo de ", quantidade_dias_referencia, " dias",sep = ""))
    #print(paste(total_diferenca_superior, " registros acima de ", quantidade_dias_referencia, " dias",sep = ""))
  }
  
  if(!is.null(valoresPadrao) && !is.null(variavel_identificador)) { 
    
    
    diferenca_de_dias <- subset(diferenca_de_dias, variavel_identificador %in% valoresPadrao) #complexidade nm
    
    total_identificada_inferior <- sum(diferenca_de_dias <= quantidade_dias_referencia, na.rm = TRUE) #complexidade 2n
    total_identificada_superior <- sum(diferenca_de_dias > quantidade_dias_referencia, na.rm = TRUE) #complexidade 2n

    
    print(paste(total_identificada_inferior, " registros abaixo de ", quantidade_dias_referencia, " dias"
                ," para valoresPadrao",sep = ""))
    print(paste(total_identificada_superior, " registros acima de ", quantidade_dias_referencia, " dias"
                ," para valoresPadrao",sep = ""))
    
  }
  
  media <- mean(diferenca_de_dias, na.rm = TRUE) #complexidade n
  if (mediana == TRUE) {
    mediana <- median(diferenca_de_dias, na.rm = TRUE) #complexidade n
    print(paste("mediana: ",mediana, sep = "")) #complexidade n
  }
  
  print(paste("media: ", media, sep = "")) #complexidade n
  
} #complexidade nm
