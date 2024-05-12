create table Utilisateurs
(
	u_id serial,
	login varchar(100) unique not null,
	email varchar(255) unique not null,
	nom varchar(100) not null,
	prenom varchar(100) not null,
	password  varchar(100) not null,
	birthdate date,
	pays varchar(100),
	label varchar(100),
	primary key(u_id),
	foreign key(label) references Categories(label) on update cascade
);

-- entités faibles de Utilisateurs
create table Admins(
	u_id int
	primary key(u_id),
	foreign key(u_id) references Utilisateurs(u_id) on delete cascade
);

create table Moderateurs(
	u_id int
	primary key(u_id),
	foreign key(u_id) references Utilisateurs(u_id) on delete cascade
);

----------

create table Categories
(
	label varchar(100),
	primary key(label)
);

create table Artistes
(
	a_id serial,
	nom varchar(100) not null,
	prenom varchar(100) not null,
	pays varchar(100),
	birthdate date,
	primary key(a_id)
);

create table Films
(
	f_id serial,
	titre varchar(100) not null,
	realisateur int,
	date_sortie date,
	primary key(f_id),
	foreign key(realisateur) references Artistes(a_id)
	--il est légalement possible qu'un même réalisateur crée plusieurs films avec exactement le même nom, c'est déjà arrivé
);

create table Genres
(
	g_id serial,
	label varchar(100) unique not null,
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
	u_id int,
	d_id int,
	date_publication datetime not null,
	primary key(p_id),
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	foreign key(d_id) references Discussions(d_id) on delete cascade
);


create type smiley as enum ('happy', 'sad', 'angry', 'shocked', 'disgusted', 'thumb', 'heart', 'lol');

create table Reactions
(
	u_id int,
	p_id int,
	emoji smiley not null,
	primary key(u_id,p_id,emoji),
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,	
);

----------

create table Evenements
(
	e_id serial,
	nom varchar(100),
	date_event date not null,
	adresse varchar(255) not null,
	prix float not null,
	primary key(e_id),
	unique (date_event, adresse)
	--pas deux événements différents au même endroit le même jour
);

-- entité faible de Evenements

create table Archives_web
(
	e_id int,
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
	
	

