-- 1.6.1
BEGIN TRANSACTION;
CREATE TABLE support (
    codesupport int,
    intsupport varchar,
    PRIMARY KEY (codesupport)
);

CREATE TABLE etat (
    codeetat int,
    designationetat VARCHAR,
    PRIMARY KEY (codeetat)
);

CREATE TABLE emprunteur (
    codepers int,
    nompers varchar,
    prenompers varchar,
    adrpers varchar,
    telpers char(14),
    PRIMARY KEY (codepers)
);

CREATE TABLE acteur (
    codeacteur int,
    nomacteur varchar,
    prenomacteur varchar,
    PRIMARY KEY (codeacteur)
);

CREATE TABLE genre (
    codegenre int,
    intgenre varchar,
    PRIMARY KEY (codegenre)
);

CREATE TABLE film (
    codefilm int,
    titrefilm varchar,
    annee char(4),
    duree smallint,
    resume text,
    codegenre int NOT NULL,
    PRIMARY KEY (codefilm)
);

CREATE TABLE jouer_un_role (
    codefilm int,
    codeacteur int,
    PRIMARY KEY (codefilm,codeacteur)
);

CREATE TABLE exemplaire (
    codefilm int,
    numexemplaire int,  
    codeetat int,
    codesupport int NOT NULL,
    PRIMARY KEY (codefilm,numexemplaire)
);

CREATE TABLE emprunt (
        codefilm int,
    numexemplaire int,
    codepers int,
    datepret date,
    dateretour date,
    PRIMARY KEY (datepret,codepers,codefilm,numexemplaire)
);

-- 1.6.2
ALTER TABLE film    ADD CONSTRAINT FK_film_genre FOREIGN KEY (codegenre) REFERENCES genre(codegenre);
ALTER TABLE jouer_un_role   ADD CONSTRAINT FK_jouer_un_role_film FOREIGN KEY (codefilm) REFERENCES film(codefilm),
                            ADD CONSTRAINT FK_jouer_un_role_acteur FOREIGN KEY (codeacteur) REFERENCES acteur(codeacteur);
ALTER TABLE exemplaire  ADD CONSTRAINT FK_exemplaire_film FOREIGN KEY (codefilm) REFERENCES film(codefilm) ON DELETE CASCADE,
                        ADD CONSTRAINT FK_exemplaire_support FOREIGN KEY (codesupport) REFERENCES support(codesupport),
                        ADD CONSTRAINT FK_exemplaire_etat FOREIGN KEY (codeetat) REFERENCES etat(codeetat) ON UPDATE CASCADE;
ALTER TABLE emprunt ADD CONSTRAINT FK_emprunt_emprunteur FOREIGN KEY (codepers) REFERENCES emprunteur(codepers),
                    ADD CONSTRAINT FK_emprunt_exemplaire FOREIGN KEY (codefilm,numexemplaire) REFERENCES exemplaire(codefilm,numexemplaire) ON DELETE SET NULL;

-- 1.6.3
ALTER TABLE film ADD CONSTRAINT CHK_film_duree CHECK( duree >= 0);
ALTER TABLE emprunt ADD CONSTRAINT CHK_dater_datep CHECK( dateretour >= datepret);

-- 1.6.4

ALTER TABLE emprunteur ADD COLUMN  datenais date;    
COMMIT;
-- 2.1
SELECT titrefilm, resume FROM film;
-- 2.2
SELECT titrefilm, duree 
FROM film
WHERE duree > 90;
-- 2.3
SELECT nomacteur || ' ' || prenomacteur 
FROM acteur
WHERE prenomacteur IN('Charles','Robert','Gérard');
-- 2.4
SELECT nompers || ' ' || prenompers || ' ' || adrpers 
FROM emprunteur 
WHERE LOWER(adrpers) LIKE '%reims%';
-- 2.5
SELECT titrefilm, annee, duree
FROM film
WHERE codegenre = 
    (SELECT DISTINCT codegenre 
    FROM genre 
    WHERE LOWER(intgenre) LIKE '%science-fiction%')
-- 2.6
SELECT titrefilm
FROM film
WHERE codefilm IN (
    SELECT DISTINCT codefilm 
    FROM emprunt
    WHERE datepret BETWEEN '2001-06-01' AND '2001-09-30')
-- 2.7
SELECT titrefilm
FROM film
WHERE codefilm IN (
    SELECT DISTINCT e.codefilm 
    FROM exemplaire e 
    JOIN support s USING(codesupport)
    WHERE s.intsupport = 'VCD')
-- 2.8
SELECT titrefilm 
FROM film
WHERE codefilm IN (
    SELECT codefilm 
    FROM emprunt
    WHERE dateretour>CURRENT_DATE )
-- 2.9
SELECT titrefilm, annee, duree
FROM film
WHERE codefilm IN 
    (SELECT codefilm 
    FROM acteur 
    JOIN jouer_un_role USING(codeacteur)
    WHERE LOWER(prenomacteur) LIKE '%sylvester%' AND LOWER(nomacteur) LIKE '%stallone%')
-- 2.10
SELECT titrefilm, annee, duree
FROM film
WHERE codefilm IN 
    (SELECT codefilm 
    FROM acteur 
    JOIN jouer_un_role USING(codeacteur)
    WHERE LOWER(prenomacteur) LIKE '%g_rard%' 
    AND LOWER(nomacteur) LIKE '%depardieu%' 
    INTERSECT
    SELECT codefilm 
    FROM acteur 
    JOIN jouer_un_role USING(codeacteur)
    WHERE LOWER(prenomacteur) LIKE '%christian%' 
    AND LOWER(nomacteur) LIKE '%clavier%' )
-- 2.11
SELECT DISTINCT eteur.nompers || ' ' || eteur.prenompers || ' ' || eteur.adrpers || ' ' || eteur.telpers
FROM emprunteur eteur
JOIN emprunt et USING(codepers)
WHERE et.codefilm IN (
    SELECT codefilm 
    FROM film 
    WHERE LOWER(titrefilm) LIKE '%rambo%' OR
    LOWER(titrefilm) LIKE '%ast_rix et ob_lix contre c_sar%' OR
    LOWER(titrefilm) LIKE '%the faculty%');
-- 2.12
SELECT 