-- relation de comptes bancaires que vous devrez créer. 
-- un numéro de compte unique (entier), le nom du propriétaire (chaîne de caractères de taille 10) 
-- et un solde (réel), qui doit toujours être positif :

-- COMPTES(NC, Nom, Solde)

DROP TABLE Comptes ;
CREATE TABLE Comptes(NC INT, Nom VARCHAR(30), Solde FLOAT CHECK (Solde >=0));

-- 1. Dans une nouvelle transaction (après connexion ou après un commit ; ou un rollback ;), 
-- insérez deux nouveaux comptes ayant pour propriétaire Paul (le numéro de compte et le solde sont à votre choix).

-- INSERT INTO [<schéma>] (<table> | <vue>) [((<colonne>[,])*)] ((VALUES [((<expr>[,])*)]) | <requête>);

COMMIT;
INSERT INTO Comptes VALUES (1, 'Paul', 200.0);
INSERT INTO Comptes VALUES (2, 'Paul', 15.0);


-- 2. Calculez la somme des soldes de tous les comptes (à l'aide d'une requête SQL).
SELECT SUM(Solde)
FROM Comptes;

-- 3. Exécutez la commande rollback ;
ROLLBACK;

-- 4. Que devient la somme des soldes de tous les comptes ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes;
-- La somme est null a cause du rollback qui a reverte toutes les operations

-- Exercice 2 : validation de transaction
-- 1. Dans une nouvelle transaction, insérez deux nouveaux comptes ayant pour propriétaire Pierre.
INSERT INTO Comptes VALUES (3, 'Pierre', 50.0);
INSERT INTO Comptes VALUES (4, 'Pierre', 5.0);

-- 2. Exécutez la commande commit
COMMIT;

-- 3 Insérez deux nouveaux comptes ayant pour propriétaire Paul.
INSERT INTO Comptes VALUES (5, 'Paul', 100.0);
INSERT INTO Comptes VALUES (6, 'Paul', 2.0);

-- 4 Calculez la somme du soldes des comptes par propriétaire
SELECT SUM(Solde)
FROM Comptes
Group by Nom;

-- 5 Exécutez la commande rollback ;
ROLLBACK;

-- 6 Que devient la somme du soldes des comptes par propriétaire ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes
Group by Nom;

-- Seulement de Pierre parce que la transaction a ete commited. Il n y a eu pas de commit apres la insertion de Paul


-- Exercice 3 : validation automatique

-- 1. Dans une nouvelle transaction, placez-vous en mode validation automatique (set autocommit on; dans SQL/Plus)
set autocommit on;


-- 2. Insérez deux nouveaux comptes appartenant à Jacques.
INSERT INTO Comptes VALUES (7, 'Jacques', 1.0);
INSERT INTO Comptes VALUES (8, 'Jacques', 30.0);

-- 3 Calculez la somme des soldes de tous les comptes (à l'aide d'une requête SQL).
SELECT SUM(Solde)
FROM Comptes;

-- 4 Exécutez la commande rollback
ROLLBACK;

-- 5 Que devient la somme des soldes de tous les comptes ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes;

-- La somme est preservee grace au commit


-- Annulez le mode validation automatique (set autocommit off ; dans SQL/Plus)
set autocommit off ; 

-- Exercice 4 : Points de sauvegarde

-- 1 Dans une nouvelle transaction, insérez deux nouveaux comptes appartenant à Jean.
INSERT INTO Comptes VALUES (9, 'Jean', 90.0);
INSERT INTO Comptes VALUES (10, 'Jean', 9.0);

-- 2 Placez un point de sauvegarde nommé « DeuxInserts » (savepoint DeuxInserts ;)
savepoint DeuxInserts ;

-- 3 Insérez deux nouveaux comptes ayant pour propriétaire Jean
INSERT INTO Comptes VALUES (11, 'Jean', 91.0);
INSERT INTO Comptes VALUES (12, 'Jean', 10.0);

-- 4 Calculez la somme du solde des comptes de Jean
SELECT SUM(Solde)
FROM Comptes
WHERE Nom = 'Jean';

-- 5 Revenez au point de sauvegarde nommé « DeuxInserts » (rollback to DeuxInserts ;)
rollback to DeuxInserts;

