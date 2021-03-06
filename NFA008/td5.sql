SELECT tel_perso, tel_prof, tel_mobile FROM client WHERE nom = 'Lecouvert' AND prenom ='Jérémi'; 
SELECT id_commande, date, id_remise FROM commande WHERE id_remise >=20;
SELECT nom,prenom FROM vendeur WHERE prenom IN ('Albert','Pascal','Philippe');
SELECT nom,prenom,tel_perso FROM client WHERE id_ville = 1;
SELECT * FROM commande WHERE id_client = 11 AND (date BETWEEN  '1-03-2005' AND  '31-03-2005');
SELECT id_produit, designation,prix,prix *1.20 AS prix_TTC FROM produit ORDER BY produit;
SELECT id_commande,(montant_ht - montant_ht * 0.1)*1.2 AS montant_ttc FROM commande WHERE id_commande = '00000011';
SELECT id_produit,designation,prix FROM produit WHERE LOWER(designation) LIKE '%carte%'; 
SELECT id_produit ||' : ' || designation || ' (' || prix || ' euros)' AS a FROM produit ;
SELECT id_vendeur, AVG(montant_ht) FROM commande GROUP BY id_vendeur;
SELECT id_produit, SUM(quantite) AS sum_q FROM ligne_commande GROUP BY id_produit HAVING SUM(quantite)>10 ORDER BY sum_q DESC,id_produit ASC;
SELECT designation,descriptif FROM produit WHERE descriptif IS NOT NULL ;
