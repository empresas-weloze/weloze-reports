
ALTER FUNCTION [BiUtil].AssetTransTypeJournal (@TypeId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT BiUtil.Enum2Str('AssetTransTypeJournal', @TypeId) AS AssetTransTypeJournal
)