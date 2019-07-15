#CAMINHO
#CRISPDM/transformacao/formata_tabela_basica_formato_final.R

#***
#documentar
formata_tabela_basica_formato_final <- function(ordemFinal, tabela, mapeamento_de_tipos) {
  
  colunasTabela <- colnames(tabela)
  
  encontro <- match(colunasTabela, ordemFinal)
  
  colunas_nao_pertencentes <- ordemFinal[-encontro[!is.na(encontro)]]
  
  for(coluna in colunas_nao_pertencentes) {
    
    print(coluna)
    print(mapeamento_de_tipos[coluna])
    
    tabela[,coluna] <- as(rep(NA, nrow(tabela)), mapeamento_de_tipos[coluna])
    
  }
  
  tabela <- tabela[,..ordemFinal] #Isto esta dando conflito entre os scripts no windows e no linux, verificar e pesquisar o motivo e pesquisar uma solucao que funcione em ambas as maquinas
  
  return(tabela)
  
  
}