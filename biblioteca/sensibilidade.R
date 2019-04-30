#***
#Padrao de programacao:

#-O estilo dplyr eh preterivel ao estilo classico R, para facilitar a comunicacao entre programador e leigo (rever)
#-As funcoes que sera utilizadas pelos usuários finais podem conter ateh 5 palavras em sua constituicao. Devem
#ser o mais clara possíveis
#-toda variavel inicia com letra minuscula e eh separada por "_" caso seja um frase, e por uma letra maiuscula
#caso possua duas palavras
#-Toda funcao deve indicar explicitamente as variaveis de entrada, o que faz e o formato das variaveis de entrada
#-O nome das variaveis e das funcoes nao pode conter mais de 3 palavras
#-Toda funcao deve conter um comentario explicando sua funcionalidade
#-Todo passo nao claro deve conter um comentario explicando a sua funcionalidade
#-Todo comentario referente ao codigo que nao se relacionam ao funcionamento logico de alguma parte integrante
#deve conter um comentario anterior no seguinte formato: " #*** "
#-Todo passo, loop e funcao deve apresentar um comentario indicando qual a sua complexidade

#***
#Funcoes irmas
source("biblioteca/funcionais.R")


#-Esta funcao recebe uma coluna de uma tabela, e dois textos referentes a: A chave correspondente a 
#uma confirmacao do caso verdadeira(chavePositivo), e a chave correspondente a um falso positivo(chave_falso_positivo)
#-retorna a porcentagem dos valores positivos que eram verdadeiros
porcentagem_verdadeiro_positivo <- function(variavel, chavePositivo, chave_falso_positivo) {# variavel = n chavePositivo = 1 chave_falso_positivo = 1
  
  variavel <- valores_em_branco_para_NA(variavel = variavel) #complexidade n(chao de 2n)
  
  quantidadePositivo <- sum(variavel == chavePositivo, na.rm = TRUE) #complexidade n(chao de 2n)
  quantidade_falso_positivo <- sum(variavel == chave_falso_positivo, na.rm = TRUE) #complexidade n(chao de 2n)
  
  retorno <- ((quantidadePositivo)/(quantidadePositivo + quantidade_falso_positivo)) * 100 #complexidade 3
  return(retorno)
  
} #complexidade n(chao de 2n)

#Esta funcao funcionara para as duas formulas do eslaide 15
casos_hospitalizados <- function(variavelX, variavelY) {
  
  
} #nao entendi bem da forma como esta colocada esta avaliacao no eslaide(ver com Marcela).

#eslaide 16 nao possui formula definida