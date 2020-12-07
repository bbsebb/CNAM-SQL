-- 2.1
/* Écrire la déclaration de la fonction AuCarre qui élève au carré la valeur d’un nombre réel passé
en paramètre. */
CREATE OR REPLACE FUNCTION AuCarre(nbr integer) RETURNS integer LANGUAGE plpgsql AS '
BEGIN
RETURN nbr*nbr;
END
';
/* Écrire la déclaration du code SQL permettant la suppression de la fonction précédente.
 */
DROP FUNCTION AuCarre(nbr integer);
/* Écrire la déclaration de la fonction VarAbs qui calcule la valeur absolue d’un nombre entier passé
en paramètre. */
CREATE OR REPLACE FUNCTION VarAbs(nbr integer) RETURNS integer LANGUAGE plpgsql AS '
BEGIN
IF nbr < 0 
    THEN nbr := nbr * -1;
END IF;
RETURN nbr;
END
'
/* Écrire la déclaration de la fonction Fibonacci qui calcule le ne terme de la suite de Fibonacci */
CREATE OR REPLACE FUNCTION fib(nbr integer) RETURNS integer LANGUAGE plpgsql AS '
DECLARE
a integer;
b integer;
c integer;
rtr integer;
BEGIN
a := 0;
b := 1;
FOR compteur IN 2..nbr LOOP
    c := a + b;
    a := b;
    b := c;
END LOOP;
IF nbr = 0 OR nbr = 1 
    THEN rtr = nbr;
ELSE rtr = c;
END IF;
RETURN rtr;
END
'
CREATE OR REPLACE FUNCTION fibRec(nbr integer) RETURNS integer LANGUAGE plpgsql AS '
DECLARE
rtr integer;
BEGIN
IF 

'
