#***
#CAMINHO
#CRISPDM/Simulacao/popula_variavel_detalhe_dias.R

library(EnvStats)

popula_variavel_detalhe_dias <- function(fatoresDetalhe, intervaloMedia, intervaloSd, nomeFator, intervaloTruncado, anos, nomeVariavel) {
  
  resultado <- NULL
  
  distribuicoesNormais <- NULL 
  
  for(fator in fatoresDetalhe) {
    
    #Define medias e desvios padroes para a pluviosidade e evaporacao de cada estado
    #Pensar em retirar o round, para gerar valores em escala muito menor
    mean <- runif(1, intervaloMedia[1], intervaloMedia[2])
    sd <- runif(1, intervaloSd[1], intervaloSd[2]) 
    
    print(fator)
    eval(parse(text = 
                 
                 "distribuicoesNormais <- rbind(distribuicoesNormais, data.frame(" %% nomeFator %% " = fator, mean = mean, sd = sd))"
               
    ))
    
    assign("distribuicoes_normais_" %% nomeFator %% "_" %% nomeVariavel, distribuicoesNormais, envir = globalenv())
    
    for(i in 1:length(anos)) {
      
      #constroi vetores de pluviosidade e evaporacao seguindo a distribuicao normal com os parametro de cada estado para cada ano
      valor <- rnormTrunc(365, mean = mean, sd = sd, min = intervaloTruncado[1], max = intervaloTruncado[2])
      
      #Criado um data frame para cada ano com respectivos dados aleatorios de pluviosidade e evaporacao
      eval(parse(text = 
                   
                   "df_aux <- data.frame(data = coluna_data_" %% anos[i] %% "," %% nomeFator %% "= rep(fator, 365)," %% nomeVariavel %% " = valor) 
                 
                   resultado <-"  %% "rbind( resultado, df_aux" %%  ") 
                 
                   rm(df_aux)"
                 
      ))
      
      assign("resultado", resultado, envir = globalenv())
      
    }
    
  }
  
}