DESC cliente;

-- Alterando a estrutura de cliente
-- obs.: os campos são maiores que os nºs, pois serão criptografados
ALTER TABLE cliente
ADD COLUMN ds_senha VARCHAR(200),
ADD COLUMN nr_cpf VARCHAR(100);


-- Criptografando com SHA2
INSERT INTO cliente (nm_cliente, ds_senha)
	VALUES ('Maria', SHA2('12345',256)); -- senha é 12345
	
	
SELECT "Ok! Usuário autenticado :)!" AS STATUS 
	FROM cliente 
	WHERE nm_cliente = 'Maria' AND ds_senha = SHA2('12345', 256);
	
-- Criptografando com MD5

INSERT INTO cliente (nm_cliente, ds_senha)
	VALUES ('Ana', MD5('12345'));
	
	
SELECT "Ok! Usuário autenticado :)!" AS STATUS 
	FROM cliente 
	WHERE nm_cliente = 'Maria' AND ds_senha = MD5 ('12345');
	
-- Criptografia reversível 
-- Criptografando 
ALTER TABLE cliente MODIFY COLUMN nr_cpf VARBINARY(100);
	
UPDATE cliente SET nr_cpf = AES_ENCRYPT('123456789-01', 'chave')
	WHERE cd_cliente = 7;
	
--Descriptografando 
SELECT C.nm_cliente AS NOME, AES_DECRYPT(c.nr_cpf, 'chave') AS CPF FROM cliente C;
	
SELECT * FROM cliente;
