#***
#CAMINHO
#CRISPDM/transformacao/calcula_quantidade_fator_peso_variavelFatPe.R

library(lazyeval)

#Repensar esta funcao tentando adaptar ao dplyr
calcula_quantidade_fator_peso_variavelFatorPeso <- function(tabela, colunaFator, colunaPeso,
                                                   fator, colunasChave, nome_nova_coluna) {
  
  coluna_peso_alterada <- tabela[[colunaPeso]]
  coluna_peso_alterada[tabela[[colunaFator]] != fator] <- 0
  
  tabela[colunaPeso] <- coluna_peso_alterada
  
  resultado <- tabela %>%
    group_by_at(colunasChave) %>%
    summarise(soma = sum(!!sym(colunaPeso), na.rm = TRUE))
  
  colnames(resultado)[names(resultado) == "soma"] <- nome_nova_coluna 
  
  return(resultado)
  
}

