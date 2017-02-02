
ALTER FUNCTION BiUtil.StatusOrdemCompra (@StatusId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		CASE @StatusId
			WHEN 0 THEN	'Nenhum' 
			WHEN 1 THEN	'Ordem em Aberto' 
			WHEN 2 THEN 'Entregue' 
			WHEN 3 THEN 'Faturada'
			WHEN 4 THEN 'Cancelada'
		END AS STATUS
)
