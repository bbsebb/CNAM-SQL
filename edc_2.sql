-- 6.1
BEGIN TRANSACTION
CREATE TABLE support (
    codesupport int,
    intsupport varchar,
    PRIMARY KEY (codesupport)
);

CREATE TABLE etat (
    codeetat int,
    designationetat int,
    PRIMARY KEY (codeetat)
);

CREATE TABLE emprunteur (
    codepers int,
    nompers varchar,
    prenompers varchar,
    adrpers varchar,
    telpers char(14),
    datenais date,
    PRIMARY KEY (codepers)
);

CREATE TABLE acteur (
    codeacteur int,
    nomacteur varchar,
    prenomacteur varchar,
    PRIMARY KEY (codeacteur)
);

CREATE TABLE genre (
    codegenr int,
    intgenre varchar,
    PRIMARY KEY (codegenr)
);

CREATE TABLE film (
    codefilm int,
    titrefilm varchar,
    annee char(4),
    duree smallint,
    resume text,
    codegenr int NOT NULL,
    PRIMARY KEY (codefilm)
)

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
)

CREATE TABLE emprunt (
    datepret date,
    codepers int,
    codefilm int,
    numexemplaire int,
    dateretour date,
    PRIMARY KEY (datepret,codepers,codefilm,numexemplaire)
)

-- 6.2
