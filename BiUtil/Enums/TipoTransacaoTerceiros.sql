
ALTER FUNCTION [BiUtil].[TipoTransacaoTerceiros] (@TransType INT)
RETURNS TABLE AS 

	RETURN 
	(
		SELECT BiUtil.Enum2Str('CTTE_InventTransferType', @TransType) AS TIPO

	);