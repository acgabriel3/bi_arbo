
library(elastic)

#***
#Script para geracao de tabela final entomologia para dengue por meio dos dados do SISPNCD 
#Percebo que as estruturas das tabelas finais sao "aninhadas".


tipos <- c( fonte = "character", data_sem_epd = "character", data_mes_epd = "character", CICLO = "numeric", NU_ANO = "numeric", ID_LOC = "character", ID_DES = "numeric", 
            SEDE = "character", ibge6 = "numeric", ibge7 = "numeric", NU_LAT = "numeric", NU_LONG = "numeric", QUART_CONC = "numeric", RESID_TRAB = "numeric", COM_TRAB = "numeric" , TB_TRAB = "numeric", PE_TRAB = "numeric",
            OUT_TRAB = "numeric", IMOV_TRAB = "numeric", TRAT_FOC = "numeric", TRAT_PER = "numeric", AMOS_COL = "numeric", DEPINS_A1 = "numeric", DEPINS_A2 = "numeric", DEPINS_B = "numeric", DEPINS_C = "numeric", 
            DEPINS_D1 = "numeric", DEPINS_D2 = "numeric", DEPINS_E = "numeric", DEPINS_TOT = "numeric", DEP_TRATM = "numeric", DEP_TRAT1 = "numeric", DEP_TRAT2 = "numeric", IMOV_INSP = "numeric", TRAB_INSP = "numeric",
            RECUSA = "numeric", FECHADO = "numeric", RECUPERADO = "numeric", PENDENCIA = "numeric", QPOS_AEG = "numeric", QPOS_ALB = "numeric", QPOS_AGAB = "numeric", DEP_AG_A1 = "numeric", DEP_AG_A2 = "numeric", DEP_AG_B = "numeric",
            DEP_AG_C = "numeric", DEP_AG_D1 = "numeric", DEP_AG_D2 = "numeric", DEP_AG_E = "numeric", DEP_AG_TOT = "numeric", RES_AG = "numeric", COM_AG = "numeric", TB_AG = "numeric", PE_AG = "numeric", OUTRO_AG = "numeric", IMOV_AG = "numeric",
            LARV_AG = "numeric", ADULT_AG = "numeric", PUPA_AG = "numeric", EXUV_AG = "numeric", RES_XX = "numeric", COM_XX = "numeric", TB_XX = "numeric", PE_XX = "numeric", OUTRO_XX = "numeric", IMOV_XX = "numeric", LARV_XX = "numeric", ADULT_XX = "numeric", 
            PUPA_XX = "numeric", CO_VIGIL = "character", CO_ATIVI = "numeric", TP_ARMAD = "numeric", TO_QUART = "numeric", TO_IMOV = "numeric", TO_ARMAD = "numeric", TO_POSIT = "numeric", TO_TUBPA = "numeric", TO_OVO = "numeric", TO_LARVA = "numeric",
            TO_AEGYP = "numeric", TO_ALBOP = "numeric", TO_OUTRO = "numeric", DS_ENDER = "character", NU_QUART = "character", NU_ARMAD = "numeric", DT_INST = "character", DT_COLET = "character", DS_LOCAL = "character", TP_OCORR = "numeric"
          )
  
entomologia <- data.frame(
  
  fonte = NA, data_sem_epd = NA, data_mes_epd = NA, CICLO = NA, NU_ANO = NA, ID_LOC = NA, ID_DES = NA, 
  SEDE = NA, ibge6 = NA, ibge7 = NA, NU_LAT = NA, NU_LONG = NA, QUART_CONC = NA, RESID_TRAB = NA, COM_TRAB = NA, TB_TRAB = NA, PE_TRAB = NA,
  OUT_TRAB = NA, IMOV_TRAB = NA, TRAT_FOC = NA, TRAT_PER = NA, AMOS_COL = NA, DEPINS_A1 = NA, DEPINS_A2 = NA, DEPINS_B = NA, DEPINS_C = NA, 
  DEPINS_D1 = NA, DEPINS_D2 = NA, DEPINS_E = NA, DEPINS_TOT = NA, DEP_TRATM = NA, DEP_TRAT1 = NA, DEP_TRAT2 = NA, IMOV_INSP = NA, TRAB_INSP = NA,
  RECUSA = NA, FECHADO = NA, RECUPERADO = NA, PENDENCIA = NA, QPOS_AEG = NA, QPOS_ALB = NA, QPOS_AGAB = NA, DEP_AG_A1 = NA, DEP_AG_A2 = NA, DEP_AG_B = NA,
  DEP_AG_C = NA, DEP_AG_D1 = NA, DEP_AG_D2 = NA, DEP_AG_E = NA, DEP_AG_TOT = NA, RES_AG = NA, COM_AG = NA, TB_AG = NA, PE_AG = NA, OUTRO_AG = NA, IMOV_AG = NA,
  LARV_AG = NA, ADULT_AG = NA, PUPA_AG = NA, EXUV_AG = NA, RES_XX = NA, COM_XX = NA, TB_XX = NA, PE_XX = NA, OUTRO_XX = NA, IMOV_XX = NA, LARV_XX = NA, ADULT_XX = NA, 
  PUPA_XX = NA, CO_VIGIL = NA, CO_ATIVI = NA, TP_ARMAD = NA, TO_QUART = NA, TO_IMOV = NA, TO_ARMAD = NA, TO_POSIT = NA, TO_TUBPA = NA, TO_OVO = NA, TO_LARVA = NA,
  TO_AEGYP = NA, TO_ALBOP = NA, TO_OUTRO = NA, DS_ENDER = NA, NU_QUART = NA, NU_ARMAD = NA, DT_INST = NA, DT_COLET = NA, DS_LOCAL = NA, TP_OCORR = NA
  
)


formata_tabela_basica_formato_final <- function(ordemFinal, tabela, mapeamento_de_tipos) {
  
  colunasTabela <- colnames(tabela)
  
  encontro <- match(colunasTabela, ordemFinal)
  
  colunas_nao_pertencentes <- ordemFinal[-encontro[!is.na(encontro)]]
  
  for(coluna in colunas_nao_pertencentes) {
    
    print(coluna)
    print(mapeamento_de_tipos[coluna])
    
    tabela[,coluna] <- as(rep(NA, nrow(tabela)), mapeamento_de_tipos[coluna])
    
  }
  
  tabela <- tabela[,..ordemFinal]
  
  return(tabela)
  
  
}
resumo_semanal_final <- formata_tabela_basica_formato_final(ordemFinal =  colnames(entomologia), tabela = resumo_semanal_entomologia, mapeamento_de_tipos = tipos)
vigilancia_entomo_final <- formata_tabela_basica_formato_final(ordemFinal = colnames(entomologia), tabela = vigilancia_entomo_consolidada, mapeamento_de_tipos = tipos)
vigilancia_ent_final <- formata_tabela_basica_formato_final(ordemFinal = colnames(entomologia), tabela = vigilancia_ent_consolidada, mapeamento_de_tipos = tipos)


tabela_final_entomologia <- rbind(resumo_semanal_final, vigilancia_entomo_final, vigilancia_ent_final)



