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
$$