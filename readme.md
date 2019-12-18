```mysql
USE cinema;
```
##### 1. Donner le nombre de films réalisés par Steven Spielberg

```mysql
SELECT count(*) AS 'nbFilm'
FROM Film
    JOIN Realisateur
        ON Film.idRealisateur = Realisateur.id
WHERE Realisateur.nom = 'Spielberg'
  AND Realisateur.prenom = 'Steven';
```
###### Résultat :

| nbFilm |
| :--- |
| 6 |

##### 2. Pour chaque film projeté (titre), lister la capacité moyenne des salles le projetant, arrondi à deux chiffres après la virgule. Ordonner les résultats par ordre décroissant de la capacité moyenne.
```mysql
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
```
###### Résultat :
| titre | avgCapacity |
| :--- | :--- |
| Comme une image | 110.00 |
| Jurassic Park | 95.00 |
| Kukushka | 80.00 |
| Fahrenheit 9/11 | 80.00 |
| Un crime dans la tête | 80.00 |
| Les Choristes | 80.00 |
| Le terminal | 80.00 |
| Alien vs Predator | 80.00 |
| Indiana Jones and the Temple of Doom | 73.33 |
| Something Evil | 71.67 |
| Shrek 2 | 70.00 |
| Bowling for Columbine | 70.00 |
| Il faut sauver le soldat Ryan | 60.00 |
| E.T. the Extra-Terrestrial | 60.00 |
| Shrek | 45.00 |

##### 3. Indiquer toutes les séances (nom du cinéma, no de la salle, titre du film) ayant lieu à Yverdon-les-Bains, qui coûtent moins de 15 CHF et qui ont lieu en soirée (à partir de 20h).
```mysql
SELECT Cinema.nom AS 'nomCinema',
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
```
###### Résultat :
| cinema | noSalle | titre | date | hereDebut |
| :--- | :--- | :--- | :--- | :--- |
| Bel air | 1 | Indiana Jones and the Temple of Doom | 18.11.2004 | 20:00 |
| Rex | 1 | Alien vs Predator | 15.11.2004 | 20:00:00 |
| Rex | 1 | Kukushka | 15.11.2004 | 20:00 |
| Rex | 1 | Indiana Jones and the Temple of Doom | 18.11.2004 | 22:00 |
| Capitol | 1 | Jurassic Park | 18.11.2004 | 22:00 |

##### 4. Pour chaque réalisateur (nom, prénom), indiquer l’âge qu’il avait lors de la réalisation de son premier film (âge à l’année civile courante du film). Ordonner les résultats 1°) par ordre croissant d’âge lors du premier film réalisé, 2°) par ordre croissant du nom, 3°) par ordre croissant du prénom.
```mysql
SELECT  Realisateur.nom,
        Realisateur.prenom,
        (MIN(Film.annee) - Realisateur.anneeNaissance) AS age
FROM Realisateur
    JOIN Film
        ON Realisateur.id = Film.idRealisateur
GROUP BY Realisateur.nom, Realisateur.prenom, Realisateur.anneeNaissance
ORDER BY age, Realisateur.nom, Realisateur.prenom;
```
###### Résultat :
| nom | prenom | age |
| :--- | :--- | :--- |
| Spielberg | Steven | 25 |
| Adamson | Andrew | 29 |
| Anderson | Paul | 34 |
| Rogozhkin | Aleksander | 35 |
| Jaoui | Agnès | 40 |
| Baratier | Christophe | 48 |
| Moore | Michael | 48 |
| Demme | Jonathan | 74 |

##### 5.  Lister le programme complet concernant les films de Michael Moore (date de la séance, heure de début de la séance, lieu, nom du cinéma, no de la salle, titre du film, tarif).
```mysql
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
```
###### Résultat :
| date | heureDebut | localite | nom | noSalle | titre | tarif |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 15.11.2004 | 20:00 | Lausanne | Les Galeries | 5 | Fahrenheit 9/11 | 14 |
| 16.11.2004 | 22:00 | Lausanne | Europlex Flon | 3 | Bowling for Columbine | 15 |
| 18.11.2004 | 20:00 | Lausanne | Cinétoile Malley | 5 | Bowling for Columbine | 16 |

##### 6.  Indiquer le(s) cinéma(s) (nom, localité) ayant projeté des films dont la différence d’années entre le plus ancien et le plus récent est d’au moins 20 ans. Trié par localité, puis nom. Utiliser le prédicat EXISTS.

