

cria_hash_nomesTabelas_nomesColunas <- function(nomes_das_tabelas) {
  
  '%%' <- function(x,y) paste0(x,y)
  
  resultado <- NULL
  
  for(tabela in nomes_das_tabelas) {
    
    resultado <- append(resultado, eval(parse(text = 
      
                                            "list("%%tabela%%" = c(colnames("%%tabela%%")))"    
      
                                            )
                                      ) 
              )
  }
  
  return(resultado)
  
}

gera_nomesColunas_unicos <- function(hash_de_nomes) {
  
  return(unique(unlist(hash_de_nomes)))

}


