
ALTER FUNCTION [BiUtil].[TipoAcaoMrp] (@ActionType INT)
RETURNS TABLE AS 

	RETURN 
	(
		SELECT BiUtil.Enum2Str('ActionType', @ActionType) AS NOME
	);
