
-- ALTER VIEW BiView.GruposImpostos AS

SELECT 

IT.DATAAREAID						AS "Empresa",
CONCAT(IT.ITEMID, ' - ', ERPT.NAME) AS "Item",
IT.TAXFISCALCLASSIFICATION_BR		AS "Classifica��o Fiscal",

ITMC.TAXITEMGROUPID AS "Grupo de Impostos (Compra)",
ITMV.TAXITEMGROUPID AS "Grupo de Impostos (Venda)",

IMGI.MODELGROUPID	AS "Grupo de Modelo do Item",

IIGI.ITEMGROUPID	AS "Grupo de Itens"

--* 

FROM INVENTTABLE IT
	JOIN ECORESPRODUCT ERP ON ERP.RECID = IT.PRODUCT
	JOIN ECORESPRODUCTTRANSLATION ERPT ON ERPT.PRODUCT = ERP.RECID AND ERPT.LANGUAGEID = 'PT-BR'
	JOIN INVENTTABLEMODULE ITMC ON ITMC.DATAAREAID = IT.DATAAREAID AND ITMC.ITEMID = IT.ITEMID AND ITMC.MODULETYPE = 1
	JOIN INVENTTABLEMODULE ITMV ON ITMV.DATAAREAID = IT.DATAAREAID AND ITMV.ITEMID = IT.ITEMID AND ITMV.MODULETYPE = 2
	JOIN INVENTMODELGROUPITEM IMGI ON IMGI.ITEMID = IT.ITEMID AND IMGI.ITEMDATAAREAID = IT.DATAAREAID
	JOIN INVENTITEMGROUPITEM IIGI ON IIGI.ITEMID = IT.ITEMID AND IIGI.ITEMDATAAREAID = IT.DATAAREAID