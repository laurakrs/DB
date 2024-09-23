-- R1 Liste des numeros et noms des stations de montagne avec leur capacite en chambres
SELECT NS,NomS,CapCH 
FROM RESORTS 
WHERE TypeS = 'montagne'; 

-- R2 Liste des noms et numrros des hotels avec leur adresse, telephone, categorie, se trouvant dans une station balneaire
SELECT NomS,NH,AdrH,TelH,CatH
FROM HOTELS h,RESORTS r
WHERE h.NS = r.NS
    AND TypeS = 'mer'; 

-- R3 Liste des noms des stations au bord de la mer ayant des hotels 4 etoiles.
SELECT DISTINCT NomS
FROM RESORTS r,HOTELS h
WHERE r.NS = h.NS
    AND TypeS = 'mer'
    AND CatH = 4;

-- R4 Noms et adresses des clients ayant reserve a la montagne.
SELECT DISTINCT NomCl,AdrCl
FROM  GUESTS g,BOOKINGS b,RESORTS r
WHERE g.NCL = b.NCL
    AND b.NS = r.NS
    AND typeS = 'montagne';

-- R5 Liste des chambres des hotels 2 etoiles situes dans une station de montagne et ayant un prix inferieur a 50 euros.
SELECT DISTINCT ro.NS,ro.NH,ro.NCH
FROM ROOMS ro, HOTELS h, RESORTS r
WHERE ro.NS = h.NS
    AND ro.NH = h.NH
    AND h.NS = r.NS
    AND CatH = 2
    AND TypeS = 'montagne'
    AND Prix < 50;

-- R6 Liste des noms des clients ayant reserve, dans un hotel dune station balneaire, une chambre avec douche.
SELECT DISTINCT NomCl
FROM GUESTS g, BOOKINGS b, RESORTS r, ROOMS ro
WHERE g.NCL = b.NCL
    AND b.NS = ro.NS
    AND b.NH = ro.NH
    AND b.NCH = ro.NCH
    AND r.NS = ro.NS
    AND TypeS = 'mer'
    AND TypCh IN ('D', 'DWC');

-- R7 Noms des clients dont ladresse est ladresse dun hotel.
SELECT DISTINCT NomCl
FROM GUESTS g, HOTELS h
WHERE g.AdrCl = h.AdrH;

-- R8 Liste des hotels 4 etoiles nayant que des chambres avec salle de bain.
SELECT DISTINCT NS,NH
FROM HOTELS
WHERE CatH = 4
MINUS
SELECT DISTINCT NS,NH
FROM ROOMS
WHERE TypCh <>'SDB';

-- R9 Liste des hotels, avec leur nom, leur adresse et leur categorie, ayant au moins deux chambres de meme prix. 
SELECT DISTINCT h.NS,h.NH,NomH,AdrH,CatH
FROM HOTELS h, ROOMS ro1, ROOMS ro2
WHERE h.NH = ro1.NH
    AND h.NH = ro2.NH
    AND h.NS = ro1.NS
    AND h.NS = ro2.NS
    AND ro1.Prix = ro2.Prix
    AND ro1.NCH <> ro2.NCH;

-- R9 autre option
SELECT DISTINCT h.NS,h.NH,NomH,AdrH,CatH
FROM HOTELS h, ROOMS r
WHERE h.NH = r.NH
    AND h.NS = r.NS
GROUP BY h.NS, h.NH, prix, h.nomH, h.AdrH, h.CatH
HAVING COUNT (*) >= 2;

-- R10 Liste des hotels avec leur nom, adresse et categorie, et leur nombre de reservations dans lannee
(SELECT h.NS,h.NH,h.NomH,h.AdrH,h.CatH,COUNT(*)
FROM HOTELS h, BOOKINGS b
WHERE h.NS = b.NS
    AND h.NH = b.NH
GROUP BY h.NS, h.NH,h.NomH,h.AdrH,h.CatH)
UNION
    (SELECT ns, nh, nomH, AdrH,CatH,0
    FROM HOTELS
    WHERE (NS,NH) NOT IN (
        SELECT DISTINCT NS, NH
        FROM BOOKINGS
    ));



