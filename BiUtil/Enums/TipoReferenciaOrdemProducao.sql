
ALTER FUNCTION [BiUtil].[TipoReferenciaOrdemProducao] (@InventRefType INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		CASE @InventRefType
			WHEN 0 THEN	'Nenhum' 
			WHEN 1 THEN	'Ordem de Venda' 
			WHEN 2 THEN 'Ordem de Compra' 
			WHEN 3 THEN 'Produ��o'
			WHEN 4 THEN 'Linha de Produ��o'
			WHEN 5 THEN 'Di�rio de Estoque'
			WHEN 6 THEN 'Cota��o de Venda'
			WHEN 7 THEN 'Ordem de Transfer�ncia'
			WHEN 8 THEN 'Ativo Fixo'
	END AS Referencia
)
