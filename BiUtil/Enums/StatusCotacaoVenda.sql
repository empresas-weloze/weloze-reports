
CREATE FUNCTION [BiUtil].[StatusCotacaoVenda] (@StatusId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('SalesQuotationStatus', @StatusId) AS SalesQuotationStatus
)