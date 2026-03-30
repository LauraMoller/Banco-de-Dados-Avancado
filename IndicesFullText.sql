-- Criando uma tabela com apenas um campo chamado dados.
CREATE TABLE pessoa2
AS
SELECT CONCAT (p.id, ' - ', p.nome, ' - ', p.email, ' - ', p.empresa , ' - ',
					p.departamento, ' - ', p.cor, ' - ', p.marca_automovel, ' - ', p.alimentos)
AS dados  -- Comando Concat vai juntar todos os dados em um literal
FROM pessoa p;

-- Alterando o tipo da tabela
ALTER TABLE pessoa2 ENGINE=MYISAM;

-- Verificando se há índices
SHOW INDEXES FROM pessoa2;

-- criando um índice para a coluna dados
CREATE INDEX pessoa2_dados_idx ON pessoa2(dados);

-- EXPLAIN
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '333111%';

-- Trunca na esquerda = não usa índice
EXPLAIN
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '%guisado%';

CREATE FULLTEXT INDEX pessoa2_dados_idx_full ON pessoa2(dados);

EXPLAIN
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '%microsoft%' 

EXPLAIN
SELECT *
FROM pessoa2 p2
WHERE MATCH (p2.dados) AGAINST ('microsoft');

-- -------------------------------------------------
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '%microsoft%' AND p2.dados LIKE '%sopas%' AND p2.dados LIKE '%Lexus%'; 

-- Equivale à

SELECT *
FROM pessoa2 p2
WHERE MATCH (p2.dados) AGAINST ('microsoft sopas lexus');

-- -------------------------------------------------
EXPLAIN
SELECT *
FROM pessoa2 p2
WHERE MATCH(p2.dados) AGAINST('microsoft +azul -sopas lex*' IN BOOLEAN MODE);

-- Equivale à
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '%microsoft%' 
  AND p2.dados LIKE '%azul%' 
  AND p2.dados NOT LIKE '%sopas%' 
  AND p2.dados LIKE 'lex%';

-- -------------------------------------------------

INSERT INTO pessoa2 SELECT * FROM pessoa2;

-- -------------------------------------------------



