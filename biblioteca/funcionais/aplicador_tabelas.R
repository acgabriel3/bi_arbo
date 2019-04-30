

#Objetivo: Criar uma funcao para aplicar outras funcoes a todas as colunas de uma tabela. 

#***
#Padronizar entradas em todas as funcoes da biblioteca.
#***
#Seria necessario colocar todas as possibilidades possiveis de entrada, talvez seja possivel 
#modularizar este processo (pensar acerca)
#***
#Posso utilizar aqui um swich

aplicador_tabelas <- function(tabela, funcao, funcao2 = NULL, valoresPadrao = NULL, 
                              colunaBase = NULL) #conjunto de variaveis possiveis) 
  {
 
  if(!is.null(funcao2) || !is.null(valoresPadrao) || !is.null(colunaBase))
  sapply(tabela, 
                    function(X) {
                        print(funcao(colunaBase, X, funcao2))
                        }
         )                             
                               
}