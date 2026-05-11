-- Categoria de Produto (com margem de lucro)
CREATE TABLE Categoria (
    cd_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nm_categoria VARCHAR(100) NOT NULL,
    pc_margem_lucro DECIMAL(5,2) DEFAULT 0.00  -- percentual de margem
);
 
-- Vinculando ao medicamento:
ALTER TABLE Medicamento
ADD cd_categoria INT,
ADD FOREIGN KEY (cd_categoria) REFERENCES Categoria(cd_categoria);
 
-- Exemplo de dados:
INSERT INTO Categoria (nm_categoria, pc_margem_lucro) VALUES
('Analgésicos', 40.00),
('Antibióticos', 35.00),
('Antifúngicos', 45.00),
('Vitaminas e Suplementos', 30.00),
('Intestinais',25.00);
 
-- Atualização dos medicamentos já existentes com categorias
UPDATE Medicamento SET cd_categoria = 1 WHERE nm_medicamento LIKE '%Benegripe%' OR nm_medicamento LIKE '%Aspirina%';
UPDATE Medicamento SET cd_categoria = 2 WHERE nm_medicamento LIKE '%Cataflan%' OR nm_medicamento LIKE '%Dermatos%';
UPDATE Medicamento SET cd_categoria = 3 WHERE nm_medicamento LIKE '%Vodol%';
UPDATE Medicamento SET cd_categoria = 4 WHERE nm_medicamento LIKE '%Vick%';
UPDATE Medicamento SET cd_categoria = 1 WHERE nm_medicamento LIKE '%Doralgina%';

-- ----------------------------------------------------------------------------------------- 
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp_atualiza_preco_venda_por_categoria (IN p_categoria INT)
BEGIN
    IF p_categoria IS NULL THEN
        UPDATE medicamento m
        JOIN categoria c ON m.cd_categoria = c.cd_categoria
        SET m.vl_venda = ROUND(m.vl_custo * (1 + (c.pc_margem_lucro / 100)), 2);
    ELSE 
        UPDATE medicamento m
        JOIN categoria c ON m.cd_categoria = c.cd_categoria
        SET m.vl_venda = ROUND(m.vl_custo * (1 + (c.pc_margem_lucro / 100)), 2)
        WHERE m.cd_categoria = p_categoria;
    END IF; 
END $$

-- Testando a PROCEDURE criada
CALL sp_atualiza_preco_venda_por_categoria(NULL);

UPDATE categoria SET pc_margem_lucro = 100 WHERE cd_categoria = 1 ;

SELECT * FROM medicamento;
SELECT * FROM categoria

DELIMITER $$
CREATE OR REPLACE PROCEDURE sp_lista_medicamentos_cat (IN p_categoria INT)
BEGIN 
    SELECT 
        m.nm_medicamento, 
        m.qt_estoque, 
        m.vl_venda, 
        fc_margem_lucro_med (m.cd_medicamento) AS margem_lucro
    FROM medicamento m 
    INNER JOIN categoria c ON m.cd_categoria = c.cd_categoria
    WHERE m.cd_categoria = p_categoria;
END $$

-- Testando a procedure criada que retorna a liste de medicamentos da categoria
CALL sp_lista_medicamentos_cat(1);
