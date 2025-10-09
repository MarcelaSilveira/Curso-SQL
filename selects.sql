USE Escola;

--Seleção Básicas e ordenações [

---(01) Mostrar todos os cursos ordenados pela carga horaria
SELECT Nomecurso, CargaHoraria
from Cursos
order by CargaHoraria desc

--(02) Mostrar os 03 cursos mais curtos
SELECT TOP 3 Nomecurso, CargaHoraria
from Cursos
order by CargaHoraria desc

---Filtros com Where
--(01) Alunos maiores que 30 anos
SELECT Nome, Idade, Email
from Alunos
Where Idade >30;

--- (02) Pagamentos ainda pendentes (<>  = diferente do pago)
SELECT Alunoid, valor, situacao
FROM Pagamentos
where situacao <> 'pago';

--(03) Carga horária dos cursos especificas ( between- entre )
SELECT *from cursos
where CargaHoraria between 40 and 80.;

-----Funções de Agregação----
--SUM, AVG, COUNT, MAX, MIN....

--(01) Quantidade de alunos matriculados por curso
SELECT c.Nomecurso, count(m.alunoID) as 'total alunos'
from cursos c
Left join Matriculas m on c.id=m.CursoID
group by c.NomeCurso
order by 'total alunos' desc;

---(02)Nota média por aluno
SELECT a.Nome, aVG(n.nota) as 'media de notas'
from alunos a
inner join notas n on a.id = n.alunoid
Group by a.nome;

---(03) Soma do total já pago!
SELECT SUM(valor) as 'total pago'
from pagamentos
where situacao = 'pago';


-----HAVING (FILTROS EM GRUPOS)
-- Cursos  com mais de um aluno matriculado
SELECT c.nomecurso, count(m.alunoid) as  total
from cursos c
inner join Matriculas m on c.id=m.CursoID
group by c.NomeCurso
HAVING COUNT (m.Alunoid) >1 

---subqQueries (sub consultas)
---Alunos com notas acima da media geral
SELECT Nome
from Alunos
where id IN (
      select alunoid 
	  from notas
	  where nota > (
	  select AVG(nota)
	  From Notas
	  )
    );

	----- CASE E formataçao
	---exibir situação de desempenho do aluno
	SELECT
	a.nome,
    n.nota,
	case 
	when n.nota >=7 then 'Aprovado'
	when n.nota >=5 then 'Recuperação'
	else 'reprovado'
	end as situacao
	from alunos a 
	inner join notas n on a.id= n.alunoid;


