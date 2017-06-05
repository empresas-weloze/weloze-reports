
ALTER FUNCTION [BiUtil].[ProdJourType] (@TypeId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('ProdJourType', @TypeId) AS ProdJourType
)