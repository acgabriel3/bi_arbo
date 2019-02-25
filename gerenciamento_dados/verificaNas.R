#CAMINHO
#gerenciamento_dados/verificaNas.R

verificaNas <- function(tabela){
  
  for(i in 1:length(tabela)) {
    
    print(paste("Quantidade Nas coluna : ", colnames(tabela)[i], " " ,sep = ""))
    print(sum(is.na(tabela[[i]])))
    
  }
  
}