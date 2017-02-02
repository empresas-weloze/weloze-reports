
ALTER VIEW BiView.AtivoFixo AS

SELECT 

	AT.DATAAREAID									AS "Empresa",

	CONCAT(AT.ASSETID, ' - ', AT.NAME)				AS "Ativo Fixo", 
	CONCAT(AB.STATUS, ' - ', STATUS_METODO.STATUS)	AS "Status do M�todo",

	AB.ACQUISITIONDATE								AS "Data de Aquisi��o",
	AB.LASTDEPRECIATIONDATE							AS "Data da �ltima Deprecia��o", 

	AB.ACQUISITIONPRICE								AS "Valor de Aquisi��o",
	AB.SERVICELIFE									AS "Vida �til", 

	AB.LIFETIME										AS "Per�odos de Deprecia��o", 
	AB.LIFETIMEREST									AS "Per�odos de Deprecia��o Restante"

FROM ASSETTABLE AT
	JOIN ASSETBOOK AB ON AB.ASSETID = AT.ASSETID AND AB.DATAAREAID = AT.DATAAREAID
	CROSS APPLY BiUtil.StatusMetodoDepreciacao(AB.STATUS) STATUS_METODO

--WHERE AT.DATAAREAID = 'WELO'

--ORDER BY 3