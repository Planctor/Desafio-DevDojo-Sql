USE DEVDOJO
GO

/*Relatorio por mês - ADMISSAO e DEMISSAO*/
WITH Admissao AS (
	SELECT
		BusinessEntityId AS ID,
		REPLACE(DtAdmissao, DtAdmissao, 'Admissao') AS Tipo,
		Diretoria,
		YEAR(CAST(DtAdmissao AS DATE)) AS Ano,
		MONTH(CAST(DtAdmissao AS DATE)) AS Mes
	FROM dbo.TblFunc
),

Demissao AS (
	SELECT
		BusinessEntityId AS ID,
		REPLACE(DtDemissao, DtDemissao, 'Demissao') AS Tipo,
		Diretoria,
		YEAR(CAST(DtDemissao AS DATE)) AS Ano,
		MONTH(CAST(DtDemissao AS DATE)) AS Mes
	FROM dbo.TblFunc
)

SELECT
Tipo AS [Tipo],
Diretoria AS [Diretoria],
Ano AS [Ano],
[1] AS [Janeiro],
[2] AS [Fevereiro],
[3] AS [Março],
[4] AS [Abril],
[5] AS [Maio],
[6] AS [Junho],
[7] AS [Julho],
[8] AS [Agosto],
[9] AS [Setembro],
[10] AS [Outubro],
[11] AS [Novembro],
[12] AS [Dezembro],
[1] + [2] + [3] + [4] + [5]  + [6] + [7] + [8] + [9] + [10] + [11] + [12] AS [TOTAL]
FROM (
	SELECT * FROM Admissao
	UNION
	SELECT * FROM Demissao
) AS Relatorio
PIVOT (
	COUNT(ID)
	FOR mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS PVT
GO

/*Cadastros Ativos*/

/***
WITH tbl AS (
	SELECT
	BusinessEntityId AS ID, 
	Diretoria,
	CAST(DtAdmissao AS DATE) AS [Admissao],
	CASE CAST(DtDemissao AS INT)
		WHEN 0
		THEN null
		ELSE CAST(DtDemissao AS DATE)
		END AS [Demissao],
	CASE CAST(DtDemissao AS INT)
		WHEN 0
		THEN 'Ativo'
		ELSE 'Inativo'
		END AS [Status]
	FROM dbo.TblFunc
	WHERE DtAdmissao >= '2020%'
)

SELECT  * FROM tbl
GO
***/

/* TAREFA 2 E 3 - RETORNA POR MES OS USUARIOS ATIVOS*/
WITH PERIODO AS (
	SELECT
	BusinessEntityId AS Id,
	Diretoria,
	YEAR(CAST(DtAdmissao AS DATE)) as AnoAdm,
	CASE YEAR(CAST(DtDemissao AS DATE))
		WHEN '1900'
		THEN DATEPART(YEAR, GETDATE())
		ELSE YEAR(CAST(DtDemissao AS DATE)) 
		END AS AnoDem,
	MONTH(CAST(DtAdmissao AS DATE)) AS mes,
	CASE DATEFROMPARTS(YEAR(CAST(DtDemissao AS DATE)), MONTH(CAST(DtDemissao AS DATE)), 1) 
		WHEN '1900-01-01'
		THEN GETDATE()
		ELSE DATEFROMPARTS(YEAR(CAST(DtDemissao AS DATE)), MONTH(CAST(DtDemissao AS DATE)), 1) 
		END AS AnoMesDm,
	DATEFROMPARTS(YEAR(CAST(DtAdmissao AS DATE)), MONTH(CAST(DtAdmissao AS DATE)), 1) AS AnoMesAdm
	FROM dbo.TblFunc
	UNION ALL
	SELECT
    ID,
    Diretoria,
    AnoAdm,
    AnoDem,
    mes,
    AnoMesDm,
    DATEADD(MONTH, 1, AnoMesAdm)
    FROM PERIODO
    WHERE AnoMesAdm < AnoMesDm
)

--SELECT * FROM  PERIODO
--where AnoMesAdm LIKE '2001-01%'
--OPTION (MAXRECURSION 0)

SELECT
Ano AS [Ano],
[1] AS [Janeiro],
[2] AS [Fevereiro],
[3] AS [Março],
[4] AS [Abril],
[5] AS [Maio],
[6] AS [Junho],
[7] AS [Julho],
[8] AS [Agosto],
[9] AS [Setembro],
[10] AS [Outubro],
[11] AS [Novembro],
[12] AS [Dezembro]
FROM (
	SELECT
	ID,
	YEAR(AnoMesAdm) AS Ano,
	MONTH(AnoMesAdm) AS Mes
	FROM PERIODO
) AS TBL
PIVOT(
	COUNT(ID)
	FOR Mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS PVT
ORDER BY Ano
OPTION(MAXRECURSION 0)