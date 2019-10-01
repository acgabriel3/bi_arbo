#***
#CAMINHO
#CRISPDM/importacao/leitura_automatica_por_tipo_arquivo.R

# - A funcao recebe: O nome da funcao de leitura de qualquer pacote que serah utilizada para ler os arquivos
# - A funcao pode receber: diretorioAlvo = o diretorio aonde se encontram os arquivos para leitura, formatoArquivo = o formato dos arquivos (.csv, .xml), o formato
#padrao eh o xmlx
# - A funcao cria uma variavel para cada arquivo lido noemada com o proprio nome do arquivo, e as mantem na memoria, a funcao retorna todos os nomes das variaveis criadas
leitura_automatica_por_tipo_arquivo <- function(diretorioAlvo = NULL, formatoArquivo = NULL, funcao_de_leitura) {
  
  '%UNE%' <- function(x, y) paste(x,y)
  
  diretorioAtual <- getwd()
  
  dadosDiretorio <- NULL
  
  if(is.null(diretorioAlvo)) {
    
    dadosDiretorio <- list.files()
    
  } else {
    
    setwd(diretorioAlvo)
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
