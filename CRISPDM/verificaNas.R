#CAMINHO
#gerenciamento_dados/verificaNas.R

verificaNas <- function(tabela){
  
  resultado <- c(NULL)
  
  for(i in 1:length(tabela)) {
    
    '%UNE%' <- function(x,y) paste(x, y) 
    
    print(paste("Quantidade Nas coluna : ", colnames(tabela)[i], " " ,sep = ""))
    
    nomeVariavel <- colnames(tabela)[i]
    nas <- sum(is.na(tabela[[i]]), na.rm = TRUE)
    
    resultado <- 
      
      eval(parse(text =
                   "c(resultado," %UNE%
                   nomeVariavel %UNE%
                   "=" %UNE%
                   "nas" %UNE%
                   ")"
        
        
      ))
    
    #***
    #Como fazer isso sem metaprog? 
    
    print(nas)
    
  }
  
  return(resultado)
  
}
