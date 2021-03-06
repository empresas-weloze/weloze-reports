
-- ALTER VIEW BiView.RequisitosLiquidosCompletos_OMT  AS

SELECT 

	COG.GROUPNAME	AS "Grupo",
	X.OPRID			AS "Opera��o (Nome)",
	CO.NUMBEROFDAYS AS "Dias",

	X.PRODID	AS "Ordem de Produ��o",
	X.OPRNUM	AS "Opera��o (C�digo)",
	X.QTYSCHED	AS "Quantidade",
	
	X.RECURSO									AS "Recurso",
	CONCAT(CT.ACCOUNTNUM , ' - ', DPT.NAME)		AS "Cliente",
	
	X.ITEM			AS "Nome do Item",
	ACAO.NOME		AS "A��o",
	X.ORDEM_VENDA	AS "Ordem de Venda",
	ST.DELIVERYDATE	AS "Prazo Ordem Venda", 
	CASE WHEN ST.DELIVERYDATE IS NOT NULL THEN ST.DELIVERYDATE- CO.NUMBEROFDAYS	ELSE X.PT_DLVDATE END AS "Prazo Ordem Produ��o",
	STATUSOP.STATUS	AS "Status"

FROM

(
SELECT 
	
	PT.DATAAREAID,
	PT.PRODID, 
	PT.PRODSTATUS,
	PR.OPRNUM, 
	PR.OPRID,
	PT.QTYSCHED,
	PT.DLVDATE AS PT_DLVDATE,
	WCT.NAME AS RECURSO,
	CONCAT(IT.ITEMID, ' - ', ERPT.NAME, ' (', MODESTOQUE.UNITID, ')') AS ITEM,
	REQ1.REQ_ACTIONTYPE,

	CASE 
		WHEN REQ1.ATE_REFTYPE = 10 THEN REQ1.ATE_REFID
		WHEN REQ2.ATE_REFTYPE = 10 THEN REQ2.ATE_REFID
		WHEN REQ3.ATE_REFTYPE = 10 THEN REQ3.ATE_REFID
		WHEN REQ4.ATE_REFTYPE = 10 THEN REQ4.ATE_REFID
		WHEN REQ5.ATE_REFTYPE = 10 THEN REQ5.ATE_REFID
		WHEN REQ6.ATE_REFTYPE = 10 THEN REQ6.ATE_REFID
		WHEN REQ7.ATE_REFTYPE = 10 THEN REQ7.ATE_REFID
	END AS ORDEM_VENDA
	
FROM PRODTABLE PT
	JOIN PRODROUTE PR ON PR.PRODID = PT.PRODID
	JOIN WRKCTRTABLE WCT ON WCT.WRKCTRID = PR.WRKCTRIDCOST AND WCT.DATAAREAID = PR.DATAAREAID
	JOIN INVENTTABLE IT ON IT.ITEMID = PT.ITEMID AND IT.DATAAREAID = PT.DATAAREAID
	JOIN ECORESPRODUCT ERP ON ERP.RECID = IT.PRODUCT
	JOIN ECORESPRODUCTTRANSLATION ERPT ON ERPT.PRODUCT = ERP.RECID AND ERPT.LANGUAGEID = 'PT-BR'

	JOIN INVENTTABLEMODULE MODESTOQUE ON MODESTOQUE.ITEMID = IT.ITEMID AND MODESTOQUE.DATAAREAID = IT.DATAAREAID AND MODESTOQUE.MODULETYPE = 0 -- Estoque

	LEFT JOIN BiView.RequisitosLiquidos_OMT REQ1 ON REQ1.REQ_REFID = PR.PRODID AND REQ1.REQ_REFTYPE = 9
	LEFT JOIN BiView.RequisitosLiquidos_OMT REQ2 ON REQ2.REQ_REFID = REQ1.ATE_REFID AND REQ2.REQ_REFTYPE = 9
	LEFT JOIN BiView.RequisitosLiquidos_OMT REQ3 ON REQ3.REQ_REFID = REQ2.ATE_REFID AND REQ3.REQ_REFTYPE = 9
	LEFT JOIN BiView.RequisitosLiquidos_OMT REQ4 ON REQ4.REQ_REFID = REQ3.ATE_REFID AND REQ4.REQ_REFTYPE = 9
	LEFT JOIN BiView.RequisitosLiquidos_OMT REQ5 ON REQ5.REQ_REFID = REQ4.ATE_REFID AND REQ5.REQ_REFTYPE = 9
	LEFT JOIN BiView.RequisitosLiquidos_OMT REQ6 ON REQ6.REQ_REFID = REQ5.ATE_REFID AND REQ6.REQ_REFTYPE = 9
	LEFT JOIN BiView.RequisitosLiquidos_OMT REQ7 ON REQ7.REQ_REFID = REQ6.ATE_REFID AND REQ7.REQ_REFTYPE = 9

WHERE 1=1
	AND PT.DATAAREAID =	'OMT'
	AND PT.PRODSTATUS = 4
	AND REQ1.ATE_REFTYPE NOT IN (14, 32)

GROUP BY 
	PT.DATAAREAID, PT.PRODID, PR.OPRNUM, PR.OPRID, PR.WRKCTRIDCOST, WCT.NAME, IT.ITEMID, ERPT.NAME, PT.PRODSTATUS, PT.DLVDATE,
	REQ1.REQ_ACTIONTYPE, PT.QTYSCHED, MODESTOQUE.UNITID,

	REQ1.ATE_REFTYPE, REQ1.ATE_REFID, REQ1.ITEMID, 
	REQ2.ATE_REFTYPE, REQ2.ATE_REFID, REQ2.ITEMID, 
	REQ3.ATE_REFTYPE, REQ3.ATE_REFID, REQ3.ITEMID, 
	REQ4.ATE_REFTYPE, REQ4.ATE_REFID, REQ4.ITEMID, 
	REQ5.ATE_REFTYPE, REQ5.ATE_REFID, REQ5.ITEMID, 
	REQ6.ATE_REFTYPE, REQ6.ATE_REFID, REQ6.ITEMID, 
	REQ7.ATE_REFTYPE, REQ7.ATE_REFID, REQ7.ITEMID

) AS X

LEFT JOIN SALESTABLE ST ON ST.SALESID = X.ORDEM_VENDA
LEFT JOIN CUSTTABLE CT ON CT.ACCOUNTNUM = ST.CUSTACCOUNT
LEFT JOIN DIRPARTYTABLE DPT ON DPT.RECID = CT.PARTY
LEFT JOIN BI_Weloze..CONFIGOPERATION CO ON CO.OPRNAME = X.OPRID
LEFT JOIN BI_Weloze..CONFIGOPERATIONGROUP COG ON COG.ID = CO.OPRGROUPID	
OUTER APPLY BiUtil.StatusOrdemProducao(X.PRODSTATUS) AS STATUSOP
OUTER APPLY BiUtil.TipoAcaoMrp(X.REQ_ACTIONTYPE) AS ACAO
