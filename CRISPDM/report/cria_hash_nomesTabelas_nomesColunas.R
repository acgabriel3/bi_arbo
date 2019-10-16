

cria_hash_nomesTabelas_nomesColunas <- function(nomes_das_tabelas) {
  
  '%%' <- function(x,y) paste0(x,y)
  
  if(is.null(nomes_das_tabelas)) {
  
    return(print("o parametro 'nomes_das_tabelas' deve estar preenchido"))
  
  }
  
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


