----------------------------
--01) Banco de dados novo
--------------------------

use master;

DROP DATABASE IF EXISTS IndicadoresBR;
go

CREATE DATABASE IndicadoresBR;
Go

Use IndicadoresBR;

----------------------------
--02) Tabelas Raw (texto)
--Motivo: Evita dor de cabeça com virgula vs ponto
--------------------------
DROP TABLE IF EXISTS Inadimplencia_raw;
create table Inadimplencia_raw (
data_str VARCHAR(20), -- "DD\MM\AAAA"
valor_str VARCHAR(50) --- NUMERO TEXTO
);

DROP TABLE IF EXISTS Selic_raw;
Create table Selic_raw (
data_str VARCHAR(20),
valor_str VARCHAR(50)
);

----------------------------
--03) Importar CSVS ( Bulk Insert)
--------------------------
BULK INSERT Inadimplencia_raw
FROM 'C:\Users\integral\Downloads\inadimplencia.csv'
WITH ( 
     FIRSTROW = 2, ---Cabeçalho na primeira linha.
	FIELDTERMINATOR = ';',--- Separador
	 ROWTERMINATOR = '0x0d0a',  --- \r\n ( terminador do Windowns)
	 CODEPAGE = '65001',  -- UTF-8(permite caracteres especiais)
	 TABLOCK   --Impede a concorrencia dessa tabela enquanto importa 
	 );


BULK INSERT Selic_raw
FROM 'C:\Users\integral\Downloads\taxa_selic.csv'
WITH ( 
     FIRSTROW = 2, ---Cabeçalho na primeira linha.
	 FIelDTERMINATOR = ';',--- Separador
	 ROWTERMINATOR = '0x0d0a',  --- \r\n ( terminador do Windowns)
	 CODEPAGE = '65001',  -- UTF-8(permite caracteres especiais)
	 TABLOCK  --Impede a concorrencia dessa tabela enquanto importa 
	 );

---COnferencia rapida se se os dados foram importador
SELECT TOP (5) * FROM Inadimplencia_raw
SELECT TOP (5) * FROM Selic_raw

----------------------------
--04) Tabelas finais (tipadas)
--------------------------
DROP TABLE IF EXISTS Inadimplencia;

SELECT 
    TRY_CONVERT(DATE, data_str, 103) AS Data,
    TRY_CONVERT(DECIMAL(18,4), REPLACE(valor_str, ',', '.')) AS valor
INTO Inadimplencia
FROM Inadimplencia_raw;

	DROP TABLE IF EXISTS Selic;
SELECT 
TRY_CONVERT (DATE,data_str, 103) AS Data,
TRY_CONVERT (decimal(18,4),replace(valor_str, ',','.')) AS valor
INTO Selic
From Selic_raw


----------------------------
--05) Selic Mensal- 
---Média do Mês
---Ultimo valor do mês
--------------------------
DROP TABLE IF EXISTS Selic_mensal_ultimo;
; with s AS (
select 
     data,
	 EOMONTH(data) AS mes,
	 valor,
	 ROW_NUMBER() over(PARTITION by EOMONTH(data) order by data desc) as rn
	 From Selic 
	 )
	 select
	 mes as data,
	 valor
	 into Selic_mensal_ultimo
	 from s
	 where rn =1;

	 ----- visualizar os dados de amostra da selic_mensal ultima
	 select top (10) * from Selic_mensal_ultimo

	 ---- Selic Média do Mês
	 SELECT 
    EOMONTH(data) AS DATA,
    AVG(valor) AS VALOR
INTO Selic_mensal_media
FROM selic
GROUP BY EOMONTH(data);

---- Visualizar os dados de amostra da Selic_mensal_media
SELECT TOP (10)* FROM Selic_mensal_media ORDER BY data;


	----------------------------
	--06) Ultimos 12 meses de inadiplencia 
	--------------------------
	select top (12)* from Inadimplencia
	order by data desc;

----------------------------
	--07) Variação Mom (mes sobre mes) da inadiplencia 
	--------------------------
	 ;WITH B AS (
    SELECT
        data,
        valor,
        LAG(valor) OVER (ORDER BY data) AS prev_valor
    FROM Inadimplencia
)
SELECT
    data,
    valor,
    CASE
        WHEN prev_valor IS NULL OR prev_valor = 0 THEN NULL
        ELSE (valor - prev_valor) / prev_valor
    END AS variacao_mm
FROM B;

---------------------------
--08) inadimplencia X Selic (média) nos ultimos 24 meses
--------------------------
select top (24)
    i.data,
	DATENAME(MONTH, i.Data) as 'mes por extenso',
    i.valor AS inadimplencia,
    s.valor AS Selic
FROM Inadimplencia i
left join Selic_mensal_media s
on s.DATA = EOMONTH(i.data)
order by i.data desc;














