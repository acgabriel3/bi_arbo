#***
#SCRIPT MAE INTERFACES


retorna_interfaces_funcoes <- function(arquivos) {
  
   if(length(arquivos) == 0) 
     arquivos <- "vazio"
  
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


interface <- function(nomeInterface = NULL, caule = FALSE) {
  
  #***
  #Pesquisar acerca do tratamento padrao de erros no R e implementar 
  if(is.null(nomeInterface)) {
    
    return(
      print("O nome da interface deve ser indicado")
    )
    
  }
  
  
  if (caule) {
    diretorioCaule <<- getwd()
  }
  
  setwd(nomeInterface)
  
  arquivos <- list.files()
  
  scripts <- retorna_interfaces_funcoes(arquivos)
  
  print("1")
  print(scripts)
  
  for(i in 1:nrow(scripts)) {
    
    diretorio_base_ou_raiz <- getwd()
    
    print("script")
    print(scripts$arquivos[i])
    print("linhas script")
    print(nrow(scripts))
    
    if(nrow(scripts) == 0) {
      setwd("..")
      return()
    }
    
    if(scripts$ehInterface[i] == FALSE) {
      
      print("2")
      print(diretorioCaule)
      print(diretorio_base_ou_raiz)
      
      setwd(diretorioCaule)
      
      source(paste(diretorio_base_ou_raiz, "/", scripts$arquivos[i], sep = ""), local = globalenv())
      
      
      setwd(diretorio_base_ou_raiz)
      if(i == nrow(scripts)) {
        setwd("..")
      }
      
    } else {
      
      print("3")
      print(scripts$arquivos[i])
      
      source(scripts$arquivos[i], local = globalenv())
      
    }
    
  }
  
  #setwd(diretorioCaule)
  
}
