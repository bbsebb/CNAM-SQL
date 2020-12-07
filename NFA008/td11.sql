-- 1.1
CREATE OR REPLACE FUNCTION montant_cmd(nom_cmd commande.id_commande%TYPE) RETURNS numeric LANGUAGE plpgsql AS '
DECLARE
    montant_ht numeric;
    remise numeric;
BEGIN
    SELECT SUM(p.prix*l.quantite) INTO montant_ht 
    FROM ligne_commande l
    JOIN produit p USING(id_produit) 
    WHERE id_commande = nom_cmd;
    SELECT CAST(id_remise AS numeric)/100 INTO remise 
    FROM commande
    WHERE id_commande = nom_cmd; 
    IF remise IS NULL THEN remise := 0;
    END IF;
    RETURN ROUND(montant_ht * (remise+1),2);
END
'
-- 1.2
CREATE OR REPLACE FUNCTION verif_montant_ht(nom_cmd commande.id_commande%TYPE) RETURNS boolean LANGUAGE plpgsql AS '
DECLARE
    montant_ht_lc commande.montant_ht%TYPE;
    montant_ht_c commande.montant_ht%TYPE;
    rtr boolean;
BEGIN
    SELECT SUM(p.prix*l.quantite) INTO montant_ht_lc 
    FROM ligne_commande l
    JOIN produit p USING(id_produit) 
    WHERE id_commande = nom_cmd;
    SELECT montant_ht INTO montant_ht_c
    FROM commande 
    WHERE id_commande = nom_cmd;
    IF montant_ht_lc = montant_ht_c 
        THEN rtr = true ;
        ELSE rtr = false;
    END IF;
    RETURN rtr;
END
'

-- 2.1
CREATE OR REPLACE FUNCTION bissextile(annee integer) RETURNS boolean LANGUAGE plpgsql AS '
DECLARE
rtr boolean DEFAULT false;
BEGIN
IF (MOD(annee,4)=0 AND MOD(annee,100)!=0)  OR MOD(annee,400) = 0 
    THEN rtr = true;
END IF;
RETURN rtr;
END
'

-- 2.2
CREATE OR REPLACE FUNCTION nbr_jours (annee integer, mois integer) RETURNS integer LANGUAGE plpgsql AS '
DECLARE
rtr integer;
BEGIN
IF mois IN (1,3,5,7,8,10,12) 
    THEN rtr = 31;
ELSEIF mois IN(4,6,9,11) 
    THEN rtr = 30;
ELSEIF mois = 2 and bissextile(annee) 
    THEN rtr = 29;
ELSE 
    rtr = 28;
END IF;
RETURN rtr;
END
'

-- 2.3
CREATE OR REPLACE FUNCTION chk_date (annee integer, mois integer, jour integer) RETURNS boolean LANGUAGE plpgsql AS '
DECLARE
rtr boolean DEFAULT true;
BEGIN
IF annee<=0 OR mois<=0 OR jour<=0 OR mois >12 OR jour > nbr_jours(annee,mois) 
    THEN rtr = false;
END IF;
RETURN rtr;
END
'
CREATE OR REPLACE FUNCTION chk_date(date date) RETURNS boolean LANGUAGE plpgsql AS '
DECLARE
annee integer;
mois integer;
jour integer;
BEGIN
annee := EXTRACT(YEAR from date );
mois := EXTRACT(MONTH from date );
jour := EXTRACT(DAY from date );
RETURN chk_date(annee,mois,jour);
END
'
-- 2.4
SELECT 
    CASE WHEN chk_date(date) THEN 'date correct'
	ELSE 'date incorrect'
	END
FROM commande;