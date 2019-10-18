
#-Recebe vetor com strings indicando o nome das variaveis que guardam os data.frames com as colunas de interesse
#-Com metaprogramaco cria um hash (tabela -> nomes da coluna da tabela) para cada tabela indicada no vetor de strings
#-Retorna hash 
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

#-recebe hash (string -> vetor de strings)
#-Naturalmente pensada para gerar um vetor com todas as strings disponiveis dentre as tabelas de interesse 
#-retorna uniao matematica dos vetores de strings, formando um unico vetor de string
gera_nomesColunas_unicos <- function(hash_de_nomes) {
  
  return(unique(unlist(hash_de_nomes)))

}


