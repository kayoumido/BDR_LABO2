USE cinema;

-- 1.
-- SELECT count(*) 
-- FROM Film 
-- 	INNER JOIN Realisateur
--		ON Film.idRealisateur = Realisateur.id
-- WHERE Realisateur.nom = 'Spielberg' AND Realisateur.prenom = 'Steven';

-- 2.
SELECT titre, ROUND(AVG(Salle.capacite), 2) AS avgCapacity
FROM Film
	INNER JOIN Seance
		ON Seance.idFilm = Film.id
	INNER JOIN Salle
		ON 
			Salle.noSalle = Seance.noSalle AND 
            Salle.idCinema = Seance.idCinema
GROUP BY Film.titre
ORDER BY avgCapacity DESC;

