DROP DATABASE IF EXISTS CemiterioDescanseEmPaz;
CREATE DATABASE CemiterioDescanseEmPaz;
USE CemiterioDescanseEmPaz;


CREATE TABLE Usuario(
IdUsuario INT AUTO_INCREMENT,
Email VARCHAR(50) UNIQUE,
Nome VARCHAR(50),
Senha VARCHAR(50),
Permissao ENUM ('admin', 'usuario') NOT NULL,
PRIMARY KEY (IdUsuario)
);


CREATE TABLE Concessionario (
	CPF VARCHAR(16) NOT NULL,
    Nome VARCHAR(25) NOT NULL,
    Sexo ENUM ('Masculino', 'Feminino') NOT NULL,
    Telefone VARCHAR(11) NOT NULL,
    EnderecoRua VARCHAR(60) NOT NULL,
    EnderecoBairro VARCHAR(30) NOT NULL,
    EnderecoCidade VARCHAR(30) NOT NULL,
    EnderecoEstado ENUM("AC",
    "AL",
    "AP",
    "AM",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MS",
    "MG",
    "PA",
    "PB",
    "PR",
    "PE",
    "PI",
    "RR",
    "RO",
    "RJ",
    "RN",
    "RS",
    "SC",
    "SP",
    "SE",
    "TO"),
    PRIMARY KEY (CPF)
);

CREATE TABLE Jazigo (
	IdJazigo INT AUTO_INCREMENT NOT NULL,
    Quadra INT NOT NULL,
    Sepultura INT NOT NULL,
    GavetasDisponiveis INT NOT NULL,
    TemConcessao BOOLEAN NOT NULL,
    UNIQUE (Quadra, Sepultura),
    PRIMARY KEY (IdJazigo)
);

CREATE TABLE Concessao (
	IdConcessao INT AUTO_INCREMENT,
	IdJazigo_FK INT UNIQUE,
    CPFConcessionario_FK VARCHAR(16),
    Tipo ENUM ('Perpetua', 'Temporaria') NOT NULL,
    PRIMARY KEY (IdConcessao),
	FOREIGN KEY (IdJazigo_FK) REFERENCES Jazigo (IdJazigo) ON DELETE SET NULL,
	FOREIGN KEY (CPFConcessionario_FK) REFERENCES Concessionario (CPF) ON DELETE SET NULL
);

CREATE TABLE Falecido (
	IdFalecido INT AUTO_INCREMENT NOT NULL,
    Nome VARCHAR(25) NOT NULL,
    Sexo ENUM ('Masculino', 'Feminino') NOT NULL,
	Situacao ENUM ('Exumado', 'Sepultado') NOT NULL,
    DataNascimento DATE NOT NULL,
    DataObito DATE NOT NULL,
    FK_IdJazigo INT NOT NULL,
    PRIMARY KEY (IdFalecido),
    FOREIGN KEY (FK_IdJazigo) REFERENCES Jazigo (IdJazigo)
);


CREATE TABLE OrdemServico(
idOrdemServico INT AUTO_INCREMENT,
CPFConcessionario_FK VARCHAR(16),
dataCriacao DATE NOT NULL,
dataVencimento DATE NOT NULL,
total DOUBLE NOT NULL,
PRIMARY KEY(idOrdemServico),
FOREIGN KEY (CPFConcessionario_FK) REFERENCES Concessionario (CPF) ON DELETE SET NULL
);

CREATE TABLE TipoServico(
idTipoServico INT AUTO_INCREMENT,
idOrdemServico_FK INT,
TipoServico VARCHAR(50) NOT NULL,
ValorServico FLOAT NOT NULL,
QuantidadeServico INT NOT NULL,
PRIMARY KEY(idTipoServico),
FOREIGN KEY (idOrdemServico_FK) REFERENCES OrdemServico (idOrdemServico) ON DELETE SET NULL
);


CREATE TABLE ServicoGerado(
IdServicoGerado INT AUTO_INCREMENT,
NomeServico VARCHAR(50) NOT NULL,
PrecoServico Double NOT NULL,
PRIMARY KEY (IdServicoGerado)
);

insert into Usuario(Email, senha, nome, permissao) values ("adm@cemiterio.com.br", "1234", "Luiz Henrique Lessa", "admin");
insert into Usuario(Email, senha, nome, permissao) values ("user@cemiterio.com.br", "1234", "Adriano de Paula", "usuario");


INSERT INTO Concessionario
VALUES  ('111.111.111-11', 'Umberto Uno', 'Masculino', '11111111111', 'Rua 1, 111', 'Vale Unilateral', 'São Paulo', 'SP'),
		('222.222.222-22', 'Sam Wilson', 'Masculino', '22222222222', 'Rua Capitão América, 22', 'Jardim Falcoaria', 'Xique-xique', 'BA'),
		('333.333.333-33', 'Helena Silva', 'Feminino', '33333333333', 'Avenida Presidente Juscelino, 333', 'Centro', 'Londrina', 'PR');
        

INSERT INTO Jazigo
VALUES  (null, 1, 1, 4, TRUE),
		(null, 1, 5, 2, TRUE),
        (null, 3, 2, 4, TRUE ),
        (null, 2, 12, 3, TRUE);


INSERT INTO Falecido
VALUES  (null, 'Steve Rogers', 'Masculino', 'Sepultado', '1918-07-04', '2019-11-28', 3),
		(null, 'Tony Stark', 'Masculino', 'Sepultado', '1970-03-07', '2019-08-15', 3),
        (null, 'Natasha Romanov', 'Feminino', 'Sepultado', '1984-08-12', '2019-06-21', 2),
        (null, 'Carmélia da Silva', 'Feminino', 'Sepultado', '1946-11-15', '2021-11-18', 2),
        (null, 'José Tobias', 'Masculino', 'Sepultado', '1965-03-25', '2014-05-22', 1),
        (null, 'Romancito Pereira', 'Masculino', 'Sepultado','1973-09-17', '2017-02-03', 1);
        
        
INSERT INTO Concessao
VALUES  (null, 1, '111.111.111-11', 'Temporaria'),
		(null, 2, '333.333.333-33', 'Temporaria'),
        (null, 3, '222.222.222-22', 'Perpetua');

DROP TRIGGER IF EXISTS atualizaJazigo;
CREATE TRIGGER atualizaJazigo
AFTER DELETE
ON Concessao FOR EACH ROW
UPDATE Jazigo 
SET temConcessao = false
WHERE idJazigo = old.idJazigo_FK;





