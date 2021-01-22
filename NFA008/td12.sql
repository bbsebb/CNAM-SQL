/* Exercice 1*/

CREATE TABLE produit_archives AS 
    SELECT * FROM produit WHERE 1=0;

CREATE OR REPLACE FUNCTION sauv_produit() RETURNS TRIGGER LANGUAGE plpgsql AS $sauv_produit$  
    BEGIN 
        INSERT INTO produit_archives SELECT OLD.*;
        RETURN NEW;
    END
    $sauv_produit$;

CREATE TRIGGER sauv_produit 
AFTER UPDATE OR DELETE 
ON produit 
FOR EACH ROW EXECUTE PROCEDURE sauv_produit(); 

DELETE FROM produit WHERE id_produit='b1286' OR id_produit='b3114';

UPDATE produit SET designation = 'test' WHERE prix>100;

/* Exercice 2 */

CREATE OR REPLACE FUNCTION calc_montant_ht() RETURNS TRIGGER LANGUAGE plpgsql AS 
$calc_montant_ht$
DECLARE
    id_com ligne_commande.id_commande%TYPE;
BEGIN

    CASE TG_OP 
        WHEN 'INSERT' THEN id_com := NEW.id_commande;
        WHEN 'DELETE' THEN id_com := OLD.id_commande;
        WHEN 'UPDATE' THEN id_com := NEW.id_commande;
        ELSE raise exception 'Erreur';
    END CASE;

    UPDATE commande SET montant_ht = montant_cmd(id_com) WHERE id_commande = id_com;

    RETURN NEW;


END
$calc_montant_ht$;

CREATE TRIGGER calc_montant_ht
AFTER UPDATE OR DELETE OR INSERT 
ON ligne_commande
FOR EACH ROW EXECUTE PROCEDURE calc_montant_ht();

DELETE FROM ligne_commande WHERE id_ligne = 3;

UPDATE ligne_commande SET quantite = 2 WHERE id_ligne = 2;

INSERT INTO ligne_commande VALUES ('00000001',1,1,'d3899');
