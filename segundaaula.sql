use escola;

--- Idempotencia para criar o banco de dados
drop database if exists escola;

create database Escola;

-- Idempotencia para criar tabela
drop table if exists Alunos;

create table Alunos (
id int identity (1,1) primary key,
Nome NVARCHAR (100) NOT NULL,
Idade int,
Email NVARCHAR (100),
datamatricula DATE NOT NULL
);

INSERT INTO Alunos( Nome, Idade,Email,datamatricula)
values 
(N'Caio',38,N'kio199@gmail.com', '2025-02-12'),
(N'Diego',29,N'diego@gmail.com', '2023-06-01'),
(N'Rafaélla',35,N'rafa@gmail.com', '2025-09-14'),
(N'juliana',27,N'ju@gmail.com', '2025-08-22'),
(N'Marcela ',45,N'marcelasilveira1@hotmail.com.com', '2025-01-01');

select*from Alunos;

---mostrando alunos com idades menores que 26 anos
select * from alunos where Idade <= 26;

--- mostrar alunos mais novos primeiros

select *from alunos order by idade Asc;

select *from alunos order by Nome Asc;

--- atualizando os dados da tabela (UPDATE)-----
UPDATE Alunos
SET Email = N'lalala@gmail.com' 
where id = 1;

SELECT *FROM Alunos;


SELECT Id, nome, email from Alunos
where id = 1;

UPDATE Alunos
SET Idade = Idade +1;

----- remoção de dados(delete)-----

DELETE FROM Alunos
WHERE id= 1;

DELETE FROM Alunos
WHERE IDADE < 30;

----MOSTAR TODOS OS ALUNOS QUE COMEÇAM  COM UMA LETRA ESPECIFICA---(LIKE)
-- COMEÇA COM A LETRA % NO FINAL, ENTRE % %, QUE TEM % NO COMEÇO.
SELECT * FROM Alunos
WHERE Nome LIKE N'D%';

----MOSTRAR APENAS OS 3 ALUNOS MAIS NOVOS ( USAR TOP PARA SELECIONAR )
SELECT TOP 3 *FROM Alunos
ORDER BY Idade  ASC

---- aluno mais velho e somente ele!!
SELECT TOP 1 * FROM Alunos
ORDER BY iDADE DESC;

--- QUANTOS ALUNOS TEMOS NA TABELA---- (COUNT)
SELECT COUNT (*) AS QT FROM ALUNOS;


----- CALCULAR A MEDIA DE IDADE DOS ALUNOS--- ( avg- MEDIA)
SELECT AVG (IDADE) AS 'IDADE MEDIA' FROM Alunos;



