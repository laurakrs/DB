-- (R1) Numéros et primes des joueurs sponsorisés par Peugeot entre 2003 et 2005.
SELECT NJ, Prime
FROM JOUEURS j, GAINS g
WHERE j.NJ = g.NJ
    AND NomSponsor = 'Peugeot'
    AND Annee >= 2003
    AND Annee <= 2005;

-- (R2) Noms et âges des joueurs ayant participé à Roland Garros en 2005.
SELECT Nom, Age
FROM JOUEURS j, RENCONTRES r
WHERE j.NJ = r.NJGagnant
        OR j.NJ = r.NJPerdant
        AND Annee = 2005
        AND LieuTournoi = 'Roland Garros';


-- (R3) Noms et nationalités des joueurs sponsorisés par Peugeot et ayant gagné au moins un match
-- à un tournoi de Roland Garros.
SELECT Nom, nationalité
FROM JOUEURS j, 
WHERE 
    AND 
    AND LieuTournoi = 'Roland Garros';


-- (R4) Noms et nationalités des joueurs ayant participé à Roland Garros et à Wimbledon en 2006.
SELECT Nom, Nationalité
FROM JOEURS j, RENCONTRES r
WHERE j.NJ = r.NJGagnant
        OR j.NJ = r.NJPerdant
        AND Annee = 2006
        AND LieuTournoi = 'Roland Garros'
INTERSECT
SELECT  Nom, Nationalité
FROM JOEURS j, RENCONTRES r
WHERE j.NJ = r.NJGagnant
        OR j.NJ = r.NJPerdant
        AND Annee = 2006
        AND LieuTournoi = 'Wimbledon';


-- (R5) Noms des joueurs ayant toutes leurs primes de Roland Garros supérieures à 150 000 €.
SELECT j.Nom
FROM JOUEURS j, GAINS g
WHERE LieuTournoi = 'Roland Garros'


-- (R6) Noms, prénoms, âges et nationalités des joueurs ayant participé à tous les tournois de Roland
-- Garros.
SELECT j.Nom, j.Prénom, j.Age, j.Nationalité
FROM JOUEURS j, RENCONTRES r
WHERE LieuTournoi = 'Roland Garros'
    AND j.NJ = r.NJGagnant
    OR j.NJ = r.NJPerdant
GROUP BY j.NJ, r.Année
HAVING COUNT(r.Année) = ALL(SELECT(
        COUNT(Année)) 
        FROM  GAINS g
        WHERE LieuTournoi = 'Roland Garros')

-- (R7) Noms et prénoms des joueurs ayant progressé au tournoi de Wimbledon entre 2004 et 2005.
SELECT j.Nom, j.Prénom
FROM JOUEURS
WHERE LieuTournoi = 'Wimbledon'

-- (R8) Somme des primes gagnées pour chaque édition de Roland Garros accueillant plus de 15
-- joueurs.