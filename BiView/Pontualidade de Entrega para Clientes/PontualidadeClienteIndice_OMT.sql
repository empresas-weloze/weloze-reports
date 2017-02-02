
-- ALTER VIEW BiView.PontualidadeClienteIndice_OMT  AS

SELECT 

	AX.[Dt. Prometida (semana/ano)],
	AX.[Dt. Prometida (m�s/ano)], 
	AX.Cliente, AX.[Ordem de Venda], 
	AX.Linha, AX.[Item - Nome], 
	
	CASE WHEN AX.[Qtd. Entrega Pendente] = 0 THEN
		AVG(AX.[Pontualidade (corrigida)])
	ELSE
		SUM(AX.[Pontualidade (corrigida)])
	END AS "Pontualidade Ajustada", 

	CASE WHEN AX.[Qtd. Entrega Pendente] = 0 THEN
		(1 - AVG(AX.[Pontualidade (corrigida)])) * AX.[Valor L�quido]
	ELSE
		(1 - SUM(AX.[Pontualidade (corrigida)])) * AX.[Valor L�quido]
	END AS "Valor em Atraso", 

	AX.[Valor L�quido]

FROM BiView.PontualidadeCliente_OMT AX

GROUP BY AX.[Dt. Prometida (semana/ano)], AX.[Dt. Prometida (m�s/ano)], AX.Cliente, AX.[Ordem de Venda], AX.LinhA, AX.[Item - Nome], AX.[Valor L�quido], AX.[Qtd. Entrega Pendente]