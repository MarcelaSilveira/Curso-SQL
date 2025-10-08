USE Escola;
---EXCLUIR TABELAS CASO JA EXISTAM ( DROP)
DROP TABLE IF EXISTS CURSOS;
DROP TABLE IF EXISTS MATRICULAS;

--- CRIANDO A TABELA DE CURSOS---
CREATE TABLE Cursos(
id int primary key identity (1,1),
NomeCurso NVARCHAR (100) NOT NULL,
CargaHoraria INT NOT NULL
);

-- INSERINDO AS INFORMAÇÕES NA TABELA DE CURSOS--
INSERT INTO Cursos (NomeCurso, CargaHoraria)
VALUES
('SQL', 40),
('Pyton', 32),
('Power BI',70),
('Excel', 16),
('PHP',80);

select *from Cursos

CREATE TABLE Matriculas( 
id int primary key identity (1,1),
Alunoid Int not null,
CursoID int not null,
DataInscricao Date not null,

FOREIGN KEY (Alunoid) references Alunos(id),
FOREIGN KEY (CursoID) references Cursos(id)
);

INSERT INTO Matriculas (Alunoid,CursoID,DataInscricao)
VALUES
(10,1,'2025-09-7'),
(2,2,'2025-09-30'),
(3,3,'2025-8-24'),
(5,4,'2025-02-20'),
(6,1,'2025-03-15');

SELECT *FROM Matriculas