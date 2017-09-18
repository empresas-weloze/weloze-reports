
ALTER FUNCTION [BiUtil].[TipoTransacaoContabil] (@LedgerTransType INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('LedgerTransType', @LedgerTransType) AS Tipo
)