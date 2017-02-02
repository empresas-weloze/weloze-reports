
ALTER FUNCTION [BiUtil].[TipoAcaoMrp] (@ActionType INT)
RETURNS TABLE AS 

	RETURN 
	(
		SELECT CASE @ActionType

			WHEN 1		THEN 'Adiantar'
			WHEN 2		THEN 'Adiar'
			WHEN 3		THEN 'Aumentar'
			WHEN 4		THEN 'Diminuir'
			WHEN 5		THEN 'Adiantar+Aumentar'
			WHEN 6		THEN 'Adiantar+Diminuir'
			WHEN 7		THEN 'Adiar+Aumentar'
			WHEN 8		THEN 'Adiar+Diminuir'
			WHEN 9		THEN 'Cancelar'

		ELSE ''
		END AS NOME
	);
