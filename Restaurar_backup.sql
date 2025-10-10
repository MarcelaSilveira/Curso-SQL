use master

ALTER DATABASE escola set single_user with rollback immediate;
restore database escola
from disk= N'C:\Users\noturno\full_bkp_Escola.bak'
with replace , --- permite sobrescrever os dados antigos
stats = 5;
