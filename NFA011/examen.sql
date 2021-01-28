CREATE TABLE DonnerLieu (
    Code varchar,
    Ref varchar,
    PRIMARY KEY (Code,Ref),
    FOREIGN KEY (code) REFERENCES Client (code),
    FOREIGN KEY (Ref) REFERENCES Facture (Ref) 
);

CREATE OR REPLACE FUNCTION majBonClient( montantBC BonClient.TotalMontant%TYPE) RETURNS integer LANGUAGE plpgsql $$
DECLARE
nbrBonClient = 0 integer;
BonClients RECORD;

BEGIN
TRUNCATE TABLE BonClient;


FOR BonClients IN   (SELECT *,SUM(Montant) AS TotalMontant FROM Client
                    JOIN DonnerLieu USING(Code)
                    JOIN Facture USING(Ref) 
                    GROUP BY Code 
                    HAVING SUM(Montant) >= montantBC)
        LOOP
            INSERT INTO BonClient VALUES (BonClients.Code, BonClients.TotalMontant);
            nbrBonClient ++;
        END LOOP;
    RETURN nbrBonClient;
END
$$;

CREATE OR REPLACE FUNCTION MontantNote(numNote Note.NoNote%TYPE) RETURNS numeric LANGUAGE plpgsql AS $$
DECLARE
TVA Note.TauxTVA%TYPE;
montantHT numeric;
BEGIN

SELECT TauxTVA INTO TVA FROM Note WHERE NoNote = numNote;

SELECT SUM(r.colPrix) INTO montantHT FROM (
                                        SELECT (SUM(Quantite) * PrixPlat) AS colPrix
                                        FROM Composer
                                        JOIN Plat USING (NoPlat) 
                                        WHERE NoNote = numNote 
                                        GROUP BY NoPlat,PrixPlat) AS r;
 
RETURN   montantHT *(1+TVA);  
END
$$;
DROP FUNCTION MontantNote(numNote Note.NoNote%TYPE);

CREATE OR REPLACE FUNCTION InserePlat(Libelle Plat.LibellePlat%TYPE, Prix Plat.PrixPlat%TYPE) RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
maxNumPlat integer;
BEGIN
    SELECT MAX(NoPlat) INTO maxNumPlat FROM Plat;
    INSERT INTO Plat VALUES (MaxNumPlat+1,Libelle,Prix);
END
$$

Select InserePlat('Salade',5.2);
SELECT * FROM Client;