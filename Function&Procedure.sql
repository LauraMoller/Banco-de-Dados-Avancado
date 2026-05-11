-- Criando um FUNCTION
DELIMITER $$
CREATE  OR REPLACE FUNCTION fc_tempo_servico (p_data DATE) RETURNS integer
BEGIN
   DECLARE data_atual DATE;
   SET data_atual = (select CURDATE());
   RETURN YEAR(data_atual) - YEAR(p_data);
END $$

-- Testando a Function
select fc_tempo_servico ('2000-01-31');

-- --------------------------------------------------------------------

-- Function que retorna a margem de lucro de um produto
SELECT * FROM medicamento;

DELIMITER $$
CREATE OR REPLACE FUNCTION fc_margem_lucro_med (p_medicamento INT) RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
	DECLARE v_custo DECIMAL (8,2) DEFAULT 0.00;
	DECLARE v_venda DECIMAL (8,2) DEFAULT 0.00;
	DECLARE v_margem DECIMaL (8,2) DEFAULT 0.00;
	SELECT m.vl_custo, m.vl_venda INTO v_custo, v_venda
	FROM medicamento m WHERE m.cd_medicamento = p_medicamento;
	SET v_margem = ROUND((v_venda - v_custo) / v_venda * 100,2);
	RETURN v_margem;
END $$

select fc_margem_lucro_med (1);

-- Procedure Atualiza todos os valores dos medicamentos 
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp_atualiza_valor_medicamento 
       (IN p_percentual INTEGER)
BEGIN
    UPDATE medicamento
       SET vl_venda = vl_venda + (vl_venda * p_percentual /100);
END $$

-- Chamada (Atualiza todos os medicamentos em 20%)
CALL sp_atualiza_valor_medicamento (20);
