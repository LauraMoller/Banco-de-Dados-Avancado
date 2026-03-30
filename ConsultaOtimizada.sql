-- Listar todos os logradouros da cidade de "Blumenau", seus respectivos bairros e CEPs, ordenados alfabeticamente 
-- pelo nome do bairro, seguido pelo nome do logradouro;
SHOW INDEXES FROM logradouro;

CREATE FULLTEXT INDEX localidade_nm_localidade_idx2 ON localidade(nm_localidade);

EXPLAIN
SELECT 
    bi.nm_bairro AS 'Bairro Início', 
    l.nr_cep AS 'CEP', 
    l.nm_logradouro AS 'Nome Logradouro'
FROM logradouro l
JOIN bairro bi ON l.cd_bairro_inicio = bi.cd_bairro
JOIN localidade loc ON l.cd_localidade = loc.cd_localidade
WHERE MATCH(loc.nm_localidade) AGAINST ('Blumenau')
ORDER BY bi.nm_bairro ASC, l.nm_logradouro ASC;

-- Listar o nome dos distritos (fl_tipo_localidade= 'D') e do respectivo município que cada distrito está associado. 
-- Considerar como filtro apenas a UF "SC" e ordenar pelo nome do município, seguido do distrito;
CREATE INDEX idx_localidade_uf_tipo_nome 
ON localidade (sg_uf, fl_tipo_localidade, nm_localidade, nm_localidade_comp);

EXPLAIN
SELECT 
    nm_localidade AS 'Município', 
    nm_localidade_comp AS 'Distrito'
FROM localidade
WHERE fl_tipo_localidade = 'D' 
  AND sg_uf = 'SC'
ORDER BY nm_localidade ASC, nm_localidade_comp ASC;

-- Listar o nome do(s) bairro(s) de "Florianópolis" com respectiva quantidade de CEPs associados. Ordenar pelo maior número de CEPs;
EXPLAIN
SELECT 
    b.nm_bairro AS 'Bairro', 
    COUNT(l.nr_cep) AS 'Quantidade de CEPs'
FROM logradouro l
JOIN bairro b ON l.cd_bairro_inicio = b.cd_bairro
JOIN localidade loc ON l.cd_localidade = loc.cd_localidade
WHERE loc.nm_localidade LIKE 'Florianópolis'
GROUP BY b.nm_bairro
ORDER BY COUNT(l.nr_cep) DESC;

-- Listar quais nomes de municípios são encontrados em mais de uma UF. Listar também a quantidade de vezes em que o nome do município é encontrado. 
-- Ordenar pelos municípios mais populares;
EXPLAIN
SELECT 
    loc.nm_localidade AS 'Município', 
    COUNT(DISTINCT sg_uf) AS 'Quantidade de UFs'
FROM localidade loc
WHERE loc.fl_tipo_localidade = 'M' 
GROUP BY loc.nm_localidade
HAVING COUNT(DISTINCT loc.sg_uf) > 1
ORDER BY COUNT(DISTINCT loc.sg_uf) DESC, loc.nm_localidade ASC;

-- Listar qual o número de total de CEPs encontrados em cada município, com respectiva UF, ordenados pelo maior número (de CEPs listados).
-- Considerar apenas os municípios que possuem mais de um CEP (tabela logradouro);
EXPLAIN
SELECT 
    loc.nm_localidade AS 'Município', 
    loc.sg_uf AS 'UF',
    COUNT(l.nr_cep) AS 'Total de CEPs'
FROM localidade loc
JOIN logradouro l ON loc.cd_localidade = l.cd_localidade
WHERE loc.fl_tipo_localidade = 'M'
GROUP BY loc.nm_localidade, loc.sg_uf
HAVING COUNT(l.nr_cep) > 1
ORDER BY COUNT(l.nr_cep) DESC;

-- Listar qual o nome do logradouro mais popular no Brasil, ou seja, o que é encontrado no maior número de municípios. Atenção, aqui poderá haver mais 
-- de um logradouro, haja vista que podem apresentar o mesmo número de ocorrências e, neste caso, todos os empatados na 1a. posição (maior número) 
-- devem ser exibidos; 
CREATE INDEX idx_logradouro_nome_localidade ON logradouro (nm_logradouro, cd_localidade);

EXPLAIN
SELECT 
    l.nm_logradouro AS 'Logradouro', 
    COUNT(DISTINCT l.cd_localidade) AS 'Total de Municípios'
FROM logradouro l
GROUP BY l.nm_logradouro
HAVING COUNT(DISTINCT l.cd_localidade) = (
    SELECT COUNT(DISTINCT l.cd_localidade)
    FROM logradouro l
    GROUP BY l.nm_logradouro
    ORDER BY COUNT(DISTINCT l.cd_localidade) DESC
    LIMIT 1
)
ORDER BY l.nm_logradouro ASC;
