
source("CRISPDM.R")


nomesTabelas <- c("dengue1993", "dengue1994", "dengue1995", "dengue1996", "dengue1997", "dengue1998", "dengue1999", "dengue2000", 
      "dengue2000", "dengue2001", "dengue2002", "dengue2003", "dengue2004", "dengue2005", "dengue2006", "dengue2007", 
      "dengue2008", "dengue2009", "dengue2010", "dengue2011", "dengue2012", "dengue2013", "dengue2014", "dengue2015", 
      "dengue2016", "dengue2017")

tabelasColunas <- cria_hash_nomesTabelas_nomesColunas(nomesTabelas)

colunasDistintas <- mostra_colunas_distintas_doMaior_conjunto(tabelasColunas)

distintas_das_distintas_dengue2016 <- mostra_colunas_distintas_doMaior_conjunto(hash_nomesTabelas_nomesColunas = colunasDistintas,
                                                                                tabelaReferencia = "dengue2006")

#Avaliando as diferencas, percebe-se que eh possivel unificar o banco a partir de provavelmente 2007

uniao <- gera_nomesColunas_unicos(hash_de_nomes = tabelasColunas)
