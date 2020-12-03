-- 1.6.1
BEGIN TRANSACTION;
CREATE TABLE support (
    codesupport int,
    intsupport varchar,
    PRIMARY KEY (codesupport)
);

CREATE TABLE etat (
    codeetat int,
    designationetat VARCHAR,
    PRIMARY KEY (codeetat)
);

CREATE TABLE emprunteur (
    codepers int,
    nompers varchar,
    prenompers varchar,
    adrpers varchar,
    telpers char(14),
    PRIMARY KEY (codepers)
);

CREATE TABLE acteur (
    codeacteur int,
    nomacteur varchar,
    prenomacteur varchar,
    PRIMARY KEY (codeacteur)
);

CREATE TABLE genre (
    codegenre int,
    intgenre varchar,
    PRIMARY KEY (codegenre)
);

CREATE TABLE film (
    codefilm int,
    titrefilm varchar,
    annee char(4),
    duree smallint,
    resume text,
    codegenre int NOT NULL,
    PRIMARY KEY (codefilm)
);

CREATE TABLE jouer_un_role (
    codefilm int,
    codeacteur int,
    PRIMARY KEY (codefilm,codeacteur)
);

CREATE TABLE exemplaire (
    codefilm int,
    numexemplaire int,  
    codeetat int,
    codesupport int NOT NULL,
    PRIMARY KEY (codefilm,numexemplaire)
);

CREATE TABLE emprunt (
        codefilm int,
    numexemplaire int,
    codepers int,
    datepret date,
    dateretour date,
    PRIMARY KEY (datepret,codepers,codefilm,numexemplaire)
);

-- 1.6.2
ALTER TABLE film    ADD CONSTRAINT FK_film_genre FOREIGN KEY (codegenre) REFERENCES genre(codegenre);
ALTER TABLE jouer_un_role   ADD CONSTRAINT FK_jouer_un_role_film FOREIGN KEY (codefilm) REFERENCES film(codefilm),
                            ADD CONSTRAINT FK_jouer_un_role_acteur FOREIGN KEY (codeacteur) REFERENCES acteur(codeacteur);
ALTER TABLE exemplaire  ADD CONSTRAINT FK_exemplaire_film FOREIGN KEY (codefilm) REFERENCES film(codefilm) ON DELETE CASCADE,
                        ADD CONSTRAINT FK_exemplaire_support FOREIGN KEY (codesupport) REFERENCES support(codesupport),
                        ADD CONSTRAINT FK_exemplaire_etat FOREIGN KEY (codeetat) REFERENCES etat(codeetat) ON UPDATE CASCADE;
ALTER TABLE emprunt ADD CONSTRAINT FK_emprunt_emprunteur FOREIGN KEY (codepers) REFERENCES emprunteur(codepers),
                    ADD CONSTRAINT FK_emprunt_exemplaire FOREIGN KEY (codefilm,numexemplaire) REFERENCES exemplaire(codefilm,numexemplaire) ON DELETE SET NULL;

-- 1.6.3
ALTER TABLE film ADD CONSTRAINT CHK_film_duree CHECK( duree >= 0);
ALTER TABLE emprunt ADD CONSTRAINT CHK_dater_datep CHECK( dateretour >= datepret);

-- 1.6.4

ALTER TABLE emprunteur ADD COLUMN  datenais date;    

-- 2.1
SELECT titrefilm, resume FROM film

