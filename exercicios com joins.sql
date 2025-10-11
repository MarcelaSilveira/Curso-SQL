---Listar alunos e os cursos em que estão matriculados
SELECT a.nome, c.nomecurso
from Matriculas m
INNER JOIN alunos a on m.Alunoid = a.id
inner join cursos c on c.id = m.CursoID

---listar todas as notas dos alunos por curso
select a.nome,c.nomecurso,n.nota
from notas n
inner join Alunos a on n.Alunoid= a.id
inner join Cursos c on n.CursoID = c.id
order by n.nota desc

-- listar alunos que ainda não pagaram (usando LEFT JOIN)
SELECT a.Nome AS Aluno, p.Valor AS ValorPago
FROM Alunos a
LEFT JOIN Pagamentos p ON a.Id = p.Alunoid
WHERE p.Id IS NULL;

---Listar todos os cursos e os professores responsáveis4
SELECT c.nomecurso, p.Nome
from cursos c
inner join Professores p on c.id = p.id

---Listar total de pagamentos por aluno
SELECT a.Nome AS Aluno, SUM(p.Valor) AS TotalPago
FROM Alunos a
INNER JOIN Pagamentos p ON a.Id = p.Alunoid
GROUP BY a.Nome;

--- Listar todos os alunos
select * from Alunos;

----Listar os nomes dos professores em ordem alfabética
select *from Professores
order by nome asc;

--- Contar quantos alunos existem na tabela
select count(*) as totalalunos from Alunos;

----Mostrar os 5 primeiros alunos cadastrados
select top 5 *
from Alunos;

---Mostrar o nome do aluno e o valor do pagamento
select a.nome,p.valor
from Pagamentos p
inner join Alunos a on a.id = p.Alunoid

----Mostrar o nome do aluno, o nome do curso e a data da matrícula
select a.nome, c.nomecurso, m.DataInscricao
from Matriculas m
inner join Alunos a On a.id= m.Alunoid
inner join Cursos c on m.Alunoid =c.id

---Mostrar os cursos sem nenhum aluno matriculado (usando LEFT JOIN)
select c.NomeCurso
from Cursos c
left join Matriculas m on c.id= m.Alunoid
where m.Alunoid is null

--Listar professores e quantos cursos cada um ministra
SELECT p.Nome AS Professor, COUNT(c.Id) AS TotalCursos
FROM Professores p
LEFT JOIN Cursos c ON c.id = p.Id
GROUP BY p.Nome;

---Mostrar a média das notas de cada aluno
SELECT a.Nome AS Aluno, AVG(n.Nota) AS MediaNota
FROM notas n
INNER JOIN Alunos a ON n.Id = a.Id
GROUP BY a.Nome;

---Listar todos os alunos com suas respectivas notas e cursos
SELECT a.nome, n.nota, c.NomeCurso
from notas n
inner join Alunos a on a.id = n.Alunoid
inner join cursos c on n.Alunoid = c.id

---- Mostrar o nome dos alunos que têm nota maior que 8 em qualquer curso
SELECT DISTINCT a.Nome AS Aluno
FROM notas n
INNER JOIN Alunos a ON n.Alunoid = a.Id
WHERE n.Nota > 8;

---Listar todos os cursos com a quantidade de alunos matriculados em cada um
SELECT c.NomeCurso AS Curso COUNT(m.IdAluno) AS TotalMatriculados
FROM Cursos c
LEFT JOIN Matriculas m ON c.id = m.Alunoid
GROUP BY c.Nome;