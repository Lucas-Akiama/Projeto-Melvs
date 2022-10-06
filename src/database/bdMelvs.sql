CREATE DATABASE bdMelvs;

USE bdMelvs;

-- Criação das tabelas
CREATE TABLE empresa(
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (50) NOT NULL,
    cnpj VARCHAR (18) NOT NULL, 
	estado CHAR (2) NOT NULL,
    cidade VARCHAR (45) NOT NULL, 
	cep VARCHAR (14) NOT NULL,
    complemento VARCHAR (15)
);

CREATE TABLE cadastro(
	idCadastro INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL, 
	email VARCHAR (30), CONSTRAINT chkemail CHECK (email LIKE '%@%'),
	senha VARCHAR (30) NOT NULL,
    cpf VARCHAR (15) NOT NULL,
    idEmpresa INT,
    FOREIGN KEY (idEmpresa) REFERENCES empresa(idEmpresa) 
);
    
CREATE TABLE sensor( 
	idSensor INT PRIMARY KEY AUTO_INCREMENT, 
	dtSensor DATETIME DEFAULT CURRENT_TIMESTAMP, 
	temperatura DOUBLE, 
	umidade DOUBLE 
); 

-- Exibição das Tabelas
SELECT * FROM sensor;

SELECT * FROM cadastro;
    
SELECT * FROM empresa;

-- Inserção de dados
INSERT INTO empresa(nome,cnpj,estado,cidade,cep) 
	VALUES('SojasExpress','12.345.678/1234-12','SP','São Paulo','08151000'),
			('SuperSoja','98.765.432/1342-13','MG','Boa Vista','50501000'),
			('Farm Soya','52.555.968/9841-35','MT','Sorriso','12124000');
    
INSERT INTO cadastro (nome,email,senha,cpf,idEmpresa)
	VALUES('Gustavo','gustavo@gmaisl.com','123456789','44785069813',1),
			('Rafael','rafael@gmail.com','987654321','55066512341',2),
			('Lucas','lucas@gmail.com','147852369','98855123614',3)	;
    
INSERT INTO sensor (temperatura,umidade)
	VALUES (45,22),
			(20,30),
			(10,52);