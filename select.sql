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
SELECT Cinema.nom     AS 'nomCinema',
       Seance.noSalle,
       Film.titre,
       DATE_FORMAT(Seance.dateHeure, '%d.%m.%Y') AS 'date',
       DATE_FORMAT(Seance.dateHeure, '%H:%i') AS 'heureDebut'
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

SELECT Cinema.nom,
       Cinema.localite
FROM Cinema
WHERE EXISTS(
    SELECT Seance.idCinema
    FROM Film
        INNER JOIN Seance
            ON Film.id = Seance.idFilm
    WHERE Cinema.id = Seance.idCinema
    GROUP BY Seance.idCinema
    HAVING MAX(Film.annee) - MIN(Film.annee) >= 20
)
ORDER BY Cinema.localite, Cinema.nom;
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
       COUNT(DISTINCT Cinema.nom, Salle.noSalle, Film.id)           AS 'nbFilm',
       COUNT(DISTINCT Cinema.nom, Salle.noSalle, Seance.dateHeure)  AS 'nbHeureDebut'
FROM Salle
    JOIN Cinema
        ON Salle.idCinema = Cinema.id
    LEFT JOIN Seance
        ON Salle.idCinema = Seance.idCinema
        AND Salle.noSalle = Seance.noSalle
    LEFT JOIN Film
        ON Seance.idFilm = Film.id
WHERE Cinema.localite = 'Lausanne'
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
       DATE_FORMAT(Seance.dateHeure, '%H:%i') AS 'heure',
       DATE_FORMAT(Seance.dateHeure, '%d.%m.%Y') AS 'date',
       Seance.tarif
FROM Seance
    JOIN Film
        ON Seance.idFilm = Film.id
    JOIN Realisateur
        ON Film.idRealisateur = Realisateur.id
    JOIN Salle
        ON Seance.idCinema = Salle.idCinema AND Seance.noSalle = Salle.noSalle
    JOIN Cinema
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
          GROUP BY Film.id
          HAVING MIN(tarif)
      )
ORDER BY Seance.dateHeure;

-- 11
-- Indiquer les séances dont le prix est supérieur au tarif moyen des séances pour un même
-- film.

SELECT Cinema.nom,
       Seance.noSalle,
       Film.titre,
       DATE_FORMAT(Seance.dateHeure, '%H:%i') AS 'heure',
       DATE_FORMAT(Seance.dateHeure, '%d.%m.%Y') AS 'date',
       Seance.tarif
FROM Film
    JOIN Seance
        ON Film.id = Seance.idFilm
    JOIN Cinema -- Utilisé pour afficher plus clairement les résulats
        ON Seance.idCinema = Cinema.id
WHERE Seance.tarif > (
    SELECT AVG(tarif)
    FROM Seance
    WHERE Seance.idFilm = Film.id
);


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


-- 13.
-- Lister tous les films (titre, année, nom et prénom du réalisateur) qui sont projetés dans un
-- cinéma dont au moins une autre séance du même film a lieu dans une salle différente.
-- Ne pas utiliser les clauses WHERE ou HAVING.
SELECT Film.titre,
       Film.annee,
       Realisateur.nom,
       Realisateur.prenom
FROM Film
    JOIN Realisateur
        ON Realisateur.id = Film.idRealisateur
    JOIN Seance AS S1
        ON S1.idFilm = Film.id
    JOIN Seance AS S2
        ON S1.id <> S2.id AND
           S1.idFilm = S2.idFilm AND
           S1.noSalle <> S2.noSalle AND
           S1.idCinema = S2.idCinema
    JOIN Cinema
        ON Cinema.id = S1.idCinema
GROUP BY Film.id, Film.titre;

-- 14
-- Pour chaque cinéma (localité et nom), indiquer le nombre de salles de cinéma, la capacité
-- moyenne (2 digits de précision) et s'il existe des séances à moins de 12 CHF. Utiliser
-- un(des) LEFT JOIN (pas de EXISTS, ...)
SELECT Cinema.localite,
       Cinema.nom,
       COUNT(DISTINCT Salle.idCinema, Salle.noSalle) AS 'nbSalle',
       ROUND(AVG(Salle.capacite), 2) AS 'moyenneCapacite',
       Seance.tarif IS NOT NULL AS aSeanceMoinsDe12Frs
FROM Cinema
    JOIN Salle
        ON Cinema.id = Salle.idCinema
    LEFT JOIN Seance
        ON Salle.idCinema = Seance.idCinema
        AND Salle.noSalle = Seance.noSalle
        AND Seance.tarif < 12
GROUP BY Cinema.localite, Cinema.nom, aSeanceMoinsDe12Frs;

-- 15.
-- Vérifier qu'une salle ne projette jamais plusieurs films de 2004 simultanément.
SELECT Cinema.nom,
       Seance.noSalle,
       DATE_FORMAT(Seance.dateHeure, '%H:%i') AS 'heure',
       DATE_FORMAT(Seance.dateHeure, '%d.%m.%Y') AS 'date'
FROM Seance
    JOIN Film
        ON Seance.idFilm = Film.id
    JOIN Cinema -- Uniquement pour un affichage plus clair
        ON Seance.idCinema = Cinema.id
WHERE Film.annee = 2004
GROUP BY Seance.idCinema, Seance.noSalle, Seance.dateHeure
HAVING COUNT(Seance.id) > 1;
