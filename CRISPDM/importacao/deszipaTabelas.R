#***
#CAMINHO
#CRISPDM/importacao/deszipaTabelas.R


# - Pode receber: diretorioAlvo = o diretorio em que os arquivos zipados serao unzipados, formato = o formato dos arquivos zipados a serem deszipados, como .rar, .zip
# - Por padrao a fun??o deszipa os arquivos no diret?rio de trabalho, e com o formato zip. Setados ou nao os parametros, a funcao buscara unzipar todos os arquivos
#no formato escolhido, presentes no diretorio
# - A funcao retorna os arquivos unzipados dentro do mesmo diretorio, e preserva os arquivos zipados
deszipaTabelas <- function(diretorioAlvo = NULL, formato = NULL) {
  
  diretorioAtual <- getwd()
  
  if(is.null(diretorioAlvo)) {
    
    dadosDiretorio <- list.files()
  
  } else {
    
    setwd(diretorioAlvo)
    dadosDiretorio <- list.files()
        
  }
  
  if(is.null(formato)) {
    formato <- ".zip"
  }
  
  dadosDiretorio <- dadosDiretorio[grepl(formato, dadosDiretorio)]
  
  for(zip in dadosDiretorio) {
    
    unzip(zip)

  }
  
  setwd(diretorioAtual)
  
  return()
  
}
