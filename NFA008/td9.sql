-- 1.1
CREATE OR REPLACE VIEW V_ligne_commande AS
SELECT c.id_commande, l.id_ligne, p.id_produit, p.prix, l.quantite, c.montant_ht, ROUND(c.montant_ht*1.2,2) AS montant_ttc
FROM commande c 
JOIN ligne_commande l USING(id_commande)
JOIN produit p USING(id_produit)
-- 1.2
SELECT view.*,cl.nom AS "Nom client",cl.prenom AS "Prénom client",cl.tel_mobile AS "Téléphone mobile client",vi.ville AS "Ville client",d.departement AS "Département client",v.nom AS "Nom vendeur",v.prenom AS "Prénom vendeur",
    (SELECT SUM(montant_ttc) 
    FROM V_ligne_commande 
    GROUP BY id_commande 
    HAVING id_commande= '00000002') AS "Montant Total TTC"
FROM V_ligne_commande view
JOIN commande co USING(id_commande)
JOIN client cl USING(id_client)
JOIN ville vi USING (id_ville)
JOIN departement d USING(id_departement)
JOIN vendeur v USING(id_vendeur)
WHERE view.id_commande = '00000002'
-- 2.1
CREATE ROLE user1 WITH LOGIN;
CREATE ROLE user2 WITH LOGIN;
CREATE ROLE user3 WITH LOGIN;
-- 2.2
GRANT SELECT ON produit TO PUBLIC;
-- 2.3
GRANT SELECT,UPDATE ON client TO user1 WITH GRANT OPTION;
-- 2.4
SELECT * FROM pg_roles WHERE rolname='user2';
-- 2.5
CREATE ROLE grp1;
GRANT SELECT,UPDATE ON vendeur TO grp1;
GRANT grp1 TO user3;

