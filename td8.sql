/* 1 */
SELECT id_commande AS "Code commande",
       montant_ht AS "prix HT",
       ROUND(montant_ht) AS Arrondi,
       TO_CHAR(montant_ht,'9,999k€')
FROM commande;

/* 2 */
SELECT DISTINCT descriptif
FROM produit
WHERE LENGTH(descriptif) =
        ( SELECT MAX(LENGTH(descriptif))
         FROM produit);

/* 3 */
SELECT "0033" || SUBSTR(TRIM(tel_mobile),1,LENGTH(TRIM(tel_mobile)))
FROM client;

/* 4 */
SELECT *
FROM commande
WHERE date BETWEEN '2005-01-01' AND '2005-01-31';

/* 5 */
SELECT c.nom,
       c.prenom,
       CASE
           WHEN c.tel_prof IS NULL THEN 'Non disponible'
           ELSE c.tel_prof
       END AS "Téléphone pre"
FROM client c
ORDER BY 1,
         2;

/* 6 */
SELECT *,
       CASE
           WHEN c.tel_perso IS NULL AND c.tel_mobile IS NULL THEN 'Non disponible'
           WHEN c.tel_mobile IS NULL THEN c.tel_perso
           ELSE c.tel_mobile
       END AS "Téléphone"
FROM client c
ORDER BY 1,
         2;
/* 7 */
SELECT ROUND(CAST(SUM(c.id_remise) AS NUMERIC)/COUNT(*),2) || ' %' AS "Taux de remise moyen"
FROM commande c;
/* 8 */
SELECT v.nom, v.prenom, EXTRACT(YEAR FROM CURRENT_TIMESTAMP) - v.annee_embauche || ' ans' AS "Ancienneté"
FROM vendeur v
ORDER BY 1,2;
/* 9 */
SELECT v.nom, v.prenom,  CURRENT_DATE - TO_DATE(v.annee_embauche || '-01-01','YYYY-MM-DD') || ' jours' AS "Ancienneté"
FROM vendeur v
ORDER BY 1,2;
/* 10 */
SELECT c.nom,c.prenom,c.tel_perso,
    SUBSTR(c.tel_perso, 1, 2) || '.' || 
        SUBSTR(c.tel_perso, 3, 2) || '.'  || 
            SUBSTR(c.tel_perso, 5, 2) || '.' || 
                SUBSTR(c.tel_perso, 7, 2) || '.' || 
                    SUBSTR(c.tel_perso, 9, 2) 
FROM client c
ORDER BY 1,2;


