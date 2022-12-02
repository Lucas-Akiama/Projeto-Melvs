CREATE DATABASE melvs;

USE melvs;

create table tipoPerfil(
idTipoPerfil int primary key auto_increment,
descPerfil varchar(45)
);

CREATE TABLE usuario(
	idUsuario INT PRIMARY KEY AUTO_INCREMENT
    , nome VARCHAR(45)
    , email VARCHAR(45)
    , senha VARCHAR(45)
    , cpf CHAR(11)
    , planos varchar(15), constraint chkPlanos check (planos in ('Silver', 'Gold', 'Platinum'))
    , fkTipo int, foreign key (fktipo) references tipoPerfil(idTipoPerfil)  
);

CREATE TABLE empresa(
	idEmpresa INT AUTO_INCREMENT primary key
    , cnpj CHAR(14)
    , nomeFantasia VARCHAR(45)
    , estado CHAR(2)
    , cidade VARCHAR(45)
    , cep CHAR(8)
    , complemento VARCHAR(45)
);

create table relacao_usuario_empresa(
fkUsuario int, foreign key(fkUsuario) references usuario(idUsuario),
fkTipoPerfil int, foreign key(fkTipoPerfil) references tipoPerfil(idTipoPerfil),
fkEmpresa int, foreign key(fkEmpresa) references empresa(idEmpresa),
relacaoEmpresa int,
dtRelacao datetime,
primary key(fkUsuario, fkTipoPerfil, fkEmpresa)
);

CREATE TABLE armazem(
	idArmazem INT AUTO_INCREMENT
    , nome VARCHAR(45)
    , fkEmpresa INT
	, FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
    , PRIMARY KEY (idArmazem, fkEmpresa)
);

CREATE TABLE sensor(
	idSensor INT PRIMARY KEY AUTO_INCREMENT
    , nome VARCHAR(45)
    , fkArmazem INT
    , FOREIGN KEY (fkArmazem) REFERENCES armazem(idArmazem)
    , fkEmpresa INT
	, FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE leitura (
	idLeitura INT AUTO_INCREMENT
    , temperatura1 DOUBLE
    , umidade1 DOUBLE
    , temperatura2 DOUBLE
    , umidade2 DOUBLE
    , temperatura3 DOUBLE
    , umidade3 DOUBLE
    , temperatura4 DOUBLE
    , umidade4 DOUBLE
    , temperatura5 DOUBLE
    , umidade5 DOUBLE
    , dtLeitura DATETIME DEFAULT CURRENT_TIMESTAMP
    , fkSensor int, foreign key(fkSensor) references sensor(idSensor)
);
