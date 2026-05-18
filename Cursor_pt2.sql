-- zerando estoque dos medicamentos
update Medicamento set qt_estoque = 0 where 1=1;
 
CREATE TABLE LoteMedicamento (
cd_lote INT AUTO_INCREMENT,
cd_medicamento INT NOT NULL,
nr_lote VARCHAR(50) NOT NULL,
dt_fabricacao DATE,
dt_validade DATE NOT NULL,
qt_lote INT NOT NULL DEFAULT 0,
vl_custo_lote DECIMAL(8,2),
st_lote CHAR(1) DEFAULT 'A', -- (A)tivo (V)encido (E)sgotado (B)loqueado
PRIMARY KEY (cd_lote),
FOREIGN KEY (cd_medicamento)
        REFERENCES Medicamento(cd_medicamento)
);
 
INSERT INTO LoteMedicamento
(cd_medicamento, nr_lote, dt_fabricacao, dt_validade, qt_lote, vl_custo_lote)
VALUES
(1,'BEN2025001','2025-01-10','2026-01-10',20,5.00),
(1,'BEN2025002','2025-03-15','2026-07-15',15,5.20),
(2,'ASP2025001','2025-02-01','2026-02-01',30,7.00),
(2,'ASP2024009','2024-01-01','2026-09-01',5,6.90),
(3,'DER2025001','2025-04-01','2027-04-01',40,20.00),
(3,'DER2025002','2025-04-15','2026-05-20',8,19.50),
(4,'CAT2025001','2025-03-10','2026-12-10',25,10.00),
(5,'REM2025001','2025-01-20','2026-01-20',18,35.00),
(6,'BGE2025001','2025-02-15','2026-11-15',50,9.00),
(7,'DGE2025001','2025-03-01','2026-08-01',12,50.00),
(8,'VOD2025001','2025-04-01','2027-04-01',22,21.20),
(9,'VIC2025001','2025-02-01','2026-02-01',60,11.50),
(10,'DOR2025001','2025-01-01','2026-05-25',7,9.90);

-- ----------------------------------------------------------------------------------------------------
SELECT * FROM lotemedicamentos;

-- Selecionar o medicamento com a respectiva quantidade em estoque considerando os diferentes lotes
SELECT m.nm_medicamento AS 'Medicamento', SUM(l.qt_lote) AS 'Quantidade em estoque'
FROM medicamento m 
JOIN lotemedicamento l ON (m.cd_medicamento = l.cd_medicamento)
GROUP BY m.nm_medicamento;

-- Rotina para atualizar o estoque dos medicamentos após lançamentos em lotes
-- Sem parâmetros
delimiter $
CREATE OR REPLACE PROCEDURE sp_atualiza_estoque_med()

BEGIN
			UPDATE medicamento m
			SET qt_estoque = (SELECT SUM(l.qt_lote)
									FROM lotemedicamento l
									WHERE m.cd_medicamento = l.cd_medicamento 
										AND l.st_lote = 'A'); -- Lote A
END $

-- Testando a rotina criada 
CALL sp_atualiza_estoque_med(); -- Deverá atualizar o estoque de cada medicamento


-- -----------------------------------------------------------------------------------------------------------------------------

-- Rotina para baixar estoque medicamento vendido considerando a quantidade em cada lote 
-- sendo que devem ser "baixadas" as quantidades dos lotes mais próximos do vencimento
-- parânmetro de entrada o id do medicamento e a quantidade vendida
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp_baixa_estoque_med(IN p_med INT, IN p_qtde INT)
BEGIN
	DECLARE v_controle INT DEFAULT 1;
	DECLARE v_cd_lote INT;
   DECLARE v_qt_lote INT; 
   DECLARE v_quantidade_restante INT;
	DECLARE cursor_estoque CURSOR FOR SELECT l.cd_lote, l.qt_lote
																FROM lotemedicamento l
																WHERE l.cd_medicamento = p_med 
																AND l.st_lote = 'A'
        														ORDER BY l.dt_validade ASC;
	DECLARE CONTINUE handler FOR NOT FOUND SET v_controle=0;
	SET v_quantidade_restante = p_qtde;
	OPEN cursor_estoque; 
	loop_atualiza_estoque:loop
		FETCH cursor_estoque INTO v_cd_lote, v_qt_lote;
		IF v_controle = 0 THEN
				leave loop_atualiza_estoque;
		END if;
		IF v_quantidade_restante = 0 THEN
				leave loop_atualiza_estoque; 
		END if;				
		
		IF v_qt_lote >= v_quantidade_restante THEN
			UPDATE lotemedicamento l 
            SET l.qt_lote = l.qt_lote - v_quantidade_restante,
				st_lote = IF((qt_lote - v_quantidade_restante) = 0, 'E', 'A')
            WHERE cd_lote = v_cd_lote;
            SET v_quantidade_restante = 0;             
      ELSE
            SET v_quantidade_restante = v_quantidade_restante - v_qt_lote;            
            UPDATE lotemedicamento l 
            SET l.qt_lote = 0,
                st_lote = 'E'
            WHERE cd_lote = v_cd_lote;  
      END IF;		
	END loop loop_atualiza_estoque;
	close cursor_estoque;		
END $$

CALL sp_baixa_estoque_med (1, 1);
CALL sp_baixa_estoque_med (1, 20);

