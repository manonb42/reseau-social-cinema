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
	bio varchar(100),
	hierarchie roles not null,
	primary key(u_id)
);

create type roles as enum ('moderateur', 'admin', 'vip');

create table Artistes
(
	a_id serial,
	nom varchar(100) not null,
	prenom varchar(100) not null,
	birth date,
	pays varchar(100),
	primary key(a_id)
);

create table Films
(
	f_id serial,
	titre varchar(100) not null,
	realisateur int not null,
	date_sortie date,
	primary key(f_id),
	foreign key(realisateur) references Artistes(a_id)
	--il est légalement possible qu'un même réalisateur crée plusieurs films avec exactement le même nom, c'est déjà arrivé
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
	label varchar(100) not null,
	primary key(d_id) --plusiers discussions peuvent avoir le même nom, comme sur beaucoup de réseaux sociaux
);


create table Publications
(
	p_id serial,
	u_id int not null,
	d_id int not null,
	date_publication datetime not null,
	primary key(p_id),
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	foreign key(d_id) references Discussions(d_id) on delete cascade
);


create type emojis as enum ('happy', 'sad', 'angry', 'shocked', 'disgusted', 'thumb', 'heart', 'lol');

---- entité faible de Publications 
create table Reactions
(
	u_id int not null,
	p_id int not null,
	emojis emoji not null,
	primary key(u_id,p_id,emoji),
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,	
);


create table Evenements
(
	e_id serial,
	nom varchar(100),
	debut date not null,
	fin date not null,
	prix float not null,
	lieu integer not null,
	capacite integer not null,
	primary key(e_id),
	foreign key(lieu) references Lieux(id_l)
	unique (debut, lieu),
	CHECK (debut < fin && prix >=0 && capacite >= 0 )
	--integrite : pour le même lieu, il ne peut pas y avoir deux événement dont les dates se superposent
);

create table Lieux
(
	id_l serial,
	nom varchar(100),
	adresse varchar(255) not null,
	ville varchar(100) not null,
	pays varchar(100) not null,
	capacite integer,
	outside boolean not null default 'false',
	primary key(id_l),
	unique (adresse, ville, pays),
	CHECK (capacite >= 0)
)

-- entité faible de Evenements
create table Archives_web
(
	e_id int not null,
	lien_web varchar(255) not null,
	primary key(e_id, lien_web),
	foreign key(e_id) references Evenements(e_id) on delete cascade
	-- trigger evenement passé
);

----------

-- liens entre tables 

create table AvisFilms -- Films et Utilisateurs
(
	f_id int,
	u_id int,
	mark float,
	primary key(f_id, u_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	CHECK (mark >=0 AND mark<=5)
);

create table FilmsGenres -- Films et Genres
(
	f_id int, 
	g_id int,
	primary key(f_id,g_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(g_id) references Films(g_id) on delete cascade
);


create table Castings --Films et Artistes
(
	f_id int,
	a_id int, 
	primary key (f_id, u_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(a_id) references Artistes(a_id) on delete cascade
);

create table ParentGenre -- Genres et Genres
(
	genre_parent int,
	genre_enfant int,
	primary key(genre_parent, genre_enfant),
	foreign key(genre_parent) references Genres(g_id) on delete cascade,
	foreign key(genre_enfant) references Genres(g_id) on delete cascade,
	CHECK (genre_parent <> genre_enfant) -- le souci c'est qu'il peut y avoir le couple (A,B) et le couple (B,A)
	--CHECK genre_parent > genre_enfant : le souci c'est que ça demande une insertion chronologique/hiérarchique des genres
);


create table Programme -- Films et Evenements
(
	e_id int,
	f_id int,
	primary key(e_if, f_id),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(f_id) references Films(f_id)
	-- trigger evenement futur
);

create table AvisEvenements --  Evenements et Utilisateurs
(
	e_id int,
	u_id int,
	mark float,
	primary key(e_id, u_id),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	CHECK (mark >=0 AND mark<=5)
	-- trigger evenement passé
);

create table Participation -- Utilisateurs et Evenements
(
	e_id int, 
	u_id int,
	interesse boolean not null,
	inscrit boolean not null, 
	primary key(e_id,u_id),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete cascade,
	CHECK (interesse <> inscrit)
	-- trigger evenement futur
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


create table ParentGenre -- Genres et Genres
(
	genre_parent int,
	genre_enfant int,
	primary key(genre_parent, genre_enfant),
	foreign key(genre_parent) references Genres(g_id) on delete cascade,
	foreign key(genre_enfant) references Genres(g_id) on delete cascade,
	CHECK (genre_parent <> genre_enfant) -- le souci c'est qu'il peut y avoir le couple (A,B) et le couple (B,A)
	--CHECK genre_parent > genre_enfant : le souci c'est que ça demande une insertion chronologique/hiérarchique des genres
);

create table Follow -- Utilisateurs et Utilisateurs
(
	follower int,
	followed int, 
	primary key(follower, followed),
	foreign key(follower) references Utilisateurs(u_id) on delete cascade,
	foreign key(followed) references Utilisateurs(u_id) on delete cascade,
	CHECK (follower <> followed) -- si (A follow B) et (B Follow A) alors on peut dire que A et B sont amis
);

create table Dialogue -- Publications et Publications
(
	source int, 
	reponse int unique,
	-- un meme id ne peut pas etre plusieurs fois dans la table comme attribut reponse car sinon il est reponse a plusieurs publications en meme temps
	-- (1,2) (1,3) (2,4) oui car 2 et 3 sont des réponses à 1, et 4 est une réponse à 2 
	-- (1,2) (1,3) (2,3) non car 3 est une reponse à 2 ET à 1
	-- primary key(source, reponse) ne sert à rien car etant donne reponse unique, le couple sera unique
	foreign key(source) references Publications(p_id) on delete set null,
	foreign key(reponse) references Publications(p_id) on delete cascade,
	CHECK (source < reponse)
);

create table KeyWords
(
	mot varchar(255),
	primary key(mot)
);

create table CompteStars
(
	id_a integer unique not null, 
	id_u integer unique not null,
	foreign key(id_a) references Artistes(id_a),
	foreign key(id_u) references Utilisateurs(id_u),
	
);

create table ArtistesKeyWords
(
	id_a integer not null,
	mot varchar(255),
	primary key(id_a, mot),
	foreign key(id_a) references Artistes(id_a) on delete cascade,
	foreign key(mot) references KeyWords(mot) on delete cascade
);

create table FilmsKeyWords
(
	id_f integer not null,
	mot varchar(255),
	primary key(id_a, mot),
	foreign key(id_f) references Films(id_f) on delete cascade,
	foreign key(mot) references KeyWords(mot) on delete cascade
);

create table EventKeyWords
(
	id_e integer not null,
	mot varchar(255),
	primary key(id_a, mot),
	foreign key(id_e) references Evenements(id_e) on delete cascade,
	foreign key(mot) references KeyWords(mot) on delete cascade
);
	
	
	
	

