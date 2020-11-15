/*1*/ CREATE TABLE categorie (
    id_categorie int PRIMARY KEY,
    nom varchar(30)
)
/*2*/ INSERT INTO categorie (id_categorie,nom) 
VALUES  (1,'Pièces détachées'),
        (2,'Stockage externe'),
        (3,'Ecrans'),
        (4,'Imprimantes'),
        (5,'Dispositifs de pointage'),
        (6,'Son'),
        (7,'Scanners')

/*3*/ ALTER TABLE produit 
ADD COLUMN id_categorie int,
ADD CONSTRAINT fk_id_categorie FOREIGN KEY (id_categorie) REFERENCES categorie (id_categorie)
/* Impossible d'ajouter pour l'instantant le condition :
"un produit appartient a une et sune seule catégorie de produit " */

/*4*/ 
BEGIN TRANSACTION;
UPDATE produit 
SET id_categorie = 
    (SELECT DISTINCT id_categorie 
    FROM categorie
    WHERE nom = 'Stockage externe') 
WHERE lower(designation) LIKE '%clé%';
UPDATE produit 
SET id_categorie = 
    (SELECT DISTINCT id_categorie 
    FROM categorie
    WHERE nom = 'Ecrans') 
WHERE lower(designation) LIKE '%_cran%';
UPDATE produit 
SET id_categorie = 
    (SELECT DISTINCT id_categorie 
    FROM categorie
    WHERE nom = 'Imprimantes') 
WHERE lower(designation) LIKE '%imprimante%';
UPDATE produit 
SET id_categorie = 
    (SELECT DISTINCT id_categorie 
    FROM categorie
    WHERE nom = 'Dispositifs de pointage') 
WHERE lower(designation) LIKE '%souris%' OR lower(designation) LIKE '%clavier%';
UPDATE produit 
SET id_categorie = 
    (SELECT DISTINCT id_categorie 
    FROM categorie
    WHERE nom = 'Son') 
WHERE lower(designation) LIKE '%haut_parleur%' ;
UPDATE produit 
SET id_categorie = 
    (SELECT DISTINCT id_categorie 
    FROM categorie
    WHERE nom = 'Scanners') 
WHERE lower(designation) LIKE '%scanner%' ;
UPDATE produit 
SET id_categorie = 
    (SELECT DISTINCT id_categorie 
    FROM categorie
    WHERE nom = 'Pièces détachées') 
WHERE id_categorie IS NULL ;
ALTER TABLE produit 
ALTER COLUMN id_categorie SET NOT NULL;
COMMIT;
/*5*/
SELECT id_produit, designation, nom 
FROM produit
JOIN categorie USING(id_categorie) 