/*1*/SELECT s.nom, v.nom, v.prenom 
FROM service s 
JOIN appartient USING(id_service) 
JOIN vendeur v USING(id_vendeur);

/*2*/SELECT c.nom,c.prenom,v.ville,p.designation 
FROM client c 
JOIN ville v USING(id_ville) 
JOIN commande USING(id_client) 
JOIN ligne_commande USING(id_commande) 
JOIN produit p USING(id_produit) 
WHERE LOWER(c.nom) = 'cnam' 
GROUP BY c.nom,c.prenom,v.ville,p.id_produit;

/*3*/SELECT v.nom,v.prenom, COUNT(*) 
FROM vendeur v 
JOIN appartient USING(id_vendeur)  
GROUP BY v.id_vendeur	;

/*4*/SELECT DISTINCT p.designation 
FROM produit p 
JOIN ligne_commande USING(id_produit) 
JOIN commande c USING(id_commande) 
WHERE c.date BETWEEN '2005-01-01' AND ;'2005-12-31' 
GROUP BY p.id_produit ;

/*5*/SELECT c.id_commande, c.date, c.montant_ht,SUM(l.quantite * p.prix)*(1-CAST(CAST(c.id_remise AS numeric(8,2))/100 AS numeric(8,2))) AS mt  FROM commande c 
JOIN ligne_commande l USING(id_commande) 
JOIN produit p USING(id_produit) 
WHERE c.id_remise IS NOT NULL 
GROUP BY c.id_commande ;

/*6*/SELECT c.id_commande, c.date, c.montant_ht , c.montant_ht * 1.20 AS montant_ttc,
c.montant_ht *0.2 AS taxe, c.id_remise || '%' AS remise, cl.nom AS nom_client,cl.prenom AS prenom_client,
v.nom AS nom_vendeur, v.prenom AS prenom_vendeur,l.id_ligne, p.designation, 
p.prix, l.quantite, p.delai_livraison, p.prix * 1.2 AS prix_ttc,
p.prix * 1.2*l.quantite AS "Montant TTC par ligne",
p.prix * l.quantite*0.2 AS "Montant TVA par ligne"
FROM commande c 
JOIN ligne_commande l USING(id_commande)
JOIN produit p USING(id_produit)
JOIN client cl USING(id_client)
JOIN vendeur v USING(id_vendeur);

/*7*/SELECT SUM(c.montant_ht) 
FROM commande c
WHERE id_client = 
    (SELECT id_client 
    FROM client 
    WHERE lower(nom) = 'cnam') 
AND id_commande IN 
    (SELECT id_commande 
    FROM ligne_commande 
    WHERE id_produit IN 
        (SELECT id_produit 
        FROM produit 
        WHERE lower(designation) LIKE '%bo_tier%'))

/*8*/SELECT SUM(c.montant_ht) 
FROM commande c 
JOIN client cl USING(id_client)
JOIN ligne_commande USING(id_commande)
JOIN produit p USING(id_produit)
WHERE lower(cl.nom) = 'cnam' AND lower(p.designation) LIKE '%bo_tier%'

/*9*/ SELECT p.designation,p.prix, SUM(l.quantite)
FROM  ligne_commande l 
JOIN produit p USING(id_produit)
GROUP BY p.id_produit

/*10*/SELECT DISTINCT p.designation
FROM  produit p 
WHERE p.id_produit NOT IN 
    (SELECT id_produit 
    FROM ligne_commande);

SELECT DISTINCT designation
FROM produit
EXCEPT
SELECT DISTINCT designation
FROM produit 
JOIN ligne_commange USING(id_produit)




