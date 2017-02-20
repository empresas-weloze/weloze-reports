
-- ALTER VIEW [BiView].[MapaFaturamento_Nopin] AS

SELECT * FROM 
(
SELECT 
	
	CASE WHEN CG.YEAR IS NULL THEN X.ANO ELSE CG.YEAR END AS "Ano",
	
	CASE WHEN CG.NUM IS NULL 
		THEN '99 - Outros'
		ELSE CONCAT(RIGHT(CONCAT('0', CG.NUM), 2), ' - ', CG.NAME) 
	END AS "Grupo",

	CASE 
		WHEN CG.NUM IS NULL THEN 
		
		(SELECT AMOUNTPERIOD FROM CUSTGOAL WHERE DATAAREAID = X.EMPRESA AND NUM = '99' AND YEAR = CG.YEAR)

		ELSE AVG(CG.AMOUNTPERIOD)

	END AS "Valor Planejado",

	SUM(X.VALORLIQUIDO)	AS "Valor Faturado",
	SUM(X.PREVISAO)		AS "Forecast"
		
FROM

(
SELECT 

			X.DATAAREAID					AS EMPRESA,
			YEAR(X.FISCALDOCUMENTDATE)		AS ANO,
			X.FISCALDOCUMENTACCOUNTNUM		AS CODIGOCLIENTE,

			SUM( X.FATOR * (X.VALORLINHA + X.IPI + X.ENCARGOS))									AS VALOR_BRUTO,
			SUM( X.FATOR * (X.VALORLINHA + X.ENCARGOS - X.PIS - X.ICMS - X.COFINS - X.ISSQN))	AS VALORLIQUIDO,

			CASE WHEN 365 - (DATEDIFF(DAY, DATEFROMPARTS(YEAR(X.FISCALDOCUMENTDATE), 1, 1), GETDATE())) > 0 
				THEN 
					SUM( X.FATOR * (X.VALORLINHA + X.ENCARGOS - X.PIS - X.ICMS - X.COFINS - X.ISSQN)) / (DATEDIFF(DAY, DATEFROMPARTS(YEAR(X.FISCALDOCUMENTDATE), 1, 1), GETDATE())) * (( DATEDIFF(DAY, DATEFROMPARTS(YEAR(X.FISCALDOCUMENTDATE), 1, 1), DATEFROMPARTS(YEAR(X.FISCALDOCUMENTDATE), 12, 31)))+1)
				ELSE 
					SUM( X.FATOR * (X.VALORLINHA + X.ENCARGOS - X.PIS - X.ICMS - X.COFINS - X.ISSQN) )
			END AS PREVISAO

			FROM 
		(

			-- Sa�das de faturamento (excluindo devolu��es de compra e simples faturamento)

			SELECT 
				NF.DATAAREAID,
				NF.FISCALDOCUMENTACCOUNTNUM, 
				NF.FISCALDOCUMENTDATE, 
				NF.FISCALDOCUMENTNUMBER,
				LNF.LINEAMOUNT VALORLINHA, 
				IIPI.VALOR AS IPI,
				IPIS.VALOR AS PIS,
				COALESCE(IICMS.VALOR, 0) + COALESCE(IICMSDIF.VALOR, 0) AS ICMS,
				ICOFINS.VALOR AS COFINS,
				IISSQN.VALOR AS ISSQN,
				ENCARGO.ENCARGO AS ENCARGOS,
				1 AS FATOR,
				LNF.LINENUM AS NUMLINHA
			FROM FISCALDOCUMENT_BR NF
				JOIN FISCALDOCUMENTLINE_BR LNF ON LNF.FISCALDOCUMENT = NF.RECID
				JOIN CUSTINVOICEJOUR I ON I.RECID = NF.REFRECID AND NF.REFTABLEID = 62
				LEFT JOIN SALESTABLE S ON S.SALESID = I.SALESID
				LEFT JOIN SALESTABLE_BR SBR ON SBR.SALESTABLE = S.RECID
				LEFT JOIN BI_WELOZE.[dbo].[FISCALDOCUMENT_OPERATIONTYPEBR] FDOT 
					ON FDOT.FISCALDOCUMENTNUMBER = NF.FISCALDOCUMENTNUMBER 
						AND FDOT.SALESID = I.SALESID
				LEFT JOIN SALESPURCHOPERATIONTYPE_BR OT ON 
					(OT.RECID = SBR.SALESPURCHOPERATIONTYPE_BR 
					OR OT.OPERATIONTYPEID = FDOT.OPERATIONTYPE
					)
				JOIN CFOPTABLE_BR CF ON CF.CFOPID = LNF.CFOP AND CF.DATAAREAID = LNF.DATAAREAID
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 8) AS IIPI
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 1) AS IPIS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 2) AS IICMS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 15) AS IICMSDIF
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 3) AS ICOFINS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 4) AS IISSQN
				CROSS APPLY WELO.EncargoLinha (LNF.RECID) AS ENCARGO
			WHERE 1=1 
				AND LNF.DATAAREAID = 'NBRA'
				AND NF.STATUS = 1 -- Status da Nota Fiscal = Aprovado
				AND NF.DIRECTION = 2 -- Dire��o Sa�da
				AND (( 
					OT.CREATEFINANCIALTRANS = 1 -- Movimenta financeiro
					AND OT.OPERATIONTYPEID NOT IN (
						'S5556/6556', 'S5201/6201', 'S5410', 'S5412/6412', 'S5413/6413', 'S5553/6553', 'S5556/6556', 'S5201/6201', 'S413', 'S201', 'S5206', 'DC5201', 'S5413', -- devolu��o de compra
						'S922', 'S5922', 'S6922', 'S5922/6922', -- exclui simples faturamento
						'S5206/6206', 'S5206' -- anula��o de frete
						)
					)
					AND (OT.OPERATIONTYPEID != 'S5551/6551' OR NF.DATAAREAID = 'NBRA') -- desconsidera venda de ativo imobilizado, exceto para Nopin
					OR (OT.OPERATIONTYPEID = 'S5902/5124' AND LNF.CFOP = '5.124') -- opera��o especial Master
					OR (OT.OPERATIONTYPEID = 'T5902/5124' AND LNF.CFOP = '5.124') -- opera��o especial Master
					OR OT.OPERATIONTYPEID IN ('S116', 'S5116', 'S6116', 'S6118', 'S5116/6116', 'S5117/6117') -- inclui simples remessa
				)

			UNION

			-- Ordens de Devolu��o

			SELECT
				NF.DATAAREAID,
				NF.FISCALDOCUMENTACCOUNTNUM, 
				NF.FISCALDOCUMENTDATE, 
				NF.FISCALDOCUMENTNUMBER,
				LNF.LINEAMOUNT VALORLINHA, 
				IIPI.VALOR AS IPI,
				IPIS.VALOR AS PIS,
				COALESCE(IICMS.VALOR, 0) + COALESCE(IICMSDIF.VALOR, 0) AS ICMS,
				ICOFINS.VALOR AS COFINS,
				IISSQN.VALOR AS ISSQN,
				ENCARGO.ENCARGO AS ENCARGOS,
				-1 AS FATOR,
				LNF.LINENUM AS NUMLINHA
			FROM FISCALDOCUMENT_BR NF
				JOIN FISCALDOCUMENTLINE_BR LNF ON LNF.FISCALDOCUMENT = NF.RECID
				JOIN CUSTINVOICEJOUR I ON I.RECID = NF.REFRECID AND NF.REFTABLEID = 62
				LEFT JOIN SALESTABLE S ON S.SALESID = I.SALESID
				LEFT JOIN SALESTABLE_BR SBR ON SBR.SALESTABLE = S.RECID
				LEFT JOIN BI_WELOZE.[dbo].[FISCALDOCUMENT_OPERATIONTYPEBR] FDOT 
					ON FDOT.FISCALDOCUMENTNUMBER = NF.FISCALDOCUMENTNUMBER 
						AND FDOT.SALESID = I.SALESID
				LEFT JOIN SALESPURCHOPERATIONTYPE_BR OT ON 
					(OT.RECID = SBR.SALESPURCHOPERATIONTYPE_BR 
					OR OT.OPERATIONTYPEID = FDOT.OPERATIONTYPE
					)
				JOIN CFOPTABLE_BR CF ON CF.CFOPID = LNF.CFOP AND CF.DATAAREAID = LNF.DATAAREAID
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 8) AS IIPI
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 1) AS IPIS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 2) AS IICMS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 15) AS IICMSDIF
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 3) AS ICOFINS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 4) AS IISSQN
				CROSS APPLY WELO.EncargoLinha (LNF.RECID) AS ENCARGO
			WHERE 1=1 
				AND LNF.DATAAREAID = 'NBRA'
				AND NF.STATUS = 1 
				AND NF.DIRECTION = 1
				AND (
					(OT.CREATEFINANCIALTRANS = 1 AND
					OT.OPERATIONTYPEID IN ('F116', 'S101/102', 'S107/108', 'S118', 'S501', 'S5101', 'S5101 001', 'S5101 V.SU', 
						'S5102', 'S5116', 'S5116/6116', 'S5122/6122', 'S5124/5125', 'S5124/S5125', 'S5501/6501', 'S5118', 'S5118/6118', 
						'S5551/6551', 'S6101', 'S6101 001', 'S6116', 'S6118', 'S6122', 'S6124/6125', 'S7101/7127', 'S933', 
						'SFERRAM.RA', 'SFERRAMENT', 'SSUCATAS'))
					OR (OT.OPERATIONTYPEID = 'S5902/5124' AND LNF.CFOP = '1.949') -- opera��o especial Master
					OR (OT.OPERATIONTYPEID = 'T5902/5124' AND LNF.CFOP = '1.949') -- opera��o especial Master
				)
		
			UNION

			-- Devolu��es por Ordem de Compra

			SELECT 		
				NF.DATAAREAID,
				CT.ACCOUNTNUM, 
				NF.FISCALDOCUMENTDATE, 
				NF.FISCALDOCUMENTNUMBER,
				LNF.LINEAMOUNT VALORLINHA, 
				IIPI.VALOR AS IPI,
				IPIS.VALOR AS PIS,
				COALESCE(IICMS.VALOR, 0) + COALESCE(IICMSDIF.VALOR, 0) AS ICMS,
				ICOFINS.VALOR AS COFINS,
				IISSQN.VALOR AS ISSQN,
				ENCARGO.ENCARGO AS ENCARGOS,
				-1 AS FATOR,
				LNF.LINENUM AS NUMLINHA
			FROM FISCALDOCUMENT_BR NF
				JOIN FISCALDOCUMENTLINE_BR LNF ON LNF.FISCALDOCUMENT = NF.RECID
				JOIN VENDINVOICEJOUR I ON I.RECID = NF.REFRECID AND NF.REFTABLEID = 491
				LEFT JOIN PURCHTABLE P ON P.PURCHID = I.PURCHID
				LEFT JOIN PURCHTABLE_BR PBR ON PBR.PURCHTABLE = P.RECID
				LEFT JOIN BI_WELOZE.[dbo].[FISCALDOCUMENT_OPERATIONTYPEBR] FDOT 
					ON FDOT.FISCALDOCUMENTNUMBER = NF.FISCALDOCUMENTNUMBER 
						AND FDOT.SALESID = I.PURCHID
				LEFT JOIN SALESPURCHOPERATIONTYPE_BR OT ON 
					(OT.RECID = PBR.SALESPURCHOPERATIONTYPE_BR 
					OR OT.OPERATIONTYPEID = FDOT.OPERATIONTYPE
					)
				JOIN VENDTABLE V ON V.ACCOUNTNUM = NF.FISCALDOCUMENTACCOUNTNUM AND V.DATAAREAID = NF.DATAAREAID
				JOIN CUSTTABLE CT ON 
						(V.CNPJCPFNUM_BR =	'' AND V.ACCOUNTNUM		= CT.VENDACCOUNT) -- Terceiros do Exterior
					OR	(V.CNPJCPFNUM_BR <> '' AND CT.CNPJCPFNUM_BR = V.CNPJCPFNUM_BR)

				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 8) AS IIPI
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 1) AS IPIS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 2) AS IICMS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 15) AS IICMSDIF
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 3) AS ICOFINS
				CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 4) AS IISSQN
				CROSS APPLY WELO.EncargoLinha (LNF.RECID) AS ENCARGO
			WHERE 1=1 
				AND NF.STATUS = 1 
				AND NF.DIRECTION = 1
				AND LNF.DATAAREAID = 'NBRA'
				AND OT.OPERATIONTYPEID IN ('E1201/2201', 'DV1201/2201', 'E201/202', 'E3201')
				AND OT.CREATEFINANCIALTRANS = 1 
		) AS X

		GROUP BY YEAR(X.FISCALDOCUMENTDATE), X.FISCALDOCUMENTACCOUNTNUM, X.DATAAREAID

) AS X

	FULL OUTER JOIN CUSTGOALLINES CGL ON CGL.DATAAREAID = X.EMPRESA AND CGL.CUSTACCOUNT = X.CODIGOCLIENTE 
	FULL OUTER JOIN CUSTGOAL CG ON CG.RECID = CGL.CUSTGOAL AND CG.YEAR = X.ANO
	LEFT JOIN CUSTTABLE CT ON CT.ACCOUNTNUM = X.CODIGOCLIENTE AND CT.DATAAREAID = X.EMPRESA
	LEFT OUTER JOIN DIRPARTYTABLE PT ON PT.RECID = CT.PARTY

GROUP BY CG.YEAR, CG.NUM, CG.NAME, X.EMPRESA, X.ANO
) AS X 
WHERE X.[Valor Faturado] IS NOT NULL OR X.[Valor Planejado] IS NOT NULL

GO