-- 6. Que devient la somme du solde des comptes de Jean ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes
WHERE Nom = 'Jean';

-- La somme ne considere pas les dernieres transactions a cause du rollback qui a fait la table revenir a la situation avant linsertion

-- 7. Faites un rollback.
ROLLBACK;

-- 8 Que devient la somme du solde des comptes de Jean ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes
WHERE Nom = 'Jean';

-- cest nulle parce quon a reverte toutes les transaction de insertion de les comptes de Jean

-- Que concluez-vous de la gestion de l’atomicité ? tout ou rien
-- Soit toutes les requêtes s’exécutent correctement soit aucune
-- On revien a l’état de la base de données avant la modification

--Partie 2 : Cohérence
-- Exercice 1 :

-- 1. Dans une nouvelle transaction, insérez un nouveau compte appartenant à Claude et ayant un solde de 100 €.
INSERT INTO Comptes VALUES (13, 'Claude', 100.0);

-- 2 Insérez un nouveau compte appartenant à Henri et ayant un solde de 200 €.
INSERT INTO Comptes VALUES (14, 'Henri', 200.0);

-- 3 Peut-on incrémenter le solde du compte de Henri de 50 € ? Pourquoi ?
UPDATE Comptes SET Solde = (SELECT Solde FROM Comptes WHERE Nom = 'Henri') + 50
WHERE Nom = 'Henri';

-- oui parce quil n y a pas de limite superieur

-- 4 Peut-on décrémenter le solde du compte de Claude de 150 € ? Pourquoi ?
UPDATE Comptes SET Solde = (SELECT Solde FROM Comptes WHERE Nom = 'Claude') - 150
WHERE Nom = 'Claude';

-- Non parce quil y a une restriction en place Solde FLOAT CHECK (Solde >=0). Le nouveau valuer nest pas valide par le check
-- check constraint violated

-- 5 Quel est le solde des comptes de Claude et Henri ?
SELECT SUM(Solde)
FROM Comptes
WHERE Nom = 'Claude' OR Nom = 'Henri'
Group by Nom;

-- 6 Exécutez la commande rollback ;
ROLLBACK;

-- 7 Quels comptes reste-t-il ?
SELECT *
FROM Comptes;

-- Seulement les comptes de Jacques et Pierre a cause du rollback au dernier commit

-- Refaites l'exercice, mais en validant la transaction (commit;) au lieu de l'annuler (rollback;)
INSERT INTO Comptes VALUES (13, 'Claude', 100.0);
INSERT INTO Comptes VALUES (14, 'Henri', 200.0);

UPDATE Comptes SET Solde = (SELECT Solde FROM Comptes WHERE Nom = 'Henri') + 50
WHERE Nom = 'Henri';
UPDATE Comptes SET Solde = (SELECT Solde FROM Comptes WHERE Nom = 'Claude') - 150
WHERE Nom = 'Claude';
COMMIT;

-- Que concluez-vous de la gestion de la cohérence dans les SGBD ?
-- Il faut verfier les constraints -- toutes les contraintes d’intégrité doivent être vérifiées

-- Partie 3 : Isolation.
-- Cette partie nécessitera d’ouvrir deux connexions à Oracle 11g (dans deux fenêtres XTerm) sur le même
-- compte (login) de façon à permettre l’accès concurrent à une même information. Ces deux sessions seront
-- nommées S1 et S2.


-- Exercice 1 : Niveau d’isolation READ COMMITED (par défaut dans Oracle)
-- 1 Dans une nouvelle transaction de la session S1, supprimez les comptes de Jacques.
DELETe from Comptes where nom = 'Jacques';

-- 2 Quels sont les comptes disponibles par une nouvelle transaction de la session S2 ?
select * from comptes;

-- tous le comptes. jacques est encore disponible

-- 3 Est-il possible de créditer tous les comptes de 10 000 € dans la session S2 ? Pourquoi ?
UPDATE Comptes SET Solde = Solde + 10000;
-- non

-- 4 Validez la transaction de la session S1. Que se passe-t-il dans la session S2 ?
COMMIT;


-- 5 Quels sont alors les comptes disponibles dans la session S2 ? Pourquoi ?
-- les comptes de jacques on ete supprimer

