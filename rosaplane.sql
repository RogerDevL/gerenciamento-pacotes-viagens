CREATE DATABASE RosaPlane;

USE RosaPlane;

CREATE TABLE Destinos(
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100),
    pais VARCHAR(100),
    descricao VARCHAR(100)
);

CREATE TABLE Pacotes(
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100),
    preco INT,
    dataInicio DATE,
    dataTermino DATE, 
    idDestino INT,
    FOREIGN KEY (idDestino) REFERENCES Destinos(id)
);

CREATE TABLE Clientes(
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100),
    telefone VARCHAR(100),
    endereco VARCHAR(100)
);

CREATE TABLE Reservas(
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    dataReserva DATE,
    numeroPessoas INT,
	statusReserva VARCHAR(100),
	idCliente INT,
    idPacote INT,
     FOREIGN KEY (idCliente) REFERENCES Clientes(id),
	 FOREIGN KEY (idPacote) REFERENCES Pacotes(id)
);


INSERT INTO Destinos (nome,pais,descricao)
VALUES ("Fortaleza","Brasil","Lugar muito bom para se divertir"),
("Bahamas","Bahamas","Lugar maravilhoso");
 
INSERT INTO Pacotes (nome,preco,dataInicio,dataTermino,idDestino)
VALUES ("Seu sonho aqui",6500,'2025-08-24','2025-08-30',1),
("Vem praK",9000,'2025-08-30','2025-09-05',2);

INSERT INTO Clientes (nome,email,telefone,endereco)
VALUES ("Roger","roger@gmail.com","11 911280718","Rua Criciuma"),
("Felipe","felipe@gmail.com","11 912394844","Rua Anapolis");
 
INSERT INTO Reservas (dataReserva,numeroPessoas,statusReserva,idCLiente,idPacote)
VALUES ('2025-04-20',5,"confirmada",1,1),
('2025-05-20',3,"pendente",2,2);

-- View para visualizar total dos preços
CREATE VIEW visualizar_preco_viagens AS 
SELECT SUM(preco) AS total_preco FROM Pacotes;

SELECT * FROM visualizar_preco_viagens;

-- View para listar os pacotes de viagem com detalhes de destino
CREATE VIEW vw_PacotesComDestino AS
SELECT 
    Pacotes.id AS idPacote,
    Pacotes.nome AS pacote,
    Pacotes.preco,
    Pacotes.dataInicio,
    Pacotes.dataTermino,
    Destinos.nome,
    Destinos.pais,
    Destinos.descricao AS descricaoDestino
FROM 
    Pacotes
JOIN 
    Destinos ON Pacotes.idDestino = Destinos.id;

-- View para listar reservas com detalhes do cliente e do pacote
CREATE VIEW vw_ReservasComDetalhes AS
SELECT 
    Reservas.id AS idReserva,
    Reservas.dataReserva,
    Reservas.numeroPessoas,
    Reservas.statusReserva,
    Clientes.nome AS clientes,
    Clientes.email,
    Clientes.telefone,
    Pacotes.nome AS Pacote,
    Pacotes.preco,
    Destinos.nome,
    Destinos.pais
FROM 
    Reservas
JOIN 
    Clientes ON Reservas.idCliente = Clientes.id
JOIN 
    Pacotes ON Reservas.idPacote = Pacotes.id
JOIN 
    Destinos ON Pacotes.idDestino = Destinos.id;

-- View para listar todos os clientes e seus pacotes reservados
CREATE VIEW vw_ClientesComReservas AS
SELECT 
    Clientes.id AS idCliente,
    Clientes.nome AS Clientes,
    Clientes.email,
    Reservas.id AS idReserva,
    Reservas.dataReserva,
    Reservas.numeroPessoas,
    Reservas.statusReserva,
    Pacotes.nome
FROM 
    Clientes
LEFT JOIN 
    Reservas ON Clientes.id = Reservas.idCliente
LEFT JOIN 
    Pacotes ON Reservas.idPacote = Pacotes.id;

-- View para mostrar o faturamento esperado por destino
CREATE VIEW vw_FaturamentoPorDestino AS
SELECT 
    Destinos.id AS idDestino,
    Destinos.nome,
    Destinos.pais,
    SUM(Pacotes.preco * Reservas.numeroPessoas) AS faturamentoEstimado
FROM 
    Reservas
JOIN 
    Pacotes ON Reservas.idPacote = Pacotes.id
JOIN 
    Destinos ON Pacotes.idDestino = Destinos.id
WHERE 
    Reservas.statusReserva = 'confirmada'
GROUP BY 
    Destinos.id;

-- View para listar reservas pendentes de confirmação
CREATE VIEW v_ReservasPendentes AS
SELECT 
    Reservas.id AS idReserva,
    Clientes.nome AS Clientes,
    Clientes.email,
    Pacotes.nome AS pacote,
    Destinos.nome,
    Reservas.dataReserva,
    Reservas.numeroPessoas,
    Reservas.statusReserva
FROM 
    Reservas
JOIN 
    Clientes ON Reservas.idCliente = Clientes.id
JOIN 
    Pacotes ON Reservas.idPacote = Pacotes.id
JOIN 
    Destinos ON Pacotes.idDestino = Destinos.id
WHERE 
    Reservas.statusReserva = 'pendente';

 
 
SELECT * FROM Destinos;
SELECT * FROM Pacotes;
SELECT * FROM Clientes;
SELECT * FROM Reservas;

DROP TABLE Destinos;
DROP TABLE Pacotes;
DROP TABLE Clientes;
DROP TABLE Reservas;
DROP DATABASE RosaPlane;