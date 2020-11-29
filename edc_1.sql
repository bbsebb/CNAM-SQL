DROP TABLE IF EXISTS  inscrire,reglement,inscription,ue,tarif,auditeur;
BEGIN TRANSACTION;
CREATE TABLE auditeur (
    id_auditeur int,
    nom varchar,
    prenom varchar,
    date_nais date,
    CONSTRAINT PK_auditeur PRIMARY KEY (id_auditeur)
);

CREATE TABLE tarif (
    id_tarif int,
    tarif varchar,
    CONSTRAINT PK_tarif PRIMARY KEY (id_tarif)
);

CREATE TABLE ue (
    id_ue varchar(10),
    designation varchar,
    ects SMALLINT,
    CONSTRAINT PK_ue PRIMARY KEY (id_ue)
);

CREATE TABLE inscription (
    id_auditeur int,
    annee SMALLINT,
    id_tarif int NOT NULL,
    CONSTRAINT PK_inscription PRIMARY KEY (id_auditeur,annee),
    CONSTRAINT FK_inscription_auditeur FOREIGN KEY (id_auditeur) REFERENCES auditeur(id_auditeur),
    CONSTRAINT FK_inscription_tarif FOREIGN KEY (id_tarif) REFERENCES tarif(id_tarif)
);

CREATE TABLE reglement (
    id_auditeur int,
    annee SMALLINT,
    num_ordre int,
    montant int,
    CONSTRAINT PK_reglement PRIMARY KEY (id_auditeur,annee,num_ordre),
    CONSTRAINT FK_reglement FOREIGN KEY (id_auditeur,annee) REFERENCES inscription(id_auditeur,annee)
);

CREATE TABLE inscrire (
    id_auditeur int ,
    annee SMALLINT ,
    id_ue varchar(10),
    note1 smallint,
    note2 smallint,
    CONSTRAINT PK_inscrire PRIMARY KEY (id_auditeur,annee,id_ue),
	CONSTRAINT FK_inscrire_inscription FOREIGN KEY (id_auditeur,annee) REFERENCES inscription(id_auditeur,annee),
    CONSTRAINT FK_inscrire_ue FOREIGN KEY (id_ue) REFERENCES ue(id_ue)
      
);
COMMIT;