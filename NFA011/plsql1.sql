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
BEGIN
IF nbr = 0 
    THEN RETURN 0;
ELSIF nbr = 1
    THEN RETURN 1;
ELSE 
    RETURN fibRec(nbr-1)+fibRec(nbr-2);
END IF;
END
'
/* Écrire la déclaration de la fonction Harmonique qui calcule le ne terme de la série de harmonique.
 */
 CREATE OR REPLACE FUNCTION Harmonique(nbr integer) RETURNS numeric LANGUAGE plpgsql AS '
 DECLARE
 a numeric;
 BEGIN
 a:=0;
 FOR compteur IN 1..nbr LOOP
    a = a + (1/CAST(compteur AS numeric));
END LOOP;
RETURN a;
END
 '

CREATE OR REPLACE FUNCTION HarmoniqueRec(nbr numeric) RETURNS numeric LANGUAGE plpgsql AS '
DECLARE
rtr numeric;
BEGIN
rtr :=0;
IF nbr = 1 
    THEN rtr := 1+rtr;
ELSE 
    rtr := HarmoniqueRec(nbr-1) + 1/nbr;
END IF;
RETURN rtr;
END
'


