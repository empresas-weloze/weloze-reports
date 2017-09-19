
-- ALTER VIEW [BiView].[MetaFaturamento_OMT]  AS

SELECT 

	SG.YEAR					AS "Ano",

	SGL.ECORESCATEGORYNAME	AS "Item - Categoria",
	'' 						AS "Item",
	SGL.SEGMENTID			AS "Cliente - Segmento",
	
	AVG(SGL.AMOUNT)	/ 1000																						AS "Meta",
	CASE WHEN SUM(REAL.[Valor Rec. Líquida]) IS NULL THEN NULL ELSE SUM(REAL.[Valor Rec. Líquida]) / 1000 END 	AS "Faturado"

FROM SALEGOAL SG
	JOIN SALEGOALLINE SGL ON SGL.SALEGOAL = SG.RECID
	LEFT JOIN BI_Weloze.BiWeloze.ReceitaLiquida_omt REAL ON YEAR(REAL.Data) = SG.YEAR AND SGL.SEGMENTID = REAL.[Cliente - Segmento] AND SGL.ECORESCATEGORYNAME = REAL.[Linha de Produto OMT]
	JOIN ECORESCATEGORY ERC ON ERC.NAME = SGL.ECORESCATEGORYNAME
	JOIN ECORESCATEGORYHIERARCHY ERCH ON ERCH.NAME = 'LINHA DE PRODUTO OMT'

GROUP BY SG.YEAR, SGL.ECORESCATEGORYNAME, SGL.SEGMENTID

UNION

SELECT 

	YEAR(REAL.Data)					AS "Ano",

	REAL.[Linha de Produto OMT]		AS "Item - Categoria",
	REAL.[Item (Un. de Estoque)]	AS "Item",
	REAL.[Cliente - Segmento]		AS "Cliente - Segmento",
	
	NULL																										AS "Meta",
	CASE WHEN SUM(REAL.[Valor Rec. Líquida]) IS NULL THEN NULL ELSE SUM(REAL.[Valor Rec. Líquida]) / 1000 END 	AS "Faturado"

FROM BI_Weloze.BiWeloze.ReceitaLiquida_omt REAL
	LEFT JOIN SALEGOALLINE SGL ON SGL.SEGMENTID = REAL.[Cliente - Segmento] AND SGL.ECORESCATEGORYNAME = REAL.[Linha de Produto OMT]
	LEFT JOIN SALEGOAL SG ON YEAR(REAL.Data) = SG.YEAR AND SG.RECID = SGL.SALEGOAL

WHERE SG.RECID IS NULL AND YEAR(REAL.Data) = '2017' 

GROUP BY (REAL.Data), REAL.[Linha de Produto OMT], REAL.[Cliente - Segmento], REAL.[Item (Un. de Estoque)]