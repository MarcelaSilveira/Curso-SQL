-- 08_delete_eficiente.sql

CREATE DATABASE db1410_eficiente_enterprise
GO

USE db1410_eficiente_enterprise;
GO

DROP TABLE IF EXISTS clientes
CREATE TABLE clientes (
-- IDENTITY(1,1) é o comando que cria de forma automática o ID, a partir do 1 e de 1 em 1
-- PRIMARY KEY declara que esse ID será utilizado como chave primária para o relacionamento com outras querys
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME
);  

DROP TABLE IF EXISTS pedidos
CREATE TABLE pedidos (
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL (10,2)
);

INSERT INTO clientes (
	cliente_id,
	nome_cliente,
	data_cadastro
	)
SELECT TOP 100000
/*
gerar o valor sequencial de 1 até o infinito por cada linha
o over exige ordenar, isso é um truque do instrutor
para dizer que nao quero em ordem pre-definida
*/
-- Gerar o cliente_id
ROW_NUMBER() OVER( ORDER BY (SELECT NULL)),
-- Gerar o nome_cliente
'Cliente: ' + CAST(ROW_NUMBER() OVER( ORDER BY (SELECT NULL)) AS VARCHAR(10)),
-- Gerar a data_cadastro da data de hoje subtraindo do dia o numero da linha
DATEADD(
	DAY,-
	(ROW_NUMBER() OVER( ORDER BY (SELECT NULL))%3650),
	GETDATE()
	)
-- Tabela temporária 
FROM master.dbo.spt_values a, master.dbo.spt_values b;
-- Truncate é mais  eficiente pois não registra a remoção, ao contrário do delete.
-- TRUNCATE TABLE clientes;

INSERT INTO pedidos(pedido_id, cliente_id, data_pedido, valor_total)
SELECT TOP 100000
	ROW_NUMBER() OVER(ORDER BY (SELECT NULL)),
	(ABS(CHECKSUM(NEWID())) % 100000)+1,
	DATEADD(
		DAY, 
		-(ROW_NUMBER() OVER(ORDER BY (SELECT NULL))%3650),
		GETDATE()
	),
	-- Rand: aleatório
	-- Cast: executa o elemento e no resultado já retorna com a formatação desejada
	CAST (RAND()*1000 AS DECIMAL (10,2))
	-- master: sistema do SQL
	-- dbo: Data Base Object (objeto do banco de dados
	-- spt_values: 
	FROM master.dbo.spt_values a, master.dbo.spt_values b;


-- visualizar os 10 primeiros registros de cada tabela
SELECT TOP 10 * FROM pedidos
SELECT TOP 10 * FROM clientes

-- conta quanntos registros temos em cada base, como estou contando as linhas, ele nao tem coluna especifica para salvar
SELECT COUNT (*) AS Quantidade FROM clientes
SELECT COUNT (*) AS Quantidade FROM pedidos

-- Tenta executar o comando
BEGIN TRY
	BEGIN TRANSACTION
	-- delcarando as variáveis de controle do lote
		DECLARE @batch_size INT = 1000;
		DECLARE @row_count INT;

		-- inicializando do 0 a variável de controle da contagem de registros exclusivos
		SET @row_count = 1

		-- looping para excluir os dados em lote 
		WHILE @row_count > 0
			BEGIN
				-- Excluir os dados em lote de 1000
				DELETE TOP (@batch_size)
				FROM clientes 
				WHERE data_cadastro < DATEADD (YEAR, -5, GETDATE());
				-- @@ROWCOUNT é uma variavel do sistema que ja conta as linhas de forma nativa
				-- obtendo a contagem de registros na interação atual 
				SET @row_count = @@ROWCOUNT
				
				-- exibindo o progresso
				PRINT 'Excluidos' + CAST(@row_count AS VARCHAR) + ' registros de clientes'

				-- esperar 1 segundo entre lotes, visando evitar blocks por parte do servidor
				WAITFOR DELAY '00:00:01';	

			END

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END
	PRINT 'Erro durante a exCLUSÃO: ' + ERROR_MESSAGE();
END CATCH;
