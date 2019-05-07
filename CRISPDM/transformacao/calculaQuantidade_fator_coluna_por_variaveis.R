#***
#CAMINHO
#CRISPDM/transformacao/calculaQuantidade_fator_coluna_por_variaveis.R

library(lazyeval)

#Repensar esta funcao tentando adaptar ao dplyr
calculaQuantidade_fator_coluna_por_variaveis <- function(tabela, coluna, fator, colunasChave, nome_nova_coluna) {
  
  colunaFatores <- tabela[[coluna]]
  
  colunaFatores[colunaFatores != fator] <- 0
  colunaFatores[colunaFatores == fator] <- 1
  
  tabela[coluna] <- colunaFatores
  
  resultado <- tabela %>%
    group_by_at(colunasChave) %>%
    summarise(soma = sum(!!sym(coluna), na.rm = TRUE))
  
  colnames(resultado)[names(resultado) == "soma"] <- nome_nova_coluna 
  
  return(resultado)
  
}



