


mostra_colunas_distintas_doMaior_conjunto <- function(hash_nomesTabelas_nomesColunas, tabelaReferencia = NULL) {
  
  max <- -1
  pos <- -1
  conjuntoReferencia <- NULL
  
  if(is.null(tabelaReferencia)) {
  
    for(i in 1:length(hash_nomesTabelas_nomesColunas)) {
      
      tamanho <- length(hash_nomesTabelas_nomesColunas[[i]]) 
      
      if(tamanho > max) {
       
        max <- tamanho  
        pos <- i
        
      }
      
    }
      
    conjuntoReferencia <- hash_nomesTabelas_nomesColunas[[pos]]
    
  } else {
    
    conjuntoReferencia <- hash_nomesTabelas_nomesColunas[[tabelaReferencia]]
    
  }
  
  for(i in 1:length(hash_nomesTabelas_nomesColunas)) {
    
    hash_nomesTabelas_nomesColunas[[i]] <- setdiff( hash_nomesTabelas_nomesColunas[[i]], conjuntoReferencia)  
    
  }
  
  return(hash_nomesTabelas_nomesColunas)
  
} #possivel melhorar a complexidade
