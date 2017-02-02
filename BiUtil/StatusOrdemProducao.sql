
ALTER FUNCTION BiUtil.StatusOrdemProducao (@StatusId INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		CASE @StatusId
			WHEN 0 THEN	'Criado' 
			WHEN 1 THEN	'Previsto' 
			WHEN 2 THEN	'Programado' 
			WHEN 3 THEN	'Liberado' 
			WHEN 4 THEN	'Iniciado' 
			WHEN 5 THEN	'Informado como Concluído' 
			WHEN 7 THEN	'Concluído' 
		END AS STATUS
)
