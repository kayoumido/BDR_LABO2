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
    SELECT ANY_VALUE(Film.id)
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
WHERE Salle.capacite > 100;

-- 8.
-- Pour chaque salle de cinéma de Lausanne (nom et numéro), indiquer le nombre de films
-- différents, ainsi que le nombre d’heures de début de séance différentes.
SELECT Cinema.nom,
       Salle.noSalle,
       COUNT(Film.id)           AS 'nbFilms',
       COUNT(Seance.dateHeure)  AS 'nbHeureDebut'
FROM Salle
    INNER JOIN Cinema
        ON Salle.idCinema = Cinema.id
    INNER JOIN Seance
        ON Salle.idCinema = Seance.idCinema
        AND Salle.noSalle = Seance.noSalle
    INNER JOIN Film
        ON Seance.idFilm = Film.id
GROUP BY Cinema.nom, Salle.noSalle;

-- 9
-- Lister tous les films projetés dans au moins 3 salles différentes
SELECT Film.titre
FROM Film
    JOIN Seance
        ON Film.id = Seance.idFilm
GROUP BY Film.titre
HAVING COUNT(DISTINCT Seance.idFilm, Seance.idCinema, Seance.noSalle) >= 3;

-- 10.
-- Indiquer la(les) projection(s) programmée(s) (titre du film, nom et localité du cinéma,
-- no de la salle, date, heure de début de la séance et tarif) où le tarif est le plus avantageux pour
-- aller voir un film de Steven Spielberg. Classer les résultats par heure de début croissante.

SELECT Film.titre,
       Cinema.nom,
       Cinema.localite,
       Salle.noSalle,
       Seance.dateHeure,
       Seance.tarif
FROM Seance
    INNER JOIN Film
        ON Seance.idFilm = Film.id
    INNER JOIN Realisateur
        ON Film.idRealisateur = Realisateur.id
    INNER JOIN Salle
        ON Seance.idCinema = Salle.idCinema AND Seance.noSalle = Salle.noSalle
    INNER JOIN Cinema
        ON Salle.idCinema = Cinema.id
WHERE Realisateur.nom = 'Spielberg' AND
      Realisateur.prenom = 'Steven' AND
      Film.id IN (
          SELECT Film.id
          FROM Seance
              INNER JOIN Salle
                  ON Seance.idCinema = Salle.idCinema AND
                     Seance.noSalle = Salle.noSalle
              INNER JOIN Film
                  ON Seance.idFilm = Film.id
          GROUP BY idFilm
          HAVING MIN(tarif)
      )
ORDER BY Seance.dateHeure;

-- 11
-- Indiquer les séances dont le prix est supérieur au tarif moyen des séances pour un même
-- film.

-- TRES MOCHE MAIS FONCTIONNE JE CROIS

SELECT Seance.id
FROM Seance
    JOIN (SELECT idFilm, AVG(tarif) AS moyenne
              FROM Seance
              GROUP BY idFilm) AS S_AVG
          ON Seance.idFilm = S_AVG.idFilm
WHERE Seance.tarif > S_AVG.moyenne;

-- 12 En considérant un taux de remplissage uniforme de 50%, indiquer les films (titre et
-- année) dans l’ordre décroissant de leur chiffre d’affaire. Lister au maximum 20 films.

SELECT Film.titre,
       Film.annee
FROM Film
    JOIN Seance
        ON Film.id = Seance.idFilm
    JOIN Salle
        ON Seance.noSalle = Salle.noSalle
        AND Seance.idCinema = Salle.idCinema
GROUP BY Film.titre, Film.annee
ORDER BY SUM(Salle.capacite * Seance.tarif * 0.5) DESC LIMIT 20;