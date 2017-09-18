
ALTER FUNCTION BiUtil.StatusOrdemVenda (@StatusId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('SalesStatus', @StatusId) AS STATUS
)
