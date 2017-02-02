
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
			WHEN 3 THEN 'Produção'
			WHEN 4 THEN 'Linha de Produção'
			WHEN 5 THEN 'Diário de Estoque'
			WHEN 6 THEN 'Cotação de Venda'
			WHEN 7 THEN 'Ordem de Transferência'
			WHEN 8 THEN 'Ativo Fixo'
	END AS Referencia
)
