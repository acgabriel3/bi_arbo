#***
#CAMINHO
#CRISPDM/importacao/leitura_automatica_por_tipo_arquivo.R

#O que deveria agora ser solucionado, eh a leitura dos arquivos por meio de uma nova list.files. O que poderia ser realizado eh a procura de um "formato" 
#em meio ao nome do arquivo, para ler somente os arquivos necessarios. 

#Terei de mudar para o diretorio e depois voltar para o diretorio, para resolver problemas de funcoes de leitura
#nao tem como generalizar para todo caso, por isso deve-se escolher um verdadeiro lado
leitura_automatica_por_tipo_arquivo <- function(diretorioAlvo = NULL, formatoArquivo = NULL, funcao_de_leitura) {
  
  '%UNE%' <- function(x, y) paste(x,y)
  
  diretorioAtual <- getwd()
  
  if(is.null(diretorioAlvo)) {
    
    dadosDiretorio <- list.files()
    
  } else {
    
    setwd(paste(diretorioAtual, diretorioAlvo, sep = ""))
    dadosDiretorio <- list.files()
    
  }
  
  if(is.null(formatoArquivo)) {
    
    formatoArquivo <- ".xlsx"
    funcao_de_leitura <- "read_excel"
    
  }
  
  dadosDiretorio <- dadosDiretorio[grepl(formatoArquivo, dadosDiretorio)]
  
  for(arquivo in dadosDiretorio) {
    
    arquivo2 <- paste("'", arquivo, "'", sep = "")
    
    eval(parse(text = 
                 
                 
                   "assign(" 
                   %UNE% arquivo2 %UNE% "," 
                   %UNE% funcao_de_leitura %UNE% "(" %UNE% arquivo2 %UNE% ")" 
                   %UNE% ",envir = globalenv()" 
                   %UNE% ")"
                 
               
               ))
    
  }
  
  setwd(diretorioAtual)
  
  return(dadosDiretorio)
  
}
