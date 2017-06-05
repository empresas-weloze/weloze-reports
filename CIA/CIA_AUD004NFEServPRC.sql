
ALTER PROCEDURE [dbo].[CIA_AUD004NFEServPRC]
		@EstabIni		varchar(3),
		@zxdataini		datetime,
		@zxdatafin		datetime,
		@EstabFim		varchar(3) = NULL        
		WITH ENCRYPTION        
AS

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @TableName varchar(120) SET @TableName = 'CIA_AUD003NFENTRADAVIEW'
	DECLARE @dataArea	varchar(4);
	DECLARE @sql		varchar(max);

	SET @dataArea = (	SELECT	TOP 1 
								DATAAREA 
						FROM	CIAESTABLISHMENTVIEW 
						WHERE	EXTESTABLISHMENTCODE = @EstabIni
						AND		EXTSOFTWARE = 0
					)
	
	SET @sql = 'SELECT	 isNull(FACODIGOEMPRESA,									dbo.ciaNullValue(''' + @tableName + ''',''FACODIGOEMPRESA''))							AS FACODIGOEMPRESA
						,isNull(FAEMITENTE,											dbo.ciaNullValue(''' + @tableName + ''',''FAEMITENTE''))								AS FAEMITENTE
						,CASE RIGHT(''00'' + CONVERT(VARCHAR,isNull(FAMODELODOCUMENTO,	dbo.ciaNullValue(''' + @tableName + ''',''FAMODELODOCUMENTO''))), 2)
							WHEN ''SE'' THEN ''50''
							ELSE RIGHT(''00'' + CONVERT(VARCHAR,isNull(FAMODELODOCUMENTO,	dbo.ciaNullValue(''' + @tableName + ''',''FAMODELODOCUMENTO''))), 2)
						 END 																																				AS FAMODELODOCUMENTO
						,CASE isNull(FATIPODOCUMENTO,								dbo.ciaNullValue(''' + @tableName + ''',''FATIPODOCUMENTO''))
							WHEN 0 THEN ''NFF''
							WHEN 1 THEN ''NF''
							WHEN 2 THEN ''CTRC''
							WHEN 4 THEN ''NFSE''
							WHEN 5 THEN ''NFFSE''
							ELSE		''NF''
						 END																																	AS FATIPODOCUMENTO
						,CASE
							WHEN isNull(FASERIEDOCUMENTO,							dbo.ciaNullValue(''' + @tableName + ''',''FASERIEDOCUMENTO'')) = ''''
								THEN '' ''
							ELSE FASERIEDOCUMENTO
						 END																																	AS FASERIEDOCUMENTO
						,dbo.ciaAsciiNumbers(isNull(FANUMERODOCUMENTO,				dbo.ciaNullValue(''' + @tableName + ''',''FANUMERODOCUMENTO'')))			AS FANUMERODOCUMENTO
						,CASE 
							WHEN FASITUACAODOC = 5 
								THEN '''' 
							ELSE 
								isNull(FANFECHAVE,	dbo.ciaNullValue(''' + @tableName + ''',''FANFECHAVE'')) 
						 END																																	AS FANFECHAVE
						,''''																																	AS FAHORASAIDA
						,isNull(FAUFEMITENTE,										dbo.ciaNullValue(''' + @tableName + ''',''FAUFEMITENTE''))					AS FAUFEMITENTE
						,isNull(FASITUACAODOC,										dbo.ciaNullValue(''' + @tableName + ''',''FASITUACAODOC''))					AS FASITUACAODOC
						,CASE isNull(FAINDCANCELAMENTO,				dbo.ciaNullValue(''' + @tableName + ''',''FAINDCANCELAMENTO''))
							WHEN 2 THEN ''S''	-- Cancelado
							WHEN 4 THEN ''S''	-- Negado/NF-e Denegado
							WHEN 5 THEN ''S''	-- Descartado
						 ELSE ''''	
						 END																																	AS FAINDCANCELAMENTO' + CHAR(13)
	SET @sql +='		,isNull(FANOTACOMPLEM,										dbo.ciaNullValue(''' + @tableName + ''',''FANOTACOMPLEM''))					AS FANOTACOMPLEM
						,0																																		AS FACONSUMIDOR
						,FACONTRIBUINTE																															AS FACONTRIBUINTE
						,isNull(FANUMERODECLARACAOIMPORTACAO,						dbo.ciaNullValue(''' + @tableName + ''',''FANUMERODECLARACAOIMPORTACAO''))	AS FANUMERODECLARACAOIMPORTACAO
						,''''																																	AS FANSU
						,''''																																	AS FANSEGURANCA
						,''''																																	AS FASUFRAMA
						,''''																																	AS FAAUTENTICACAO
						,''''																																	AS FAREFERENCIAGNRE
						,FATIPOFATURA																															AS FATIPOFATURA
						,isNull(FAINSCRICAOSUBSTITUTO,								dbo.ciaNullValue(''' + @tableName + ''',''FAINSCRICAOSUBSTITUTO''))			AS FAINSCRICAOSUBSTITUTO
						,isNull(FAVIATRANSPORTE,									dbo.ciaNullValue(''' + @tableName + ''',''FAVIATRANSPORTE''))				AS FAVIATRANSPORTE
						,isNull(FAMODALIDADEFRETE,									dbo.ciaNullValue(''' + @tableName + ''',''FAMODALIDADEFRETE''))				AS FAMODALIDADEFRETE
						,isNull(FAQTDEVOLUMES,										dbo.ciaNullValue(''' + @tableName + ''',''FAQTDEVOLUMES''))					AS FAQTDEVOLUMES
						,isNull(FAESPECIEVOLUMES,									dbo.ciaNullValue(''' + @tableName + ''',''FAESPECIEVOLUMES''))				AS FAESPECIEVOLUMES
						,''''																																	AS FAMARCAVOLUMES
						,''''																																	AS FANUMERACAOVOLUMES
						,isNull(FAIDENTIFICACAOVEICULO,								dbo.ciaNullValue(''' + @tableName + ''',''FAIDENTIFICACAOVEICULO''))		AS FAIDENTIFICACAOVEICULO
						,isNull(FAUFPLACA,											dbo.ciaNullValue(''' + @tableName + ''',''FAUFPLACA''))						AS FAUFPLACA
						,''''																																	AS FANUMEROLACRE' + CHAR(13)
	SET @sql +='		,isNull(FACODRETENCAO,										dbo.ciaNullValue(''' + @tableName + ''',''FACODRETENCAO''))					AS FACODRETENCAO
						,''''																																	AS FAOBSERVACAO
						,''''																																	AS FAOBSICM
						,''''																																	AS FAOBSCOMPLEMENTAR
						,''''																																	AS FAOBSFISCAL
						,''''																																	AS FAINFCOMPLEMENTAR
						,''''																																	AS FAAIDF
						,cast(isNull(FATIPONOTA,									dbo.ciaNullValue(''' + @tableName + ''',''FATIPONOTA'')) as char(1))		AS FATIPONOTA
						,''''																																	AS FANOTASIMPLIFICADA
						,isNull(FALANCAMENTO,										dbo.ciaNullValue(''' + @tableName + ''',''FALANCAMENTO''))					AS FALANCAMENTO
						,''''																																	AS FAINDCOMPLEMENTOICM
						,isNull(ITNUMEROITEM,										dbo.ciaNullValue(''' + @tableName + ''',''ITNUMEROITEM''))					AS ITNUMEROITEM
						,isNull(ITSERVICO,											dbo.ciaNullValue(''' + @tableName + ''',''ITSERVICO''))						AS ITSERVICO
						,isNull(ITCODIGOPRODUTO,									dbo.ciaNullValue(''' + @tableName + ''',''ITCODIGOPRODUTO''))				AS ITCODIGOPRODUTO
						,''''																																	AS ITDESCRCOMPLEMENTAR
						,isNull(REPLACE(ITCFOP,''.'',''''),							dbo.ciaNullValue(''' + @tableName + ''',''ITCFOP''))						AS ITCFOP
						,''''																																	AS ITCFOPCOMPLEMENTAR
						,isNull(ITCLASSIFICACAOFISCAL,								dbo.ciaNullValue(''' + @tableName + ''',''ITCLASSIFICACAOFISCAL''))			AS ITCLASSIFICACAOFISCAL
						,''''																																	AS ITEXIMPORTACAO
						,isNull(ITSITUACAOTRIBUTARIAFEDERAL,						dbo.ciaNullValue(''' + @tableName + ''',''ITSITUACAOTRIBUTARIAFEDERAL''))	AS ITSITUACAOTRIBUTARIAFEDERAL' + CHAR(13)
	SET @sql +='		,isNull(ITSITUACAOTRIBUTARIAESTADUAL,						dbo.ciaNullValue(''' + @tableName + ''',''ITSITUACAOTRIBUTARIAESTADUAL''))	AS ITSITUACAOTRIBUTARIAESTADUAL
						,isNull(ITUNIDADEMEDIDA,									dbo.ciaNullValue(''' + @tableName + ''',''ITUNIDADEMEDIDA''))				AS ITUNIDADEMEDIDA
						--***********************************************************************************************************************************************
						-- OS VALORES DE AMBOS OS CAMPOS SERÃO DEIXADOS COM O VALOR ''N'' POR HORA. NECESSITA-SE DE DEFINIÇÕES FUNCIONAIS
						--***********************************************************************************************************************************************
						/*
						,CASE
							WHEN isNull(ITINDMOVIMENTACAO,							dbo.ciaNullValue(''' + @tableName + ''',''ITINDMOVIMENTACAO'')) = 1 THEN ''S''
							ELSE ''N''
						END																																		AS ITINDMOVIMENTACAO
						,CASE
							WHEN isNull(ITMOVIMENTACAOESTOQUE,						dbo.ciaNullValue(''' + @tableName + ''',''ITMOVIMENTACAOESTOQUE'')) = 1 THEN ''S''
							ELSE ''N''
						END																																		AS ITMOVIMENTACAOESTOQUE
						*/
						,''N''																																	AS ITINDMOVIMENTACAO
						,''N''																																	AS ITMOVIMENTACAOESTOQUE
						--***********************************************************************************************************************************************
						,isNull(ITTIPOICMIMPORT,									dbo.ciaNullValue(''' + @tableName + ''',''ITTIPOICMIMPORT''))				AS ITTIPOICMIMPORT
						,isNull(ITCREDITOSUSPENSO,									dbo.ciaNullValue(''' + @tableName + ''',''ITCREDITOSUSPENSO''))				AS ITCREDITOSUSPENSO' + CHAR(13)
	SET @sql +='		,isNull(ITTIPORELAT,										dbo.ciaNullValue(''' + @tableName + ''',''ITTIPORELAT''))					AS ITTIPORELAT
						,isNull(ITFORMACALCULOIPI,									dbo.ciaNullValue(''' + @tableName + ''',''ITFORMACALCULOIPI''))				AS ITFORMACALCULOIPI
						,isNull(ITENQUADRAIPI,										dbo.ciaNullValue(''' + @tableName + ''',''ITENQUADRAIPI''))					AS ITENQUADRAIPI
						,isNull(ITCODRETENCAO,										dbo.ciaNullValue(''' + @tableName + ''',''ITCODRETENCAO''))					AS ITCODRETENCAO
						,isNull(ITCODIGODES,										dbo.ciaNullValue(''' + @tableName + ''',''ITCODIGODES''))					AS ITCODIGODES
						,isNull(ITCFPS,												dbo.ciaNullValue(''' + @tableName + ''',''ITCFPS''))						AS ITCFPS
						,isNull(ITFORMACALCULOPIS,									dbo.ciaNullValue(''' + @tableName + ''',''ITFORMACALCULOPIS''))				AS ITFORMACALCULOPIS
						,isNull(ITSITTRIBPIS,										dbo.ciaNullValue(''' + @tableName + ''',''ITSITTRIBPIS''))					AS ITSITTRIBPIS
						,isNull(ITFORMACALCULOCOFINS,								dbo.ciaNullValue(''' + @tableName + ''',''ITFORMACALCULOCOFINS''))			AS ITFORMACALCULOCOFINS
						,isNull(ITSITTRIBCOFINS,									dbo.ciaNullValue(''' + @tableName + ''',''ITSITTRIBCOFINS''))				AS ITSITTRIBCOFINS
						,isNull(ITVALOROUTROICM,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALOROUTROICM''))				AS ITVALOROUTROICM
						,isNull(ITINDCOMPLEMENTOICM,								dbo.ciaNullValue(''' + @tableName + ''',''ITINDCOMPLEMENTOICM''))			AS ITINDCOMPLEMENTOICM
						,''AX.CIA.''+DATAAREA																													AS ORIGEMDADOS
						,isNull(FADATAEMISSAO,										dbo.ciaNullValue(''' + @tableName + ''',''FADATAEMISSAO''))					AS FADATAEMISSAO
						,''''																																	AS FAVENCIMENTOGNRE
						,''''																																	AS FAVALORGNRE
						,isNull(FAVALORDESCONTO,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALORDESCONTO''))				AS FAVALORDESCONTO
						,isNull(FADESCONTONAOTRIBUT,								dbo.ciaNullValue(''' + @tableName + ''',''FADESCONTONAOTRIBUT''))			AS FADESCONTONAOTRIBUT
						,isNull(FATOTALICM,											dbo.ciaNullValue(''' + @tableName + ''',''FATOTALICM''))					AS FATOTALICM
						,isNull(FAVALORBASEREDUCAOIPI,								dbo.ciaNullValue(''' + @tableName + ''',''FAVALORBASEREDUCAOIPI''))			AS FAVALORBASEREDUCAOIPI' + CHAR(13)
	SET @sql +='		,isNull(FAVALORIPI,											dbo.ciaNullValue(''' + @tableName + ''',''FAVALORIPI''))					AS FAVALORIPI
						,isNull(FAICMNAOCREDITADO,									dbo.ciaNullValue(''' + @tableName + ''',''FAICMNAOCREDITADO''))				AS FAICMNAOCREDITADO
						,isNull(FAIPINAOCREDITADO,									dbo.ciaNullValue(''' + @tableName + ''',''FAIPINAOCREDITADO''))				AS FAIPINAOCREDITADO 
						,isNull(FATOTALBASESUBST,									dbo.ciaNullValue(''' + @tableName + ''',''FATOTALBASESUBST''))				AS FATOTALBASESUBST 
						,isNull(FATOTALICMSUBST,									dbo.ciaNullValue(''' + @tableName + ''',''FATOTALICMSUBST''))				AS FATOTALICMSUBST 
						,ABS(isNull(FAVALORFRETE,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALORFRETE'')))					AS FAVALORFRETE 
						,ABS(isNull(FAVALORSEGURO,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALORSEGURO'')))				AS FAVALORSEGURO 
						,ABS(isNull(FAVALOROUTRAS,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALOROUTRAS'')))				AS FAVALOROUTRAS 
						,isNull(FAPESOBRUTO,										dbo.ciaNullValue(''' + @tableName + ''',''FAPESOBRUTO''))					AS FAPESOBRUTO 
						,isNull(FAPESOLIQUIDO,										dbo.ciaNullValue(''' + @tableName + ''',''FAPESOLIQUIDO''))					AS FAPESOLIQUIDO 
						,isNull(FAALIQUOTAIRRF,										dbo.ciaNullValue(''' + @tableName + ''',''FAALIQUOTAIRRF''))				AS FAALIQUOTAIRRF 
						,isNull(FAVALORBASEIRRF,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALORBASEIRRF''))				AS FAVALORBASEIRRF 
						,isNull(FAVALORIRRF,										dbo.ciaNullValue(''' + @tableName + ''',''FAVALORIRRF''))					AS FAVALORIRRF 
						,isNull(FADATARETIRRF,										dbo.ciaNullValue(''' + @tableName + ''',''FADATARETIRRF''))					AS FADATARETIRRF 
						,isNull(FABASEISSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FABASEISSRETIDO''))				AS FABASEISSRETIDO 
						,isNull(FAALIQISSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FAALIQISSRETIDO''))				AS FAALIQISSRETIDO 
						,isNull(FAVALORISSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALORISSRETIDO''))				AS FAVALORISSRETIDO 
						,isNull(FABASEPISRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FABASEPISRETIDO''))				AS FABASEPISRETIDO 
						,isNull(FAALIQPISRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FAALIQPISRETIDO''))				AS FAALIQPISRETIDO 
						,isNull(FAVALORPISRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALORPISRETIDO''))				AS FAVALORPISRETIDO' + CHAR(13) 
	SET @sql +='		,isNull(FABASECOFINSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FABASECOFINSRETIDO''))			AS FABASECOFINSRETIDO 
						,isNull(FAALIQCOFINSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FAALIQCOFINSRETIDO''))			AS FAALIQCOFINSRETIDO 
						,isNull(FAVALORCOFINSRETIDO,								dbo.ciaNullValue(''' + @tableName + ''',''FAVALORCOFINSRETIDO''))			AS FAVALORCOFINSRETIDO 
						,isNull(FABASECSLLRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FABASECSLLRETIDO''))				AS FABASECSLLRETIDO 
						,isNull(FAALIQCSLLRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FAALIQCSLLRETIDO''))				AS FAALIQCSLLRETIDO 
						,isNull(FAVALORCSLLRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALORCSLLRETIDO''))				AS FAVALORCSLLRETIDO 
						,isNull(FABASECALCULOINSS,									dbo.ciaNullValue(''' + @tableName + ''',''FABASECALCULOINSS''))				AS FABASECALCULOINSS 
						,isNull(FAALIQINSSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''FAALIQINSSRETIDO''))				AS FAALIQINSSRETIDO 
						,isNull(FAVALORINSS,										dbo.ciaNullValue(''' + @tableName + ''',''FAVALORINSS''))					AS FAVALORINSS 
						,isNull(FADATARETINSS,										dbo.ciaNullValue(''' + @tableName + ''',''FADATARETINSS''))					AS FADATARETINSS 
						,isNull(FABASEISS,											dbo.ciaNullValue(''' + @tableName + ''',''FABASEISS''))						AS FABASEISS 
						,isNull(FAVALORISS,											dbo.ciaNullValue(''' + @tableName + ''',''FAVALORISS''))					AS FAVALORISS 
						,isNull(FADATARETENCAO,										dbo.ciaNullValue(''' + @tableName + ''',''FADATARETENCAO''))				AS FADATARETENCAO 
						,isNull(FADATAISS,											dbo.ciaNullValue(''' + @tableName + ''',''FADATAISS''))						AS FADATAISS 
						,isNull(FABASEPIS,											dbo.ciaNullValue(''' + @tableName + ''',''FABASEPIS''))						AS FABASEPIS 
						,isNull(FAVALORPIS,											dbo.ciaNullValue(''' + @tableName + ''',''FAVALORPIS''))					AS FAVALORPIS 
						,isNull(FABASEPISST,										dbo.ciaNullValue(''' + @tableName + ''',''FABASEPISST''))					AS FABASEPISST 
						,isNull(FAVALORPISST,										dbo.ciaNullValue(''' + @tableName + ''',''FAVALORPISST''))					AS FAVALORPISST 
						,isNull(FABASECOFINS,										dbo.ciaNullValue(''' + @tableName + ''',''FABASECOFINS''))					AS FABASECOFINS 
						,isNull(FAVALORCOFINS,										dbo.ciaNullValue(''' + @tableName + ''',''FAVALORCOFINS''))					AS FAVALORCOFINS' + CHAR(13) 
	SET @sql +='		,isNull(FABASECOFINSST,										dbo.ciaNullValue(''' + @tableName + ''',''FABASECOFINSST''))				AS FABASECOFINSST 
						,isNull(FAVALORCOFINSST,									dbo.ciaNullValue(''' + @tableName + ''',''FAVALORCOFINSST''))				AS FAVALORCOFINSST 
						,''''																																	AS FACOMPLEMENTOICM 
						,isNull(ITMATERIALPROPRIO,									dbo.ciaNullValue(''' + @tableName + ''',''ITMATERIALPROPRIO''))				AS ITMATERIALPROPRIO 
						,isNull(ITMATERIALTERCEIROS,								dbo.ciaNullValue(''' + @tableName + ''',''ITMATERIALTERCEIROS''))			AS ITMATERIALTERCEIROS
						,isNull(ITVALORDESCONTO,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORDESCONTO''))				AS ITVALORDESCONTO 
						,isNull(ITDESCONTONAOTRIBUT,								dbo.ciaNullValue(''' + @tableName + ''',''ITDESCONTONAOTRIBUT''))			AS ITDESCONTONAOTRIBUT 
						,ABS(isNull(ITVALORDESPESAFRETE,							dbo.ciaNullValue(''' + @tableName + ''',''ITVALORDESPESAFRETE'')))			AS ITVALORDESPESAFRETE
						,ABS(isNull(ITVALORDESPESASEGURO,							dbo.ciaNullValue(''' + @tableName + ''',''ITVALORDESPESASEGURO'')))			AS ITVALORDESPESASEGURO 
						,ABS(isNull(ITVALOROUTRASDESPESAS,							dbo.ciaNullValue(''' + @tableName + ''',''ITVALOROUTRASDESPESAS'')))		AS ITVALOROUTRASDESPESAS 
						,isNull(ITVALORBASEICM,										dbo.ciaNullValue(''' + @tableName + ''',''ITVALORBASEICM''))				AS ITVALORBASEICM 
						,isNull(ITALIQUOTAICM,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTAICM''))					AS ITALIQUOTAICM
						,isNull(ITVALORICM,											dbo.ciaNullValue(''' + @tableName + ''',''ITVALORICM''))					AS ITVALORICM 
						,isNull(ITVALORISENTOICM,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORISENTOICM''))				AS ITVALORISENTOICM 
						,isNull(ITVALORBASEENTRADA,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORBASEENTRADA''))			AS ITVALORBASEENTRADA 
						,isNull(ITALIQUOTAENTRADA,									dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTAENTRADA''))				AS ITALIQUOTAENTRADA 
						,isNull(ITICMNAOCREDITADO,									dbo.ciaNullValue(''' + @tableName + ''',''ITICMNAOCREDITADO''))				AS ITICMNAOCREDITADO 
						,isNull(ITVALORBASEDIFALIQUOTA,								dbo.ciaNullValue(''' + @tableName + ''',''ITVALORBASEDIFALIQUOTA''))		AS ITVALORBASEDIFALIQUOTA 
						,isNull(ITALIQUOTAINTERNA,									dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTAINTERNA''))				AS ITALIQUOTAINTERNA 
						,isNull(ITDIFERENCAALIQUOTA,								dbo.ciaNullValue(''' + @tableName + ''',''ITDIFERENCAALIQUOTA''))			AS ITDIFERENCAALIQUOTA' + CHAR(13) 
	SET @sql +='		,isNull(ITICMSRETIDO,										dbo.ciaNullValue(''' + @tableName + ''',''ITICMSRETIDO''))					AS ITICMSRETIDO 
						,isNull(ITVALORBASEDIFALIQUOTA,								dbo.ciaNullValue(''' + @tableName + ''',''ITVALORBASEDIFALIQUOTA''))		AS ITVALORBASEDIFALIQUOTA 
						,isNull(ITVALORBASESUBSTITUICAO,							dbo.ciaNullValue(''' + @tableName + ''',''ITVALORBASESUBSTITUICAO''))		AS ITVALORBASESUBSTITUICAO
						,isNull(ITALIQUOTASUBSTITUICAO,								dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTASUBSTITUICAO''))		AS ITALIQUOTASUBSTITUICAO 
						,isNull(ITVALORICMSUBSTITUICAO,								dbo.ciaNullValue(''' + @tableName + ''',''ITVALORICMSUBSTITUICAO''))		AS ITVALORICMSUBSTITUICAO 
						,isNull(ITBASEICMSTNAOCRED,									dbo.ciaNullValue(''' + @tableName + ''',''ITBASEICMSTNAOCRED''))			AS ITBASEICMSTNAOCRED 
						,isNull(ITVALORICMSTNAOCRED,								dbo.ciaNullValue(''' + @tableName + ''',''ITVALORICMSTNAOCRED''))			AS ITVALORICMSTNAOCRED 
						,isNull(ITMVA,												dbo.ciaNullValue(''' + @tableName + ''',''ITMVA''))							AS ITMVA 
						,isNull(ITVALORBASEIPI,										dbo.ciaNullValue(''' + @tableName + ''',''ITVALORBASEIPI''))				AS ITVALORBASEIPI
						,isNull(ITALIQUOTAIPI,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTAIPI''))					AS ITALIQUOTAIPI 
						,isNull(ITVALORIPI,											dbo.ciaNullValue(''' + @tableName + ''',''ITVALORIPI''))					AS ITVALORIPI 
						,isNull(ITVALORISENTOIPI,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORISENTOIPI''))				AS ITVALORISENTOIPI 
						,isNull(ITVALOROUTROIPI,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALOROUTROIPI''))				AS ITVALOROUTROIPI 
						,isNull(ITIPINAOCREDITADO,									dbo.ciaNullValue(''' + @tableName + ''',''ITIPINAOCREDITADO''))				AS ITIPINAOCREDITADO 
						,isNull(ITQTDEBCIPI,										dbo.ciaNullValue(''' + @tableName + ''',''ITQTDEBCIPI''))					AS ITQTDEBCIPI 
						,isNull(ITALIQIPIREAIS,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQIPIREAIS''))				AS ITALIQIPIREAIS 
						,isNull(ITVALORSERVICO,										dbo.ciaNullValue(''' + @tableName + ''',''ITVALORSERVICO''))				AS ITVALORSERVICO 
						,isNull(ITVALORBASEIRRF,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORBASEIRRF''))				AS ITVALORBASEIRRF 
						,isNull(ITALIQUOTAIRRF,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTAIRRF''))				AS ITALIQUOTAIRRF 
						,isNull(ITVALORIRRF,										dbo.ciaNullValue(''' + @tableName + ''',''ITVALORIRRF''))					AS ITVALORIRRF' + CHAR(13) 
	SET @sql +='		,isNull(ITBASEISSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITBASEISSRETIDO''))				AS ITBASEISSRETIDO 
						,isNull(ITALIQISSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITALIQISSRETIDO''))				AS ITALIQISSRETIDO 
						,isNull(ITVALORISSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORISSRETIDO''))				AS ITVALORISSRETIDO 
						,isNull(ITBASEPISRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITBASEPISRETIDO''))				AS ITBASEPISRETIDO 
						,isNull(ITALIQUOTAPISRETIDO,								dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTAPISRETIDO''))			AS ITALIQUOTAPISRETIDO 
						,isNull(ITVALORPISRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORPISRETIDO''))				AS ITVALORPISRETIDO 
						,isNull(ITBASECOFINSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITBASECOFINSRETIDO''))			AS ITBASECOFINSRETIDO 
						,isNull(ITALIQUOTACOFINSRETIDO,								dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTACOFINSRETIDO''))		AS ITALIQUOTACOFINSRETIDO 
						,isNull(ITVALORCOFINSRETIDO,								dbo.ciaNullValue(''' + @tableName + ''',''ITVALORCOFINSRETIDO''))			AS ITVALORCOFINSRETIDO 
						,isNull(ITBASECSLLRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITBASECSLLRETIDO''))				AS ITBASECSLLRETIDO 
						,isNull(ITALIQUOTACSLLRETIDO,								dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTACSLLRETIDO''))			AS ITALIQUOTACSLLRETIDO 
						,isNull(ITVALORCSLLRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORCSLLRETIDO''))				AS ITVALORCSLLRETIDO 
						,isNull(ITBASECALCULOINSS,									dbo.ciaNullValue(''' + @tableName + ''',''ITBASECALCULOINSS''))				AS ITBASECALCULOINSS 
						,isNull(ITALIQINSSRETIDO,									dbo.ciaNullValue(''' + @tableName + ''',''ITALIQINSSRETIDO''))				AS ITALIQINSSRETIDO 
						,isNull(ITVALORINSS,										dbo.ciaNullValue(''' + @tableName + ''',''ITVALORINSS''))					AS ITVALORINSS 
						,isNull(ITVALORBASEISS,										dbo.ciaNullValue(''' + @tableName + ''',''ITVALORBASEISS''))				AS ITVALORBASEISS 
						,isNull(ITALIQUOTAISS,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTAISS''))					AS ITALIQUOTAISS 
						,isNull(ITVALORISS,											dbo.ciaNullValue(''' + @tableName + ''',''ITVALORISS''))					AS ITVALORISS 
						,isNull(ITBASEPIS,											dbo.ciaNullValue(''' + @tableName + ''',''ITBASEPIS''))						AS ITBASEPIS 
						,isNull(ITALIQUOTAPIS,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTAPIS''))					AS ITALIQUOTAPIS' + CHAR(13) 
	SET @sql +='		,isNull(ITVALORPIS,											dbo.ciaNullValue(''' + @tableName + ''',''ITVALORPIS''))					AS ITVALORPIS 
						,isNull(ITBASEPISST,										dbo.ciaNullValue(''' + @tableName + ''',''ITBASEPISST''))					AS ITBASEPISST 
						,isNull(ITALIQPISST,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQPISST''))					AS ITALIQPISST 
						,isNull(ITVALORPISST,										dbo.ciaNullValue(''' + @tableName + ''',''ITVALORPISST''))					AS ITVALORPISST 
						,isNull(ITALIQPISREAIS,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQPISREAIS''))				AS ITALIQPISREAIS 
						,isNull(ITQTDEBCPIS,										dbo.ciaNullValue(''' + @tableName + ''',''ITQTDEBCPIS''))					AS ITQTDEBCPIS 
						,isNull(ITBASECOFINS,										dbo.ciaNullValue(''' + @tableName + ''',''ITBASECOFINS''))					AS ITBASECOFINS 
						,isNull(ITALIQUOTACOFINS,									dbo.ciaNullValue(''' + @tableName + ''',''ITALIQUOTACOFINS''))				AS ITALIQUOTACOFINS 
						,isNull(ITVALORCOFINS,										dbo.ciaNullValue(''' + @tableName + ''',''ITVALORCOFINS''))					AS ITVALORCOFINS 
						,isNull(ITBASECOFINSST,										dbo.ciaNullValue(''' + @tableName + ''',''ITBASECOFINSST''))				AS ITBASECOFINSST 
						,isNull(ITALIQCOFINSST,										dbo.ciaNullValue(''' + @tableName + ''',''ITALIQCOFINSST''))				AS ITALIQCOFINSST 
						,isNull(ITVALORCOFINSST,									dbo.ciaNullValue(''' + @tableName + ''',''ITVALORCOFINSST''))				AS ITVALORCOFINSST 
						,isNull(ITALIQCOFINSREAIS,									dbo.ciaNullValue(''' + @tableName + ''',''ITALIQCOFINSREAIS''))				AS ITALIQCOFINSREAIS 
						,isNull(ITQTDEBCCOFINS,										dbo.ciaNullValue(''' + @tableName + ''',''ITQTDEBCCOFINS''))				AS ITQTDEBCCOFINS 
						,isNull(ITCOMPLEMENTOICM,									dbo.ciaNullValue(''' + @tableName + ''',''ITCOMPLEMENTOICM''))				AS ITCOMPLEMENTOICM 
						,isNull(ITINDTRIBUTACAOICM,									dbo.ciaNullValue(''' + @tableName + ''',''ITINDTRIBUTACAOICM''))			AS ITINDTRIBUTACAOICM
						,isNull(ITINDTRIBUTACAOIPI,									dbo.ciaNullValue(''' + @tableName + ''',''ITINDTRIBUTACAOIPI''))			AS ITINDTRIBUTACAOIPI	
						,isNull(FAMATERIALPROPRIO,									dbo.ciaNullValue(''' + @tableName + ''',''FAMATERIALPROPRIO''))				AS ZZMATERIALPROPRIO
						,isNull(FAMATERIALTERCEIROS,								dbo.ciaNullValue(''' + @tableName + ''',''FAMATERIALTERCEIROS''))			AS ZZMATERIALTERCEIROS
						,isNull(ITUNIDADEMEDIDA,									dbo.ciaNullValue(''' + @tableName + ''',''ITUNIDADEMEDIDA''))				AS ITUNIDADEPADRAO' + CHAR(13)			-- NAO CONSTA EM LAYOUT, POREM IGUAL A INFORMACAO JA MAPEADA
	SET @sql +='		,isNull(FABASEICMS,											dbo.ciaNullValue(''' + @tableName + ''',''FABASEICMS''))					AS FABASEICM
						,isNull(FADATAEMISSAO,										dbo.ciaNullValue(''' + @tableName + ''',''FADATAEMISSAO''))					AS FADATAEMISSAOORIGINAL
						,isNull(FADATAENTRADA,										dbo.ciaNullValue(''' + @tableName + ''',''FADATAENTRADA''))					AS FADATAENTRADA
						,isNull(ABS(FATOTALNFISCAL),								dbo.ciaNullValue(''' + @tableName + ''',''FATOTALNFISCAL''))				AS ITVALORTOTALDOCUMENTO	-- NAO CONSTA EM LAYOUT, POREM IGUAL A INFORMACAO JA MAPEADA
						,isNull(ABS(FATOTALNFISCAL),								dbo.ciaNullValue(''' + @tableName + ''',''FATOTALNFISCAL''))				AS FAVALORTOTALNFISCAL
						,isNull(ABS(ITQTDEPRODUTO),									dbo.ciaNullValue(''' + @tableName + ''',''ITQTDEPRODUTO''))					AS ITQTDEPRODUTO		
						,isNull(ABS(ITVALORUNITARIO),								dbo.ciaNullValue(''' + @tableName + ''',''ITVALORUNITARIO''))				AS ITVALORUNITARIO 
						,isNull(ABS(ITPRECOTOTAL),									dbo.ciaNullValue(''' + @tableName + ''',''ITPRECOTOTAL''))					AS ITPRECOTOTAL 
						,isNull(ABS(ITVALORCONTABILICM),							dbo.ciaNullValue(''' + @tableName + ''',''ITVALORCONTABILICM''))			AS ITVALORCONTABILICM
						,isNull(ABS(FAVALORTOTALPRODUTOS),							dbo.ciaNullValue(''' + @tableName + ''',''FAVALORTOTALPRODUTOS''))			AS FAVALORTOTALPRODUTOS
						,isNull(ABS(FAVALORSERVICOS),								dbo.ciaNullValue(''' + @tableName + ''',''FAVALORSERVICOS''))				AS FAVALORSERVICOS
						,isNull(ITTIPOSUBSTITUICAO,									dbo.ciaNullValue(''' + @tableName + ''',''ITTIPOSUBSTITUICAO''))			AS ITTIPOSUBSTITUICAO
						-- EMITENTE
						,isNull(
							CASE
								WHEN ACCOUNTTYPE = 1 AND CarrierAccountTypeRecId IS NOT NULL THEN ''T''+FACODIGOEMITENTE
								WHEN ACCOUNTTYPE = 1 AND CarrierAccountTypeRecId IS NULL	 THEN ''F''+FACODIGOEMITENTE
								ELSE ''C''+FACODIGOEMITENTE
							END,													dbo.ciaNullValue(''' + @tableName + ''',''FACODIGOEMITENTE''))				AS FACODIGOEMITENTE
						,CASE 
							WHEN isNull(FACODIGOTRANSPORTADOR,						dbo.ciaNullValue(''' + @tableName + ''',''FACODIGOTRANSPORTADOR'')) <> ''''
								THEN ''T''+isNull(FACODIGOTRANSPORTADOR,			dbo.ciaNullValue(''' + @tableName + ''',''FACODIGOTRANSPORTADOR''))
							ELSE
								isNull(FACODIGOTRANSPORTADOR,						dbo.ciaNullValue(''' + @tableName + ''',''FACODIGOTRANSPORTADOR''))
						END																																		AS FACODIGOTRANSPORTADOR
						,''''																																	AS ITINDINCENTIVO
						,''''																																	AS ITNATUREZAFRETE
						,''''																																	AS ITNUMEROCONTRATO				
						,0																																		AS FAVALORICMFUNDO
						,''''																																	AS FADESFAZIMENTO
						,0																																		AS ITALIQSTUFDESTINO
						,''''																																	AS ITDATAFABRICACAO
						,''''																																	AS ITDATAVALIDADE
						,0																																		AS ITPRECOMAXIMO
						,0																																		AS ITQTDELOTE
						-- DATA TRANSFORMED
						,''''																																	AS ITTIPOICMSUBST			-- CAN BE NULL
						,''''																																	AS ITCODIGOSELOIPI			-- FUNCTIONAL TO MAP
						, 0																																		AS ITQTDESELOIPI			-- FUNCTIONAL TO MAP
						,''''																																	AS ITCODIGOOFICIAL' + CHAR(13)			-- CAN BE NULL
	SET @sql +='		,''''																																	AS ITBENEFICIARIO			-- FUNCTIONAL TO MAP
						,''''																																	AS ITCONTAANALITICA			-- CAN BE NULL
						,''''																																	AS ITCODIGOCTB				-- CAN BE NULL
						,''''																																	AS FACONTAANALITICA			-- CAN BE NULL
						,''''																																	AS FACODIGOCLASSE			-- CAN BE NULL
						,''''																																	AS FAINDFOMEZERO			-- CAN BE NULL
						,''''																																	AS FASERIENFISCALREFERENCIA -- CAN BE NULL
						,''''																																	AS FANFISCALREFERENCIA		-- CAN BE NULL
						,''''																																	AS FAREMETENTE				-- FUNCTIONAL TO MAP
						,''''																																	AS FAUFREMETENTE			-- FUNCTIONAL TO MAP
						,''''																																	AS FADESTINATARIO			-- FUNCTIONAL TO MAP
						,''''																																	AS FAUFDESTINATARIO			-- FUNCTIONAL TO MAP
						,''''																																	AS FACONDICAOPAGTO			-- FUNCTIONAL TO MAP
						,''''																																	AS FARNTC					-- FUNCTIONAL TO MAP
						,''''																																	AS ZZLIVRECABECALHO			-- CAN BE NULL
						,''''																																	AS ITTIPOPRODUTO			-- CAN BE NULL
						,''''																																	AS ITNUMEROLOTE				-- CAN BE NULL
						,''''																																	AS ITINDICADORBASE			-- CAN BE NULL
						,''''																																	AS ITMODDETERMINACAOBCST	-- CAN BE NULL
						,''''																																	AS ITPERCENTREDBCST' + CHAR(13)			-- CAN BE NULL
	SET @sql +='		,''''																																	AS ZZLIVREITEM				-- CAN BE NULL
						,''''																																	AS FACATEGORIARELACIONADA	-- FUNTIONAL TO MAP
						,''''																																	AS FAINDMOVIMENTO			-- FUNCTIONAL TO MAP
						, 0																																		AS ITVALORCONTABILIPI		-- FUNCTIONAL TO MAP			
						,''''																																	AS FANUMERODOCUMENTOORIGINAL	
						,''''																																	AS FASERIEDOCUMENTOORIGINAL				      
				FROM	CIA_AUD003NFENTRADAVIEW
				WHERE	(
						([FAINDCANCELAMENTO]					= 1)
				OR		([FAINDCANCELAMENTO]					= 2 
				AND		 [FAEMITENTE]							= 0)
				OR		([FAINDCANCELAMENTO]					= 4 
				AND		 [FAEMITENTE]						    = 0)
				OR		([FAINDCANCELAMENTO]					= 5 
				AND		 [FAEMITENTE]							= 0)
						)
				AND		[InventoryDirection]					= 1 -- 1:Entrada, 2:Saída
				AND		[FATIPONOTA]							= 2 -- Somente serviços, não conjugada
				AND		DATAAREA								= ''' + @dataArea + '''
				AND		EXTSOFTWARE								= 0
				AND		ESTABELECIMENTOATIVO					between ''' + @EstabIni + ''' AND ''' + ISNULL(@EstabFim, @EstabIni) + '''
				AND		[FADATAENTRADA]							between convert(datetime,''' + dbo.ciaDate2String(@zxdataini) + ''', 103) 
				AND														convert(datetime,''' + dbo.ciaDate2String(@zxdatafin) + ''', 103)
				AND		' + dbo.ciaGetFilter(@tableName, @dataArea, null) + '
				ORDER BY  
						DATAAREA
						,INVENTORYDIRECTION
						,FADATAEMISSAO
						,FASERIEDOCUMENTO
						,FANUMERODOCUMENTO
						,ITNUMEROITEM'

	 exec(@sql)
 END
GO