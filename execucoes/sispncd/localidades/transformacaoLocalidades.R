#***
#CAMINHO

library(data.table)

#***
#Script de transformacao para localidades

#tera uma fonte 
#ordem: tempo - espaco - atributos 

#Criar uma coluna vazia de "fonte" referente a fonte que forneceu aquela observacao
#Criar metadados de fontes, que seria um tipo de atributo por fator (avaliar)

#***
#fazer transformacao para todas as datas estarem no padrao desejado

limpa$DT_ATUA <- paste(limpa$DT_ATUA, "23:59:59",  sep = " ")
limpa$DT_CAD_LOC <- paste(limpa$DT_CAD_LOC, "23:59:59", sep = " ") #seria mesmo necessario apagar os dias dessas datas? Ou seria mesmo por mes

colunas <- colnames(limpa)

colunasEspaco <- c("DT_ATUA", "DT_CAD_LOC", "ID_LOC", "NM_LOC", "NU_CEP", "ibge6", "ibge7", "DIST_CENTR", "ID_CAT", "ID_STAT", "NU_LAT", "NU_LONG", "NU_ALT_LOC"
            ,"CS_URBRUR")

aux <- match(ordena, colunas)

aux <- colunas[-aux]

colunasDemograficos <- c("DT_ATUA", "ID_LOC", aux)

localidadesEspaco <- limpa[,colunasEspaco]

#***
#Inserir a data formatada para os dados demograficos tambem

localidadesDemograficos <- limpa[colunasDemograficos]

#***
#insere fontes em espaco
colunas <- colnames(localidadesEspaco)

localidadesEspaco$fonte <- NA

nova_ordem_colunas <- c("fonte", colunas)

localidadesEspaco <- localidadesEspaco[,nova_ordem_colunas]

#***
#insere fontes em demograficos
colunas <- colnames(localidadesDemograficos)

localidadesDemograficos$fonte <- NA

nova_ordem_colunas <- c("fonte", colunas)

localidadesDemograficos <- localidadesDemograficos[,nova_ordem_colunas]

fwrite(x = localidadesEspaco, file = "dados/processados/SISPNCD/localidades/localidadesEspaco.csv")
fwrite(x= localidadesDemograficos, file = "dados/processados/SISPNCD/localidades/localidadesDemograficos.csv")


