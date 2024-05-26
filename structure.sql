DROP TABLE IF EXISTS Utilisateurs CASCADE;
DROP TABLE IF EXISTS Artistes CASCADE;
DROP TABLE IF EXISTS Entreprises CASCADE;
DROP TABLE IF EXISTS Films CASCADE;
DROP TABLE IF EXISTS Genres CASCADE;
DROP TABLE IF EXISTS Discussions CASCADE;
DROP TABLE IF EXISTS Lieux CASCADE;
DROP TABLE IF EXISTS Evenements CASCADE;
DROP TABLE IF EXISTS Publications CASCADE;
DROP TABLE IF EXISTS Reactions CASCADE;
DROP TABLE IF EXISTS Archives CASCADE;
DROP TABLE IF EXISTS Avis CASCADE;
DROP TABLE IF EXISTS GenresFilms CASCADE;
DROP TABLE IF EXISTS Staff CASCADE;
DROP TABLE IF EXISTS SocietesDeProduction CASCADE;
DROP TABLE IF EXISTS GenresParents CASCADE;
DROP TABLE IF EXISTS Programmes CASCADE;
DROP TABLE IF EXISTS Participants CASCADE;
DROP TABLE IF EXISTS Organisateurs CASCADE;
DROP TABLE IF EXISTS Annonces CASCADE;
DROP TABLE IF EXISTS Relations CASCADE;
DROP TABLE IF EXISTS Conversations CASCADE;
DROP TABLE IF EXISTS KeyWords CASCADE;
DROP TABLE IF EXISTS ComptesArtistes CASCADE;
DROP TABLE IF EXISTS ComptesEntreprises CASCADE;
DROP TABLE IF EXISTS ArtistesKeyWords CASCADE;
DROP TABLE IF EXISTS FilmsKeyWords CASCADE;
DROP TABLE IF EXISTS EventsKeyWords CASCADE;
DROP TYPE IF EXISTS attributions CASCADE;
DROP TYPE IF EXISTS fonctions CASCADE;
DROP TYPE IF EXISTS emojis CASCADE;

create type attributions as enum ('modérateur', 'admin', 'vip', 'certifié', 'propriétaire');
create type emojis as enum ('happy', 'sad', 'angry', 'shocked', 'disgusted', 'thumb', 'like', 'lol');
create type fonctions as enum ('acteur', 'réalisateur', 'producteur');

create table Utilisateurs
(
	u_id serial,
	pseudo varchar(100) unique not null,
	email varchar(255) unique not null,
	nom varchar(100) not null,
	prenom varchar(100) not null,
	mdp  varchar(100) not null,
	birth date,
	pays varchar(100),
	biographie varchar(100),
	attribution attributions,
	primary key(u_id)
);



create table Artistes 
(
	a_id serial,
	nom varchar(100) not null,
	prenom varchar(100) not null,
	birth date,
	pays varchar(100),
	primary key(a_id)
);



create table Entreprises
(
	ent_id serial,
	nom varchar(100) not null,
	primary key(ent_id)
);

create table Films
(
	f_id serial,
	titre varchar(255) not null,
	date_sortie date,
	primary key(f_id)
);

create table Genres
(
	g_id serial,
	nom varchar(100) unique not null,
	primary key(g_id)
);

create table Discussions
(
	d_id serial,
	nom varchar(100) not null,
	primary key(d_id)
);



create table Lieux
(
	l_id serial,
	nom varchar(100),
	adresse varchar(255) not null,
	ville varchar(100) not null,
	pays varchar(100) not null,
	capacite int,
	outside boolean not null default 'false',
	primary key(l_id),
	unique (adresse, ville, pays),
	CHECK (capacite >= 0)
);

create table Evenements
(
	e_id serial,
	nom varchar(100),
	debut date not null,
	fin date not null,
	prix float not null,
	lieu int not null,
	capacite int not null,
	primary key(e_id),
	foreign key(lieu) references Lieux(l_id),
	unique (debut, lieu),
	CHECK (debut < fin AND prix >=0 AND capacite >= 0 )
);

