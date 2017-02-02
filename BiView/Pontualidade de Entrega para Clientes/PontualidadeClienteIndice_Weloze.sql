
-- ALTER VIEW BiView.PontualidadeClienteIndice_Weloze  AS

SELECT 

	AX.[Dt. Prometida (semana/ano)],
	AX.[Dt. Prometida (mês/ano)], 
	AX.Cliente, AX.[Ordem de Venda], 
	AX.Linha, AX.[Item - Nome], 
	
	CASE WHEN AX.[Qtd. Entrega Pendente] = 0 THEN
		AVG(AX.[Pontualidade (corrigida)])
	ELSE
		SUM(AX.[Pontualidade (corrigida)])
	END AS "Pontualidade Ajustada", 

	CASE WHEN AX.[Qtd. Entrega Pendente] = 0 THEN
		(1 - AVG(AX.[Pontualidade (corrigida)])) * AX.[Valor Líquido]
	ELSE
		(1 - SUM(AX.[Pontualidade (corrigida)])) * AX.[Valor Líquido]
	END AS "Valor em Atraso", 

	AX.[Valor Líquido]

FROM BiView.PontualidadeCliente_Weloze AX

--WHERE AX.[Ordem de Venda] = 'OV-000518'

GROUP BY AX.[Dt. Prometida (semana/ano)], AX.[Dt. Prometida (mês/ano)], AX.Cliente, AX.[Ordem de Venda], AX.LinhA, AX.[Item - Nome], AX.[Valor Líquido], AX.[Qtd. Entrega Pendente]