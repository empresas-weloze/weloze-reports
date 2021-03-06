
-- ALTER VIEW [BiView].[AnaliseMargem_Delav] AS 

SELECT 

	CONCAT(SPOT.OPERATIONTYPEID, ' - ', SPOT.NAME)	AS "Tipo de Opera��o",

	CONCAT(CT.ACCOUNTNUM, ' - ', DPT.NAME)			AS "Cliente",
	SUBSTRING(DPT.NAME, 0, 20)						AS "Cliente (reduzido)",

	CONCAT(IT.ITEMID, ' - ', ERPT.NAME)						AS "Item",
	SUBSTRING(CONCAT(IT.ITEMID, ' - ', ERPT.NAME), 0, 20)	AS "Item (reduzido)",

	DATA.DIA_MES_ANO	AS "Data",
	DATA.MES_ANO		AS "Data (m�s/ano)",
	DATA.SEMANA_ANO		AS "Data (semana/ano)",

	CIT.INVOICEID			AS "Fatura",

	TRANSACOES.[Quantidade],
	TRANSACOES.[Valor Bruto],
	TRANSACOES.[Custo Total],
	TRANSACOES.[Valor Impostos],

	TRANSACOES.[Valor Bruto] - TRANSACOES.[Valor Impostos]								AS "Receita L�quida",
	TRANSACOES.[Custo Total] / TRANSACOES.Quantidade									AS "Custo Unit�rio",
	TRANSACOES.[Valor Bruto] - TRANSACOES.[Custo Total] - TRANSACOES.[Valor Impostos]	AS "Valor de Margem"

FROM CUSTINVOICETRANS CIT
	JOIN CUSTINVOICEJOUR CIJ ON CIJ.SALESID = CIT.SALESID 
		AND CIJ.INVOICEID = CIT.INVOICEID
		AND CIJ.INVOICEDATE = CIT.INVOICEDATE
		AND CIJ.NUMBERSEQUENCEGROUP = CIT.NUMBERSEQUENCEGROUP
	LEFT JOIN FISCALDOCUMENT_BR FD ON CIJ.RECID = FD.REFRECID AND FD.REFTABLEID = 62
	JOIN CUSTTABLE CT ON CT.ACCOUNTNUM = CIJ.ORDERACCOUNT
	JOIN DIRPARTYTABLE DPT ON DPT.RECID = CT.PARTY
	
	LEFT JOIN (
	
		SELECT 

		CIT.DATAAREAID, CIT.RECID, CIT.INVENTTRANSID,
		
		AVG(CIT.QTY)																				AS "Quantidade",
		AVG(CIT.LINEAMOUNT)																			AS "Valor Bruto",
		-SUM(COALESCE(IT.COSTAMOUNTPOSTED, 0)) + SUM(COALESCE(COSTAMOUNTADJUSTMENT, 0))							AS "Custo Total",
		(SELECT 
			SUM(FDTT.TAXAMOUNT) 
		FROM FISCALDOCUMENTLINE_BR FDL 
			JOIN FISCALDOCUMENTTAXTRANS_BR FDTT ON FDTT.FISCALDOCUMENTLINE = FDL.RECID AND FDTT.TYPE IN (1, 2, 3, 15) 
		WHERE FDL.REFRECID = CIT.RECID
		) AS "Valor Impostos"

		FROM CUSTINVOICETRANS CIT 				
			LEFT JOIN INVENTTRANSORIGIN ITO ON ITO.INVENTTRANSID = CIT.INVENTTRANSID
			LEFT JOIN INVENTTRANS IT ON IT.INVENTTRANSORIGIN = ITO.RECID 
				AND IT.DATEFINANCIAL = CIT.INVOICEDATE 
				AND IT.INVOICEID = CIT.INVOICEID
				--AND IT.QTY <> 0
				AND IT.PACKINGSLIPRETURNED = 0
				AND IT.STATUSRECEIPT IN (0, 1)
				AND IT.STATUSISSUE IN (0, 1)
		WHERE CIT.DATAAREAID = 'DELA'
		GROUP BY CIT.DATAAREAID, CIT.RECID, CIT.INVENTTRANSID

	) AS TRANSACOES ON TRANSACOES.RECID = CIT.RECID AND TRANSACOES.DATAAREAID = CIT.DATAAREAID
	JOIN SALESLINE SL ON SL.INVENTTRANSID = CIT.INVENTTRANSID
	JOIN SALESTABLE ST ON ST.SALESID = SL.SALESID AND ST.DATAAREAID = SL.DATAAREAID
	JOIN SALESTABLE_BR ST_BR ON ST_BR.SALESTABLE = ST.RECID
	JOIN SALESPURCHOPERATIONTYPE_BR SPOT ON SPOT.RECID = ST_BR.SALESPURCHOPERATIONTYPE_BR
	JOIN INVENTTABLE IT ON IT.ITEMID = CIT.ITEMID AND IT.DATAAREAID = CIT.DATAAREAID
	JOIN ECORESPRODUCT ERP ON ERP.RECID = IT.PRODUCT
	JOIN ECORESPRODUCTTRANSLATION ERPT ON ERPT.PRODUCT = ERP.RECID AND ERPT.LANGUAGEID = 'PT-BR'
	CROSS APPLY BiUtil.DataFiltro(CIT.INVOICEDATE) AS DATA

WHERE CIT.DATAAREAID = 'DELA'
