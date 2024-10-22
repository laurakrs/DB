CREATE TABLE pilote (
    codeP INT CONSTRAINT KcodeP PRIMARY KEY,
    nom VARCHAR(20),
    prenom VARCHAR(20),
    age INT CONSTRAINT Constage CHECK(age > 18)
    grade INT
);

CREATE TABLE navire (
    codeNav INT CONSTRAINT KcodeNav PRIMARY KEY,
    rayonAct FLOAT,
    nbp INT
    vitesseM FLOAT
);

CREATE TABLE galaxie (
    codeG INT CONSTRAINT KcodeG PRIMARY KEY,
    nomG VARCHAR(20),
    dist FLOAT
);

CREATE TABLE mission (
    codeMi INT CONSTRAINT KcodeMi PRIMARY KEY,
    NbVaiss INT,
    vitesseMin FLOAT
);

CREATE TABLE dataMi (
    dat DATE CONSTRAINT Kdat PRIMARY KEY,
);

CREATE TABLE equipage (
    codeEq DATE CONSTRAINT Keq PRIMARY KEY,
    effectif INT
);

CREATE TABLE milieu (
    compoM 
)






CREATE TABLE PRODUCTEURS
(np INTEGER CONSTRAINT Knp PRIMARY KEY (np),
nom CHAR (20) CONSTRAINT NOM-UNIQUE UNIQUE,
prenom CHAR(20),
region CHAR CONSTRAINT Ci CHECK (region IN ('E','O','S','N')) )