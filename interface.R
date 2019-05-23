#***
#SCRIPT MAE INTERFACES


retorna_interfaces_funcoes <- function(arquivos) {
  
  ehInterface <- data.frame(arquivos = arquivos, ehInterface = FALSE, ehScript = TRUE)
  
  for(i in 1:length(arquivos)) {
    
    aux <- paste(arquivos[i], ".R", sep = "")
    
    pos <- aux == ehInterface$arquivos
    
    ehInterface$ehInterface[pos] <- TRUE
    
  }
  
  for(i in 1:length(arquivos)) {
    
    tamanhoString <- nchar(arquivos[i])
    
    capturaScript <- substring(arquivos[i], tamanhoString - 1, tamanhoString)
    
    if(capturaScript != ".R") {
      ehInterface$ehScript[i] <- FALSE
    }
    
  }
  
  ehInterface <- ehInterface[ehInterface$ehScript,]
  
  ehInterface <- ehInterface[c("arquivos", "ehInterface")]
  
  ehInterface$arquivos <- as.character(ehInterface$arquivos)
  
  return(ehInterface)
  
}


interface <- function(nomeInterface = NULL) {
  
  #***
  #Pesquisar acerca do tratamento padrao de erros no R e implementar 
  if(is.null(nomeInterface)) {
    
    return(
      print("O nome da interface deve ser indicado")
    )
    
  }
  
  
  diretorioCaule <- getwd()
  
  setwd(nomeInterface)
  
  arquivos <- list.files()
  
  scripts <- retorna_interfaces_funcoes(arquivos)
  
  for(i in nrow(scripts)) {
    
    diretorio_base_ou_raiz <- getwd()
    
    if(scripts$ehInterface[i] == FALSE) {
      
      print(diretorioCaule)
      
      setwd(diretorioCaule)
      
      source(paste(diretorio_base_ou_raiz, "/", scripts$arquivos[i], sep = ""))
      
      setwd(diretorio_base_ou_raiz)
      
    } else {
      
      print(scripts$arquivos[i])
      
      source(scripts$arquivos[i])
      
    }
    
  }
  
  setwd(diretorioCaule)
  
}
