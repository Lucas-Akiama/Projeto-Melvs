-- Arquivo de apoio, caso você queira criar tabelas como as aqui criadas para a API funcionar.
-- Você precisa executar os comandos no banco de dados para criar as tabelas,
-- ter este arquivo aqui não significa que a tabela em seu BD estará como abaixo!

/*
comandos para mysql - banco local - ambiente de desenvolvimento
*/

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




/*
comando para sql server - banco remoto - ambiente de produção
*/

CREATE TABLE usuario (
	id INT PRIMARY KEY IDENTITY(1,1),
	nome VARCHAR(50),
	email VARCHAR(50),
	senha VARCHAR(50),
);

CREATE TABLE aviso (
	id INT PRIMARY KEY IDENTITY(1,1),
	titulo VARCHAR(100),
	descricao VARCHAR(150),
	fk_usuario INT FOREIGN KEY REFERENCES usuario(id)
);

create table aquario (
/* em nossa regra de negócio, um aquario tem apenas um sensor */
	id INT PRIMARY KEY IDENTITY(1,1),
	descricao VARCHAR(300)
);

/* esta tabela deve estar de acordo com o que está em INSERT de sua API do arduino - dat-acqu-ino */

CREATE TABLE medida (
	id INT PRIMARY KEY IDENTITY(1,1),
	dht11_umidade DECIMAL,
	dht11_temperatura DECIMAL,
	luminosidade DECIMAL,
	lm35_temperatura DECIMAL,
	chave TINYINT,
	momento DATETIME,
	fk_aquario INT FOREIGN KEY REFERENCES aquario(id)
);

/*
comandos para criar usuário em banco de dados azure, sqlserver,
com permissão de insert + update + delete + select
*/

CREATE USER [usuarioParaAPIWebDataViz_datawriter_datareader]
WITH PASSWORD = '#Gf_senhaParaAPIWebDataViz',
DEFAULT_SCHEMA = dbo;

EXEC sys.sp_addrolemember @rolename = N'db_datawriter',
@membername = N'usuarioParaAPIWebDataViz_datawriter_datareader';

EXEC sys.sp_addrolemember @rolename = N'db_datareader',
@membername = N'usuarioParaAPIWebDataViz_datawriter_datareader';
