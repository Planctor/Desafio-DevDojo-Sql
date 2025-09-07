USE DEVDOJO
GO

/*Relatorio por mês*/
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
[12] AS [Dezembro]
FROM (
	SELECT * FROM Admissao
	UNION
	SELECT * FROM Demissao
) AS Relatorio
PIVOT (
	COUNT(ID)
	FOR mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS PVT

/*Cadastros Ativos*/

