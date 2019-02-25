#***
#CAMINHO
#gerenciamento_dados/calcula_observacoes_unicas_ordenadas.R 

calcula_observacoes_unicas_ordenadas <- function(coluna) {
  
  resultado <- unique(coluna)
  resultado <- sort(resultado)
  return(resultado)

} 
