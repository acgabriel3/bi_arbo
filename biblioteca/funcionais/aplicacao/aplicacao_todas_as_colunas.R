#***
#CAMINHO
#biblioteca/funcionais/aplicacao/aplicacaoBase/quantidade_para_cada_observacao.R

library(xlsx)

source("biblioteca/funcionais/aplicacao/aplicacaoBase.R")

aplicacao_todas_as_colunas <- function(colunaBase, tabela, funcao, valoresPadrao = NULL) {
  
  retorno <- NULL  
  
  if(!is.null(valoresPadrao)) {
    
    if(length(valoresPadrao) > 1) {
      
      if(length(valoresPadrao) != length(tabela)) {
        return(print("valoresPadrao precisa possuir o mesmo numero de colunas que a tabela"))
      }
      
    }
    
  }
    
  for(i in 1:length(tabela)) {
     
    if(is.null(valoresPadrao)) {
          
        registro <- tabela_variaveis_avaliacao(colunaBase, tabela[[i]], funcao)
        registro["coluna"] <- colnames(tabela)[i]
        retorno <- rbind(retorno, registro)

    }else if(length(valoresPadrao) == length(tabela)) {
      
      registro <- tabela_variaveis_avaliacao(colunaBase, tabela[[i]], funcao, valoresPadrao[i])
      registro["coluna"] <- colnames(tabela)[i]
      retorno <- rbind(retorno, registro)
      
    } else {
    
        registro <- tabela_variaveis_avaliacao(colunaBase, tabela[[i]], funcao, valoresPadrao)
        registro["coluna"] <- colnames(tabela)[i]
        retorno <- rbind(retorno, registro)
        
    }
     
  }
  
  write.xlsx(retorno, "tabela_gerada.xlsx")
  return(retorno)
  
}
