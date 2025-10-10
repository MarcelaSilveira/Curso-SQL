use Escola;

declare @arquivo nvarchar(260) = N'C:\Users\noturno\full_bkp_Escola.bak';

BACKUP DATABASE escola
to disk =@arquivo_diff
with differential,
init,
compression, -- torna o arquivo menos
stats= 10;--- progresso a cada 10%
