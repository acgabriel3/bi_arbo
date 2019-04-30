#***
#CAMINHO
#biblioteca/funcionais/aplicacao/filtro_mes_servico.R

library(lubridate)



#- Esta funcao recebe de uma a tres tabelas, respectivamente com: 1 a 3 nomes de colunas
#com informacoes, 1 a 3 nomes de colunas acerca de data, e 1 a 3 colunas acerca de valores 
#categoricos. Recebe valoresPadrao, casos, meses, e anos.
#- Esta funcao filtra segundo os anos e meses dados, as colunas de informacao, segundo
#as categorias das colunas categoricas, e aplica uma funcao qualquer a estes dados. 
#(deve-se preencher corretamente a funcao, de acordo com a funcao que sera aplicada (indicador))
#- Retorna uma tabela com os resultados da funcao aplicada para cada categoria e data escolhida.
filtro_mes_variavel <- function(tabelaA, coluna_quantidade_somatorioA, tabelaB = NULL, coluna_quantidade_somatorioB = NULL,
                               tabelaC = NULL, coluna_quantidade_somatorioC = NULL, 
                               colunafiltroA, colunafiltroB, colunafiltroC, 
                               colunaDataA, colunaDataB,colunaDataC = NULL, meses, anos, indicador, valores_padrao_aplicados = NULL, 
                               casos = NULL, valoresPadrao = NULL
                               ) { #linhas tabela = n, meses = k, anos = t, indicador = "complexidade"
  
  aux <- data.frame(servicio = NA, data = NA, indicador = NA) #complexidade 1
  retorno <- NULL #complexidade 1
  print("1") 
  tabelaA[colunaDataA] <- as.Date(tabelaA[[colunaDataA]]) #complexidade n
  print("2")
  if(!is.null(tabelaB)) {
    tabelaB[colunaDataB] <- as.Date(tabelaB[[colunaDataB]]) #complexidade n
  }
  if(!is.null(colunaDataC)) {
    tabelaC[colunaDataC] <- as.Date(tabelaC[[colunaDataC]]) #complexidade n
  }
  print("2")
  
  valores <- as.vector(levels(as.factor(tabelaA[[colunafiltroA]]))) #complexidade n, gera-se valores = m
  print(valores)
  
  for(i in 1:length(valores)) { #m vezes
    print("3")
    
    tabelaFiltradaA <- subset(tabelaA, tabelaA[[colunafiltroA]] %in% valores[i]) #complexidade n
    
    if(!is.null(tabelaB)) {
      tabelaFiltradaB <- subset(tabelaB, tabelaB[[colunafiltroB]] %in% valores[i])
    }
    
    if(!is.null(tabelaC)) {
      tabelaFiltradaC <- subset(tabelaC, tabelaC[[colunafiltroC]] %in% valores[i])
    }
    
    for(ano in anos) { #k vezes
      for(mes in meses) { #t vezes
     
        tabela_filtradaA <- subset(tabelaFiltradaA, (month(as.POSIXlt(tabelaFiltradaA[[colunaDataA]]))== mes) &
                                     year(as.POSIXlt(tabelaFiltradaA[[colunaDataA]]))== ano) #complexidade n
        
        if(!is.null(tabelaB)) {
          tabela_filtradaB <- subset(tabelaFiltradaB, (month(as.POSIXlt(tabelaFiltradaB[[colunaDataB]]))== mes) &
                                       year(as.POSIXlt(tabelaFiltradaB[[colunaDataB]]))== ano)
        }
        if(!is.null(tabelaC)) {
          tabela_filtradaC <- subset(tabelaFiltradaC, (month(as.POSIXlt(tabelaFiltradaC[[colunaDataC]]))== mes) &
                                       year(as.POSIXlt(tabelaFiltradaC[[colunaDataC]]))== ano)
        }
        
        
        if(!is.null(coluna_quantidade_somatorioB) & is.null(coluna_quantidade_somatorioC)) {
          if(is.null(casos) & is.null(valoresPadrao)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]],
                      tabela_filtradaB[[coluna_quantidade_somatorioB]]) 
            
          } else if(!is.null(casos) & !is.null(valoresPadrao)){
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]],
                                   tabela_filtradaB[[coluna_quantidade_somatorioB]], casos = casos, valoresPadrao = valoresPadrao)
            
          } else if(!is.null(casos)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]],
                                   tabela_filtradaB[[coluna_quantidade_somatorioB]], casos = casos)
            
          } else if(!is.null(valoresPadrao)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]],
                                   tabela_filtradaB[[coluna_quantidade_somatorioB]], valoresPadrao = valoresPadrao)
            
          }
        } else if(!is.null(coluna_quantidade_somatorioC)){
          
          if(is.null(casos) & is.null(valoresPadrao)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]],
                                   tabela_filtradaB[[coluna_quantidade_somatorioB]],
                                   tabelaFiltradaC[[coluna_quantidade_somatorioC]])
            
          } else if(!is.null(casos) & !is.null(valoresPadrao)){
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]],
                                   tabela_filtradaB[[coluna_quantidade_somatorioB]],
                                   tabela_filtradaC[[coluna_quantidade_somatorioC]], casos = casos, valoresPadrao = valoresPadrao)
            
          } else if(!is.null(casos)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]],
                                   tabela_filtradaB[[coluna_quantidade_somatorioB]],
                                   tabela_filtradaC[[coluna_quantidade_somatorioC]], casos = casos)
            
          } else if(!is.null(valoresPadrao)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]],
                                   tabela_filtradaB[[coluna_quantidade_somatorioB]],
                                   tabela_filtradaC[[coluna_quantidade_somatorioC]], valoresPadrao = valoresPadrao)
            
          }
          
        } else {
          
          if(is.null(casos) & is.null(valoresPadrao)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]])
            
          } else if(!is.null(casos) & !is.null(valoresPadrao)){
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]], casos = casos, valoresPadrao = valoresPadrao)
            
          } else if(!is.null(casos)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]], casos = casos)
            
          } else if(!is.null(valoresPadrao)) {
            
            resultado <- indicador(tabela_filtradaA[[coluna_quantidade_somatorioA]], valoresPadrao = valoresPadrao)
            
          }
          
        }
        
        
        aux[1,1] <- valores[i]
        if(mes < 10) {
          aux[1,2] <- paste(ano,"/", "0" ,mes, "/","01", sep ="")
        } else {
          aux[1,2] <- paste(ano,"/",mes, "/","01", sep ="")
        }
        aux[1,3] <- resultado
        retorno <- rbind(retorno, aux)
        
      }
  }
    
  }
  
  return(retorno)
  
} #complexidade mkt X max(n, complexidadeIndicador), sendo k < 12 (pode ser quadratica em alguns casos, porem na maioria dos casos eh aprox quadratica)


#tabela <- filtro_mes_variavel(tabelaA = material, 
#                 coluna_quantidade_somatorioA = "KA_CANTID", 
#                 tabelaB = hospitalizacion, 
#                 coluna_quantidade_somatorioB = "HO_DIASH", 
#                 colunafiltroB = "HO_CSERV", 
#                 colunafiltroA= "KA_CSER",
#                 colunaDataA = "KA_FECDES", 
#                 colunaDataB = "HO_FHOSP", 
#                 meses = c(1:6),
#                 anos = c(2018),
#                 indicador = indicadorConsumo)
