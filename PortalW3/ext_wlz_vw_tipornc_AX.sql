
-- ALTER VIEW biwelozew3.ext_wlz_vw_tipornc_AX  WITH ENCRYPTION AS

-- São utilizados os valores fixos 0 - Baixa, 1 - Média, 2 - Alta 

SELECT 0 AS cdtipornc, 'BAIXO' AS nmtipornc, 'Baixo Impacto' AS dstipornc
UNION
SELECT 1 AS cdtipornc, 'MEDIO' AS nmtipornc, 'Médio Impacto' AS dstipornc
UNION
SELECT 2 AS cdtipornc, 'ALTO' AS nmtipornc, 'Alto Impacto' AS dstipornc

/* Versão antiga quando se usava o codigo que fica na RNC
SELECT RECID AS cdtipornc, 
	PROBLEMTYPEID AS nmtipornc, 
	DESCRIPTION as dstipornc 
FROM INVENTPROBLEMTYPE*/

/* Versão antiga (quando se utilizava os casos)
SELECT 
	RECID AS cdtipornc, 
	CASECATEGORY as nmtipornc, 
	DESCRIPTION as dstipornc
FROM CASECATEGORYHIERARCHYDETAIL
WHERE DATAAREAID = 'WELO';*/