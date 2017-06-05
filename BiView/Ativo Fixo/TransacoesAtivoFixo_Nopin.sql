
-- ALTER VIEW BiView.TransacaoAtivoFixo_Nopin AS

SELECT 
	
	ATA.ASSETID,
	ATA.NAME,
	ATA.UNITCOST,
	TRANSACAO.AssetTransType,
	ATR.AMOUNTCUR,
	ATR.TRANSDATE,
	ATA.ASSETGROUP,
	ESTABELECIMENTO.VALOR AS ESTABELECIMENTO,
	UNIDADEdeCUSTO.VALOR AS UNIDADEdeCUSTO,
	DEPARTAMENTO.VALOR AS DEPARTAMENTO,
	CENTROdeCUSTO.VALOR AS CENTROdeCUSTO

FROM ASSETTRANS ATR
	JOIN ASSETTABLE ATA ON ATA.ASSETID = ATR.ASSETID AND ATA.DATAAREAID = ATR.DATAAREAID
	JOIN ASSETBOOK AB ON AB.ASSETID = ATA.ASSETID AND AB.DATAAREAID = ATA.DATAAREAID
	CROSS APPLY BiUtil.TipoTransacaoAtivoFixo(ATR.TRANSTYPE) TRANSACAO
	OUTER APPLY BiUtil.DimensaoFinanceira(AB.DEFAULTDIMENSION, 'ESTABELECIMENTO') AS ESTABELECIMENTO
	OUTER APPLY BiUtil.DimensaoFinanceira(AB.DEFAULTDIMENSION, 'UNIDADEdeCUSTO') AS UNIDADEdeCUSTO
	OUTER APPLY BiUtil.DimensaoFinanceira(AB.DEFAULTDIMENSION, 'DEPARTAMENTO') AS DEPARTAMENTO
	OUTER APPLY BiUtil.DimensaoFinanceira(AB.DEFAULTDIMENSION, 'CENTROdeCUSTO') AS CENTROdeCUSTO

WHERE ATA.DATAAREAID = 'NBRA' AND ATA.ASSETID NOT LIKE 'BL%'