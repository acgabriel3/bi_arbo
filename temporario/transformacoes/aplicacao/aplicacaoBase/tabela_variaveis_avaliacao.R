#CAMINHO
#biblioteca/funcionais/tabela_variaveis_avaliacao.R

library(xlsx)

source("biblioteca/funcionais/limpeza/valores_em_branco_para_NA.R")


#-Esta funcao recebe duas variaveis de mesmo tamanho de uma tabela ou duas, uma funcao da biblioteca de avalicao 
#e valores padrao para serem aplicados na coluna alvo
#-Retorna e registra em formato excel uma tabela com a medida aplicada a cada observacao diferente de variavelBase
#-VariavelBase e variavel devem ser uma coluna de uma data frame, ou um vetor
#-Funcao deve ser uma funcao aplicada a uma coluna, que possua ou nao valoresPadrao como parametro
  #Se nao forem informados valores padrao, a funcao sera aplicada apenas recebendo variavel como parametro
#-ValoresPadrao deve ser um vetor
tabela_variaveis_avaliacao <- function(variavelBase, variavel, funcao, valoresPadrao = NULL) { #variavelBase = n = variavel, levels(variavelBase) = m, valoresPadrao = k
  
  variavelBase <- valores_em_branco_para_NA(variavelBase) #complexidade n
  aux_variavel_base <- as.factor(variavelBase) #complexidade n
  distintos <- levels(aux_variavel_base) #complexidade n
  colunas <- c(distintos) 
  aux <- data.frame(matrix(ncol = length(colunas), nrow = 1))
  colnames(aux) <- colunas

  for(i in 1:length(distintos)) {
    filtro <- variavel[variavelBase == distintos[i]] #complexidade 2n
    
    if(is.null(valoresPadrao)) {
      medida <- funcao(filtro) #complexidade polinomial
    } else {
      medida <- funcao(filtro, valoresPadrao = valoresPadrao) #complexidade mXpolinomialXk
    }
    
    aux[1,i] <- medida
  } #complexidade mXpolinomial ou mXpolinomalXk
  
  #write.xlsx(retorno, "tabela_variaveis_avaliacao.xlsx")
  return(aux)
  
} #complexidade mXpolinomial ou mXpolinomalXk
