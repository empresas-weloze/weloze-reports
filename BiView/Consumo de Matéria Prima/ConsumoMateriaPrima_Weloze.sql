
-- ALTER VIEW BiView.ConsumoMateriaPrima_Weloze AS

SELECT 	

	L.TRANSDATE AS "Data", 
	DATA.MESANO AS "Data (ano/m�s)",
	II.ITEMGROUPID AS "Grupo",
	P.PRODID AS "Ordem de Produ��o",
	
	CONCAT(L.ITEMID, ' - ', PT.NAME) AS "Item",
	PR.SEARCHNAME AS "Item - Nome de Pesquisa",
	L.BOMCONSUMP AS "Consumo", 
	
	CASE WHEN L.BOMUNITID = 'Kg' 
		THEN 1.0 
		ELSE I.NETWEIGHT 
	END AS "Peso",
	
	CASE WHEN L.BOMUNITID = 'Kg' 
		THEN L.BOMCONSUMP 
		ELSE L.BOMCONSUMP * I.NETWEIGHT 
	END  AS "Total"

FROM PRODJOURNALBOM L
	JOIN PRODJOURNALTABLE T ON T.JOURNALID = L.JOURNALID AND T.JOURNALTYPE = 0
	JOIN INVENTDIM D ON D.INVENTDIMID = L.INVENTDIMID
	JOIN PRODTABLE P ON P.PRODID = L.PRODID
	JOIN INVENTTABLE I ON I.ITEMID = L.ITEMID AND I.DATAAREAID = L.DATAAREAID
	JOIN ECORESPRODUCT PR ON PR.RECID = I.PRODUCT
	JOIN ECORESPRODUCTTRANSLATION PT ON PT.PRODUCT = PR.RECID AND PT.LANGUAGEID = 'PT-BR'
	CROSS APPLY BiUtil.DataFiltroAnoMes(L.TRANSDATE) DATA
	JOIN INVENTITEMGROUPITEM II ON II.ITEMDATAAREAID = I.DATAAREAID AND II.ITEMID = I.ITEMID
WHERE II.ITEMGROUPID IN ('010', '020', '080')
	AND T.POSTED = 1
	AND T.DATAAREAID = 'WELO'
	AND L.BOMCONSUMP > 0

UNION

SELECT 

	PP.TRANSDATE AS "Data", 
	DATA.MESANO AS "Data (ano/m�s)",
	II.ITEMGROUPID AS "Grupo",
	P.PRODID AS "Ordem de Produ��o",
	
	CONCAT(I.ITEMID, ' - ', PT.NAME) AS "Item",
	PR.SEARCHNAME AS "Item - Nome de Pesquisa",

	SUM((C.CONSUMPVARIABLE + CONSUMPCONSTANT)) / SUM(C.QTY) * SUM(PP.QTYGOOD + PP.QTYERROR) AS "Consumo",
	
	CASE WHEN C.UNITID = 'Kg' 
		THEN 1.0 
		ELSE I.NETWEIGHT 
	END AS "Peso",
	
	CASE WHEN C.UNITID = 'Kg' 
		THEN (SUM(C.CONSUMPVARIABLE + CONSUMPCONSTANT)) / SUM(C.QTY) * SUM(PP.QTYGOOD + PP.QTYERROR) 
		ELSE (SUM(C.CONSUMPVARIABLE + CONSUMPCONSTANT)) / SUM(C.QTY) * SUM(PP.QTYGOOD + PP.QTYERROR) * I.NETWEIGHT
	END  AS "Total"

FROM PRODCALCTRANS C
	JOIN PRODTABLE P ON P.PRODID = C.TRANSREFID AND P.COLLECTREFPRODID = C.COLLECTREFPRODID
	JOIN PRODJOURNALTABLE PJ ON PJ.PRODID = P.PRODID
	JOIN PRODJOURNALPROD PP ON PP.JOURNALID = PJ.JOURNALID AND PJ.JOURNALTYPE = 1
	JOIN INVENTDIM D ON D.INVENTDIMID = C.INVENTDIMID
	JOIN INVENTTABLE I ON I.ITEMID = C.RESOURCE_ AND I.DATAAREAID = C.DATAAREAID
	JOIN ECORESPRODUCT PR ON PR.RECID = I.PRODUCT
	JOIN ECORESPRODUCTTRANSLATION PT ON PT.PRODUCT = PR.RECID AND PT.LANGUAGEID = 'PT-BR'
	JOIN INVENTITEMGROUPITEM II ON II.ITEMDATAAREAID = I.DATAAREAID AND II.ITEMID = I.ITEMID
	CROSS APPLY BiUtil.DataFiltroAnoMes(PP.TRANSDATE) DATA
WHERE 1=1
	AND II.ITEMGROUPID = '150'
	--AND P.PRODSTATUS IN ()
	AND P.DATAAREAID = 'WELO'
GROUP BY PP.TRANSDATE, DATA.MESANO, P.PRODID, II.ITEMGROUPID, I.ITEMID, PT.NAME, PR.SEARCHNAME, C.UNITID, I.NETWEIGHT
HAVING SUM(C.QTY) > 0
