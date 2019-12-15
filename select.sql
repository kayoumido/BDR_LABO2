USE cinema;

-- 1.
-- Donner le nombre de films réalisés par Steven Spielberg.
SELECT count(*) AS 'nbFilm'
FROM Film
    JOIN Realisateur
        ON Film.idRealisateur = Realisateur.id
WHERE Realisateur.nom = 'Spielberg'
  AND Realisateur.prenom = 'Steven';

-- 2.
SELECT titre, ROUND(AVG(Salle.capacite), 2) AS avgCapacity
FROM Film
    JOIN Seance
        ON Seance.idFilm = Film.id
    JOIN Salle
        ON
            Salle.noSalle = Seance.noSalle AND
            Salle.idCinema = Seance.idCinema
GROUP BY Film.titre
ORDER BY avgCapacity DESC;

-- 3. 
-- Indiquer toutes les séances (nom du cinéma, no de la salle, titre du film) ayant lieu à Yverdon-les-Bains, 
--  qui coûtent moins de 15 CHF et qui ont lieu en soirée(à partir de 20h).
SELECT Cinema.nom     AS 'cinema',
       Seance.noSalle AS 'noSalle',
       Film.titre     AS 'film',
       Seance.dateHeure,
       Seance.tarif,
       Cinema.localite
FROM Seance
    JOIN Film
        ON Seance.idFilm = Film.id
    JOIN Cinema
        ON Seance.idCinema = Cinema.id
WHERE HOUR(Seance.dateHeure) >= 20
    AND Cinema.localite = 'Yverdon-les-bains'
    AND Seance.tarif < 15;

-- 4.
-- Pour chaque réalisateur (nom, prénom), indiquer l’âge qu’il avait lors de la réalisation de son
-- premier film (âge à l’année civile courantedu film). Ordonner les résultats 1°) par ordre croissant
-- d’âge lors dupremier film réalisé, 2°) par ordre croissant du nom, 3°) par ordre croissant du prénom.
SELECT  Realisateur.nom,
        Realisateur.prenom,
        (MIN(Film.annee) - Realisateur.anneeNaissance) AS age
FROM Realisateur
    JOIN Film
        ON Realisateur.id = Film.idRealisateur
GROUP BY Realisateur.nom, Realisateur.prenom, Realisateur.anneeNaissance
ORDER BY age, Realisateur.nom, Realisateur.prenom;

-- 5.
-- Lister le programme complet concernant les films de Michael Moore (date de la séance,
-- heure de début de la séance, lieu, nom du cinéma, no de la salle, titre du film, tarif).
SELECT DATE_FORMAT(Seance.dateHeure, '%d.%m.%Y') AS 'date',
       DATE_FORMAT(Seance.dateHeure, '%H:%i') AS 'heureDebut',
       Cinema.localite,
       Cinema.nom,
       Seance.noSalle,
       Film.titre,
       Seance.tarif
FROM Seance
    JOIN Film
        ON Seance.idFilm = Film.id
    JOIN Realisateur
        ON Film.idRealisateur = Realisateur.id
    JOIN Cinema
        ON Seance.idCinema = Cinema.id
WHERE Realisateur.nom = 'Moore'
    AND Realisateur.prenom = 'Michael';

-- 6.
-- Indiquer le(s) cinéma(s) (nom, localité) ayant projeté des films dont la différence
-- d’années entre le plus ancien et le plus récent est d’au moins 20 ans. Trié par localité, puis
-- nom. Utiliser le prédicat EXISTS.

SELECT nom,
       localite
FROM Cinema
WHERE EXISTS(
    SELECT any_value(Film.id)
    FROM Film
        INNER JOIN Seance
            ON Film.id = Seance.idFilm
    WHERE Cinema.id = Seance.idCinema
    HAVING MAX(Film.annee) - MIN(Film.annee) >= 20
);

-- 7
-- Lister les cinémas (nom et localité) projetant des films réalisés par Michael Moore ou
-- possédant une salle avec une capacité supérieure à 100 places. Utiliser l’opérateur
-- UNION.

SELECT DISTINCT Cinema.nom,
                Cinema.localite
FROM Cinema
    JOIN Seance
        ON Cinema.id = Seance.idCinema
    JOIN Film
        ON Seance.idFilm = Film.id
    JOIN Realisateur
        ON Film.idRealisateur = Realisateur.id
WHERE Realisateur.prenom = 'Michael'
    AND Realisateur.nom = 'Moore'
UNION
SELECT DISTINCT Cinema.nom,
                Cinema.localite
FROM Cinema
    JOIN Salle
        ON Cinema.id = Salle.idCinema
WHERE Salle.capacite > 100