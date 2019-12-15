USE cinema;

-- 1.
-- Donner le nombre de films réalisés par Steven Spielberg.
SELECT count(*) AS "Nb Film"
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
SELECT Cinema.nom     AS 'Cinema',
       Seance.noSalle AS 'N° Salle',
       Film.titre     AS 'Film',
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
    AND Realisateur.prenom = 'Michael'



