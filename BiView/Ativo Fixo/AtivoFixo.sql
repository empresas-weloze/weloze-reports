
ALTER VIEW BiView.AtivoFixo AS

SELECT 

	AT.DATAAREAID									AS "Empresa",

	CONCAT(AT.ASSETID, ' - ', AT.NAME)				AS "Ativo Fixo", 
	CONCAT(AB.STATUS, ' - ', STATUS_METODO.STATUS)	AS "Status do Método",

	AB.ACQUISITIONDATE								AS "Data de Aquisição",
	AB.LASTDEPRECIATIONDATE							AS "Data da Última Depreciação", 

	AB.ACQUISITIONPRICE								AS "Valor de Aquisição",
	AB.SERVICELIFE									AS "Vida Útil", 

	AB.LIFETIME										AS "Períodos de Depreciação", 
	AB.LIFETIMEREST									AS "Períodos de Depreciação Restante"

FROM ASSETTABLE AT
	JOIN ASSETBOOK AB ON AB.ASSETID = AT.ASSETID AND AB.DATAAREAID = AT.DATAAREAID
	CROSS APPLY BiUtil.StatusMetodoDepreciacao(AB.STATUS) STATUS_METODO

--WHERE AT.DATAAREAID = 'WELO'

--ORDER BY 3