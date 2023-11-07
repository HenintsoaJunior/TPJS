-- 1. Création de la base de données "tp_postgres"
CREATE DATABASE tp_postgres;

-- 2. Création de l'utilisateur "tp" avec accès à la base "tp_postgres"
CREATE USER tp WITH PASSWORD 'votre_mot_de_passe';
GRANT ALL PRIVILEGES ON DATABASE tp_postgres TO tp;

-- Connexion à la base de données
\c tp_postgres

-- 3. Création des tables (avec les clés étrangères)
CREATE TABLE Client (
    NumClient SERIAL PRIMARY KEY,
    Nom VARCHAR(255),
    Prenom VARCHAR(255),
    Adresse VARCHAR(255),
    Tel VARCHAR(15),
    Compte VARCHAR(255)
);

CREATE TABLE Films (
    NumFilm SERIAL PRIMARY KEY,
    Titre VARCHAR(255),
    Genre VARCHAR(255),
    Prix DECIMAL(10, 2),
    NombreDVD INT
);

CREATE TABLE Personne (
    NumPers SERIAL PRIMARY KEY,
    Nom VARCHAR(255),
    Prenom VARCHAR(255)
);

CREATE TABLE Locations (
    IdLocation SERIAL PRIMARY KEY,
    DateLoc DATE,
    NbeJourLoc INT,
    Livraison BOOLEAN,
    NumFilm INT REFERENCES Films(NumFilm),
    NumClient INT REFERENCES Client(NumClient)
);

CREATE TABLE Reservations (
    IdReservation SERIAL PRIMARY KEY,
    DateRes DATE,
    NbJourRes INT,
    NumFilm INT REFERENCES Films(NumFilm),
    NumClient INT REFERENCES Client(NumClient)
);

CREATE TABLE Joue (
    NumPers INT REFERENCES Personne(NumPers),
    NumFilm INT REFERENCES Films(NumFilm),
    PRIMARY KEY (NumPers, NumFilm)
);

CREATE TABLE Realise (
    NumPers INT REFERENCES Personne(NumPers),
    NumFilm INT REFERENCES Films(NumFilm),
    PRIMARY KEY (NumPers, NumFilm)
);

-- Exemples de données (vous pouvez ajuster les données selon vos besoins)
-- Clients
INSERT INTO Client (Nom, Prenom, Adresse, Tel, Compte) VALUES
    ('Doe', 'John', '123 Rue A', '555-1234', 'Compte123'),
    ('Smith', 'Jane', '456 Rue B', '555-5678', 'Compte456'),
    -- Ajoutez les autres clients ici...

-- Films
INSERT INTO Films (Titre, Genre, Prix, NombreDVD) VALUES
    ('Avengers', 'Action', 9.99, 50),
    ('Inception', 'Science Fiction', 7.99, 30),
    -- Ajoutez les autres films ici...

-- Personnes
INSERT INTO Personne (Nom, Prenom) VALUES
    ('Smith', 'John'),
    ('Doe', 'Jane'),
    -- Ajoutez les autres personnes ici...

-- Locations
INSERT INTO Locations (DateLoc, NbeJourLoc, Livraison, NumFilm, NumClient) VALUES
    ('2023-09-01', 3, TRUE, 1, 1),
    ('2023-09-02', 5, FALSE, 2, 2),
    -- Ajoutez d'autres locations ici...

-- Reservations
INSERT INTO Reservations (DateRes, NbJourRes, NumFilm, NumClient) VALUES
    ('2023-09-03', 2, 1, 2),
    ('2023-09-04', 4, 2, 1),
    -- Ajoutez d'autres réservations ici...

-- Joue
INSERT INTO Joue (NumPers, NumFilm) VALUES
    (1, 1),
    (2, 2),
    -- Ajoutez d'autres associations ici...

-- Realise
INSERT INTO Realise (NumPers, NumFilm) VALUES
    (1, 3),
    (2, 4),
    -- Ajoutez d'autres associations ici...
SELECT C.Nom, C.Prenom
FROM Client C
INNER JOIN Locations L ON C.NumClient = L.NumClient
INNER JOIN Films F ON L.NumFilm = F.NumFilm
WHERE F.Titre = 'Avengers';


SELECT P.Nom, P.Prenom
FROM Personne P
INNER JOIN Joue J ON P.NumPers = J.NumPers
INNER JOIN Realise R ON P.NumPers = R.NumPers
WHERE J.NumFilm = R.NumFilm;

SELECT F.Titre
FROM Films F
LEFT JOIN Locations L ON F.NumFilm = L.NumFilm
LEFT JOIN Reservations R ON F.NumFilm = R.NumFilm
WHERE L.NumFilm IS NULL AND R.NumFilm IS NULL;


SELECT F.Titre, COALESCE(SUM(L.NbeJourLoc), 0) + COALESCE(SUM(R.NbJourRes), 0) AS Popularite
FROM Films F
LEFT JOIN Locations L ON F.NumFilm = L.NumFilm
LEFT JOIN Reservations R ON F.NumFilm = R.NumFilm
GROUP BY F.Titre
ORDER BY Popularite DESC
LIMIT 3;


SELECT C.NumClient, C.Nom, C.Prenom,
       COALESCE(COUNT(L.IdLocation), 0) AS NombreLocations,
       COALESCE(COUNT(R.IdReservation), 0) AS NombreReservations
FROM Client C
LEFT JOIN Locations L ON C.NumClient = L.NumClient
LEFT JOIN Reservations R ON C.NumClient = R.NumClient
GROUP BY C.NumClient, C.Nom, C.Prenom;


-- Création des tables de clients
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
