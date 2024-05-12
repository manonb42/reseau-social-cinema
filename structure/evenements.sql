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

)

create table Archives_web -- entité faible de Evenements
(
	e_id int,
	lien_web varchar(255) not null,
	primary key(e_id, lien_web),
	foreign key(e_id) references Evenements(e_id) on delete cascade
	-- trigger evenement passé
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
	mark float,
	primary key(e_id, u_id),
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	CHECK (mark >=0 AND mark<=5)
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