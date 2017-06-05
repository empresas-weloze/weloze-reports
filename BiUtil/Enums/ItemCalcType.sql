
ALTER FUNCTION [BiUtil].[ItemCalcType] (@TypeId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('ItemCalcType', @TypeId) AS ItemCalcType
)