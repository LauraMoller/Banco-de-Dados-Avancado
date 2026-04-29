-- Criando os grupos

	-- Administrador
	CREATE ROLE 'admin';
	GRANT SELECT, INSERT, UPDATE, DELETE
		 ON base_tutores.* TO 'admin';
		 
	-- Recepcionista 
	CREATE ROLE recep;
	GRANT SELECT ON base_tutores.atendimento TO 'recep';
	GRANT SELECT ON base_tutores.animal TO 'recep';
	GRANT INSERT, UPDATE, DELETE ON 
		base_tutores.animal TO 'recep';

	-- Veterinário
	CREATE ROLE veterinario;
	GRANT SELECT ON base_tutores.* TO 'veterinario';
	GRANT INSERT, UPDATE, DELETE ON 
		base_tutores.atendimento TO 'veterinario';


-- Criando um usuário para cada grupo

	-- Administrador
	CREATE USER 'laura'
		IDENTIFIED BY 'laura123';
		
	GRANT 'admin' TO 'laura';
	SET DEFAULT ROLE 'admin' FOR 'laura';
	
	-- Recepcionista
	CREATE USER 'recepcionista1'
		IDENTIFIED BY 'recp01';
	
	GRANT 'recep' TO 'recepcionista1';
	SET DEFAULT ROLE 'recep' FOR 'recepcionista1';
		
	-- Veterinário
	CREATE USER 'veterinario1'
		IDENTIFIED BY 'vet01';
		
	GRANT 'veterinario' TO 'veterinario1';
	SET DEFAULT ROLE 'veterinario' FOR 'veterinario1';
	
	
	-- Script dos testes abaixo
	

INSERT INTO tutor VALUES (6, 'Laura Möller', 'lala@hotmail.com', '(51)99999-9999');
DELETE FROM tutor  WHERE id_tutor = 6;
UPDATE tutor SET nm_tutor = 'Fernanda Alves M.' WHERE id_tutor=2;

INSERT INTO animal VALUES (11, 'Totó', '2024-01-01', 10.0, 'M', 1);
DELETE FROM animal  WHERE id_animal = 11;
UPDATE animal SET vl_peso = 8 WHERE id_animal=10;

INSERT INTO atendimento VALUES (12, '2025-12-12', 'teste', 1);
DELETE FROM atendimento  WHERE nr_atendimento = 12;
UPDATE atendimento SET dt_atendimento = '2020-01-01' WHERE nr_atendimento=10;