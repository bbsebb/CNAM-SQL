/*
1.1
π annee, num_ordre, montant (REGLEMENT ⋈ INSCRIPTION ⋈ ( σ nom=’dupont’ AND prenom=’Christophe’ (AUDITEUR) ))

1.2
π nom,prenom ( AUDITEUR ⋈ INSCRIPTION ⋈ ( σ id_ue = ‘NFA008’ AND (note1 ⩾ 10 OR note2 ⩾ 10) (INSCRIRE)))

1.3
π tarif (TARIF ⋈ INSCRIPTION ⋈ ( σ nom = ‘dupont’ AND prenom = ‘Christophe’ (AUDITEUR) ))

1.4
R1 = π nom, prenom (AUDITEUR ⋈ INSCRIPTION)
R2 = π nom, prenom (AUDITEUR)
R2-R1

1.5 
R1 = π id_ue ( UE ⋈ (σ note1 ⩾ 10 OR note2 ⩾ 10 (INSCRIRE)) ⋈ INSCRIPTION ⋈ ( σ nom = ‘dupont’ AND prenom = ‘Christophe’ (AUDITEUR)))
R2 = π id_ue (UE)
R2-R1
*/
/*2.1*/
SELECT ROUND(AVG(montant),2) || '€' FROM reglement;

/*2.2*/
SELECT  nom, prenom, EXTRACT(year FROM AGE(date_nais::timestamp)) || ' années' AS "années", 
        EXTRACT(month FROM AGE(date_nais::timestamp)) || ' mois'AS "mois",
        EXTRACT(day FROM AGE(date_nais::timestamp)) || ' jours' AS "jours"
FROM auditeur;

/*2.3*/
SELECT nom,prenom,ROUND(AVG(note1),2) 
FROM inscrire 
JOIN inscription USING(id_auditeur,annee)
JOIN auditeur USING(id_auditeur)
GROUP BY nom,prenom;

/*2.4*/
SELECT id_ue, annee, COUNT(*) AS "nbr d'inscrit"
FROM auditeur
JOIN inscription USING(id_auditeur)
JOIN inscrire USING(id_auditeur,annee)
GROUP BY id_ue,annee
ORDER BY id_ue,annee;

/*2.5*/
SELECT nom,prenom,count(*)
FROM auditeur
JOIN inscription USING(id_auditeur)
GROUP BY nom,prenom
HAVING COUNT(*) = (SELECT COUNT(DISTINCT(annee)) FROM inscription );

/*3.1*/
CREATE OR REPLACE VIEW V_nbr_ue_by_auditeur AS 
SELECT nom,prenom,COUNT(*) AS nbr_ue
FROM auditeur
JOIN inscription USING(id_auditeur)
JOIN inscrire USING(id_auditeur,annee)
GROUP BY nom,prenom;

/*3.2*/
SELECT * FROM V_nbr_ue_by_auditeur;

/*3.3*/
INSERT INTO inscrire VALUES (12,2005,'NFA002');

/*3.4
Elle a bien été prise en compte en effectuant la requete suivant, l'auditeur avec l'id 12 passe de 1 à 2 nombre d'ue inscrit*/
SELECT * FROM V_nbr_ue_by_auditeur;

/*4.1*/
CREATE OR REPLACE FUNCTION valider_ue(code_auditeur auditeur.id_auditeur%TYPE,code_ue1 inscrire.id_ue%TYPE, code_ue2 inscrire.id_ue%TYPE) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE 
rs1 boolean;
rs2 boolean;
rtr boolean DEFAULT false;
BEGIN

    -- Retourne une ligne si l'auditeur a reussi cette ue (peu importe l'année)
    PERFORM * FROM inscrire WHERE id_auditeur = code_auditeur AND id_ue = code_ue1 AND (note1>=10 OR note2>=10);
    IF FOUND -- si un ligne a ete trouvé
        THEN rs1 := true;
        ELSE rs1 := false;
    END IF;
    -- Retourne une ligne si l'auditeur a reussi cette ue (peu importe l'année)
    PERFORM * FROM inscrire WHERE id_auditeur = code_auditeur AND id_ue = code_ue2 AND (note1>=10 OR note2>=10);
    IF FOUND -- si un ligne a ete trouvé
        THEN rs2 := true;
        ELSE rs2 := false;
    END IF;

    IF rs1 AND rs2 -- si les deux ue ont été validées
        THEN rtr := true;
        ELSE rtr := false;
    END IF;

    RETURN rtr;
END
$$;

/*4.2*/
CREATE OR REPLACE FUNCTION valider_ue(code_auditeur auditeur.id_auditeur%TYPE) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE
lesUE ue%ROWTYPE;
rtr boolean DEFAULT false;
rtrr boolean DEFAULT false;
BEGIN
    FOR lesUE IN (SELECT distinct(id_ue) FROM ue) -- On recupère la liste de toutes les ue
    LOOP -- pour chaque ue
        -- Retourne une ligne si l'auditeur a reussi cette ue (peu importe l'année)
        PERFORM * FROM inscrire WHERE id_auditeur = code_auditeur AND id_ue = lesUE.id_ue AND (note1>=10 OR note2>=10);
        IF FOUND -- si un ligne a ete trouvé
            THEN rtr := true;
            ELSE 
                rtr := false; 
                exit; -- on peut quitter le boucle dès qu'une ue n'a pas été validée
         END IF;
    END LOOP;

    RETURN rtr;
END
$$

/*5.1*/
CREATE OR REPLACE FUNCTION supp_gratuit() RETURNS TRIGGER LANGUAGE plpgsql AS $supp_gratuit$
DECLARE
inscr inscription%ROWTYPE;
BEGIN
    IF NEW.id_tarif = 2 -- Si le nouveau tarif est gratuit
        THEN
            SELECT * INTO inscr FROM inscription WHERE id_tarif = 2 AND id_auditeur = NEW.id_auditeur;
            -- On supprime la ligne de la reglement qui correspond
            DELETE FROM reglement WHERE id_auditeur = inscr.id_auditeur AND annee = inscr.annee;
            RAISE NOTICE 'Le reglement est devenu nul et une ligne a été supprimée % %',inscr.id_auditeur,inscr.annee;
        ELSE
            RAISE NOTICE 'Aucun changement' ;
    END IF;
    RETURN NEW;
END
$supp_gratuit$;

CREATE TRIGGER supp_gratuit AFTER UPDATE ON inscription 
FOR EACH ROW 
EXECUTE PROCEDURE supp_gratuit();

/*5.2*/

CREATE OR REPLACE FUNCTION verif_note2() RETURNS TRIGGER LANGUAGE plpgsql AS $verif_note2$
BEGIN
    IF OLD.note1 >= 10 -- Si la note 1 est positive, on arrête la procèdure et lance une exception.
        THEN RAISE EXCEPTION 'La note 1 est positive, cette ue est déjà validée';
    END IF;

    RETURN NEW;
END
$verif_note2$;

CREATE TRIGGER verif_note2 BEFORE INSERT OR UPDATE ON inscrire FOR EACH ROW EXECUTE PROCEDURE verif_note2();


