-- Caso de sucesso
SELECT * FROM tab1; 

-- Caso de erro
SELECT * FROM tab2;

-- SELECT de coluna -> Sucesso
SELECT tx, ds FROM tab1;

-- Inseerindo valor
DESC tab1;
INSERT INTO tab1 VALUES('registro 6', 'r6', 2);

-- Criando uma tabela
CREATE TABLE tab3 (ds VARCHAR(10));

-- Verificando os privilégios
SHOW GRANTS FOR 'user1';

-- Verificando os privilégios
DELETE FROM tab1
	WHERE cd = 1;
