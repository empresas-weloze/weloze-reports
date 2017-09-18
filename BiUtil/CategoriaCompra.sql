
ALTER FUNCTION BiUtil.CategoriaCompra (@CFOP VARCHAR(5)) 
RETURNS TABLE AS
	RETURN 
	(
		SELECT CASE 
			WHEN @CFOP IN (
				'1.101', '1.111', '1.124', '1.125', '1.352', '1.401', '1.122', '1.922',
				'2.101', '2.111', '2.124', '2.125', '2.352', '2.401', '2.122', '2.922',
				'3.101', '3.102', '3.127',						
				'5.201', 
				'6.201'	
			) THEN 'Compras para Industrialização'
			ELSE 'Uso e Consumo / Outras Compras'
		END AS CATEGORIA
	)

