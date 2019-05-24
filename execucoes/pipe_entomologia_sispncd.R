

#***
#Script para geracao de tabela final entomologia para dengue por meio dos dados do SISPNCD 
#Percebo que as estruturas das tabelas finais sao "aninhadas".


entomologia <- data.frame(
  
  fonte = NA, data_sem_epd = NA, data_mes_epd = NA, SEM_EPID = NA, COMPET = NA, CICLO = NA, NU_ANO = NA, ID_LOC = NA, ID_DES = NA, 
  SEDE = NA, ibge6 = NA, ibge7 = NA, NU_LAT = NA, NU_LONG = NA, QUART_CONC = NA, RESID_TRAB = NA, COM_TRAB = NA, TB_TRAB = NA, PE_TRAB = NA,
  OUT_TRAB = NA, IMOV_TRAB = NA, TRAT_FOC = NA, TRAT_PER = NA, AMOS_COL = NA, DEPINS_A1 = NA, DEPINS_A2 = NA, DEPINS_B = NA, DEPINS_C = NA, 
  DEPINS_D1 = NA, DEPINS_D2 = NA, DEPINS_E = NA, DEPINS_TOT = NA, DEP_TRATM = NA, DEP_TRAT1 = NA, DEP_TRAT2 = NA, IMOV_INSP = NA, TRAB_INSP = NA,
  RECUSA = NA, FECHADO = NA, RECUPERADO = NA, PENDENCIA = NA, QPOS_AEG = NA, QPOS_ALB = NA, QPOS_AGAB = NA, DEP_AG_A1 = NA, DEP_AG_A2 = NA, DEP_AG_B = NA,
  DEP_AG_C = NA, DEP_AG_D1 = NA, DEP_AG_D2 = NA, DEP_AG_E = NA, DEP_AG_TOT = NA, RES_AG = NA, COM_AG = NA, TB_AG = NA, PE_AG = NA, OUTRO_AG = NA, IMOV_AG = NA,
  LARV_AG = NA, ADULT_AG = NA, PUPA_AG = NA, EXUV_AG = NA, RES_XX = NA, COM_XX = NA, TB_XX = NA, PE_XX = NA, OUTRO_XX = NA, IMOV_XX = NA, LARV_XX = NA, ADULT_XX = NA, 
  PUPA_XX = NA, CO_VIGIL = NA, CO_ATIVI = NA, TP_ARMAD = NA, TO_QUART = NA, TO_IMOV = NA, TO_ARMAD = NA, TO_POSIT = NA, TO_TUBPA = NA, TO_OVO = NA, TO_LARVA = NA,
  TO_AEGYP = NA, TO_ALBOP = NA, TO_OUTRO = NA, DS_ENDER = NA, NU_QUART = NA, NU_ARMAD = NA, DT_INST = NA, DT_COLET = NA, DS_LOCAL = NA, TP_OCORR = NA
  
)

#***
#Necessidade criacao de uma funcao de formatacao de uma tabela qualquer para o formato de sua tabela final

ordemFinal <- colnames(entomologia)
tabela <- resumo

formata_tabela_basica_formato_final <- function(ordemFinal, tabela) {
  
  colunasTabela <- colnames(tabela)
  
  encontro <- match(colunasTabela, ordemFinal)
  
  colunas_nao_pertencentes <- ordemFinal[-encontro[!is.na(encontro)]]
  
  for(coluna in colunas_nao_pertencentes) {
    
    tabela[,coluna] <- NA
     
  }
  
  tabela <- tabela[,..ordemFinal]
  
  return(tabela)
  
  
}
