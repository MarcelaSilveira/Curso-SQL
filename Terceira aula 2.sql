
--- inner join ( mostrar os alunos matriculados)
SELECT a.Nome,a.email,c.NomeCurso, m.Datainscricao
FROM Alunos a

INNER JOIN Matriculas m ON a.id = m.Alunoid
INNER JOIN Cursos c ON c.id = m.CursoID

order by a.Nome


INSERT INTO Alunos ( Nome, Idade, Email, datamatricula)
VALUES
(N'Thamires', 32, 'thamires@gmail.com', '2025-02-12'),
(N' Antonio', 22,'antonio@gmail.com', '2025-06-01');


--- Left join ( mostrar todos os alunos mesmo sem matricula)

SELECT a.Nome, c.nomecurso, datainscricao
From Alunos a
left join Matriculas m On a.id = m.Alunoid
left join Cursos c on c.id= m.CursoID
order by m.DataInscricao

--- tabela de professores--
DROP TABLE IF EXISTS professores;
CREATE TABLE Professores (
id int primary key IDENTITY (1,1),
Nome Nvarchar(100) not null,
Email Nvarchar(100)
);

INSERT INTO Professores( Nome, Email)
VALUES
('Katia','katia@gmail.com'),
('Ricardo','ricardo@gmail.com'),
('Sibeli','sibeli@gmail.com');

select *from Professores

-- tabela de notas
--{Id, AlunoID, CursoID, nota, DataAvaliacao}

DROP TABLE IF EXISTS notas;
CREATE TABLE notas (
id int primary key identity (1,1),
Alunoid Int not null,
CursoID int not null,
nota int not null,
DataAvaliacao Date not null

FOREIGN KEY (Alunoid) references Alunos(id),
FOREIGN KEY (CursoID) references Cursos(id)
);

INSERT INTO notas(Alunoid,CursoID,nota,DataAvaliacao)
VALUES
(10,1,10,'2023-02-10'),
(2,2,5,'2024-01-19'),
(3,3,2,'2025-7-23'),
(11,5,8,'2022-02-28'),
(8,4,6,'2022-02-28'),
(12,1,7,'2025-03-22');

SELECT *FROM Alunos
SELECT *FROM Cursos
SELECT *FROM notas


--- TABELA DE PAGAMENTOS
---{Id, AlunoID, DataPagamento, Situacao}
DROP TABLE IF EXISTS Pagamentos;
CREATE TABLE Pagamentos (
Id INT PRIMARY KEY IDENTITY (1,1),
Valor INT NOT NULL,
Alunoid int not null,
DataPagamento date not null,
Situacao nvarchar (10) not null
FOREIGN KEY (AlunoId) REFERENCES Alunos(id),
);

INSERT INTO Pagamentos (Alunoid, Valor, DataPagamento,Situacao)
Values
(10,200,'2023-02-10','Pago'),
(2,300,'2024-01-30','Pendente'),
(3,600,'2025-4-23','Pago'),
(11, 800,'2022-06-28','Atrasado'),
(8,400,'2023-02-21','Pendente'),
(12,700,'2023-07-22','Pago');

SELECT *FROM Pagamentos

----Mostrar notas dos alunos em cada curso
SELECT
a.Nome AS Aluno,
c.NomeCurso As Curso,
n.Nota,
n.Dataavaliacao AS DATA

from notas n
Inner join Alunos a On a.id= n.Alunoid
Inner join Cursos c on c.id= n.cursoid

order by n.DataAvaliacao desc

---media de notas por cursos
SELECT c.Nomecurso, AVG(n.nota) AS 'Media de Notas'
from Notas n
Inner join Cursos c On c.id = n.CursoID
Group by c.NomeCurso
Order by 'media de notas'desc

---Visualizar pagamento por aluno---
SELECT a.nome,p.valor,p.datapagamento, p.situacao
from pagamentos p

inner join alunos a on a.id=p.Alunoid
order by p.DataPagamento


---quantidade de alunos por situacao de pagamento0 contar = count(*) qd se colocar o * entre parenteses no count, ele conta tudo.
SELECT p.situacao, count(*) as quantidade 
from pagamentos p
group by p.Situacao

----