create table Publications
(
	p_id serial,
	u_id int not null,
	d_id int not null,
	date_publication timestamp not null,
	contenu text not null,
	primary key(p_id),
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	foreign key(d_id) references Discussions(d_id) on delete cascade
);



create table Reactions
(
	u_id int not null,
	p_id int not null,
	emoji emojis not null,
	primary key(u_id,p_id,emoji),
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,	
	foreign key(p_id) references Publications(p_id) on delete cascade
);



create table Archives
(
	e_id int not null,
	lien_web varchar(255) not null,
	primary key(e_id, lien_web),
	foreign key(e_id) references Evenements(e_id) on delete cascade

);



create table Avis -- Films et Utilisateurs
(
	f_id int,
	u_id int,
	mark float not null,
	commentaire text,
	primary key(f_id, u_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	CHECK (mark >=0 AND mark<=5)
);



create table GenresFilms -- Films et Genres
(
	f_id int, 
	g_id int,
	primary key(f_id,g_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(g_id) references Genres(g_id) on delete cascade
);



create table Staff --Films et Artistes
(
	f_id int,
	a_id int, 
	fonction fonctions not null,
	primary key (f_id, a_id, fonction),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(a_id) references Artistes(a_id)
);



create table SocietesDeProduction
(
	f_id int,
	ent_id int,
	primary key(f_id, ent_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(ent_id) references Entreprises(ent_id)
);



create table Programmes -- Films et Evenements
(
	e_id int,
	f_id int,
	primary key(e_id, f_id),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(f_id) references Films(f_id)
);



create table Participants -- Utilisateurs et Evenements
(
	e_id int, 
	u_id int,
	interesse boolean not null,
	inscrit boolean not null, 
	primary key(e_id,u_id),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete cascade,
	CHECK (interesse <> inscrit)
);



create table Organisateurs -- Utilisateurs et Evenements
(
	e_id int, 
	organisateur int,
	primary key(e_id,organisateur),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(organisateur) references Utilisateurs(u_id) on delete cascade
);



create table Annonces -- Discussions et Evenements
(
	e_id int unique, 
	d_id int unique, 
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(d_id) references Discussions(d_id) on delete cascade
);



create table GenresParents -- Genres et Genres
(
	genre int,
	sousgenre int,
	primary key(genre, sousgenre),
	foreign key(genre) references Genres(g_id) on delete cascade,
	foreign key(sousgenre) references Genres(g_id) on delete cascade,
	CHECK (genre <> sousgenre)
);



create table Relations -- Utilisateurs et Utilisateurs
(
	follower int,
	followed int, 
	primary key(follower, followed),
	foreign key(follower) references Utilisateurs(u_id) on delete cascade,
	foreign key(followed) references Utilisateurs(u_id) on delete cascade,
	CHECK (follower <> followed) -- si (A follow B) et (B Follow A) alors on peut dire que A et B sont amis
);



create table Conversations -- Publications et Publications
(
	source int, 
	reponse int unique,
	foreign key(source) references Publications(p_id) on delete set null,
	foreign key(reponse) references Publications(p_id) on delete cascade,
	CHECK (source < reponse)
);



create table KeyWords
(
	mot varchar(255),
	primary key(mot)
);



create table ComptesArtistes
(
	a_id int, 
	u_id int,
	primary key(a_id,u_id),
	foreign key(a_id) references Artistes(a_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete cascade
);



create table ComptesEntreprises
(
	ent_id int, 
	u_id int,
	primary key(ent_id,u_id),
	foreign key(ent_id) references Entreprises(ent_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete cascade
	
);



create table ArtistesKeyWords
(
	a_id int not null,
	mot varchar(255),
	primary key(a_id, mot),
	foreign key(a_id) references Artistes(a_id) on delete cascade,
	foreign key(mot) references KeyWords(mot) on delete cascade
);



create table FilmsKeyWords
(
	f_id int not null,
	mot varchar(255),
	primary key(f_id, mot),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(mot) references KeyWords(mot) on delete cascade
);



create table EventsKeyWords
(
	e_id int not null,
	mot varchar(255),
	primary key(e_id, mot),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(mot) references KeyWords(mot) on delete cascade
);
	
	
	
	

