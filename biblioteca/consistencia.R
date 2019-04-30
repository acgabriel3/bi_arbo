#***
#Funcao caule

#***
#CAMINHO
#biblioteca/consistencia.R

source("biblioteca/funcionais.R")


#-Esta funcao recebe duas colunas de um data.frame
#-Pode receber um formato especifico para a data ou valores padrao para calcular a inconsistencia
#-Calcula a consistencia dos dados da coluna B segundo a coluna A 
#-Se forem datas, inconsitencia eh entendida como uma data na coluna B anterior a uma data na coluna A
#-Retorna a porcentagem de valores inconsistentes na coluna B
consistencia <- function(colunaA = NULL, colunaB = NULL, coluna_adicional_parametro = NULL, 
                         duas_colunas_data = TRUE, valoresPadrao = NULL
                         , valores_padrao_adicionais = NULL, formato = NULL) { #colunaA = n = colunaB, valoresPadra = m
  
  if(is.null(colunaA) || is.null(colunaB)) {
    return("Entrada invalida, colunaA e colunaB devem ser ambas preenchidas")
  }
  
  colunaA <- valores_em_branco_para_NA(colunaA) #complexidade n
  colunaB <- valores_em_branco_para_NA(colunaB) #complexidade n
  
  if(duas_colunas_data) {
    
    preenchidos <- !is.na(colunaA)
    colunaA <- colunaA[preenchidos]
    colunaB <- colunaB[preenchidos]
    
    tamanho_coluna_A <- length(colunaA) #complexidade n
    
    if(is.null(formato)) {
      datasA <- as.Date(colunaA) #complexidade n
      #esta coluna sera avaliada
      datasB <- as.Date(colunaB) #complexidade n
    } else {
      datasA <- as.Date(colunaA, format = formato) #complexidade n
      #esta coluna sera avaliada
      datasB <- as.Date(colunaB, format = formato) #complexidade n
    }
    
    valoresInconsistentes <- (datasB - datasA) < 0 #complexidade 2n
    qtdInconsistentes <- sum(valoresInconsistentes, na.rm = TRUE) #complexidade n
    
    proporcao <- (qtdInconsistentes/tamanho_coluna_A) * 100 #complexidade 2n
    
    return(paste("porcentagem de valores inconsistentes na coluna B: ", proporcao, "%", sep = ""))
    
  } else {
    
    if(is.null(valoresPadrao)) {
      
      valoresPreenchidos <- !is.na(colunaA) #complexidade 2n
      dadosInconsistentes <- sum(is.na(colunaB[valoresPreenchidos]), na.rm = TRUE) #complexidade 3n
      proporcao <- (dadosInconsistentes/length(colunaA[valoresPreenchidos])) * 100 #complexidade 4n
      
      return(paste("Proporcao de valores inconsistentes: ", proporcao, "%", sep = ""))
      
    } else {
      
      coluna_filtrada <- subset(colunaB, colunaA %in% valoresPadrao) #complexidade nm
      proporcao <- (sum(is.na(coluna_filtrada), na.rm = TRUE)/length(coluna_filtrada)) * 100 #complexidade 3n
      return(paste("Proporcao de valores inconsistentes: ", proporcao, "%", sep = ""))
      
    }
    
  }
  
  if(!is.null(coluna_adicional_parametro)) {
    coluna_adicional_parametro <- valores_em_branco_para_NA(coluna_adicional_parametro)
    
    if(is.null(valoresPadrao)) {
      
      valoresPreenchidos <- !is.na(colunaA) & !is.na(coluna_adicional_parametro) #xomplexidade 5n
      dadosInconsistentes <- sum(is.na(colunaB[valoresPreenchidos]), na.rm = TRUE) #complexidade 3n
      proporcao <- (dadosInconsistentes/length(colunaA[valoresPreenchidos])) * 100 #complexidade 4n
      
      return(paste("Proporcao de valores inconsistentes: ", proporcao, "%", sep = ""))
      
    } else {
      
      if(is.null(valores_padrao_adicionais)) {
        return("valores_padrao_adicionais deve ser fornecido")
      }
      
      coluna_filtrada <- subset(colunaB, (colunaA %in% valoresPadrao) & 
                                  (coluna_adicional_parametro %in% valores_padrao_adicionais)) #complexidade 2nm + n
      proporcao <- (sum(is.na(coluna_filtrada), na.rm = TRUE)/length(coluna_filtrada)) * 100 #complexidade 3n
      return(paste("Proporcao de valores inconsistentes: ", proporcao, "%", sep = ""))
      
    }
    
  }
  
  return("entrada invalida")
  
} #complexidade n(chao de 2n) (para duas datas) ou complexidade n(chao de 4n) (para valoresPadrao null e nao data) ou complexidade nm (chao de 2nm+n) (para valoresPadrao setados)
