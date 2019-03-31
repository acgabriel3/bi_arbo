

uneTabelas <- function(nomeTabelas, formatoArquivos = NULL) {
  
  '%UNE%' <- function(x, y) paste0(x,y)
  
  resultado <- NULL
  
  if(!is.null(formatoArquivos)) {
    nomeTabelas <- nomeTabelas[grepl(formatoArquivos, nomeTabelas)]
  }
  
  for(tabela in nomeTabelas) {
    
    resultado <- rbind( resultado, eval(as.symbol(tabela)) )
                 
  }
  
  return(resultado)
  
}
