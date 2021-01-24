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

