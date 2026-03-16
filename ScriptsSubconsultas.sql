-- Recuperar o(s) acessório(s) que não estão associado(s) a nenhum veículo;
SELECT a.cd_acessorio, a.ds_acessorio
FROM acessorio a
WHERE NOT EXISTS (
    SELECT va.cd_acessorio
    FROM veiculo_acessorio va
    WHERE va.cd_acessorio = a.cd_acessorio
);

--  Listar a descrição do(s) acessório(s) mais popular (que mais é encontrado entre os veículos cadastrados);
SELECT a.cd_acessorio, a.ds_acessorio, COUNT(*) AS qtde
FROM acessorio a, veiculo_acessorio va
WHERE a.cd_acessorio = va.cd_acessorio
GROUP BY a.cd_acessorio, a.ds_acessorio
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM veiculo_acessorio
    GROUP BY cd_acessorio
);

-- Listar a descrição da marca que possui o maior número de veículos cadastrado;
SELECT ma.cd_marca, ma.ds_marca, COUNT(*) AS qtde
FROM veiculo v, modelo mo, marca ma
WHERE v.cd_modelo = mo.cd_modelo
AND mo.cd_marca = ma.cd_marca
GROUP BY ma.cd_marca, ma.ds_marca
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM veiculo v, modelo mo
    WHERE v.cd_modelo = mo.cd_modelo
    GROUP BY mo.cd_marca
);

-- Listar a descrição do combustível que apresenta o menor número de veículos associado;
SELECT c.cd_combustivel, c.ds_combustivel, COUNT(*) AS qtde
FROM veiculo v, veiculo_combustivel vc, combustivel c
WHERE v.nr_placa = vc.nr_placa
AND vc.cd_combustivel = c.cd_combustivel
GROUP BY c.cd_combustivel, c.ds_combustivel
HAVING COUNT(*) <= ALL (
    SELECT COUNT(*)
    FROM veiculo_combustivel vc, combustivel c
    WHERE vc.cd_combustivel = c.cd_combustivel
    GROUP BY c.cd_combustivel
);

-- Listar a(s) marca(s) e modelo(s) de veículo(s) movido(s) ao combustível "Elétrico" e que apresenta(m) acessório "ADAS".
SELECT ma.ds_marca, mo.ds_modelo
FROM marca ma, modelo mo, veiculo v
WHERE ma.cd_marca = mo.cd_marca
AND mo.cd_modelo = v.cd_modelo
AND v.nr_placa IN (
    SELECT vc.nr_placa
    FROM veiculo_combustivel vc, combustivel c, veiculo_acessorio va, acessorio a
    WHERE vc.cd_combustivel = c.cd_combustivel
    AND vc.nr_placa = va.nr_placa
    AND va.cd_acessorio = a.cd_acessorio
    AND c.ds_combustivel = 'Elétrico'
    AND a.ds_acessorio = 'ADAS'
);
