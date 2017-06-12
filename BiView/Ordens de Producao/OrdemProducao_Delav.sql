
-- ALTER VIEW [BiView].[OrdemProducao_Delav]  AS 

SELECT 
	P.PRODID AS "Ordem de Produção - Número", 
	P.DLVDATE AS "Ordem de Produção - Data de Entrega", 
	P.PRODPOOLID AS "Ordem de Produção - Grupo",
	P.SCHEDDATE AS "Ordem de Produção - Data Inicial",
	DATEADD(dd, 0, DATEDIFF(dd, 0, P.CREATEDDATETIME)) AS "Ordem de Produção - Data de Criação", 
	P.QTYSCHED AS "Ordem de Produção - Quantidade", 
	P.REMAININVENTPHYSICAL AS "Ordem de Produção - Quantidade Pendente",
	TIPOREFERENCIA.Referencia AS "Ordem de Produção - Tipo de Referência", 
	STATUSOP.STATUS AS "Ordem de Produção - Status",
	
	-- R.OPRNUM AS "Operação - Número", 
	-- R.OPRID AS "Operação - Descrição", 
	-- R.CALCQTY AS "Operação - Quantidade", 
	-- R.PROCESSTIME / R.PROCESSPERQTY * R.TOHOURS AS "Tempo por Item",
	-- R.PROCESSTIME / R.PROCESSPERQTY * R.TOHOURS * P.QTYSCHED "Tempo Total",
	-- R.PROCESSTIME / R.PROCESSPERQTY * R.TOHOURS * P.QTYSCHED "Tempo Pendente",
	   
	-- R.WRKCTRIDCOST AS "Recurso/Grupo - Código", 
	-- W.NAME AS "Recurso/Grupo - Nome", 
	
	P.ITEMID AS "Item - Código", 
	PT.NAME AS "Item - Nome", 
	CONCAT(P.ITEMID, ' - ', PT.NAME) AS "Item - Código e Nome",
		
	S.SALESID AS "Ordem de Venda", 
	CONCAT(C.ACCOUNTNUM, ' - ', PTC.NAME) AS "Cliente",

	ID.INVENTSIZEID AS "Dimensão - Tensão",
	ID.INVENTSTYLEID AS "Dimensão - Largura da Lâmina",
	ID.INVENTSITEID	AS "Dimensão - Site",
	ID.INVENTLOCATIONID AS "Dimensão - Depósito",
	ID.INVENTBATCHID AS "Dimensão - Lote",
	ID.WMSLOCATIONID AS "Dimensão - Localização",
	ID.INVENTSERIALID AS "Dimensão - Nº  de Série",

	P.INVENTREFID AS "Referência - Código",
	P.INVENTREFTYPE AS "Referência - Tipo"

FROM PRODTABLE P
	--JOIN PRODROUTE R ON R.PRODID = P.PRODID
	--JOIN WRKCTRTABLE W ON W.WRKCTRID = R.WRKCTRIDCOST AND W.DATAAREAID = R.DATAAREAID
	JOIN INVENTTABLE I ON I.ITEMID = P.ITEMID AND I.DATAAREAID = P.DATAAREAID
	JOIN ECORESPRODUCT PR ON PR.RECID = I.PRODUCT
	JOIN ECORESPRODUCTTRANSLATION PT ON PT.PRODUCT = PR.RECID AND PT.LANGUAGEID = 'PT-BR'
	LEFT JOIN SALESTABLE S ON S.SALESID = P.INVENTREFID AND P.INVENTREFTYPE = 1 -- Ordem de Venda
	LEFT JOIN CUSTTABLE C ON C.ACCOUNTNUM = S.CUSTACCOUNT
	LEFT JOIN DIRPARTYTABLE PTC ON PTC.RECID = C.PARTY
	JOIN INVENTDIM ID ON ID.INVENTDIMID = P.INVENTDIMID

	CROSS APPLY BI.TipoReferenciaOrdemProducao (P.INVENTREFTYPE) AS TIPOREFERENCIA
	CROSS APPLY BI.StatusOrdemProducao (P.PRODSTATUS) AS STATUSOP 

WHERE P.DATAAREAID = 'DELA'
