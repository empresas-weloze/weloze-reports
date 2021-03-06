
-- ALTER VIEW biwelozew3.ext_wlz_vw_IDC WITH ENCRYPTION AS 

-- <2016>

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-01-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-01-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-02-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-02-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-03-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-03-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-04-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-04-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-05-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-05-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-06-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-06-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-07-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-07-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-08-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-08-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-09-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-09-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-10-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-10-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-11-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-11-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2016-12-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2016-12-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''


-- </ 2016>
-- <2017>

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-01-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-01-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-02-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-02-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-03-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-03-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-04-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-04-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-05-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-05-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-06-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-06-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-07-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-07-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-08-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-08-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-09-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-09-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-10-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-10-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-11-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-11-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''

UNION 

SELECT NOPRAZO.MES,
	NOPRAZO.ANO, 
	PT.ORGNUMBER AS FORNECEDOR, 
	CASE WHEN NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE = 0 
		THEN 1 * 100
		ELSE NOPRAZO.QUANTIDADE / (NOPRAZO.QUANTIDADE + EMATRASO.QUANTIDADE) * 100
	END AS IDC
FROM VENDTABLE V
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
	OUTER APPLY biwelozew3._faturasNoPrazo (V.ACCOUNTNUM, '2017-12-01') AS NOPRAZO
	OUTER APPLY biwelozew3._faturasEmAtraso (V.ACCOUNTNUM, '2017-12-01') AS EMATRASO
WHERE V.DATAAREAID = 'WELO'
	AND PT.ORGNUMBER <> ''
