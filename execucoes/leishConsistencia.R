#***
#Calculo estatistico de consistencia 

#***
#obs: Pode-se separar os arquivos em: importacao/limpeza, estatisticos, e transformacoes

#***
#Elucidacao: Vale a pena construir os pipes por meio de funcoes? Talvez seja interessante para a legibilidade do codigo 
  

for(coluna in c("CS_SEXO", "CS_RACA", "HIV")) {
  
  print(coluna)
  print(consistencia(colunaA = leish_2010_2017[[coluna]], colunaB = leish_2010_2017$ENTRADA, duas_colunas_data = FALSE))

}


