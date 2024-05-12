create table Artistes
(
	a_id serial,
	nom varchar(100) not null,
	prenom varchar(100) not null,
	pays varchar(100),
	birthdate date,
	primary key(a_id)
)