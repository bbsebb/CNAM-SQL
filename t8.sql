/* 1 */
SELECT id_commande AS "Code commande", montant_ht  AS "prix HT", ROUND(montant_ht) AS Arrondi ,TO_CHAR(montant_ht,'9,999k€')
FROM commande;