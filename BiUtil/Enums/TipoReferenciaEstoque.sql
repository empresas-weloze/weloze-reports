
ALTER FUNCTION [BiUtil].[TipoTransacaoEstoque] (@InventTransType INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('InventTransType ', @InventTransType) AS InventTransType 
)

GO


