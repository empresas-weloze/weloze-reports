
ALTER FUNCTION [BiUtil].[TipoReferenciaRequisito] (@RefType INT)
RETURNS TABLE AS 

	RETURN 
	(
		SELECT CASE @RefType

			WHEN 1		THEN 'Dispon�vel'
			WHEN 8		THEN 'Ordem de Compra'
			WHEN 9		THEN 'Produ��o'
			WHEN 10		THEN 'Ordem de Venda'
			WHEN 12		THEN 'Linha de Produ��o'
			WHEN 14		THEN 'Estoque de Seguran�a'
			WHEN 21		THEN 'Previs�o de Demanda'
			WHEN 31		THEN 'Produ��o Planejada'
			WHEN 32		THEN 'Linha de BOM'
			WHEN 33		THEN 'Ordens de Compra Planejadas'
			WHEN 37		THEN 'Ordem de Quarentena'
			WHEN 13		THEN 'Di�rio de Estoque'
			WHEN 15		THEN 'Transfer�ncia de D��rio de Estoque'
			WHEN 16		THEN 'Remessa de Ordem de Transfer�ncia'
			WHEN 17		THEN 'Recebimento de Ordem de Transfer�ncia'
			WHEN 34		THEN 'Transfer�ncia Planejada'
			WHEN 35		THEN 'Necessidade de Transfer�ncia'
			WHEN 36		THEN 'Desatualizado'
			WHEN 38		THEN 'Cota��o'
			WHEN 39		THEN 'Kanban'
			WHEN 40		THEN 'Linha Kanban'
			WHEN 41		THEN 'Kanban Planejado'
			WHEN 42		THEN 'Linha Kanban Planejada'
			WHEN 45		THEN 'Linha da F�rmula'
			WHEN 46		THEN 'Ordem de Lote Planejado'
			WHEN 47		THEN 'Lote Expirado'
			WHEN 49		THEN 'Co-produto de ordem de lote'
			WHEN 43		THEN 'Planejamento de Demanda Intercompanhia'
			WHEN 101	THEN 'Demonstrativo'
			WHEN 50		THEN 'Linha de Requisi��o'

		ELSE ''
		END AS STATUS
	);

