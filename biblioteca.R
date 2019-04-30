#***
#Esta eh uma bibilioteca para automatizar a avaliacao quantitativa dos sistemas de informacoes que geram dados
#acerca das arboviroses. (exemplificar melhor)

#***
#Padrao de programacao:

#-O estilo dplyr eh preterivel ao estilo classico R, para facilitar a comunicacao entre programador e leigo (rever)
#-As funcoes que serao utilizadas pelos usuários finais podem conter ateh 5 palavras em sua constituicao. Devem
#ser o mais claras possíveis
#-toda variavel inicia com letra minuscula e eh separada por "_" caso seja um frase, e por uma letra maiuscula
#caso possua duas palavras
#-Toda funcao deve indicar explicitamente as variaveis de entrada, o que faz e o formato das variaveis de entrada
#-O nome das variaveis e das funcoes nao pode conter mais de 3 palavras
#-Toda funcao deve conter um comentario explicando sua funcionalidade
#-Todo passo nao claro deve conter um comentario explicando a sua funcionalidade
#-Todo comentario referente ao codigo que nao se relacionam ao funcionamento logico de alguma parte integrante
#deve conter um comentario anterior no seguinte formato: " #*** "
#-Toda funcao deve apresentar a representacao matematica para a complexidade de cada variavel
#-Todo passo, loop e funcao deve apresentar um comentario indicando qual a sua complexidade
#-Todo script deve apresentar o caminho para realizar o acesso a ele


library(dplyr)
library(foreign)


#***
#LEITURA:
#a ideia da leitura eh criar funcoes que facilitem a leitura de dados

#dengue_2007 <- read.dbf("dados/DENGUE_2007.dbf")

#for(i in 7:13) {

#as.name(paste("dengue_200", i, sep = "")) <-  read.dbf(paste("dados/", "DENGUE_200", i, ".dbf", sep = ""))

#} #Ainda nao funcionou

#***
#RESUMO
#A ideia do resumo eh apresentar os dados da tabela de maneira inteligente e facilitada para o usuario final

#***
#FUNCIONAIS
source("biblioteca/funcionais.R")

#***
#QUALIDADE
source("biblioteca/qualidade.R")

#***
#OPORTUNIDADE
source("biblioteca/oportunidade.R")

#***
#REPRESENTATIVIDADE
source("biblioteca/representatividade.R")

#***
#SENSIBILIDADE
source("biblioteca/sensibilidade.R")

#***
#VALOR PREDITIVO POSITIVO
#A funcao "porcentagem_verdadeiro_positivo" tambem funciona para este caso

#***
#CONSISTENCIA
source("biblioteca/consistencia.R")

#***
#Pensar que pode ser positivo para o entendimento renomear as funcoes mesmo que as mesmas facam a mesma coisa na pratica


