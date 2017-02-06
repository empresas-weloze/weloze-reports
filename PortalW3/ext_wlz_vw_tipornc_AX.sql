
-- ALTER VIEW biwelozew3.ext_wlz_vw_tipornc_AX  WITH ENCRYPTION AS

-- S�o utilizados os valores fixos 0 - Baixa, 1 - M�dia, 2 - Alta 

SELECT 0 AS cdtipornc, 'BAIXO' AS nmtipornc, 'Baixo Impacto' AS dstipornc
UNION
SELECT 1 AS cdtipornc, 'MEDIO' AS nmtipornc, 'M�dio Impacto' AS dstipornc
UNION
SELECT 2 AS cdtipornc, 'ALTO' AS nmtipornc, 'Alto Impacto' AS dstipornc

/* Vers�o antiga quando se usava o codigo que fica na RNC
SELECT RECID AS cdtipornc, 
	PROBLEMTYPEID AS nmtipornc, 
	DESCRIPTION as dstipornc 
FROM INVENTPROBLEMTYPE*/

/* Vers�o antiga (quando se utilizava os casos)
SELECT 
	RECID AS cdtipornc, 
	CASECATEGORY as nmtipornc, 
	DESCRIPTION as dstipornc
FROM CASECATEGORYHIERARCHYDETAIL
WHERE DATAAREAID = 'WELO';*/