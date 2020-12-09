CREATE OR REPLACE FUNCTION supcompte(num_compte integer) RETURNS void LANGUAGE plpgsql AS '
DECLARE
tuple_compte compte%ROWTYPE;
nbr_compte INTEGER;
num_client client.code_client%TYPE;
BEGIN
    SELECT DISTINCT code_client INTO num_client FROM compte WHERE no_compte = num_compte;
    SELECT count(*) INTO nbr_compte FROM compte WHERE code_client = num_client;
    SELECT * INTO tuple_compte FROM compte WHERE no_compte = num_compte;

    INSERT INTO ancclient SELECT * FROM client WHERE code_client = num_client ON CONFLICT DO NOTHING;
    INSERT INTO anccompte 
    VALUES (num_compte,tuple_compte.date_creation,CURRENT_DATE,tuple_compte.code_client);

    DELETE FROM ecriture WHERE no_compte = num_compte;
    DELETE FROM associer WHERE no_compte = num_compte;
    DELETE FROM compte WHERE no_compte = num_compte;

    IF nbr_compte = 1 THEN 
        DELETE FROM client WHERE code_client = num_client;
    END IF;
END
';


