
-- ALTER VIEW [BiView].[ReceitaLiquida_Delav]  AS

SELECT 

	X.TIPO AS "Nota Fiscal - Tipo",
	X.FISCALDOCUMENTNUMBER	AS "Nota Fiscal - Número",
	X.FISCALESTABLISHMENT	AS "Nota Fiscal - Estabelecimento Fiscal",
	X.NUMLINHA AS "Nota Fiscal - Número da Linha",

	X.FISCALDOCUMENTDATE AS "Data",
	DATAFILTRO.MESANO AS "Data - Mês/Ano",
	DATEPART(ISO_WEEK, X.FISCALDOCUMENTDATE) AS "Data - Nº da Semana",

	X.FISCALDOCUMENTACCOUNTNUM AS "Cliente - Código",
	CONCAT(X.FISCALDOCUMENTACCOUNTNUM, ' - ', X.CLIENTE) AS "Cliente - Nome",
	X.THIRDPARTYCNPJCPF		AS "Cliente - CNPJ",
	X.IENUM_BR AS "Cliente - IE",
	X.LINEOFBUSINESSID AS "Cliente - Linha de Negócio",
	X.SEGMENTID AS "Cliente - Segmento",
	X.SUBSEGMENTID AS "Cliente - Subsegmento",

	CONCAT(X.CIDADE, ' / ',  X.ESTADO)	AS "Cliente - Cidade/Estado",
	CONCAT(X.ESTADO, ' / ', X.PAIS)		AS "Cliente - Estado/País",
	X.ESTADO							AS "Cliente - Estado",
	X.PAIS								AS "Cliente - País",

	X.FISCALCLASSIFICATION AS "Item - NCM",
	X.CATEGORIA AS "Item - Categoria",

	X.OPERATIONTYPEID AS "Tipo de Operação - Código",
	CONCAT(X.OPERATIONTYPEID, ' - ', X.OPERATIONNAME) AS "Tipo de Operação - Descrição",

	X.CFOPID AS "CFOP - Código",
	CONCAT(X.CFOPID, ' - ', X.CFOPNAME) AS "CFOP - Descrição",

	X.DOCUMENTOORIGINAL AS "Ordem de Compra/Venda",
	X.GRUPOVENDA AS "Grupo de Vendas",
	X.GRUPOOV AS "Grupo",
	X.CONDICAOPGTO AS "Condição de Pagamento",
	X.PLANOPGTO AS "Plano de Pagamento",

	X.ITEMID AS "Item - Código",
	CONCAT(X.ITEMID, ' - ', X.NAMEALIAS) AS "Item - Nome de Pesquisa",
	CONCAT(X.ITEMID, ' - ', X.ITEMNAME, ' (', X.UNIDADENF, ')')		 AS "Item (Un. da Nota Fiscal)",
	CONCAT(X.ITEMID, ' - ', X.ITEMNAME, ' (', X.UNIDADEVENDA, ')')	 AS "Item (Un. de Venda)",
	CONCAT(X.ITEMID, ' - ', X.ITEMNAME, ' (', X.UNIDADEESTOQUE, ')') AS "Item (Un. de Estoque)",

	X.QUANTITY * X.FATOR AS "Quantidade (Un. da Nota Fiscal)",
	CASE WHEN COMPRA.FATOR IS NULL	THEN X.QUANTITY * X.FATOR	ELSE COMPRA.FATOR * X.QUANTITY * X.FATOR	END AS "Quantidade (Un. de Compra)",
	CASE WHEN ESTOQUE.FATOR IS NULL THEN X.QUANTITY * X.FATOR	ELSE ESTOQUE.FATOR * X.QUANTITY	* X.FATOR	END AS "Quantidade (Un. de Estoque)",

	X.FATOR * (X.VALORLINHA - X.DESCONTO + X.IPI + X.ENCARGOS)					AS "Valor Fat. Bruto",
	X.FATOR * (X.VALORLINHA - X.DESCONTO + X.IPI )								AS "Valor Fat. Bruto s/ Encargos",
	X.FATOR * (X.VALORLINHA - X.DESCONTO + X.ENCARGOS)							AS "Valor Rec. Bruta s/ IPI",
	X.FATOR * (X.VALORLINHA - X.DESCONTO + X.ENCARGOS - X.PIS - X.ICMS - X.COFINS - X.ISSQN) AS "Valor Rec. Líquida",
	
	X.FATOR * (X.ENCARGOS)	AS "Valor Encargos",
	X.FATOR * (X.IPI)		AS "Valor IPI",
	X.FATOR * (X.PIS)		AS "Valor PIS",
	X.FATOR * (X.ICMS)		AS "Valor ICMS",
	X.FATOR * (X.COFINS)	AS "Valor COFINS",
	X.FATOR * (X.ISSQN)		AS "Valor ISSQN"	

 FROM 
