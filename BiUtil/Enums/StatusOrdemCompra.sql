
ALTER FUNCTION BiUtil.StatusOrdemCompra (@StatusId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('PurchStatus', @StatusId) AS STATUS
)
