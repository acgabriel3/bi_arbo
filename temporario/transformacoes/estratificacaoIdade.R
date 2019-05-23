#***
#CAMINHO
#execucoes/transformacoes/estratificacaoIdade.R

#-Essa funcao recebe tabela (um data frame), coluna = A coluna de idade que ira ser estratificada (podendo ser uma data de nascimento ou idades inteiras)
#extratos = A extratificacao escolhida pelo usuario (caso contrario sera usado um modelo padrao), nomeNovaColuna = Pode dar um nome a nova coluna de extratos
#coluna_eh_data_nascimento = indica se o paramentro coluna eh uma data de nascimento para indicar o que a funcao deve fazer, formatoData = indica o formato da
#coluna data de nascimento
#-Se for uma coluna de idades inteiras, apenas cria a extratificacao segundo escolhido. Se for uma coluna de datas, calcula as idades e depois calcula os extratos.
#-Retorna a mesma tabela com a variavel adicional de extratos agregada ao seu final
extratificacaoIdade <- function(tabela, coluna, extratos = NULL, nomesExtratos = NULL, nomeNovaColuna = NULL, coluna_eh_data_nascimento = FALSE, formatoData = NULL) {
  
  resultado <- NULL
  
  if(is.null(nomeNovaColuna)) {
    nomeNovaColuna <- "idade_extrato"
  }
  
  if(is.null(extratos)) {
    extratos <- c(0, 1, 5, 10, 20, 30, 40, 50, 60, 70, 150)
  }
  
  if(coluna_eh_data_nascimento) {
    
    if(is.null(formatoData)) {
      coluna <- year(strptime(Sys.Date(), format = "%Y-%m-%d"))-
                    year(strptime(coluna, format = "%Y-%m-%d"))
    
    } else {
      coluna <- year(strptime(Sys.Date(), format = "%Y-%m-%d"))-
                    year(strptime(coluna, format = formatoData))
    }
  }
  
  resultado <- tabela
  
  if(is.null(nomesExtratos)) {
  
    resultado[[nomeNovaColuna]] <- cut(coluna, extratos)
  
  } else {
    
    resultado[[nomeNovaColuna]] <- cut(coluna, extratos, labels = nomesExtratos)
  
  }
  
  return(resultado)
}


