SELECT * FROM medicamento;
SELECT * FROM notafiscal;
SELECT * FROM itemnotafiscal;

-- Criando um gatilho para atualizar o estoque de um medicamento vendido
DELIMITER $$
CREATE OR REPLACE TRIGGER tg_venda_medicamento BEFORE INSERT
	ON itemnotafiscal FOR EACH ROW
BEGIN
	DECLARE var_vl_medicamento DECIMAL(8,2) DEFAULT 0.0;
	DECLARE var_qnt_estoque INT DEFAULT 0;
	-- Obtendo a quantidade em estoque do medicamento
	SELECT m.qt_estoque INTO var_qnt_estoque
		FROM medicamento m
			WHERE m.cd_medicamento = NEW.cd_medicamento;
	-- testando se há estoque suficiente
	IF var_qnt_estoque < NEW.qt_vendida THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: Estoque insuficiente para este medicamento.';
   END IF;
	-- Reduzindo a quantidade do estoque
	UPDATE medicamento m
		SET m.qt_estoque = m.qt_estoque - NEW.qt_vendida
		WHERE m.cd_medicamento = NEW.cd_medicamento;
	-- obtendo o valor do medicamento e armazenando em var_vl_medicamento
	SELECT m.vl_venda INTO var_vl_medicamento FROM medicamento m 
		WHERE m.cd_medicamento = NEW.cd_medicamento;
	-- ajustando o valor da venda
	SET NEW.vl_venda = var_vl_medicamento;		
	-- Atualizando o valor total da NF 
	UPDATE notafiscal nf SET nf.vl_total = nf.vl_total + (NEW.qt_vendida * NEW.vl_venda)
		WHERE nf.nr_notafiscal = NEW.nr_notafiscal;
END $$


-- Validando 
INSERT INTO cliente (nm_cliente) VALUES ('José');
INSERT INTO notafiscal (cd_cliente) VALUES (1);
INSERT INTO itemnotafiscal (nr_notafiscal, cd_medicamento, qt_vendida, vl_venda) VALUES (1, 1, 2, 0);