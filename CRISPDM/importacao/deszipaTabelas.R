#***
#CAMINHO
#CRISPDM/importacao/deszipaTabelas.R

deszipaTabelas <- function(diretorioAlvo = NULL, formato = NULL) {
  
  diretorioAtual <- getwd()
  
  if(is.null(diretorioAlvo)) {
    
    dadosDiretorio <- list.files()
  
  } else {
    
    setwd(paste(diretorioAtual, diretorioAlvo, sep = ""))
    dadosDiretorio <- list.files()
        
  }
  
  if(is.null(formato)) {
    formato <- ".zip"
  }
  
  dadosDiretorio <- dadosDiretorio[grepl(formato, dadosDiretorio)]
  
  for(zip in dadosDiretorio) {
    
    unzip(zip)

  }
  
  setwd(diretorioAtual)
  
  return()
  
}
