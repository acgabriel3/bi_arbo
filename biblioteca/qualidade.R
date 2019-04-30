#***
#cAMINHO
#biblioteca/qualidade.R

#***
#Padrao de programacao:

#-O estilo dplyr eh preterivel ao estilo classico R, para facilitar a comunicacao entre programador e leigo (rever)
#-As funcoes que sera utilizadas pelos usuários finais podem conter ateh 5 palavras em sua constituicao. Devem
#ser o mais clara possíveis
#-toda variavel inicia com letra minuscula e eh separada por "_" caso seja um frase, e por uma letra maiuscula
#caso possua duas palavras
#-Toda funcao deve indicar explicitamente as variaveis de entrada, o que faz e o formato das variaveis de entrada
#-O nome das variaveis e das funcoes nao pode conter mais de 3 palavras
#-Toda funcao deve conter um comentario explicando sua funcionalidade
#-Todo passo nao claro deve conter um comentario explicando a sua funcionalidade
#-Todo comentario referente ao codigo que nao se relacionam ao funcionamento logico de alguma parte integrante
#deve conter um comentario anterior no seguinte formato: " #*** "
#-Todo passo, loop e funcao deve apresentar um comentario indicando qual a sua complexidade

#***
#Funcoes irmas
source("biblioteca/funcionais.R")

#***
#QUALIDADE

source("biblioteca/qualidade/completitude.R")

#***
#Melhorar o nome da funcao logo abaixo

#-Esta funcao recebe uma coluna referente a alguma variavel de uma tabela, uma lista dos valores padrao da coluna
#e duas variaveis logicas indicando se eh uma avaliacao de intervalo ou de data
#-Retorna a proporcao de valores que nao estao de acordo com os valores padroes, e indica quais sao estes.
#-Variavel deve ser uma coluna de uma data frame, ou um vetor
#-ValoresPadrao deve ser uma coluna de um data frame, ou um vetor(mesmo que possua apenas um valor)
#-ValoresPadrao deve apresentar o menor valor na primeira posicao, e o maior na segunda caso intervalo seja TRUE
#***
#como tratar os valores nulos? 
#***
#Refatorar funcao para melhorar a usabilidade
#estah eh a validade?
camposDistintos <- function(variavel, valoresPadrao, intervalo = FALSE
                            , data = FALSE, formatoData = NULL) { #variavel = n, valoresPadrao = m
  
  if((data == TRUE) && (intervalo == TRUE)) {
    
    return("data e intervalo nao podem ser simultaneamente verdadeiros")
    
  } else {
    
    variavel <- as.character(variavel) #complexidade n
    variavel <- valores_em_branco_para_NA(variavel = variavel) #complexidade n
    totalVariavel <- length(variavel) #complexidade n
    
  }
  
  if((data == FALSE) && (intervalo == FALSE)) {
    
    totalCorretos <- sum(is.na(variavel))
    
    variavel <- variavel[!is.na(variavel)] #complexidade n
    
    #***
    #as funcoes apply podem ser facilmente empregadas aqui?
    for(i in 1:length(valoresPadrao)) { 
      
      totalCorretos <- totalCorretos + sum(variavel == valoresPadrao[i], na.rm = TRUE) #complexidade n
      
    } #complexidade m.n, com m << n 
    
    #Encontra as posicoes em que existem variaveis que nao estão na lista de variaveis padrao
    variavelIncongruentes <- c(variavel[is.na(match(variavel, valoresPadrao))]) #complexidade n
    variavelIncongruentes <- variavelIncongruentes[!is.na(variavelIncongruentes)]
    
    if(length(variavelIncongruentes) == 0) {
      variavelIncongruentes <- "vazia"
    }
    
    proporcao <- 100 - ((totalCorretos/totalVariavel) * 100) #complexidade n
    
    return(paste(proporcao, "% ", "de valores incongruentes ||| "
                 , "lista de valores incongruentes: ", toString(levels(as.factor(variavelIncongruentes))), sep = "")) #complexidade x << n
    
    
  }
  
  if(data == TRUE) {
    #checa se ha alguma observacao que nao seja uma data
    
    #Caso tenha sido imposto um formato, o utiliza, caso contrario realiza uma chamada padrao
    if(is.null(formatoData)) { 
    
      totalCorretos <- sum(!is.na(as.Date(variavel))) #complexidade 2n
    
    } else {
      
      totalCorretos <- sum(!is.na(as.Date(variavel, format = formatoData))) #complexidade 2n
      
    }
    
    proporcao <- 100 - ((totalCorretos/totalVariavel) * 100) #complexidade n
    return(paste(proporcao, "% ", "de valores incongruentes", sep = ""))
    
  }
  
  if(intervalo == TRUE) {
    
    if(length(valoresPadrao) != 2) {
      return("Intervalo invalido")
    }
    
    #checa se ha alguma informacao fora do intervalo definido
    variavel <- as.numeric(variavel)
    valoresPadrao <- as.numeric(valoresPadrao)
    totalCorretos <- sum((variavel < valoresPadrao[2]) & (variavel > valoresPadrao[1]), na.rm = TRUE) #complexidade 3n
    proporcao <- 100 - ((totalCorretos/totalVariavel) * 100) #complexidade n
    return(paste(proporcao, "% ", "de valores incongruentes", sep = ""))
    
  }
  
  return("erro, entrada incapaz de ser executada")
  
} #complexidade n.m
