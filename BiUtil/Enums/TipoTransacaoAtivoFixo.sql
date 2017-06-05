
ALTER FUNCTION [BiUtil].[TipoTransacaoAtivoFixo] (@StatusId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('AssetTransType', @StatusId) AS AssetTransType
)