-- Criando tabelas para exemplificar operações sobre a álgebra relacional
CREATE TABLE tab1 (
tx VARCHAR(20)
);

CREATE TABLE tab2 (
tx VARCHAR(20)
);

-- Inserindo dados para os testes
INSERT INTO tab1 VALUE ('registro 1'), ('registro 2'), ('registro 3'), ('registro 4');
INSERT INTO tab2 VALUE ('registro 0'), ('registro 2'), ('registro 3'), ('registro 5');
SELECT * FROM tab1;
SELECT * FROM tab2;

-- Operação de UNION
SELECT * FROM tab1
UNION 
SELECT * FROM tab2;

-- Operação de INTERSECT
SELECT * FROM tab1
INTERSECT  
SELECT * FROM tab2;

-- Operação de EXCEPT
SELECT * FROM tab1
EXCEPT 
SELECT * FROM tab2;
-- ou 
SELECT * FROM tab2
INTERSECT  
SELECT * FROM tab1;

-- operação de produto cartesiano
SELECT * FROM tab1, tab2;
