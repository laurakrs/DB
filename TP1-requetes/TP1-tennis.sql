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

-- R9 PROBLEME Liste des hotels, avec leur nom, leur adresse et leur categorie, ayant au moins deux chambres de meme prix. 
SELECT DISTINCT h.NS,h.NH,NomH,AdrH,CatH
FROM HOTELS h, ROOMS ro1, ROOMS ro2
WHERE h.NH = ro1.NH
    AND h.NH = ro2.NH
    AND ro1.Prix = ro2.Prix
    AND ro1.NCH <> ro2.NCH;

-- R10 Liste des hotels avec leur nom, adresse et categorie, et leur nombre de reservations dans lannee
SELECT DISTINCT h.NS,h.NH,NomH,AdrH,CatH
FROM HOTELS h, BOOKINGS b
WHERE h.NS = b.NS
    AND h.NH = b.NH;