(

	-- Saídas de faturamento (excluindo devoluções de compra e simples faturamento)

	SELECT P.RECID AS ECORESPRODUCTID,
		NF.STATUS,
		NF.DIRECTION,
		NF.DATAAREAID AS EMPRESA, 
		OT.CREATEFINANCIALTRANS, 
		OT.CREATEINVENTTRANS, 
		NF.FISCALDOCUMENTACCOUNTNUM, 
		CF.CFOPID, CF.NAME AS CFOPNAME,  
		LNF.FISCALCLASSIFICATION,
		IT.ITEMID, T.NAME ITEMNAME, 
		S.SALESID AS DOCUMENTOORIGINAL,
		NF.FISCALESTABLISHMENT, NF.FISCALDOCUMENTDATE, PT.NAME AS CLIENTE, 
		NF.FISCALDOCUMENTNUMBER, NF.THIRDPARTYCNPJCPF, C.IENUM_BR, 
		LNF.LINEAMOUNT VALORLINHA,  
		LNF.LINEDISCOUNT AS DESCONTO,
		OT.OPERATIONTYPEID, OT.NAME AS OPERATIONNAME,
		IIPI.VALOR AS IPI,
		IPIS.VALOR AS PIS,
		COALESCE(IICMS.VALOR, 0) + COALESCE(IICMSDIF.VALOR, 0) AS ICMS,
		ICOFINS.VALOR AS COFINS,
		IISSQN.VALOR AS ISSQN,
		ENCARGO.ENCARGO AS ENCARGOS,
		1 AS FATOR,
		'Venda' AS TIPO,
		LNF.LINENUM AS NUMLINHA,
		CATEGORIA.CATEGORIA,
		LNF.QUANTITY,
		LNF.UNIT AS UNIDADENF,
		MODVENDA.UNITID AS UNIDADEVENDA,
		MODESTOQUE.UNITID AS UNIDADEESTOQUE,
		IT.NAMEALIAS,
		C.SEGMENTID,
		C.SUBSEGMENTID,
		C.LINEOFBUSINESSID,
		S.SALESGROUP AS GRUPOVENDA,
		S.SALESPOOLID AS GRUPOOV,
		S.PAYMENT AS CONDICAOPGTO,
		S.PAYMENTSCHED AS PLANOPGTO,
		LPA.COUNTRYREGIONID PAIS,
		LPA.STATE AS ESTADO,
		LPA.CITY AS CIDADE
	FROM FISCALDOCUMENT_BR NF
		JOIN FISCALDOCUMENTLINE_BR LNF ON LNF.FISCALDOCUMENT = NF.RECID
		JOIN CUSTINVOICEJOUR I ON I.RECID = NF.REFRECID AND NF.REFTABLEID = 62
		LEFT JOIN SALESTABLE S ON S.SALESID = I.SALESID
		LEFT JOIN SALESTABLE_BR SBR ON SBR.SALESTABLE = S.RECID
		LEFT JOIN SALESPURCHOPERATIONTYPE_BR OT ON OT.RECID = SBR.SALESPURCHOPERATIONTYPE_BR
		JOIN CUSTTABLE C ON C.ACCOUNTNUM = NF.FISCALDOCUMENTACCOUNTNUM
		JOIN DIRPARTYTABLE PT ON PT.RECID = C.PARTY
		JOIN CFOPTABLE_BR CF ON CF.CFOPID = LNF.CFOP AND CF.DATAAREAID = LNF.DATAAREAID
		JOIN INVENTTABLE IT ON IT.ITEMID = LNF.ITEMID AND IT.DATAAREAID = LNF.DATAAREAID
		JOIN ECORESPRODUCT P ON P.RECID = IT.PRODUCT
		JOIN ECORESPRODUCTTRANSLATION T ON T.PRODUCT = P.RECID
		JOIN LANGUAGETABLE L ON L.LANGUAGEID = T.LANGUAGEID
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 8) AS IIPI
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 1) AS IPIS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 2) AS IICMS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 15) AS IICMSDIF
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 3) AS ICOFINS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 4) AS IISSQN
		CROSS APPLY WELO.EncargoLinha (LNF.RECID) AS ENCARGO
		OUTER APPLY BiUtil.CategoriaDelav(P.RECID) AS CATEGORIA
		JOIN INVENTTABLEMODULE MODVENDA ON MODVENDA.ITEMID = IT.ITEMID AND MODVENDA.DATAAREAID = IT.DATAAREAID AND MODVENDA.MODULETYPE = 2 -- Venda
		JOIN INVENTTABLEMODULE MODESTOQUE ON MODESTOQUE.ITEMID = IT.ITEMID AND MODESTOQUE.DATAAREAID = IT.DATAAREAID AND MODESTOQUE.MODULETYPE = 0 -- Estoque
		JOIN LOGISTICSLOCATION LL ON LL.RECID = PT.PRIMARYADDRESSLOCATION
		JOIN LOGISTICSPOSTALADDRESS LPA ON LPA.LOCATION = LL.RECID AND CONVERT(DATE, GETDATE()) BETWEEN LPA.VALIDFROM AND LPA.VALIDTO
	WHERE 1=1 
		AND LNF.DATAAREAID = 'DELA'
		AND NF.STATUS = 1 -- Status da Nota Fiscal = Aprovado
		AND NF.DIRECTION = 2 -- Direção Saída
		AND (( 
			OT.CREATEFINANCIALTRANS = 1 -- Movimenta financeiro
			AND OT.OPERATIONTYPEID NOT IN (
				'S5556/6556', 'S5201/6201', 'S5410', 'S5412/6412', 'S5413/6413', 'S5553/6553', 'S5556/6556', 'S5201/6201', 'S413', 'S201', 'S5206', 'DC5201', 'S5413', -- devolução de compra
				'S922', 'S5922', 'S6922', 'S5922/6922', -- exclui simples faturamento
				'S5206/6206', 'S5206' -- anulação de frete
				)
			)
			AND (OT.OPERATIONTYPEID != 'S5551/6551' OR NF.DATAAREAID = 'NBRA') -- desconsidera venda de ativo imobilizado, exceto para Nopin
			OR (OT.OPERATIONTYPEID = 'S5902/5124' AND LNF.CFOP = '5.124') -- operação especial Master
			OR (OT.OPERATIONTYPEID = 'T5902/5124' AND LNF.CFOP = '5.124') -- operação especial Master
			OR OT.OPERATIONTYPEID IN ('S116', 'S5116', 'S6116', 'S6118', 'S5116/6116', 'S5117/6117') -- inclui simples remessa
		)

	UNION

	-- Ordens de Devolução

	SELECT P.RECID AS ECORESPRODUCTID,
		NF.STATUS,
		NF.DIRECTION,
		NF.DATAAREAID AS EMPRESA, 
		OT.CREATEFINANCIALTRANS, 
		OT.CREATEINVENTTRANS, 
		NF.FISCALDOCUMENTACCOUNTNUM, 
		CF.CFOPID, CF.NAME AS CFOPNAME,  
		LNF.FISCALCLASSIFICATION,
		IT.ITEMID, T.NAME ITEMNAME, 
		S.SALESID AS DOCUMENTOORIGINAL,
		NF.FISCALESTABLISHMENT, NF.ACCOUNTINGDATE, PT.NAME AS CLIENTE, 
		NF.FISCALDOCUMENTNUMBER, NF.THIRDPARTYCNPJCPF, C.IENUM_BR, 
		LNF.LINEAMOUNT VALORLINHA,  
		LNF.LINEDISCOUNT AS DESCONTO,
		OT.OPERATIONTYPEID, OT.NAME AS OPERATIONNAME,
		IIPI.VALOR AS IPI,
		IPIS.VALOR AS PIS,
		COALESCE(IICMS.VALOR, 0) + COALESCE(IICMSDIF.VALOR, 0) AS ICMS,
		ICOFINS.VALOR AS COFINS,
		IISSQN.VALOR AS ISSQN,
		ENCARGO.ENCARGO AS ENCARGOS,
		-1 AS FATOR, 
		'Ordem Devolvida' AS TIPO,
		LNF.LINENUM AS NUMLINHA,
		CATEGORIA.CATEGORIA,
		LNF.QUANTITY,
		LNF.UNIT AS UNIDADENF,
		MODVENDA.UNITID AS UNIDADEVENDA,
		MODESTOQUE.UNITID AS UNIDADEESTOQUE,
		IT.NAMEALIAS,
		C.SEGMENTID,
		C.SUBSEGMENTID,
		C.LINEOFBUSINESSID,
		S.SALESGROUP AS GRUPOVENDA,
		S.SALESPOOLID AS GRUPOOV,
		S.PAYMENT AS CONDICAOPGTO,
		S.PAYMENTSCHED AS PLANOPGTO,
		LPA.COUNTRYREGIONID PAIS,
		LPA.STATE AS ESTADO,
		LPA.CITY AS CIDADE
	FROM FISCALDOCUMENT_BR NF
		JOIN FISCALDOCUMENTLINE_BR LNF ON LNF.FISCALDOCUMENT = NF.RECID
		JOIN CUSTINVOICEJOUR I ON I.RECID = NF.REFRECID AND NF.REFTABLEID = 62
		LEFT JOIN SALESTABLE S ON S.SALESID = I.SALESID
		LEFT JOIN SALESTABLE_BR SBR ON SBR.SALESTABLE = S.RECID
		LEFT JOIN SALESPURCHOPERATIONTYPE_BR OT ON OT.RECID = SBR.SALESPURCHOPERATIONTYPE_BR
		JOIN CUSTTABLE C ON C.ACCOUNTNUM = NF.FISCALDOCUMENTACCOUNTNUM
		JOIN DIRPARTYTABLE PT ON PT.RECID = C.PARTY
		JOIN CFOPTABLE_BR CF ON CF.CFOPID = LNF.CFOP AND CF.DATAAREAID = LNF.DATAAREAID
		JOIN INVENTTABLE IT ON IT.ITEMID = LNF.ITEMID AND IT.DATAAREAID = LNF.DATAAREAID
		JOIN ECORESPRODUCT P ON P.RECID = IT.PRODUCT
		JOIN ECORESPRODUCTTRANSLATION T ON T.PRODUCT = P.RECID
		JOIN LANGUAGETABLE L ON L.LANGUAGEID = T.LANGUAGEID
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 8) AS IIPI
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 1) AS IPIS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 2) AS IICMS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 15) AS IICMSDIF
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 3) AS ICOFINS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 4) AS IISSQN
		CROSS APPLY WELO.EncargoLinha (LNF.RECID) AS ENCARGO
		OUTER APPLY BiUtil.CategoriaDelav(P.RECID) AS CATEGORIA
		JOIN INVENTTABLEMODULE MODVENDA ON MODVENDA.ITEMID = IT.ITEMID AND MODVENDA.DATAAREAID = IT.DATAAREAID AND MODVENDA.MODULETYPE = 2 -- Venda
		JOIN INVENTTABLEMODULE MODESTOQUE ON MODESTOQUE.ITEMID = IT.ITEMID AND MODESTOQUE.DATAAREAID = IT.DATAAREAID AND MODESTOQUE.MODULETYPE = 0 -- Estoque
		JOIN LOGISTICSLOCATION LL ON LL.RECID = PT.PRIMARYADDRESSLOCATION
		JOIN LOGISTICSPOSTALADDRESS LPA ON LPA.LOCATION = LL.RECID AND CONVERT(DATE, GETDATE()) BETWEEN LPA.VALIDFROM AND LPA.VALIDTO
	WHERE 1=1 
		AND LNF.DATAAREAID = 'DELA'
		AND NF.STATUS = 1 
		AND NF.DIRECTION = 1
		AND (
			(OT.CREATEFINANCIALTRANS = 1 AND
			OT.OPERATIONTYPEID IN ('F116', 'S101/102', 'S107/108', 'S118', 'S501', 'S5101', 'S5101 001', 'S5101 V.SU', 
				'S5102', 'S5116', 'S5116/6116', 'S5122/6122', 'S5124/5125', 'S5124/S5125', 'S5501/6501', 'S5118', 'S5118/6118', 
				'S5551/6551', 'S6101', 'S6101 001', 'S6116', 'S6118', 'S6122', 'S6124/6125', 'S7101/7127', 'S933', 
				'SFERRAM.RA', 'SFERRAMENT', 'SSUCATAS'))
			OR (OT.OPERATIONTYPEID = 'S5902/5124' AND LNF.CFOP = '1.949') -- operação especial Master
			OR (OT.OPERATIONTYPEID = 'T5902/5124' AND LNF.CFOP = '1.949') -- operação especial Master
		)


	UNION

	-- Devoluções por Ordem de Compra

	SELECT P.RECID AS ECORESPRODUCTID,
		NF.STATUS,
		NF.DIRECTION,
		NF.DATAAREAID AS EMPRESA, 
		OT.CREATEFINANCIALTRANS, 
		OT.CREATEINVENTTRANS, 
		CT.ACCOUNTNUM,
		CF.CFOPID, CF.NAME AS CFOPNAME,  
		LNF.FISCALCLASSIFICATION,
		IT.ITEMID, T.NAME ITEMNAME, 
		P.PURCHID AS DOCUMENTOORIGINAL,
		NF.FISCALESTABLISHMENT, NF.ACCOUNTINGDATE, PT.NAME AS CLIENTE, 
		NF.FISCALDOCUMENTNUMBER, NF.THIRDPARTYCNPJCPF, V.IENUM_BR,
		LNF.LINEAMOUNT VALORLINHA,  
		LNF.LINEDISCOUNT AS DESCONTO,
		OT.OPERATIONTYPEID, OT.NAME AS OPERATIONNAME,
		IIPI.VALOR AS IPI,
		IPIS.VALOR AS PIS,
		COALESCE(IICMS.VALOR, 0) + COALESCE(IICMSDIF.VALOR, 0) AS ICMS,
		ICOFINS.VALOR AS COFINS,
		IISSQN.VALOR AS ISSQN,
		ENCARGO.ENCARGO AS ENCARGOS,
		-1 AS FATOR,
		'Devolução por Ordem de Compra' AS TIPO,
		LNF.LINENUM AS NUMLINHA,
		CATEGORIA.CATEGORIA,
		LNF.QUANTITY,
		LNF.UNIT AS UNIDADENF,
		MODVENDA.UNITID AS UNIDADEVENDA,
		MODESTOQUE.UNITID AS UNIDADEESTOQUE,
		IT.NAMEALIAS,
		CT.SEGMENTID,
		CT.SUBSEGMENTID,
		CT.LINEOFBUSINESSID,
		'Devolução por Ordem de Compra' AS GRUPOVENDA,
		'Devolução por Ordem de Compra' AS GRUPOOV,
		'Devolução por Ordem de Compra' AS CONDICAOPGTO,
		'Devolução por Ordem de Compra' AS PLANOPGTO,
		LPA.COUNTRYREGIONID PAIS,
		LPA.STATE AS ESTADO,
		LPA.CITY AS CIDADE
	FROM FISCALDOCUMENT_BR NF
		JOIN FISCALDOCUMENTLINE_BR LNF ON LNF.FISCALDOCUMENT = NF.RECID
		JOIN VENDINVOICEJOUR I ON I.RECID = NF.REFRECID AND NF.REFTABLEID = 491
		LEFT JOIN PURCHTABLE P ON P.PURCHID = I.PURCHID
		LEFT JOIN PURCHTABLE_BR PBR ON PBR.PURCHTABLE = P.RECID
		LEFT JOIN SALESPURCHOPERATIONTYPE_BR OT ON OT.RECID = PBR.SALESPURCHOPERATIONTYPE_BR
		JOIN VENDTABLE V ON V.ACCOUNTNUM = NF.FISCALDOCUMENTACCOUNTNUM
		JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
		JOIN CFOPTABLE_BR CF ON CF.CFOPID = LNF.CFOP AND CF.DATAAREAID = LNF.DATAAREAID
		JOIN INVENTTABLE IT ON IT.ITEMID = LNF.ITEMID AND IT.DATAAREAID = LNF.DATAAREAID
		JOIN ECORESPRODUCT PR ON PR.RECID = IT.PRODUCT
		JOIN ECORESPRODUCTTRANSLATION T ON T.PRODUCT = PR.RECID
		JOIN LANGUAGETABLE L ON L.LANGUAGEID = T.LANGUAGEID
		JOIN CUSTTABLE CT ON 
				((V.CNPJCPFNUM_BR =	'' AND V.ACCOUNTNUM		= CT.VENDACCOUNT) -- Terceiros do Exterior
			OR	(V.CNPJCPFNUM_BR <> '' AND CT.CNPJCPFNUM_BR = V.CNPJCPFNUM_BR))
			AND V.DATAAREAID = CT.DATAAREAID
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 8) AS IIPI
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 1) AS IPIS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 2) AS IICMS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 15) AS IICMSDIF
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 3) AS ICOFINS
		CROSS APPLY WELO.ImpostoLinha (LNF.RECID, 4) AS IISSQN
		CROSS APPLY WELO.EncargoLinha (LNF.RECID) AS ENCARGO
		OUTER APPLY BiUtil.CategoriaDelav(P.RECID) AS CATEGORIA
		JOIN INVENTTABLEMODULE MODVENDA ON MODVENDA.ITEMID = IT.ITEMID AND MODVENDA.DATAAREAID = IT.DATAAREAID AND MODVENDA.MODULETYPE = 2 -- Venda
		JOIN INVENTTABLEMODULE MODESTOQUE ON MODESTOQUE.ITEMID = IT.ITEMID AND MODESTOQUE.DATAAREAID = IT.DATAAREAID AND MODESTOQUE.MODULETYPE = 0 -- Estoque
		JOIN LOGISTICSLOCATION LL ON LL.RECID = PT.PRIMARYADDRESSLOCATION
		JOIN LOGISTICSPOSTALADDRESS LPA ON LPA.LOCATION = LL.RECID AND CONVERT(DATE, GETDATE()) BETWEEN LPA.VALIDFROM AND LPA.VALIDTO
	WHERE 1=1 
		AND NF.STATUS = 1 
		AND NF.DIRECTION = 1
		AND LNF.DATAAREAID = 'DELA'
		AND OT.OPERATIONTYPEID IN ('E1201/2201', 'DV1201/2201', 'E201/202', 'E3201')
		AND OT.CREATEFINANCIALTRANS = 1 
) AS X

CROSS APPLY BI.DataFiltroAnoMes(X.FISCALDOCUMENTDATE) AS DATAFILTRO
OUTER APPLY BiUtil.FatorConversaoUnidades (UNIDADENF, UNIDADEESTOQUE, ECORESPRODUCTID)	AS ESTOQUE
OUTER APPLY BiUtil.FatorConversaoUnidades (UNIDADENF, UNIDADEVENDA, ECORESPRODUCTID)		AS COMPRA

UNION

SELECT * FROM DAX_WELOZE_HIST.[BiView].[ReceitaLiquida_HIST_Delav] 