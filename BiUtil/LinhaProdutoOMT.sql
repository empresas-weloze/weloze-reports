
ALTER FUNCTION [BiUtil].[LinhaProdutoOMT] (@EcoResProductRecId BIGINT) 
RETURNS TABLE AS 

	RETURN (
		SELECT ERC.NAME AS LINHA FROM ECORESCATEGORYHIERARCHY ERCH
			JOIN ECORESCATEGORY ERC ON ERC.CATEGORYHIERARCHY = ERCH.RECID
			JOIN ECORESPRODUCTCATEGORY ERPC ON ERPC.CATEGORY = ERC.RECID
		WHERE ERCH.NAME = 'LINHA DE PRODUTO OMT' AND ERC.NAME <> 'LINHAS OMT'
			AND ERPC.PRODUCT = @EcoResProductRecId
	) 





