
-- ALTER VIEW BiView.Contabilidade_OMT AS 

SELECT

	GJE.JOURNALNUMBER,
	GJE.SUBLEDGERVOUCHER,
	GJE.ACCOUNTINGDATE,
	GJAE.TEXT,
	GJAE.LEDGERACCOUNT,
	GJAE.TRANSACTIONCURRENCYAMOUNT,

	SUBSTRING(GJAE.LEDGERACCOUNT, 1, 10) AS ACCOUNT,
	SUBSTRING(GJAE.LEDGERACCOUNT, 12, 4) AS DIMENSAO1,
	CASE WHEN LEN(GJAE.LEDGERACCOUNT) < 37 
		THEN SUBSTRING(GJAE.LEDGERACCOUNT, 17, 2) 
		ELSE SUBSTRING(GJAE.LEDGERACCOUNT, 36, 2) 
	END AS DIMENSAO2,
	CASE WHEN LEN(GJAE.LEDGERACCOUNT) < 37 
		THEN SUBSTRING(GJAE.LEDGERACCOUNT, 20, 6) 
		ELSE SUBSTRING(GJAE.LEDGERACCOUNT, 29, 6) 
	END AS DIMENSAO3,
	CASE WHEN LEN(GJAE.LEDGERACCOUNT) < 37
		THEN SUBSTRING(GJAE.LEDGERACCOUNT, 27, 10) 
		ELSE SUBSTRING(GJAE.LEDGERACCOUNT, 18, 10) 
	END AS DIMENSAO4

FROM GENERALJOURNALENTRY GJE 
	JOIN GENERALJOURNALACCOUNTENTRY GJAE ON GJAE.GENERALJOURNALENTRY = GJE.RECID

WHERE GJE.SUBLEDGERVOUCHERDATAAREAID = 'OMT'