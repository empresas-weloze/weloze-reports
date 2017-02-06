
-- ALTER VIEW biwelozew3.ext_wlz_vw_casos_AX WITH ENCRYPTION AS

SELECT RNC.INVENTNONCONFORMANCEID AS cdcaso, 
	RNC.NONCONFORMANCEDATE as dtcaso, 
	PROB.DESCRIPTION as dscaso, 
	(SELECT MAX(PRIORITY) FROM INVENTTESTCORRECTION COR WHERE COR.INVENTNONCONFORMANCEID = RNC.INVENTNONCONFORMANCEID AND COR.CORRECTIONCOMPLETED = 0) AS cdtipocaso,
	PT.ORGNUMBER AS cdfornecedor,
	V.ACCOUNTNUM AS codigofornecedorax,
	PT.NAME AS nmfornecedor
FROM INVENTNONCONFORMANCETABLE RNC
	JOIN INVENTPROBLEMTYPE PROB ON PROB.PROBLEMTYPEID = RNC.INVENTTESTPROBLEMTYPEID
	JOIN VENDTABLE V ON V.ACCOUNTNUM = RNC.VENDACCOUNT
	JOIN DIRPARTYTABLE PT ON PT.RECID = V.PARTY
WHERE 1=1
	AND RNC.INVENTNONCONFORMANCETYPE = 2 -- RNC de Fornecedor
	AND RNC.INVENTNONCONFORMANCEAPPROVAL = 1 -- Aprovada
	AND RNC.DATAAREAID = 'WELO'
	AND EXISTS (SELECT 1 FROM INVENTTESTCORRECTION  COR WHERE COR.INVENTNONCONFORMANCEID = RNC.INVENTNONCONFORMANCEID)
	AND PT.ORGNUMBER <> ''
	AND EXISTS (SELECT * FROM INVENTTESTCORRECTION COR WHERE COR.INVENTNONCONFORMANCEID = RNC.INVENTNONCONFORMANCEID AND COR.CORRECTIONCOMPLETED = 0)