```mysql
SELECT Cinema.nom,
       Cinema.localite
FROM Cinema
WHERE EXISTS(
    SELECT Seance.idCinema
    FROM Film
        JOIN Seance
            ON Film.id = Seance.idFilm
    WHERE Cinema.id = Seance.idCinema
    GROUP BY Seance.idCinema
    HAVING MAX(Film.annee) - MIN(Film.annee) >= 20
)
ORDER BY Cinema.localite, Cinema.nom;
```
###### Résultat :
| nom | localite |
| :--- | :--- |
| Cinétoile Malley | Lausanne |
| Europlex Flon | Lausanne |
| Bel air | Yverdon-les-Bains |
| Rex | Yverdon-les-Bains |

##### 7.  Lister les cinémas (nom et localité) projetant des films réalisés par Michael Moore ou possédant une salle avec une capacité supérieure à 100 places. Utiliser l’opérateur UNION.
```mysql
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
```
###### Résultat :
| nom | localite |
| :--- | :--- |
| Les Galeries | Lausanne |
| Europlex Flon | Lausanne |
| Cinétoile Malley | Lausanne |
| Capitol | Yverdon-les-Bains |

##### 8.  Pour chaque salle de cinéma de Lausanne (nom et numéro), indiquer le nombre de films différents, ainsi que le nombre d’heures de début de séance différentes.
```mysql
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
```
###### Résultat :
| nom | noSalle | nbFilms | nbHeureDebut |
| :---              | :---  | :---  | :---  |
| Cinétoile Malley  | 1     | 0     | 0     |
| Cinétoile Malley  | 2     | 2     | 2     |
| Cinétoile Malley  | 3     | 1     | 1     |
| Cinétoile Malley  | 4     | 1     | 1     |
| Cinétoile Malley  | 5     | 5     | 6     |
| Cinétoile Malley  | 8     | 0     | 2     |
| Europlex Flon     | 1     | 0     | 0     |
| Europlex Flon     | 2     | 1     | 1     |
| Europlex Flon     | 3     | 2     | 2     |
| Europlex Flon     | 4     | 0     | 0     |
| Europlex Flon     | 5     | 1     | 1     |
| Europlex Flon     | 6     | 0     | 0     |
| Europlex Flon     | 7     | 0     | 0     |
| Les Galeries      | 1     | 1     | 1     |
| Les Galeries      | 2     | 0     | 0     |
| Les Galeries      | 3     | 1     | 1     |
| Les Galeries      | 4     | 0     | 0     |
| Les Galeries      | 5     | 1     | 1     |
| Les Galeries      | 6     | 0     | 0     |
| Les Galeries      | 7     | 0     | 0     |

##### 9.  Lister tous les films projetés dans au moins 3 salles différentes.

```mysql
SELECT Film.titre
FROM Film
    JOIN Seance
        ON Film.id = Seance.idFilm
GROUP BY Film.titre
HAVING COUNT(DISTINCT Seance.idFilm, Seance.idCinema, Seance.noSalle) >= 3;
```
###### Résultat :
| titre |
| :--- |
| Indiana Jones and the Temple of Doom |
| Something Evil |

##### 10.  Indiquer la(les) projection(s) programmée(s) (titre du film, nom et localité du cinéma, no de la salle, date, heure de début de la séance et tarif) où le tarif est le plus avantageux pour aller voir un film de Steven Spielberg. Classer les résultats par heure de début croissante.

```mysql
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
              JOIN Salle
                  ON Seance.idCinema = Salle.idCinema AND
                     Seance.noSalle = Salle.noSalle
              JOIN Film
                  ON Seance.idFilm = Film.id
          GROUP BY Film.id
          HAVING MIN(tarif)
      )
ORDER BY Seance.dateHeure;

```
###### Résultat :
| titre | nom | localite | noSalle | heure | date | tarif |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Indiana Jones and the Temple of Doom | Bel air | Yverdon-les-Bains | 1 | 18.11.2004 | 20:00 | 10 |
| Indiana Jones and the Temple of Doom | Rex | Yverdon-les-Bains | 1 | 18.11.2004 | 22:00 | 10 |
| Jurassic Park | Capitol | Yverdon-les-Bains | 1 | 18.11.2004 | 22:00 | 10 |
| E.T. the Extra-Terrestrial | Europlex Flon | Lausanne | 2 | 18.11.2004 | 22:00 | 16 |
| Il faut sauver le soldat Ryan | Cinétoile Malley | Lausanne | 2 | 19.11.2004 | 18:00 | 16 |
| Indiana Jones and the Temple of Doom | Europlex Flon | Lausanne | 3 | 19.11.2004 | 18:00 | 16 |
| Something Evil | Cinétoile Malley | Lausanne | 2 | 19.11.2004 | 22:00 | 14 |
| Le terminal | Cinétoile Malley | Lausanne | 5 | 20.11.2004 | 18:00 | 14 |
| Jurassic Park | Cinétoile Malley | Lausanne | 5 | 20.11.2004 | 22:00 | 14 |
| Something Evil | Cinétoile Malley | Lausanne | 5 | 20.11.2004 | 23:30 | 14 |
| Something Evil | Europlex Flon | Lausanne | 5 | 20.11.2004 | 23:00 | 14 |

