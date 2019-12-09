DROP DATABASE IF EXISTS cinema;
CREATE DATABASE IF NOT EXISTS cinema;
USE cinema;

-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Cinema (
  id INTEGER UNSIGNED AUTO_INCREMENT,
  nom varchar(50) NOT NULL,
  localite varchar(50) NOT NULL,
  CONSTRAINT PK_Cinema PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- --------------------------------------------------------

-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Salle (
  idCinema INTEGER UNSIGNED,
  noSalle INTEGER UNSIGNED,
  capacite SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT PK_Salle PRIMARY KEY (idCinema, noSalle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- --------------------------------------------------------

-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Realisateur (
  id INTEGER UNSIGNED AUTO_INCREMENT,
  nom varchar(50) NOT NULL,
  prenom varchar(50) NOT NULL,
  anneeNaissance SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT PK_Realisateur PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- --------------------------------------------------------

-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Film (
  id INTEGER UNSIGNED AUTO_INCREMENT,
  idRealisateur INTEGER UNSIGNED NOT NULL,
  titre varchar(50) NOT NULL,
  annee SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT PK_Film PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- --------------------------------------------------------

-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Seance (
  id INTEGER UNSIGNED AUTO_INCREMENT,
  dateHeure datetime NOT NULL,
  idCinema INTEGER UNSIGNED NOT NULL,
  noSalle INTEGER UNSIGNED NOT NULL,
  idFilm INTEGER UNSIGNED NOT NULL,
  tarif TINYINT UNSIGNED NOT NULL,
  CONSTRAINT PK_Seance PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- --------------------------------------------------------

-- --------------------------------------------------------
ALTER TABLE Film ADD CONSTRAINT FK_Film_idRealisateur
	FOREIGN KEY (idRealisateur) REFERENCES Realisateur (id);
ALTER TABLE Salle ADD CONSTRAINT FK_Salle_idCinema
	FOREIGN KEY (idCinema) REFERENCES Cinema (id);
ALTER TABLE Seance ADD CONSTRAINT FK_Seance_idCinema_noSalle
	FOREIGN KEY (idCinema, noSalle) REFERENCES Salle (idCinema, noSalle);
ALTER TABLE Seance ADD CONSTRAINT FK_Seance_idFilm
	FOREIGN KEY (idFilm) REFERENCES Film (id);	
-- --------------------------------------------------------

-- --------------------------------------------------------
INSERT INTO Cinema (nom, localite)
VALUES ('Bel air', 'Yverdon-les-Bains'),
       ('Rex', 'Yverdon-les-Bains'),
       ('Capitol', 'Yverdon-les-Bains'),
       ('Les Galeries', 'Lausanne'),
       ('Europlex Flon', 'Lausanne'),
	   ('Cinétoile Malley', 'Lausanne');
-- --------------------------------------------------------

-- --------------------------------------------------------
INSERT INTO Salle (idCinema, noSalle, capacite)
VALUES (1, 1, 80),
       (2, 1, 80),
       (3, 1, 110),
       (4, 1, 45),
       (4, 2, 60),
	   (4, 3, 60),
	   (4, 4, 80),
	   (4, 5, 80),
	   (4, 6, 80),
	   (4, 7, 150),
	   (5, 1, 60),
	   (5, 2, 60),
	   (5, 3, 60),
	   (5, 4, 75),
	   (5, 5, 75),
	   (5, 6, 90),
	   (5, 7, 120),
	   (6, 1, 60),
	   (6, 2, 60),
	   (6, 3, 80),
	   (6, 4, 80),
	   (6, 5, 80),
	   (6, 8, 120);
-- --------------------------------------------------------

-- --------------------------------------------------------
INSERT INTO Realisateur (nom, prenom, anneeNaissance)
VALUES ('Anderson', 'Paul', 1970),
       ('Rogozhkin', 'Aleksander', 1969),
       ('Jaoui', 'Agnès', 1964),
       ('Adamson', 'Andrew', 1972),
       ('Moore', 'Michael', 1954),
       ('Spielberg', 'Steven', 1947),
       ('Demme', 'Jonathan', 1930),
       ('Baratier', 'Christophe', 1956);
-- --------------------------------------------------------
	   
-- --------------------------------------------------------
INSERT INTO Film (idRealisateur, titre, annee)
VALUES (1, 'Alien vs Predator', 2004),
       (2, 'Kukushka', 2004),
       (3, 'Comme une image', 2004),
       (4, 'Shrek', 2001),
       (4, 'Shrek 2', 2004),
       (5, 'Fahrenheit 9/11', 2004),
       (5, 'Bowling for Columbine', 2002),
       (6, 'Le terminal', 2004),
       (6, 'E.T. the Extra-Terrestrial', 1976),
       (6, 'Indiana Jones and the Temple of Doom', 1984),
       (6, 'Jurassic Park', 1993),
       (6, 'Il faut sauver le soldat Ryan', 1998),
       (6, 'Something Evil', 1972),
       (7, 'Un crime dans la tête', 2004),
       (8, 'Les Choristes', 2004),
       (4, 'Shrek 5', 2021);
-- --------------------------------------------------------

-- --------------------------------------------------------
INSERT INTO Seance (dateHeure, idCinema, noSalle, idFilm, tarif)
VALUES ('2004-11-15 18:00:00', 1, 1, 1, 10),
       ('2004-11-15 20:00:00', 2, 1, 1, 10),
	   ('2004-11-15 20:00:00', 2, 1, 2, 10),
	   ('2004-11-16 18:00:00', 3, 1, 3, 10),
	   ('2004-11-15 18:00:00', 4, 1, 4, 12),
	   ('2004-11-15 18:00:00', 4, 3, 5, 13),
	   ('2004-11-15 20:00:00', 4, 5, 6, 14),
	   ('2004-11-16 22:00:00', 5, 3, 7, 15),
	   ('2004-11-17 18:00:00', 6, 4, 5, 16),
	   ('2004-11-18 20:00:00', 6, 5, 7, 16),
	   ('2004-11-18 22:00:00', 5, 2, 9, 16),
	   ('2004-11-19 18:00:00', 5, 3, 10, 16),
	   ('2004-11-18 20:00:00', 1, 1, 10, 10),
	   ('2004-11-18 22:00:00', 2, 1, 10, 10),
	   ('2004-11-18 22:00:00', 3, 1, 11, 10),
	   ('2004-11-19 18:00:00', 6, 2, 12, 16),
	   ('2004-11-19 22:00:00', 6, 2, 13, 14),
	   ('2004-11-19 23:30:00', 6, 3, 14, 14),
	   ('2004-11-20 13:30:00', 6, 5, 15, 14),
	   ('2004-11-20 16:00:00', 6, 5, 15, 14),
	   ('2004-11-20 18:00:00', 6, 5, 8, 14),
	   ('2004-11-20 22:00:00', 6, 5, 11, 14),
	   ('2004-11-20 23:30:00', 6, 5, 13, 14),
	   ('2004-11-20 23:30:00', 5, 5, 13, 14);
-- --------------------------------------------------------
