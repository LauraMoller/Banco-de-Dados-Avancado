-- a) Criação de uma view para listar a descrição da marca, a descrição do modelo e a quantidade de veículos cadastrados;
CREATE VIEW vw_veiculos 
AS
SELECT m.ds_marca AS marca, mo.ds_modelo AS modelo, COUNT(*) AS quantidade
FROM modelo mo, marca m, veiculo v
WHERE mo.cd_marca = m.cd_marca
AND v.cd_modelo = mo.cd_modelo
GROUP BY m.ds_marca, mo.ds_modelo;

-- b)  Criação de uma view para listar dados completos dos veículos: placa, descrição da marca, descrição do modelo, descrição dos acessórios e descrição do combustível que o move, 
-- O resultado desta busca poderá resultar na repetição dos do veículo (placa, marca e modelo) face a apresentação de mais de um combustível e/ou acessório;

CREATE VIEW vw_veiculos_completo
AS
SELECT v.nr_placa AS placa,
			ma.ds_marca AS 'marca',
			mo.ds_modelo AS 'modelo',
			a.ds_acessorio AS 'acessorio',
			c.ds_combustivel AS 'combustível'
FROM veiculo v, marca ma, modelo mo, veiculo_acessorio va, combustivel c, acessorio a, veiculo_combustivel vc
WHERE v.cd_modelo = mo.cd_modelo
	AND mo.cd_marca = ma.cd_marca
	AND v.nr_placa = va.nr_placa
	AND va.cd_acessorio = a.cd_acessorio
	AND v.nr_placa = vc.nr_placa
	AND vc.cd_combustivel = c.cd_combustivel
GROUP BY v.nr_placa, ma.ds_marca, mo.ds_modelo, a.ds_acessorio, c.ds_combustivel;

-- c) Criação de uma view para listar o nome da localidade com a respectiva quantidade proprietários associada (que residem na respectiva localidade);
CREATE VIEW vw_localidade_proprietarios
AS
SELECT l.nm_localidade, COUNT(*) AS 'quantidade de proprietários'
FROM localidade l, proprietario p
WHERE l.cd_localidade = p.cd_localidade
GROUP BY l.cd_localidade, l.nm_localidade;

-- d) Criação de uma view para listar a descrição do acessório com a respectiva quantidade de veículos associados a cada acessório listado;
CREATE OR REPLACE VIEW vw_veiculo_acessorio
AS
SELECT a.ds_acessorio AS 'acessorio', COUNT(*) AS 'quantidade de veículos associados'
FROM acessorio a, veiculo_acessorio va
WHERE a.cd_acessorio = va.cd_acessorio
GROUP BY a.ds_acessorio;

-- e) Criação de uma view para listar a descrição do modelo, a descrição da marca, ano do modelo e a respectiva cor de cada veículo;
CREATE VIEW vw_modelo
AS
SELECT mo.ds_modelo AS 'modelo', ma.ds_marca AS 'marca', v.nr_ano_mod AS 'Ano de fabricação', c.ds_cor AS 'cor'
FROM modelo mo, marca ma, veiculo v, cor c
WHERE v.cd_modelo = mo.cd_modelo
	AND mo.cd_marca = ma.cd_marca
	AND v.cd_cor = c.cd_cor;