##### 11. Indiquer les séances dont le prix est supérieur au tarif moyen des séances pour un même film.
```mysql
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
```
###### Résultat :
| nom               | noSalle   | titre | heure | date | tarif |
| :---              | :---      | :--- | :--- | :--- | :--- |
| Europlex Flon     | 3     | Indiana Jones and the Temple of Doom | 18:00 | 19.11.2004 | 16 |
| Cinétoile Malley  | 4     | Shrek 2 | 18:00 | 17.11.2004 | 16 |
| Cinétoile Malley  | 5     | Bowling for Columbine | 20:00 | 18.11.2004 | 16 |
| Cinétoile Malley  | 5     | Jurassic Park | 22:00 | 20.11.2004 | 14 |


##### 12.  En considérant un taux de remplissage uniforme de 50%, indiquer les films (titre et année) dans l’ordre décroissant de leur chiffre d’affaire. Lister au maximum 20 films.
```mysql
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
```
###### Résultat :
| titre | annee |
| :--- | :--- |
| Something Evil | 1972 |
| Indiana Jones and the Temple of Doom | 1984 |
| Les Choristes | 2004 |
| Jurassic Park | 1993 |
| Bowling for Columbine | 2002 |
| Shrek 2 | 2004 |
| Alien vs Predator | 2004 |
| Un crime dans la tête | 2004 |
| Fahrenheit 9/11 | 2004 |
| Le terminal | 2004 |
| Comme une image | 2004 |
| Il faut sauver le soldat Ryan | 1998 |
| E.T. the Extra-Terrestrial | 1976 |
| Kukushka | 2004 |
| Shrek | 2001 |

##### 13.  Lister tous les films (titre, année, nom et prénom du réalisateur) qui sont projetés dans un cinéma dont au moins une autre séance du même film a lieu dans une salle différente. Ne pas utiliser les clauses WHERE ou HAVING.
```mysql
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
```
###### Résultat :
| titre | annee | nom | prenom |
| :--- | :--- | :--- | :--- |
| Something Evil | 1972 | Spielberg | Steven |

##### 14.  Pour chaque cinéma (localité et nom), indiquer le nombre de salles de cinéma, la capacité moyenne (2 digits de précision) et s'il existe des séances à moins de 12 CHF. Utiliser un(des) LEFT JOIN (pas de EXISTS, …)
```mysql
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
```
###### Résultat :
| localite | nom | nbSalle | moyenneCapacite | aSeanceMoinsDe12Frs |
| :--- | :--- | :--- | :--- | :--- |
| Lausanne | Cinétoile Malley   | 6 | 80.00 | 0 |
| Lausanne | Europlex Flon      | 7 | 77.14 | 0 |
| Lausanne | Les Galeries       | 7 | 79.29 | 0 |
| Yverdon-les-Bains | Bel air   | 1 | 80.00 | 1 |
| Yverdon-les-Bains | Capitol   | 1 | 110.00 | 1 |
| Yverdon-les-Bains | Rex       | 1 | 80.00 | 1 |

##### 15. Vérifier qu'une salle ne projette jamais plusieurs films de 2004 simultanément.
```mysql
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
```
###### Résultat :
| nom | noSalle | heure | date |
| :--- | :--- | :--- | :--- |
| Rex | 1 | 20:00 | 15.11.2004 |

###### Remarques
Normalement, une telle requête devrait ne rien retourné car il n'est pas possible qu'une salle puisse projeter plusieurs films simultanément. Malheureusement, notre requête nous retourne une résultat  un résultat ce qu'il y a possiblement une incohérence dans la base de données.
