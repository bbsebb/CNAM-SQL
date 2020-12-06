CREATE OR REPLACE FUNCTION montant_cmd(nom_cmd commande.id_commande%TYPE) RETURNS numeric LANGUAGE plpgsql AS '
DECLARE
    montant_ht numeric;
    remise numeric NOT NULL DEFAULT 0;
BEGIN
    SELECT SUM(p.prix*l.quantite) INTO montant_ht 
    FROM ligne_commande l
    JOIN produit p USING(id_produit) 
    WHERE id_commande = nom_cmd;
    SELECT id_remise/100 INTO remise 
    FROM commande
    WHERE id_commande = nom_cmd;
    RETURN montant_ht * (remise+1);
END
'