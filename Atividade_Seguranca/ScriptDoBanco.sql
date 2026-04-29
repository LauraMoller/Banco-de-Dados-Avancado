-- Table: animal
CREATE TABLE animal (
    id_animal int  NOT NULL,
    nm_animal varchar(50)  NOT NULL,
    dt_nascimento date  NOT NULL,
    vl_peso decimal(4,1)  NOT NULL,
    fl_sexo char(1)  NOT NULL,
    tutor_id_tutor int  NOT NULL,
    CONSTRAINT animal_pk PRIMARY KEY (id_animal)
);
 
-- Table: atendimento
CREATE TABLE atendimento (
    nr_atendimento int  NOT NULL,
    dt_atendimento date  NOT NULL,
    ds_atendimento varchar(100)  NOT NULL,
    animal_id_animal int  NOT NULL,
    CONSTRAINT atendimento_pk PRIMARY KEY (nr_atendimento)
);
 
-- Table: tutor
CREATE TABLE tutor (
    id_tutor int  NOT NULL,
    nm_tutor varchar(50)  NOT NULL,
    ds_email varchar(50)  NOT NULL,
    nr_telefone varchar(15)  NOT NULL,
    CONSTRAINT tutor_pk PRIMARY KEY (id_tutor)
);
 
-- foreign keys
-- Reference: animal_tutor (table: animal)
ALTER TABLE animal ADD CONSTRAINT animal_tutor FOREIGN KEY animal_tutor (tutor_id_tutor)
    REFERENCES tutor (id_tutor);
 
-- Reference: atendimento_animal (table: atendimento)
ALTER TABLE atendimento ADD CONSTRAINT atendimento_animal FOREIGN KEY atendimento_animal (animal_id_animal)
    REFERENCES animal (id_animal);
 
-- ==========================
-- INSERÇÃO DE DADOS - TABELA TUTOR
-- ==========================
INSERT INTO tutor (id_tutor, nm_tutor, ds_email, nr_telefone) VALUES
(1, 'Carlos Mendes', 'carlos.mendes@email.com', '(11) 98877-1122'),
(2, 'Fernanda Alves', 'fernanda.alves@email.com', '(11) 97766-3344'),
(3, 'João Pereira', 'joao.pereira@email.com', '(21) 99655-7788'),
(4, 'Mariana Rocha', 'mariana.rocha@email.com', '(31) 98544-6677'),
(5, 'Rafael Lima', 'rafael.lima@email.com', '(41) 98433-5566');
 
-- ==========================
-- INSERÇÃO DE DADOS - TABELA ANIMAL
-- ==========================
INSERT INTO animal (id_animal, nm_animal, dt_nascimento, vl_peso, fl_sexo, tutor_id_tutor) VALUES
(1, 'Rex',       '2020-03-15', 25.3, 'M', 1),
(2, 'Luna',      '2019-07-22', 18.7, 'F', 2),
(3, 'Thor',      '2021-01-10', 30.1, 'M', 3),
(4, 'Mia',       '2022-09-05',  4.2, 'F', 4),
(5, 'Bob',       '2018-11-11', 12.8, 'M', 5),
(6, 'Mel',       '2023-04-25',  5.6, 'F', 1),
(7, 'Simba',     '2020-12-02',  7.4, 'M', 2),
(8, 'Nina',      '2021-06-19', 10.5, 'F', 3),
(9, 'Toby',      '2019-02-14', 21.0, 'M', 4),
(10, 'Lola',     '2022-01-30',  6.8, 'F', 5);
 
-- ==========================
-- INSERÇÃO DE DADOS - TABELA ATENDIMENTO
-- ==========================
INSERT INTO atendimento (nr_atendimento, dt_atendimento, ds_atendimento, animal_id_animal) VALUES
(1, '2024-01-15', 'Consulta de rotina e vacinação anual', 1),
(2, '2024-02-10', 'Exame de sangue e check-up geral', 2),
(3, '2024-03-12', 'Tratamento de otite', 3),
(4, '2024-04-05', 'Castração', 4),
(5, '2024-05-21', 'Aplicação de antipulgas e vermífugo', 5),
(6, '2024-06-15', 'Limpeza dentária', 6),
(7, '2024-07-02', 'Curativo em ferimento na pata', 7),
(8, '2024-08-09', 'Retorno pós-castração', 4),
(9, '2024-09-18', 'Consulta de rotina', 8),
(10,'2024-10-01', 'Alergia cutânea e medicação', 9),
(11,'2024-10-10', 'Vacinação múltipla', 10);