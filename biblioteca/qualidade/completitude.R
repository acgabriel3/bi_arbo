#***
#CAMINHO
#biblioteca/qualidade/completitude.R

library(xlsx)

#***
#QUALIDADE

source("biblioteca/qualidade/completitude/completitude.R")


#***
#COMPOSTA PARA TABELA

#-Esta funcao recebe uma tabela inteira
#-Retorna uma tabela com a completitude de cada variavel da tabela
#-Funciona para valores em branco e NA
#-Tabela deve ser um data frame
completitude_variaveis_de_uma_tabela <- function(tabela, registrar = FALSE) { #tabela linhas = n tabela colunas = m
  
  numLinhas <- length(tabela) #complexidade m
  nomeColunas <- colnames(tabela) #complexidade m
  
  tabVariavel_x_completitude <- data.frame(variavel = c(1:numLinhas), completitude = NA) #complexidade inteira
  
  
  for(i in 1:numLinhas) {
    
      tabVariavel_x_completitude$variavel[i] <- nomeColunas[i] #complexidade 1
      tabVariavel_x_completitude$completitude[i] <- completitude(as.vector(tabela[[as.character(nomeColunas[i])]])) #complexidade m + 4n
    
  } #complexidade 4nm + mQuadrado
  
  if(registrar)
  write.xlsx(tabVariavel_x_completitude, "completitude_variaveis.xlsx")
  
  return(tabVariavel_x_completitude)
  
} #complexidade nm(chao de 4nm) ou mQuadrado (depende do qtd de variaveis) ou nm + mQuadrado


#***
#COMPOSTA PARA AVALIACAO COM BASE EM OUTRA VARIAVEL

#-Esta funcao recebe duas colunas de um data.frame, e uma lista de caracteres
#-Retorna a completitude da "variavel_para_avaliacao" contendo apenas as linhas que possuiam um determinado
#caractere na "variavel_de_referencia"
#-Funciona para valores em branco e NA
#-As variaveis devem advir de um data.frame
completitude_relacionada <- function(variavel_de_referencia, variavel_para_avaliacao, valoresPadrao) { #variavel_de_referencia = n = variavel_para_avaliacao  valoresPadrao = m
  
  variavel_de_referencia <- as.character(variavel_de_referencia) #complexidade n
  tabela <- data.frame(variavel_de_referencia, variavel_para_avaliacao) #complexidade n
  
  linhas <- variavel_de_referencia == .Machine$integer.max #complexidade n
  
  for(i in 1:length(valoresPadrao)) {
    
      linhas <- linhas | (variavel_de_referencia == as.character(valoresPadrao[i])) #complexidade 2n
    
  } #complexidade 2nm
  
  tabela <- tabela[linhas,] #complexidade n
  
  
  retorno <- completitude(tabela[,2])
  
  return(retorno)
} #complexidade nm(chao de 2nm)
