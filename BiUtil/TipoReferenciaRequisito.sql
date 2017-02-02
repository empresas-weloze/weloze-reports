
ALTER FUNCTION [BiUtil].[TipoReferenciaRequisito] (@RefType INT)
RETURNS TABLE AS 

	RETURN 
	(
		SELECT CASE @RefType

			WHEN 1		THEN 'Disponível'
			WHEN 8		THEN 'Ordem de Compra'
			WHEN 9		THEN 'Produção'
			WHEN 10		THEN 'Ordem de Venda'
			WHEN 12		THEN 'Linha de Produção'
			WHEN 14		THEN 'Estoque de Segurança'
			WHEN 21		THEN 'Previsão de Demanda'
			WHEN 31		THEN 'Produção Planejada'
			WHEN 32		THEN 'Linha de BOM'
			WHEN 33		THEN 'Ordens de Compra Planejadas'
			WHEN 37		THEN 'Ordem de Quarentena'
			WHEN 13		THEN 'Diário de Estoque'
			WHEN 15		THEN 'Transferência de Díário de Estoque'
			WHEN 16		THEN 'Remessa de Ordem de Transferência'
			WHEN 17		THEN 'Recebimento de Ordem de Transferência'
			WHEN 34		THEN 'Transferência Planejada'
			WHEN 35		THEN 'Necessidade de Transferência'
			WHEN 36		THEN 'Desatualizado'
			WHEN 38		THEN 'Cotação'
			WHEN 39		THEN 'Kanban'
			WHEN 40		THEN 'Linha Kanban'
			WHEN 41		THEN 'Kanban Planejado'
			WHEN 42		THEN 'Linha Kanban Planejada'
			WHEN 45		THEN 'Linha da Fórmula'
			WHEN 46		THEN 'Ordem de Lote Planejado'
			WHEN 47		THEN 'Lote Expirado'
			WHEN 49		THEN 'Co-produto de ordem de lote'
			WHEN 43		THEN 'Planejamento de Demanda Intercompanhia'
			WHEN 101	THEN 'Demonstrativo'
			WHEN 50		THEN 'Linha de Requisição'

		ELSE ''
		END AS STATUS
	);

