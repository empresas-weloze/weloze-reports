
ALTER FUNCTION [BiUtil].[TipoReferenciaRequisito] (@RefType INT)
RETURNS TABLE AS 

	RETURN 
	(
		SELECT BiUtil.Enum2Str('ReqRefType', @RefType) AS STATUS
	);

