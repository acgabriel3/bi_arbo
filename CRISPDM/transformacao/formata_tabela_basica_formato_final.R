#CAMINHO
#CRISPDM/transformacao/formata_tabela_basica_formato_final.R

#-Recebe ordemFinal = um vetor de caracteres que indicam os nomes das colunas da tabela final, ordenados segundo a ordem das colunas da tabela final,
#tabela = a tabela originical, mapeamento_de_tipos = um hash indicando a coluna e o respectivo tipo de dado que a mesma guarda
#-Acrescenta as colunas nao existentes a tabela, com o tipo de dados indicado pelo mapeamento
#-Retorna a tabela formatada para o formato de tabela final
formata_tabela_basica_formato_final <- function(ordemFinal, tabela, mapeamento_de_tipos) {
  
  print(ordemFinal)
  
  colunasTabela <- colnames(tabela)
  
  encontro <- match(colunasTabela, ordemFinal)
  
  colunas_nao_pertencentes <- ordemFinal[-encontro[!is.na(encontro)]]
  
  for(coluna in colunas_nao_pertencentes) {
    
    print(coluna)
    print(mapeamento_de_tipos[coluna])
    
    tabela[,coluna] <- as(rep(NA, nrow(tabela)), mapeamento_de_tipos[coluna])
    
  }
  
  tabela <- tabela[,ordemFinal] #Isto esta dando conflito entre os scripts no windows e no linux, verificar e pesquisar o motivo e pesquisar uma solucao que funcione em ambas as maquinas
  
  return(tabela)
  
  
}
