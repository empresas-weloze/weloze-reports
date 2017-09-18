
ALTER FUNCTION [BiUtil].[TipoReferenciaOrdemProducao] (@InventRefType INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('InventRefType', @InventRefType) AS Referencia
)
