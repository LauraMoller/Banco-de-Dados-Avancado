CREATE TABLE pessoa
(id INT PRIMARY KEY,
nome VARCHAR(50),
email VARCHAR(50));

CREATE TABLE registro_log
(dt_op DATE,
hr_op TIME,
ds_op VARCHAR(100)
);

-- Criando um gatilho
DELIMITER $$ -- Ajustando o caracter terminador da estrução para $$
CREATE OR REPLACE TRIGGER tg_inserindo_pessoa
	AFTER INSERT ON pessoa FOR EACH ROW
BEGIN
	INSERT INTO registro_log (dt_op, hr_op, ds_op)
		VALUES (CURDATE(), CURTIME(), CONCAT('INSERIDO row pessoa id: ', NEW.id));
END $$
-- CURDATE e CURTIME retorna o dado (data e hora) instantânea do servidor.
-- CONCAT concatena literais/strings

-- Inserindo o dado em pessoa e testando o gatilho 
INSERT INTO pessoa (id, nome, email) VALUES (1, 'Pessoa 1', 'pessoa1@gmail.com');

-- Validando 
SELECT id, nome, email FROM pessoa p;
SELECT * FROM registro_log;

-- Criando gatilho com BEFORE
DELIMITER $$
CREATE OR REPLACE TRIGGER tg_alterando_pessoa
	BEFORE UPDATE ON pessoa FOR EACH ROW
BEGIN
	INSERT INTO registro_log (dt_op, hr_op, ds_op)
		VALUES (CURDATE(), CURTIME(), CONCAT('Alterando row pessoa id: ', OLD.id, ' para: ', NEW.id));
END $$

-- Testando o gatilho alterando dados de pessoa
UPDATE pessoa SET id=11 WHERE id=1;

-- Validando
SELECT id, nome, email FROM pessoa p;
SELECT * FROM registro_log;

-- Identificando rotinas criadas
SELECT *
FROM information_schema.triggers
WHERE trigger_schema = 'base_pr_testes';


-- Criando outro gatilho
DELIMITER $$
CREATE OR REPLACE TRIGGER tg_alterando_pessoa
	BEFORE UPDATE ON pessoa FOR EACH ROW
BEGIN
	if OLD.nome <> NEW.nome THEN
		INSERT INTO registro_lg ((dt_op, hr_op, ds_op)
			VALUES CURDATE(), CURTIME(), CONCAT('Alterando row pessoa NOME: ', OLD.NOME, ' para: ', NEW.NOME));
END $$

UPDATE pessoa SET  nome='novo nome' WHERE id=11;

-- Validando
SELECT id, nome, email FROM pessoa p;
SELECT * FROM registro_log;
