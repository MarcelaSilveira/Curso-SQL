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

	--- Consultas combinadas ( exists , Union)
 --- Mostrar apenas os alunos que tem pagamentos registrados

 SELECT nome
 from Alunos a
 where EXISTS (
 select 1 from pagamentos p where p.Alunoid = a.id
 );

 --- combinar alunos e professores em uma mesma lista ( UNION= JUNTAR DUAS TABELAS EM UMA UNICA) 
 SELECT nome, 'aluno' as tipo
 from Alunos 
 UNION
 select nome, 'professor'as tipo
 from professores 

 -- Extra- receita final
 ---Alunos com suas ultimas notas

select a.nome, c.Nomecurso, n.nota, n.DataAvaliacao
from Alunos a
inner join notas n on a.id = n.Alunoid
inner join cursos c on c.id = n.CursoID
where n.DataAvaliacao =(
select max(DataAvaliacao)
from notas n2
where n2.Alunoid = a.id
);

-- ranking de alunos pelas notas 
--(usaremos uma função de janela)
select a.nome, c.nomecurso, n.nota,
rank () over (order by n.nota desc) as ranking
from notas n
join alunos a on n.Alunoid = a.id
join Cursos c on n.CursoID = c.id

--multiplos calculos- 
---função Cast = Usar a nota em decimal
---Min= Menor nota
---Max= maior nota
select 
a.nome As Aluno,
avg (cast (n.nota as decimal(10,2))) as 'media de notas',
Min(n.nota) as 'Menor nota',
max(n.nota) as 'Maior nota',
Count (*) as 'qts notas'
from alunos a
inner join notas n on n.alunoid =  a.id
group by a.nome

---contar quantas avaliações há por situação
select 
case 
when n.nota >=7 then 'aprovado'
when n.nota >=5 then 'recuperacao'
else 'reprovado'
end as situacao, 
count (*) as quantidade
from alunos a
inner join notas n on a.id =n.Alunoid
group by
case 
when n.nota >=7 then 'aprovado'
when n.nota >=5 then 'recuperacao'
else 'reprovado'
end 
order by quantidade desc;

-- quero alunos com email do gmail
select a.nome, a.email
from alunos a 
where Email like '%@gmail.com';


