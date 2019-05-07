#***
#Funcoes irmas
source("biblioteca/funcionais.R")

#***
#REPRESENTATIVIDADE
source("biblioteca/representatividade/representatividadeRaiz.R")


#-Esta funcao recebe duas colunas de uma tabela, que devem possuir tamanho igual. Tambem recebe dois vetores de valores possiveis na tabela.
#-Retorna a porcentagem dos valores de valoresPadrao encontrados na colunaAlvo, que possuem tambem os valoresFiltro na colunaFiltro
representatividadeCondicionada <- function(colunaFiltro, valoresFiltro, colunaAlvo, valoresPadrao) { #colunaFiltro = n = colunaAlvo, valoresFiltro = t, valoresPadrao = j
  
  if(is.null(colunaFiltro) || is.null(valoresFiltro) || is.null(colunaAlvo) || is.null(valoresPadrao)) {
    return("valores passados a funcao sao invalidos")
  } #complexidade 2n + t + j
  
  colunaFiltro <- valores_em_branco_para_NA(variavel = colunaFiltro) #complexidade n
  colunaAlvo <- valores_em_branco_para_NA(variavel = colunaAlvo) #complexidade n
  
  colunaFiltrada <- subset(colunaAlvo, colunaFiltro %in% valoresFiltro) #complexidade nt
  
  representatividade(colunaFiltrada, valoresPadrao) #complexidade nj
  
} #complexidade nt + nj
