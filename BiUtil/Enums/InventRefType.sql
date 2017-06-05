
ALTER FUNCTION [BiUtil].[InventRefType] (@TypeId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('InventRefType', @TypeId) AS InventRefType
)