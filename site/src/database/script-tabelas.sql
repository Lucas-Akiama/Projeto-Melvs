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
     nome VARCHAR(45)
    , email VARCHAR(45)
    , senha VARCHAR(256)
    , cpf CHAR(14) 
    , planos varchar(15), constraint chkPlanos check (planos in ('Silver', 'Gold', 'Platinum'))
    , fkTipo int, foreign key (fktipo) references tipoPerfil(idTipoPerfil)  
	, primary key (cpf, fkTipo)
);


insert into tipoPerfil values
(null, 'admin'),
(null, 'analista');

CREATE TABLE empresa(
	 cnpj CHAR(18) primary key
    , nomeFantasia VARCHAR(45)
    , estado CHAR(2)
    , cidade VARCHAR(45)
    , cep CHAR(9)
    , complemento VARCHAR(45)
);

create table relacao_usuario_empresa(
fkUsuario char(14),
fkEmpresa char(18), 
fkTipoPerfil int,
 foreign key(fkEmpresa) references empresa(cnpj),
dtRelacao datetime default current_timestamp,
 primary key(fkUsuario, fkTipoPerfil, fkEmpresa),
 FOREIGN KEY (fkUsuario, fkTipoPerfil) REFERENCES usuario (cpf, fkTipo)
);

CREATE TABLE armazem(
	idArmazem INT unique AUTO_INCREMENT
    , nome VARCHAR(45)
    , fkEmpresa char(18)
	, FOREIGN KEY (fkEmpresa) REFERENCES empresa(cnpj)
    , PRIMARY KEY (idArmazem, fkEmpresa)
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
    , dtLeitura DATETIME DEFAULT CURRENT_TIMESTAMP
    , fkSensor int, foreign key(fkSensor) references sensor(idSensor)
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