-- (R11) Adresse de l’hôtel de la station « Chamonix » ayant eu le plus de réservations faites sur l’année.
SELECT h.NS, h.NH, h.NomH, h.AdrH
FROM HOTELS h, RESORTS r, BOOKINGS b
WHERE h.NH = b.NH
    AND h.NS = r.NS
    AND h.NS = b.NS
    AND r.NomS = 'Chamonix'
GROUP BY h.NS, h.NH, h.NomH, h.AdrH
HAVING COUNT(b.NCL) = 
    (SELECT MAX(
        COUNT(NCL)) 
        FROM  BOOKINGS b2, RESORTS r2
        WHERE b2.NS = r2.NS
            AND r2.NomS = 'Chamonix'
        GROUP BY b2.NS,b2.NH);

-- R11 autre option
SELECT h.NS, h.NH, h.NomH, h.AdrH
FROM HOTELS h, RESORTS r, BOOKINGS b
WHERE h.NH = b.NH
    AND h.NS = r.NS
    AND h.NS = b.NS
    AND r.NomS = 'Chamonix'
GROUP BY h.NS, h.NH, h.NomH, h.AdrH
HAVING COUNT(b.NCL) >= ALL(SELECT(
        COUNT(NCL)) 
        FROM  BOOKINGS b2, RESORTS r2
        WHERE b2.NS = r2.NS
            AND r2.NomS = 'Chamonix'
        GROUP BY b2.NS,b2.NH);





-- (R12) Jour de l’année où l’hôtel « Bon Séjour » de la station « Chamonix » a eu le plus de réservations.
SELECT b.Jour
FROM HOTELS h, RESORTS r, BOOKINGS b
WHERE h.NH = b.NH
    AND h.NS = r.NS
    AND h.NS = b.NS
    AND h.NomH = 'Bon Séjour'
    AND r.NomS = 'Chamonix'
GROUP BY b.Jour
HAVING COUNT(b.NCL) = (SELECT MAX(
        COUNT(NCL))
        FROM BOOKINGS b2, RESORTS r2, HOTElS h2
        wHERE b2.NS = r2.NS
            AND r2.NomS = 'Chamonix'
            AND r2.NS = h2.NS
            AND h2.NomH = 'Bon Séjour'
            AND h2.NH = b2.NH
        GROUP BY b.Jour);



SELECT h.NS, h.NH, h.NomH, b.Jour, b.NCL
FROM HOTELS h, RESORTS r, BOOKINGS b
WHERE h.NH = b.NH
    AND h.NS = r.NS
    AND h.NS = b.NS
    AND h.NomH = 'Bon Séjour'
    AND r.NomS = 'Chamonix'
GROUP BY h.NS, h.NH, h.NomH, b.Jour, b.NCL
HAVING COUNT(b.NCL) >= ALL(SELECT(
        COUNT(NCL))
        FROM BOOKINGS b2, RESORTS r2, HOTElS h2
        wHERE b2.NS = r2.NS
            AND r2.NomS = 'Chamonix'
            AND r2.NS = h2.NS
            AND h2.NomH = 'Bon Séjour'
        GROUP BY b2.NS, b2.NH);

-- (R13) Liste des hôtels, avec leur nom, adresse et catégorie, dont toutes les chambres ont un prix
-- inférieur à 40 euros.

SELECT DISTINCT h.nomH, h.AdrH, h.CatH
FROM HOTELS h, ROOMS r
WHERE h.NH = r.NH
    AND h.NS = r.NS
GROUP BY h.nomH, h.AdrH, h.CatH
HAVING ALL(SELECT prix FROM HOTELS
            
            
            )

-- (R14) Prix de la chambre la moins chère des hôtels 3 étoiles situés dans une station balnéaire.


-- (R15) Nom des clients ayant réservé dans tous les hôtels 2 étoiles de la station « Chamonix ».


-- (R16) Nom des clients ayant réservé au moins trois jours consécutifs une même chambre dans le
--même hôtel de la même station.