
-- ALTER VIEW BiView.DiariosAtivosFixos_Nopin AS 

SELECT 
	
	LJTA.JOURNALNUM								AS "N�mero do Di�rio", 
	CONCAT(LJTA.NAME, ' RECID( ', LJTA.RECID, ' )')	AS "Descri��o do Di�rio", 
	LJTA.CREATEDBY			AS "Criador por",
	LJTA.MODIFIEDBY			AS "Modificado por",
	LJTA.POSTEDDATETIME		AS "Lan�ado em",

	COUNT(LJTR.RECID) AS "Qtd. de Linhas",

	SUM(LJTR.AMOUNTCURCREDIT)		AS "Valor Cr�dito", 
	SUM(LJTR.AMOUNTCURDEBIT)		AS "Valor D�bito"

FROM LEDGERJOURNALTABLE LJTA
	LEFT JOIN LEDGERJOURNALTRANS LJTR ON LJTR.JOURNALNUM = LJTA.JOURNALNUM
	LEFT JOIN LEDGERJOURNALTRANS_ASSET LJTR_A ON LJTR_A.REFRECID = LJTR.RECID
WHERE LJTA.DATAAREAID = 'NBRA'

GROUP BY LJTA.JOURNALNUM, LJTA.NAME, LJTA.RECID, LJTA.CREATEDBY, LJTA.MODIFIEDBY, LJTA.POSTEDDATETIME