-- Criando um usuário
CREATE USER 'user1'
	IDENTIFIED BY 'user1';
	
-- Concedendo um privilégio de select
GRANT SELECT ON bd_teste.tab1 TO 'user1';

-- Concedendo um privilégio de select de coluna
GRANT SELECT (tx, ds) ON bd_teste.tab1 TO 'user1';

-- Concedendo um privilégio de insert
GRANT INSERT ON bd_teste.tab1 TO 'user1';

-- Concedendo um privilégio de sistema (CREATE) -- Para funcionar precisa parar a conexão e abrir de novo
GRANT CREATE ON bd_teste.* TO 'user1';

-- Revogando privilégio
REVOKE CREATE ON bd_teste FROM 'user1';

-- Crinado um papel
CREATE ROLE r1;

-- Concedendo privilégio à r1
GRANT INSERT, DELETE, UPDATE ON
	bd_teste.tab1 TO r1;
	
-- Associando r1 para o usuário 'user1'
GRANT r1 TO 'user1';
-- Setando a role default
SET DEFAULT ROLE r1 FOR 'user1';