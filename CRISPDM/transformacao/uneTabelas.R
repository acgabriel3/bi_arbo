#CAMINHO
#CRISPDM/transformacao/uneTabelas.R   

# - A funcao recebe: nomeTabelas = uma lista de strings, contendo o nome de todas as tabelas presentes na mem?ria que deverao ser juntadas em uma soh
# - A funcao pode receber: formatoArquivos = uma string comum a todos os nomes de tabelas que deseja-se unir , remover = se setado para TRUE a funcao ira remover
#todas as tabelas que foram unificadas da memoria ram
# - Retorna uma tabela com todas as tabelas que foram unificadas
uneTabelas <- function(nomeTabelas, formatoArquivos = NULL, remover = FALSE) {
  
  '%%' <- function(x, y) paste0(x,y)
  
  resultado <- NULL
  
  if(!is.null(formatoArquivos)) {
    nomeTabelas <- nomeTabelas[grepl(formatoArquivos, nomeTabelas)]
  }
  
  for(tabela in nomeTabelas) {
    
    resultado <- rbind( resultado, eval(as.symbol(tabela)) )
    
    if(remover) 
      eval(parse( text = 
                    "rm("%%tabela%%",envir=globalenv()"%%")"
      ))
                 
  }
  
  return(resultado)
  
}
