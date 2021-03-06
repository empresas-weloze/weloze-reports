
ALTER FUNCTION BiUtil.EncargoLinhaOrdemVenda(@SalesLineRecId BIGINT)
RETURNS TABLE
AS 
RETURN 

	(SELECT COALESCE(SUM(VALUE), 0) AS VALOR FROM MARKUPTRANS M
		JOIN SALESLINE L ON M.TRANSTABLEID = 359 AND L.RECID = M.TRANSRECID AND M.DATAAREAID = L.DATAAREAID
	WHERE L.RECID = @SalesLineRecId);

