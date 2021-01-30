

CREATE OR REPLACE FUNCTION InsererRdv(dateF Lecon.Date%TYPE,heureF Lecon.Heure%TYPE, dureeF Lecon.Duree%TYPE, lieuRdvF Lecon.LieuRdv%TYPE, 
                                    codeMoniteurF Lecon.CodeMoniteur%TYPE, numeroEleveF Lecon.NumeroEleve%TYPE, immatriculationF Lecon.Immatriculation%TYPE) RETURNS boolean LANGUAGE plpgsql AS $$
DECLARE
newNumLecon Lecon.NumLecon%TYPE;
BEGIN
    -- On verifie si le code moniteur existe
    PERFORM * FROM Moniteur WHERE CodeMoniteur = codeMoniteurF;
    IF NOT FOUND THEN 
        RETURN false; -- Si il n'existe pas, on returne false et on arrête la fonction
    END IF;
    -- On verifie si le numéro d'éléve existe
    PERFORM * FROM Eleve WHERE NumeroEleve = numeroEleveF;
    IF NOT FOUND THEN 
        RETURN false; -- Si il n'existe pas, on returne false et on arrête la fonction
    END IF;
    -- On verifie si l'immatriculation' existe
    PERFORM * FROM Vehicule WHERE Immatriculation = immatriculationF;
    IF NOT FOUND THEN 
        RETURN false; -- Si il n'existe pas, on returne false et on arrête la fonction
    END IF;

    -- Toutes les verifications sont correctes
    -- On cherche le dernier numéro de la clé primaire de la table 'Lecon'
    SELECT MAX(NumLecon) + 1 INTO newNumLecon FROM Lecon;
    -- On ajoute les données dans la table 'Lecon'
    INSERT INTO Lecon VALUES (newNumLecon,dateF,heureF, dureeF, lieuRdvF, codeMoniteurF, numeroEleveF, immatriculationF);
       
    -- On verifie qu'une donnée a bien été inserée sinon on renvoie false;
    IF FOUND THEN 
        RETURN true;
    ELSE 
        RETURN false;
    END IF;

END
$$;

DROP FUNCTION InsererRdv (dateF Lecon.Date%TYPE,heureF Lecon.Heure%TYPE, dureeF Lecon.Duree%TYPE, lieuRdvF Lecon.LieuRdv%TYPE, 
                                    codeMoniteurF Lecon.CodeMoniteur%TYPE, numeroEleveF Lecon.NumeroEleve%TYPE, immatriculationF Lecon.Immatriculation%TYPE);



CREATE OR REPLACE FUNCTION InsererRdv(dateF Lecon.Date%TYPE,heureF Lecon.Heure%TYPE, dureeF Lecon.Duree%TYPE, lieuRdvF Lecon.LieuRdv%TYPE, 
                                    codeMoniteurF Lecon.CodeMoniteur%TYPE, numeroEleveF Lecon.NumeroEleve%TYPE, immatriculationF Lecon.Immatriculation%TYPE) RETURNS boolean LANGUAGE plpgsql AS $$
DECLARE
newNumLecon Lecon.NumLecon%TYPE;
BEGIN
    -- On verifie si le code moniteur existe
    PERFORM * FROM Moniteur WHERE CodeMoniteur = codeMoniteurF;
    IF NOT FOUND THEN 
        RETURN false; -- Si il n'existe pas, on returne false et on arrête la fonction
    END IF;
    -- On verifie si le numéro d'éléve existe
    PERFORM * FROM Eleve WHERE NumeroEleve = numeroEleveF;
    IF NOT FOUND THEN 
        RETURN false; -- Si il n'existe pas, on returne false et on arrête la fonction
    END IF;
    -- On verifie si l'immatriculation' existe
    PERFORM * FROM Vehicule WHERE Immatriculation = immatriculationF;
    IF NOT FOUND THEN 
        RETURN false; -- Si il n'existe pas, on returne false et on arrête la fonction
    END IF;

    -- Toutes les verifications sont correctes
    -- On cherche le dernier numéro de la clé primaire de la table 'Lecon'
    SELECT MAX(NumLecon) + 1 INTO newNumLecon FROM Lecon;
    -- On ajoute les données dans la table 'Lecon'
    INSERT INTO Lecon VALUES (newNumLecon,dateF,heureF, dureeF, lieuRdvF, codeMoniteurF, numeroEleveF, immatriculationF);
       
    -- On verifie qu'une donnée a bien été inserée sinon on renvoie false;
    IF FOUND THEN 
        RETURN true;
    ELSE 
        RETURN false;
    END IF;

END
$$;

DROP FUNCTION InsererRdv (dateF Lecon.Date%TYPE,heureF Lecon.Heure%TYPE, dureeF Lecon.Duree%TYPE, lieuRdvF Lecon.LieuRdv%TYPE, 
                                    codeMoniteurF Lecon.CodeMoniteur%TYPE, numeroEleveF Lecon.NumeroEleve%TYPE, immatriculationF Lecon.Immatriculation%TYPE);