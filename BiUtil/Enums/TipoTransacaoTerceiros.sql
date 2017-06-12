
ALTER FUNCTION [BiUtil].[TipoTransacaoTerceiros] (@TransType INT)
RETURNS TABLE AS 

	RETURN 
	(
		SELECT CASE @TransType

			WHEN 1		THEN 'Envio'
			WHEN 2		THEN 'Retorno'
			WHEN 3		THEN 'Recebimento'
			WHEN 4		THEN 'Devolução'

		END AS TIPO

	);