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
    (SELECT codegenre 
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
SELECT titrefilm
FROM film
WHERE codefilm IN (
    SELECT DISTINCT codefilm 
    FROM emprunt
    WHERE dateretour IS NULL
    EXCEPT
    SELECT DISTINCT codefilm 
    FROM emprunt
    WHERE dateretour IS NOT NULL);
-- 2.13
SELECT titrefilm 
FROM film
WHERE codegenre IN (
    SELECT codegenre 
    FROM genre 
    WHERE LOWER(intgenre) LIKE '%divers%')
    AND codefilm IN ( 
    SELECT codefilm 
    FROM acteur 
    JOIN jouer_un_role USING(codeacteur)
    WHERE LOWER(prenomacteur) LIKE '%g_rard%' AND LOWER(nomacteur) LIKE '%depardieu%');
-- 2.14
SELECT titrefilm,annee,duree
FROM film 
WHERE annee = '1986' AND (duree = 110 OR duree = 120);
-- 2.15
SELECT count(*) 
FROM film
WHERE codefilm IN (SELECT e.codefilm 
    FROM exemplaire e 
    JOIN support s USING(codesupport)
    WHERE s.intsupport = 'DVD')
-- 2.16
BEGIN TRANSACTION;
CREATE TABLE serie (
    codeserie int,
    intserie varchar,
    CONSTRAINT PK_serie PRIMARY KEY (codeserie)
);
ALTER TABLE film ADD COLUMN codeserie int REFERENCES serie(codeserie);
-- 2.17
INSERT INTO serie VALUES 
    (1,'TRILOGIE RAMBO'),
    (2,'TRILOGIE BEST OF THE BEST'),
    (3,'JAWS'),
    (4,'TRILOGIE SCREAM') ;
-- 2.18 
UPDATE film SET codeserie = 1 WHERE LOWER(titrefilm) = 'rambo';
UPDATE film SET codeserie = 2 WHERE LOWER(titrefilm) = 'best of the best 2';
UPDATE film SET codeserie = 1 WHERE LOWER(titrefilm) = 'dents de la mer (les)';
UPDATE film SET codeserie = 1 WHERE LOWER(titrefilm) = 'scream';
COMMIT;
-- 2.19
SELECT f.titrefilm, a.nomacteur || ' ' || a.prenomacteur 
FROM film f
JOIN jouer_un_role USING(codefilm)
JOIN acteur a USING(codeacteur);
-- 2.20
SELECT titrefilm, intgenre
FROM film
JOIN genre USING(codegenre)
ORDER BY 2;
-- 2.21
SELECT f.titrefilm, e.datepret,e.dateretour
FROM film f
JOIN exemplaire USING(codefilm)
JOIN emprunt e USING(codefilm,numexemplaire)
WHERE e.codepers = (
    SELECT codepers
    FROM emprunteur
    WHERE LOWER(nompers) = 'taparov' AND LOWER(prenompers) = 'igor');
-- 2.22 
SELECT DISTINCT f.titrefilm, g.intgenre, a.nomacteur || ' ' || a.prenomacteur, s.intsupport 
FROM film f
JOIN genre g USING(codegenre) 
JOIN jouer_un_role USING(codefilm)
JOIN acteur a USING(codeacteur)
JOIN exemplaire USING(codefilm)
JOIN support s USING(codesupport)
WHERE UPPER(f.titrefilm) LIKE 'S%';
-- 2.23
SELECT f.titrefilm, count(e.codesupport) AS "nombre exemplaires"
FROM film f
JOIN exemplaire e USING(codefilm)
GROUP BY f.titrefilm
HAVING count(e.codesupport)>1;
-- 2.24
SELECT g.intgenre, SUM(f.duree) AS "somme durées en min"
FROM genre g
JOIN film f USING (codegenre)
GROUP BY g.intgenre;
-- 2.25
SELECT g.intgenre, count(f.*) AS "nombre de film"
FROM genre g
JOIN film f USING (codegenre)
GROUP BY g.intgenre
HAVING count(f.*)>4;
-- 2.26
SELECT titrefilm
FROM film
WHERE duree>(SELECT AVG(duree) FROM film);
-- 2.27
SELECT AVG(duree) FROM film
-- 2.28
SELECT UPPER(SUBSTR(titrefilm,0,1)) || SUBSTR(titrefilm,1)
FROM film;
-- 2.29
SELECT titrefilm, 'Longueur : ' || LENGTH(titrefilm) || ' caractères' AS "nbr caractère"
FROM film
WHERE LENGTH(titrefilm) = (
    SELECT MAX(LENGTH(titrefilm))
    FROM film
)
-- 2.30
SELECT f.titrefilm || ' est sorti de la videothèque depuis ' ||  ( CURRENT_DATE - em.datepret ) ||' jours'
FROM film f
JOIN exemplaire ex USING(codefilm)
JOIN emprunt em USING(codefilm,numexemplaire)
WHERE em.dateretour>CURRENT_DATE AND NOT EXISTS (
    SELECT * 
    FROM emprunt em2
    WHERE em2.codefilm = f.codefilm AND (em.dateretour<=CURRENT_DATE OR em.dateretour IS NULL)
)
-- 2.31
SELECT titrefilm || ' (VF)'
FROM film;
SELECT CONCAT(titrefilm,' ','(VF)')
FROM film;
-- 2.32
SELECT CONCAT('00 33 ',REPLACE(SUBSTR(telpers,1),'.',' '))
FROM emprunteur;
-- 2.33
SELECT DISTINCT titrefilm
FROM film
WHERE codefilm IN (
    SELECT codefilm
    FROM emprunt em
    WHERE EXTRACT('year' FROM em.datepret ) = 2001 AND EXTRACT('month' FROM em.datepret ) = 1)
-- 2.34
SELECT titrefilm, 
    CASE WHEN duree IS NULL THEN 'Durée non renseigné'  
        ELSE CAST(duree AS varchar)
    END AS "durée",
    CASE WHEN annee IS NULL THEN 'Année non renseigné'
        ELSE annee
    END AS "année"
FROM film;
