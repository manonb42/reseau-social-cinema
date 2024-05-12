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
	
)

create table Follow -- Utilisateurs et Utilisateurs
(
	follower int,
	followed int, 
	primary key(follower, followed),
	foreign key(follower) references Utilisateurs(u_id) on delete cascade,
	foreign key(followed) references Utilisateurs(u_id) on delete cascade,
	CHECK (follower <> followed) -- si (A follow B) et (B Follow A) alors on peut dire que A et B sont amis
)

-- entités faibles de Utilisateurs
create table Admins(
	u_id int
	primary key(u_id),
	foreign key(u_id) references Utilisateurs(u_id) on delete cascade

)

create table Moderateurs(
	u_id int
	primary key(u_id),
	foreign key(u_id) references Utilisateurs(u_id) on delete cascade
)