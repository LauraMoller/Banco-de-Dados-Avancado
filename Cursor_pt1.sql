-- Rotina para ajustar preço de medicamentos considerando parâmetros.
-- entrada: preço mínimo, preço máximo, desconto.
-- saída: sem retorno.
delimiter $$
CREATE OR REPLACE PROCEDURE sp_atualiza_preco (IN p_ini DECIMAL(8,2),
												IN p_fim DECIMAL(8,2),
												IN p_percentual DECIMAL (4,2))
BEGIN
	DECLARE v_controle INT DEFAULT 1; -- Controle de cursor
	DECLARE v_custo DECIMAL(8,2); -- recebe o valor do medicamento
	DECLARE v_preco_ajustado DECIMAL(8,2); -- Mantém o novo preço do medicamento
	DECLARE v_medicamento INT; -- Recebe o id do medicamento
	-- Criando o cursor
	DECLARE cursor_medicamentos CURSOR FOR SELECT m.cd_medicamento, m.vl_custo
																FROM medicamento m
																WHERE m.vl_custo BETWEEN p_ini AND p_fim;
	-- declarando o tratamento para o fim do cursor
	DECLARE CONTINUE handler FOR NOT FOUND SET v_controle=0;
	OPEN cursor_medicamentos; -- manda executar o select
	loop_med: loop
		-- atribuindo valores das colunas para as variáveis
		FETCH cursor_medicamentos INTO v_medicamento, v_custo; -- atribui valores das colunas às variáveis
		-- testando se fim da estrutura (dados do cursor)
		if v_controle = 0 THEN
			leave loop_med; -- interrompe o laço
		END if;
		SET v_preco_ajustado = v_custo - (v_custo * (p_percentual / 100));
		UPDATE medicamento m SET m.vl_venda = v_preco_ajustado -- atualiza o valor de venda
									WHERE m.cd_medicamento = v_medicamento; -- para cada medicamento obtido do cursor
	END loop;
	close cursor_medicamentos; -- fechamento do cursor (desaloca a estrutura de memória)
END $$
	
-- testando a rotina
CALL sp_atualiza_preco(10, 30, 50);	-- Medicamentos entre 10 e 30 reais terão 50% de deconto.
SELECT * FROM medicamento WHERE vl_custo BETWEEN 10 AND 30;

	SELECT m.cd_medicamento, m.vl_custo
																FROM medicamento m
																WHERE m.vl_custo BETWEEN p_ini AND p_fim;