-- 6 Validez la transaction de la session S2.
UPDATE Comptes SET Solde = Solde + 10000;
COMMIT;


-- Que concluez-vous du niveau d’isolation READ COMMITED ?
-- on peut seulement lire et faire un update se les vaulers on ete valide
-- Lecture des valeurs validées uniquement

-- Exercice 2 : Niveau d’isolation SERIALIZABLE.
-- 1. Dans une nouvelle transaction de la session S1, calculez la somme du solde de tous les comptes.
SELECT SUM(Solde)
FROM Comptes;

-- 2. Dans une nouvelle transaction de la session S2, passez en mode SERIALIZABLE (set transaction isolation
-- level serializable ; dans SQL/Plus).
set transaction isolation level serializable ;

-- Attention : ce mode ne sera actif que pour la transaction en cours.

-- 3. Dans la session S2, insérez un nouveau compte ayant pour propriétaire Paul et pour solde 500 €
INSERT INTO Comptes VALUES (15, 'Paul', 500.0);

-- 4. Que devient la somme du solde de tous les comptes dans la session S1 ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes;

-- la meme parce que on n'a pas valide la transaction de s2

-- 5. Validez la transaction de la session S2
COMMIT;


-- 6. Que devient la somme du solde des comptes dans la session S1 ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes;

-- la somma a change parce quon a valide la transaction

-- 7. Validez la transaction de la session S1.
COMMIT;



-- 8. Dans une nouvelle transaction de la session S2, passez en mode SERIALIZABLE (set transaction isolation
-- level serializable ; dans SQL/Plus).
set transaction isolation level serializable ;

-- Attention : ce mode ne sera actif que pour la transaction en cours.

-- 9. Dans la session S2, calculez la somme du solde des comptes.
SELECT SUM(Solde)
FROM Comptes;

-- 10. Dans la session S1, insérez un autre compte ayant pour propriétaire Paul et pour solde 1000 €
INSERT INTO Comptes VALUES (16, 'Paul', 1000.0);

-- 11. Que devient la somme du solde de tous les comptes dans la session S2 ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes;

-- pas change

-- 12. Validez la transaction de la session S1.
COMMIT;


-- 13. Que devient la somme du solde des comptes dans la session S2 ? Pourquoi ?
SELECT SUM(Solde)
FROM Comptes;

-- pas changer parce que cest serializable

-- 14. Validez la transaction de la session S2.
COMMIT;

-- 15. Que devient la somme du solde des comptes dans la session S2 ? Pourquoi ?
-- apres le commit elle a change
SELECT SUM(Solde)
FROM Comptes;

-- 16. Validez la transaction de la session S2.
COMMIT;


-- Que concluez-vous du niveau d’isolation SERIALIZABLE ?
-- Niveau le plus fort


-- Exercice 3 : Interblocage
-- 1. Dans une nouvelle transaction de la session S1, augmentez le solde des compte de Paul de 100 €
UPDATE Comptes SET Solde = Solde + 100 WHERE Nom = 'Paul';

-- 2. Dans une nouvelle transaction de la session S2, peut-on augmenter le solde des comptes de Pierre de 50 € ?
-- Pourquoi ?


-- 3. Dans la session S1, peut-on diminuer le solde des comptes de Pierre de 100 € ? Pourquoi ?
-- 4. Dans la session S2, peut-on augmenter le solde des comptes de Paul de 200 € ? Pourquoi ?
-- 5. Quels est l'état des comptes (dans les sessions S1 ou S2) si vous validez les deux transactions ?
-- 6. Quels est l'état des comptes (dans les sessions S1 ou S2) si vous validez la transaction de la session S 1 et
-- annulez celle de la session S2 ? (il faut refaire les étapes 1 à 4).
-- 7. Quels est l'état des comptes (dans les sessions S1 ou S2) si vous annulez la transaction de la sessions S1 et
-- validez celle de la session S2 ? (il faut refaire les étapes 1 à 4).
-- 8. Quels est l'état des comptes (dans les sessions S1 ou S2) si vous annulez les deux transactions ? (il faut
-- refaire les étapes 1 à 4)
-- 9. Est-il possible d'automatiser la décision quant à la terminaison des transactions de S1 et S2 ?
-- Que concluez-vous de cette gestion de l’isolation ?
