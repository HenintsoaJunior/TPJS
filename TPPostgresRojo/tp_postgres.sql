CREATE DATABASE tp_postgres;

CREATE USER tp WITH PASSWORD 'tp';
ALTER USER tp WITH SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE tp_postgres TO tp;

\c tp_postgres


CREATE TABLE Client (
	NumClient SERIAL PRIMARY KEY ,
	Nom VARCHAR(50),
	Prenom VARCHAR(50),
	Adresse VARCHAR(50),
	Tel VARCHAR(50),
	Compte VARCHAR(50)
);

CREATE TABLE Films (
	NumFilm SERIAL PRIMARY KEY,
	Titre VARCHAR(50),
	Genre VARCHAR(10),
	Prix DECIMAL(10,2),
	NombreDVD INT
);

CREATE TABLE Personne (
	NumPers SERIAL PRIMARY KEY,
	Nom VARCHAR(50),
	Prenom VARCHAR(50)
);

CREATE TABLE Locations(
	IdLocations SERIAL PRIMARY KEY,
	DateLoc DATE ,
	NbeJourLoc INT,
	Livraison VARCHAR(50),
	NumFilm INT REFERENCES Films(NumFilm),
    NumClient INT REFERENCES Client(NumClient)
);

CREATE TABLE Reservation (
	IdReservation SERIAL PRIMARY KEY,
	DateRes DATE,
	NbeJourRes INT,
	NumFilm INT REFERENCES Films(NumFilm),
	NumClient INT REFERENCES Client(NumClient)
);
CREATE TABLE Joue (
	NumPers INT REFERENCES Personne(NumPers),
	NumFilm INT REFERENCES Films(NumFilm)
);
CREATE TABLE Realise (
	NumPers INT REFERENCES Personne(NumPers),
	NumFilm INT REFERENCES Films(NumFilm)
);

*********************************************
INSERT INTO Client (Nom, Prenom, Adresse, Tel, Compte) VALUES
    ('Rabekoto', 'John', 'MB 171', '0342236466', 'Compte123'),
    ('Rakotoarimanana', 'Henintsoa', 'HO55TERA', '0382325899', 'Compte456'),
	('Junior', 'Andria', 'AB185', '032556988', 'Compte455'),
	('Bekoto', 'Merse', 'MA456', '0345569855', 'Compte454'),
	('Marina', 'Lava', 'MM145', '038454466', 'Compte453'),
	('Rojo', 'Niaiana', 'MA1789', '032654488', 'Compte452'),
	('Razafinjoelina', 'Tahina', 'MB456', '0386966655', 'Compte451'),
	('Smith', 'Jane', '456 Rue B', '555-5678', 'Compte456');

***************************************************
INSERT INTO Films (Titre, Genre, Prix, NombreDVD) VALUES
    ('Avengers', 'Action', 9.99, 50),
    ('Inception', 'Science', 7.99, 30),
	('Boika' , 'Action',80 ,20),
	('Fast' ,'Action',40.1,100),
	('Clochete' ,'Aventure',10.1,60),
	('Barbie' ,'Romance',90.1,100),
	('Roi Lion' ,'Action',20.1,70),
	('Main' ,'Horreur',80.1,100),
	('First Love' ,'Romance',60.1,100),
	('John wick' ,'Action',100.1,100);

****************************************************

INSERT INTO Personne (Nom, Prenom) VALUES
    ('Smith', 'John'),
    ('Doe', 'Jane'),
	('Junior', 'Rax'),
	('Maxime', 'Rajoa'),
	('MadMax', 'BadBoy');

*****************************************************
INSERT INTO Locations (DateLoc, NbeJourLoc, Livraison, NumFilm, NumClient) VALUES
    ('2023-09-01', 3, TRUE, 1, 1),
    ('2023-08-02', 5, FALSE, 2, 2),
	('2023-09-03', 5, FALSE, 3, 3),
	('2023-09-04', 6, FALSE, 1, 2),
	('2023-09-05', 5, FALSE, 2, 2),
	('2023-09-06', 4, FALSE, 3, 2),
	('2023-09-07', 2, FALSE, 4, 1),
	('2023-09-08', 5, FALSE, 2, 4),
	('2023-09-09', 3, FALSE, 3, 1),
	('2023-09-10', 7, FALSE, 3, 1);

*******************************************************
INSERT INTO Reservation (DateRes, NbeJourRes, NumFilm, NumClient) VALUES
    ('2023-10-03', 2, 1, 2),
    ('2023-10-04', 4, 2, 1),
	('2023-10-05', 3, 3, 3),
	('2023-10-06', 5, 4, 4),
	('2023-10-07', 6, 2, 5);

********************************************************
INSERT INTO Joue (NumPers, NumFilm) VALUES
    (1, 1),
    (2, 2),
	(3, 2),
	(4, 4),
	(5, 5);
********************************************************
INSERT INTO Realise (NumPers, NumFilm) VALUES
    (1, 3),
    (2, 4),
	(3, 1),
	(2, 5),
	(1, 3);
*********************************************************
CREATE VIEW V_CliLocFil AS
SELECT C.Nom, C.Prenom , F.Titre
FROM Client C
INNER JOIN Locations L ON C.NumClient = L.NumClient
INNER JOIN Films F ON L.NumFilm = F.NumFilm;

SELECT * FROM  V_CliLocFil WHERE Titre = 'Avengers';
****************************************
SELECT 
P.Nom,
P.Prenom
FROM Personne P
INNER JOIN Joue J ON P.NumPers = J.NumPers
INNER JOIN Realise R ON P.NumPers = R.NumPers
WHERE J.NumFilm = R.NumFilm

****************************************

SELECT *

FROM Films F
INNER JOIN Locations L ON F.NumFilm = L.NumFilm
INNER JOIN Reservation R ON F.NumFilm = R.NumFilm

WHERE L.NumFilm ISNULL AND R.NumFilm ISNULL;

****************************************
SELECT F.Titre, COALESCE(SUM(L.NbeJourLoc), 0) + COALESCE(SUM(R.NbeJourRes), 0) AS Popularite
FROM Films F
LEFT JOIN Locations L ON F.NumFilm = L.NumFilm
LEFT JOIN Reservation R ON F.NumFilm = R.NumFilm
GROUP BY F.Titre
ORDER BY Popularite DESC
LIMIT 3;

****************************************
SELECT C.NumClient, C.Nom, C.Prenom,
       COALESCE(COUNT(L.IdLocations), 0) AS NombreLocations,
       COALESCE(COUNT(R.IdReservation), 0) AS NombreReservations
FROM Client C
LEFT JOIN Locations L ON C.NumClient = L.NumClient
LEFT JOIN Reservation R ON C.NumClient = R.NumClient
GROUP BY C.NumClient, C.Nom, C.Prenom;
*****************************************

//sudo -i -u postgres
*****************************************
CREATE TABLE clients_mini AS
SELECT NumClient
FROM Client
GROUP BY NumClient
HAVING COUNT(*) < 2;

CREATE TABLE clients_medium AS
SELECT NumClient
FROM Client
GROUP BY NumClient
HAVING COUNT(*) >= 2 AND COUNT(*) < 5;

CREATE TABLE clients_premium AS
SELECT NumClient
FROM Client
GROUP BY NumClient
HAVING COUNT(*) >= 5;