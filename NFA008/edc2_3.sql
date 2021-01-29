/*Exercice 1*/
CREATE OR REPLACE FUNCTION moyDuree() RETURNS numeric LANGUAGE plpgsql AS $$
BEGIN
    RETURN (SELECT AVG( -- Calcule de la moyenne de durée des film
            CASE WHEN duree IS NULL -- Si la durée est null, on met 0
                THEN 0 
                ELSE duree 
            END)::numeric(5,2) 
    
    FROM film);
   
END
$$;

/*EXERCICE 2*/
CREATE OR REPLACE FUNCTION castHM(nbrMinutes int) RETURNS varchar LANGUAGE plpgsql AS $$
DECLARE
heure int;
minute int;
rtr varchar;
BEGIN
heure = TRUNC(nbrMinutes/60);
minute = nbrMinutes%60;
rtr =  heure || 'H' || minute || 'min';
RETURN rtr;
END
$$;

SELECT titrefilm, castHM(duree), duree FROM film;

/*EXERCICE 3*/
CREATE OR REPLACE FUNCTION fichefilm(titre varchar) RETURNS varchar LANGUAGE plpgsql AS $$
DECLARE
filmTrouve RECORD;
acteursTrouve RECORD;
rtr varchar;
BEGIN
rtr = '';
-- On boucle les resultats trouvés pour le film en parametre
FOR filmTrouve IN   (SELECT * 
                    FROM film 
                    JOIN genre USING(codegenre) 
                    WHERE LOWER(titrefilm) LIKE LOWER('%'||titre||'%'))
    LOOP 
        rtr = rtr || filmTrouve.titrefilm;
        -- Si la durée ou l'année sont présent
        IF (filmTrouve.duree IS NOT NULL OR filmTrouve.annee IS NOT NULL) THEN
             rtr =  rtr || ' (';
            -- Si la durée et l'année sont présent
            IF (filmTrouve.annee IS NOT NULL AND filmTrouve.duree IS NOT NULL) THEN
                 rtr = rtr || filmTrouve.annee || ', ' || filmTrouve.duree;
            -- Si seulement la durée
            ELSEIF (filmTrouve.duree IS NOT NULL) THEN
                 rtr = rtr || filmTrouve.duree;
            -- Si seulement l'année
            ELSE  
                 rtr = rtr || filmTrouve.annee;
            END IF;
            rtr = rtr || ')';
        END IF;
        -- Mise en forme avec retour à la ligne (chr(10))
        rtr = rtr || CHR(10) ;
        rtr = rtr || filmTrouve.intgenre || CHR(10) ;
        -- On boucle les acteurs pour ce film
        FOR acteursTrouve IN    (SELECT nomacteur || ' ' || prenomacteur AS "acteur"
                                FROM jouer_un_role 
                                JOIN acteur USING(codeacteur) 
                                WHERE codefilm = filmTrouve.codefilm)
            LOOP
                rtr = rtr || acteursTrouve.acteur || CHR(10) ;
            END LOOP;
    END LOOP;
    rtr = rtr || CHR(10) || CHR(10);
    RETURN rtr;
END
$$;

/*Exercice 4*/

CREATE OR REPLACE FUNCTION testgenre() RETURNS TRIGGER LANGUAGE plpgsql AS $testgenre$ 
BEGIN
    IF NEW.codegenre < 0 THEN
        RAISE EXCEPTION 'Erreur : vous devez entrer un code genre positif à la place de %' , NEW.codegenre;
    END IF;
    RETURN NEW;
END
$testgenre$;

CREATE TRIGGER testgenre 
BEFORE UPDATE OR INSERT 
ON genre 
FOR EACH ROW EXECUTE PROCEDURE testgenre();

INSERT INTO genre VALUES (-1,'test');
UPDATE genre SET codegenre = -1 WHERE codegenre = 1;

/*Exercice 5 */

CREATE TABLE film_archive AS (SELECT * FROM film WHERE 1=0);

CREATE OR REPLACE FUNCTION arch_film() RETURNS TRIGGER LANGUAGE plpgsql AS $arch_film$
BEGIN
INSERT INTO film_archive 
VALUES  (OLD.codefilm,OLD.titrefilm,OLD.annee,
        OLD.duree,OLD.resume,OLD.codegenre,OLD.codeserie);
RETURN NEW;
END
$arch_film$;

DROP TRIGGER arch_film ON film;

CREATE TRIGGER arch_film 
AFTER DELETE 
ON film 
FOR EACH ROW EXECUTE PROCEDURE arch_film();

DELETE FROM film WHERE codefilm = 7 OR codefilm = 8;

/*Exercice 6*/
CREATE TABLE emprunt_archive AS (SELECT * from emprunt WHERE 1=0);

CREATE OR REPLACE FUNCTION archive_emprunt() RETURNS TRIGGER LANGUAGE plpgsql AS $archive_emprunt$
DECLARE
nbrEnr int;
emprunt_obsolete emprunt%ROWTYPE;
BEGIN
    -- on compte le nombre d'emprunt avec une date de retour
    SELECT COUNT(*) INTO nbrEnr FROM emprunt WHERE dateretour IS NOT NULL;
    -- Si nbr d'emprunt superieur à 10
    IF nbrEnr > 10 THEN
        -- On parcours tous ces emprunts pour les transferer
        FOR emprunt_obsolete IN (SELECT * FROM emprunt WHERE dateretour IS NOT NULL)
            LOOP
                INSERT INTO emprunt_archive VALUES (emprunt_obsolete.*);
                DELETE FROM emprunt WHERE codefilm = emprunt_obsolete.codefilm
                AND numexemplaire = emprunt_obsolete.numexemplaire 
                AND codepers = emprunt_obsolete.codepers AND datepret =  emprunt_obsolete.datepret;
            END LOOP;
    END IF;
    RETURN NEW;
END
$archive_emprunt$;

CREATE TRIGGER archive_emprunt 
AFTER UPDATE OR INSERT 
ON emprunt 
FOR EACH ROW EXECUTE PROCEDURE archive_emprunt(); 

SELECT * from emprunt;
SELECT * from emprunt_archive;
UPDATE emprunt SET dateretour = CURRENT_DATE WHERE codefilm = 12 AND codepers=2;
SELECT * from emprunt;
SELECT * from emprunt_archive;