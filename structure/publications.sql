create table Publications
(
	p_id serial,
	u_id int,
	d_id int,
	date_publication datetime not null,
	primary key(p_id),
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	foreign key(d_id) references Discussions(d_id) on delete cascade
)

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
)

--entité faible de Publications

create type smiley as enum ('happy', 'sad', 'angry', 'shocked', 'disgusted', 'thumb', 'heart', 'lol');

create table Reactions
(
	u_id int,
	p_id int,
	emoji smiley not null,
	primary key(u_id,p_id,emoji),
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,	
)