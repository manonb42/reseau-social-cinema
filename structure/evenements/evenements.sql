create table Evenements
(
	e_id serial,
	nom varchar(100),
	debut_event timestamp not null,
	fin_event timestamp not null, 
	adresse varchar(255) not null,
	prix float not null,
	primary key(e_id),
	unique (date_event, adresse)
	--pas deux événements différents au même endroit le même jour

)


create table Programme -- Films et Evenements
(
	e_id int,
	f_id int,
	primary key(e_if, f_id),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(f_id) references Films(f_id)
	-- trigger evenement futur
)

create table AvisEvenements --  Evenements et Utilisateurs
(
	e_id int,
	u_id int,
	note float,
	primary key(e_id, u_id),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	CHECK (note >=0 AND note<=5)
	-- trigger evenement passé
)

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
)

create table Organisateurs -- Utilisateurs et Evenements
(
	e_id int, 
	organisateur int,
	primary key(e_id,organisateur),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(organisateur) references Utilisateurs(u_id) on delete cascade
)

create table Localisation 
(
    nom varchar(255) not null,
    numero_rue varchar(255) not null,
	ville varchar(255) not null,
	pays varchar(255) not null,
    capacite integer not null,
    outside boolean not null default 'false',
	primary key(numero_rue, ville, pays),
	check capacite > 0
);