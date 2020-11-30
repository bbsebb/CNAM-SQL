/* DROP TABLE IF EXISTS  inscrire,reglement,inscription,ue,tarif,auditeur; */
-- 5
CREATE DATABASE scolarite ENCODING 'UTF8';

BEGIN TRANSACTION;
CREATE TABLE auditeur (
    id_auditeur int,
    nom varchar,
    prenom varchar,
    date_nais date,
    CONSTRAINT PK_auditeur PRIMARY KEY (id_auditeur)
);

CREATE TABLE tarif (
    id_tarif int,
    tarif varchar,
    CONSTRAINT PK_tarif PRIMARY KEY (id_tarif)
);

CREATE TABLE ue (
    id_ue varchar(10),
    designation varchar,
    ects smallint,
    CONSTRAINT PK_ue PRIMARY KEY (id_ue)
);

CREATE TABLE inscription (
    id_auditeur int,
    annee smallint,
    id_tarif int NOT NULL,
    CONSTRAINT PK_inscription PRIMARY KEY (id_auditeur,annee),
    CONSTRAINT FK_inscription_auditeur FOREIGN KEY (id_auditeur) REFERENCES auditeur(id_auditeur),
    CONSTRAINT FK_inscription_tarif FOREIGN KEY (id_tarif) REFERENCES tarif(id_tarif)
);

CREATE TABLE reglement (
    id_auditeur int,
    annee smallint,
    num_ordre int,
    montant int,
    CONSTRAINT PK_reglement PRIMARY KEY (id_auditeur,annee,num_ordre),
    CONSTRAINT FK_reglement FOREIGN KEY (id_auditeur,annee) REFERENCES inscription(id_auditeur,annee)
);

CREATE TABLE inscrire (
    id_auditeur int ,
    annee smallint ,
    id_ue varchar(10),
    note1 smallint,
    note2 smallint,
    CONSTRAINT PK_inscrire PRIMARY KEY (id_auditeur,annee,id_ue),
	CONSTRAINT FK_inscrire_inscription FOREIGN KEY (id_auditeur,annee) REFERENCES inscription(id_auditeur,annee),
    CONSTRAINT FK_inscrire_ue FOREIGN KEY (id_ue) REFERENCES ue(id_ue)
      
);
COMMIT;
-- 7.1
INSERT INTO inscription (id_auditeur,annee,id_tarif) VALUES (21,2006,10); -- Viole la contrainte de la clé étrangère "fk_inscription_tarif"
-- 7.2 
DELETE FROM auditeur WHERE upper(nom) = 'DUPONT' AND upper(prenom) = 'CHRISTOPHE'; -- Viole la contrainte ed la flé étrangère "fk_inscription_tarif"
-- 7.3
ALTER TABLE inscription ADD CONSTRAINT annee_check CHECK (annee>2004 AND annee<2020); -- La contrainte de verification annee_check n'est pas applicable pcq il y a déjà une ligne avec 2004
-- 7.4
 ALTER TABLE auditeur ADD CONSTRAINT date_nais_check CHECK (date_nais>'1930-01-01'); -- La contrainte de verification annee_check n'est pas applicable pcq il y a déjà une ligne avec 1890
-- 7.5
ALTER TABLE inscrire 
    ADD CONSTRAINT note1_check CHECK (note1 BETWEEN 0 AND 20),
    ADD CONSTRAINT note2_check CHECK (note2 BETWEEN 0 AND 20); -- Table modifiée
-- 7.6 
UPDATE inscrire 
SET note1=-1, note2=21 
WHERE id_ue='NFA005'AND id_auditeur=
    (SELECT DISTINCT id_auditeur 
    FROM auditeur 
    WHERE upper(nom) = 'DUPONT' AND upper(prenom) = 'CHRISTOPHE'); -- Viole la contrainte note1_check et note2_check
-- 7.7
ALTER TABLE ue ALTER COLUMN ects SET NOT NULL; -- Colonne modifée
-- 8.1
SELECT a.nom, a.prenom, SUM(ects) AS "Nombre d'etcs obtenable"
FROM ue
JOIN inscrire ire USING(id_ue)
JOIN inscription ion USING(id_auditeur,annee)
JOIN auditeur a USING(id_auditeur)
WHERE ion.annee=2005 
GROUP BY a.nom, a.prenom
HAVING  upper(a.nom) = 'DUPONT' 
-- 8.2
SELECT a.nom, a.prenom, SUM(ue.ects) AS "Nombre d'etcs obtenu"
FROM ue
JOIN inscrire ire USING(id_ue)
JOIN inscription ion USING(id_auditeur,annee)
JOIN auditeur a USING(id_auditeur)
WHERE note1 >=10 OR note2 >=10
GROUP BY a.nom, a.prenom
HAVING  upper(a.nom) = 'DUPONT' 
-- 8.3
SELECT ROUND(CAST(count(*) AS numeric)/count(DISTINCT id_auditeur),2) AS "nbr ue moyen choisi"
FROM inscrire
WHERE annee = 2005
-- 8.4
SELECT a.nom, a.prenom, i.annee AS "Année d'inscription", ue.id_ue AS "Code ue", ue.designation,  i.annee - EXTRACT('year' FROM a.date_nais) AS "Age au debut de l'inscription a cette ue"
FROM inscription i
JOIN auditeur a USING(id_auditeur)
JOIN inscrire ire USING(id_auditeur,annee)
JOIN ue USING(id_ue)
ORDER BY 1,2
-- 8.5
SELECT i.annee,i.id_tarif,count(DISTINCT id_auditeur)
FROM inscription i
GROUP BY i.annee,i.id_tarif
HAVING count(id_tarif) > 3
-- 8.6
SELECT r.annee,sum(r.montant) AS "montant total"
FROM reglement r
GROUP BY annee 
-- 8.7
SELECT ue.id_ue, count(DISTINCT i.id_auditeur) AS "nombre "
FROM ue
JOIN inscrire i USING(id_ue)
GROUP BY ue.id_ue
-- 8.8
SELECT DISTINCT i.id_auditeur,a.nom,a.prenom
FROM inscrire i
JOIN inscription USING(id_auditeur,annee)
JOIN auditeur a USING(id_auditeur)
EXCEPT
SELECT DISTINCT i.id_auditeur,a.nom,a.prenom
FROM inscrire i
JOIN inscription USING(id_auditeur,annee)
JOIN auditeur a USING(id_auditeur)
WHERE i.id_ue = 'NFA001' AND (i.note1>=10 OR i.note2>=10)

SELECT DISTINCT id_auditeur,nom,prenom
FROM auditeur
WHERE id_auditeur NOT IN (
    SELECT id_auditeur 
    FROM inscrire 
    WHERE i.id_ue = 'NFA001' AND (i.note1>=10 OR i.note2>=10))
-- 8.9
SELECT s1.id_auditeur,a.nom,a.prenom ,
	CASE
	WHEN count(s1.id_auditeur)>1 THEN 'Différent tarif utilisé'
	ELSE 'Un seul tarif utilisé'
	END
FROM (SELECT id_tarif,id_auditeur,count(DISTINCT id_auditeur)
FROM inscription
GROUP BY id_auditeur,id_tarif) AS s1
JOIN auditeur a USING(id_auditeur)
GROUP BY s1.id_auditeur,a.nom,a.prenom
ORDER BY 1