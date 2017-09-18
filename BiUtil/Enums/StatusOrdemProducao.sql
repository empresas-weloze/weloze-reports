
ALTER FUNCTION BiUtil.StatusOrdemProducao (@StatusId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('ProdStatus', @StatusId) AS STATUS
)
