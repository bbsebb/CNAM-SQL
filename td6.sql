SELECT s.nom, v.nom, v.prenom FROM service s INNER JOIN appartient USING(id_service) JOIN vendeur v USING(id_vendeur);
test