
ALTER FUNCTION [BiUtil].[TipoTransacaoContabil] (@LedgerTransType INTEGER)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		CASE @LedgerTransType
			WHEN 0 THEN	'' 
			WHEN 2 THEN	'Ordem de Venda' 
			WHEN 3 THEN 'Ordem de Compra'
			WHEN 4 THEN 'Estoque'
			WHEN 5 THEN 'Produ��o'
			WHEN 7 THEN	'Juros' 
			WHEN 8 THEN 'Cliente'
			WHEN 9 THEN	'Reavalia��o em Moeda Estrangeira' 
			WHEN 12 THEN 'Ativos Fixos'
			WHEN 14 THEN 'Fornecedores'
			WHEN 15 THEN 'Pagamento' 
			WHEN 16 THEN 'Imposto'
			WHEN 17 THEN 'Banco'
			WHEN 24 THEN 'Liquida��o' 
			WHEN 25 THEN 'Aloca��o'
			WHEN 27 THEN 'Desconto � vista' 
			WHEN 36 THEN 'Di�rio Geral' 
		END AS Tipo
)