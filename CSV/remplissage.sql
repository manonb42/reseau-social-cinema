create temporary table Utilisateurs_temp 
(   
    u_id int,
    pseudo varchar(100),
    email varchar(255),
    nom varchar(100),
    prenom varchar(100),
    mdp  varchar(100),
    birth date,
    pays varchar(100),
    biographie varchar(100),
    attribution attributions
);

create temporary table Artistes_temp 
(
	a_id int,
	nom varchar(100),
	prenom varchar(100),
	birth date,
	pays varchar(100)
);

create temporary table Entreprises_temp
(
	ent_id int,
	nom varchar(100)
);

create temporary table Films_temp
(
	f_id int,
	titre varchar(255),
	date_sortie date
);

create temporary table Genres_temp
(
	g_id int,
	nom varchar(100)
);

create temporary table Discussions_temp
(
	d_id int,
	theme varchar(100)
);

create temporary table Lieux_temp
(
	l_id int,
	nom varchar(100),
	adresse varchar(255),
	ville varchar(100),
	pays varchar(100),
	capacite int,
	outside boolean
);

create temporary table Evenements_temp
(
	e_id int,
	nom varchar(100),
	debut date,
	fin date,
	prix float,
	lieu int,
	capacite int
);

create temporary table Publications_temp
(
	p_id int,
	u_id int,
	d_id int,
	date_publication timestamp,
	contenu text
);
	


\COPY Utilisateurs_temp FROM 'CSV/utilisateurs.csv' WITH csv;
\COPY Artistes_temp FROM 'CSV/artistes.csv' WITH csv;
\COPY Entreprises_temp FROM 'CSV/entreprises.csv' WITH csv;
\COPY Films_temp FROM 'CSV/films.csv' WITH csv;
\COPY Genres_temp FROM 'CSV/genres.csv' WITH csv;
\COPY Discussions_temp FROM 'CSV/discussions.csv' WITH csv;
\COPY Lieux_temp FROM 'CSV/lieux.csv' WITH csv;
\COPY Evenements_temp FROM 'CSV/evenements.csv' WITH csv;
\COPY Publications_temp FROM 'CSV/publications.csv' WITH csv;

INSERT INTO Utilisateurs (pseudo, email, nom, prenom, mdp, birth, pays, biographie, attribution)
SELECT pseudo, email, nom, prenom, mdp, birth, pays, biographie, attribution FROM Utilisateurs_temp;

INSERT INTO Artistes (nom, prenom, birth, pays)
SELECT nom,prenom,birth,pays FROM Artistes_temp;

INSERT INTO Entreprises (nom)
SELECT nom FROM Entreprises_temp;

INSERT INTO Films (titre, date_sortie)
SELECT titre, date_sortie FROM Films_temp;

INSERT INTO Genres (nom)
SELECT nom FROM Genres_temp;

INSERT INTO Discussions (theme) 
SELECT theme FROM Discussions_temp;

INSERT INTO Lieux (nom, adresse, ville, pays, capacite, outside)
SELECT nom, adresse, ville, pays, capacite, outside FROM Lieux_temp;

INSERT INTO Evenements (nom, debut, fin, prix, lieu, capacite)
SELECT nom, debut, fin, prix, lieu, capacite FROM Evenements_temp;

INSERT INTO Publications (u_id, d_id, date_publication, contenu)
SELECT u_id, d_id, date_publication, contenu FROM Publications_temp;

\COPY Reactions FROM 'CSV/reactions.csv' WITH CSV;
\COPY Archives FROM 'CSV/archives.csv' WITH CSV;
\COPY AvisFilms FROM 'CSV/avisfilms.csv' WITH CSV;
\COPY AvisEvenements FROM 'CSV/avisevenements.csv' WITH CSV;
\COPY GenresFilms FROM 'CSV/genresfilms.csv' WITH CSV;
\COPY Staff FROM 'CSV/staff.csv' WITH CSV;
\COPY SocietesDeProduction FROM 'CSV/societesdeproduction.csv' WITH CSV;
\COPY Programmes FROM 'CSV/programmes.csv' WITH CSV;
\COPY Participants FROM 'CSV/participants.csv' WITH CSV;
\COPY Organisateurs FROM 'CSV/organisateurs.csv' WITH CSV;
\COPY Annonces FROM 'CSV/annonces.csv' WITH CSV;
\COPY GenresParents FROM 'CSV/genresparents.csv' WITH CSV;
\COPY Relations FROM 'CSV/relations.csv' WITH CSV;
\COPY Conversations FROM 'CSV/conversations.csv' WITH CSV;
\COPY ComptesArtistes FROM 'CSV/comptesartistes.csv' WITH CSV;
\COPY ComptesEntreprises FROM 'CSV/comptesentreprises.csv' WITH CSV;
--\COPY KeyWords FROM 'CSV/keywords.csv' WITH CSV;
--\COPY ArtistesKeyWords FROM 'CSV/artisteskeywords.csv' WITH CSV;
--\COPY FilmsKeyWords FROM 'CSV/filmskeywords.csv' WITH CSV;
--\COPY EventsKeyWords FROM 'CSV/eventskeywords.csv' WITH CSV;
--\COPY GenresKeyWords FROM 'CSV/genreskeywords.csv' WITH CSV;


DROP TABLE IF EXISTS Utilisateurs_temp;
DROP TABLE IF EXISTS Artistes_temp;
DROP TABLE IF EXISTS Entreprises_temp;
DROP TABLE IF EXISTS Films_temp;
DROP TABLE IF EXISTS Genres_temp;
DROP TABLE IF EXISTS Discussions_temp;
DROP TABLE IF EXISTS Lieux_temp;
DROP TABLE IF EXISTS Evenements_temp;
DROP TABLE IF EXISTS Publications_temp;
