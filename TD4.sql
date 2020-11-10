CREATE TABLE Departement (
	id_departement int2,
	departement varchar(50) not null,
	PRIMARY KEY (id_departement)
);

CREATE TABLE Produit (
	id_produit int,
	designation varchar(100) NOT NULL,
	descriptif varchar, -- sans limite est idem à TEXT
	prix numeric(10,2) DEFAULT 0 CHECK (prix>=0),
	delai_livraison interval,
	PRIMARY KEY (id_produit)
);

CREATE TABLE Remise (
	id_remise int,
	intitule varchar(100),
	PRIMARY KEY (id_remise)
	
);

CREATE TABLE Service (
	id_service int,
	nom varchar(100),
	PRIMARY KEY (id_service)
);

CREATE TABLE Ville (
	id_ville int ,
	ville varchar(100) NOT NULL,
	id_departement int NOT NULL,
	PRIMARY KEY (id_ville),
	FOREIGN KEY (id_departement) REFERENCES Departement(id_departement)
);

CREATE TABLE Client (
	id_client int,
	nom varchar(50) NOT NULL,
	prenom varchar(50) NOT NULL,
	id_ville int,
	tel_perso smallint,
	tel_prof smallint,
	tel_mobile smallint,
	PRIMARY KEY (id_client),
	FOREIGN KEY (id_ville) REFERENCES Ville(id_ville)
);

CREATE TABLE Vendeur(
	id_vendeur int,
	nom varchar(50) NOT NULL, 
	prenom varchar(50) NOT NULL,
	salaire numeric(10,2) CHECK (salaire>=0),
	annee_embauche date CHECK(annee_embauche>='01-01-1983'),
	id_vendeur_resp int,
	PRIMARY KEY (id_vendeur),
	FOREIGN KEY (id_vendeur_resp) REFERENCES Vendeur(id_vendeur)
		ON DELETE SET NULL
);

CREATE TABLE Appartient (
	id_vendeur int,
	id_service int,
	PRIMARY KEY (id_vendeur,id_service)
);

CREATE TABLE Commande (
	id_commande int,
	date date NOT NULL,
	montant_HT numeric(20,2) NOT NULL CHECK (montant_HT>=0),
	id_client int NOT NULL,
	id_vendeur int,
	id_remise int,
	PRIMARY KEY (id_commande),
	FOREIGN KEY (id_client) REFERENCES Client(id_client),
	FOREIGN KEY (id_vendeur) REFERENCES Vendeur(id_vendeur),
	FOREIGN KEY (id_remise) REFERENCES Remise(id_remise)
);

CREATE TABLE Ligne_Commande (
	id_commande int,
	id_ligne int,
	quantite bigint DEFAULT CHECK (quantite>=0),
	id_produit int NOT NULL,
	PRIMARY KEY(id_commande,id_ligne),
	FOREIGN KEY (id_produit) REFERENCES Produit(id_produit)
);


