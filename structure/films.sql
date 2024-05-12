create table Films
(
	f_id serial,
	titre varchar(100) not null,
	realisateur int,
	date_sortie date,
	primary key(f_id),
	foreign key(realisateur) references Artistes(a_id)
	--il est légalement possible qu'un même réalisateur crée plusieurs films avec exactement le même nom, c'est déjà arrivé
)


create table FilmsGenres -- Films et Genres
(
	f_id int, 
	g_id int,
	primary key(f_id,g_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(g_id) references Films(g_id) on delete cascade
)

create table AvisFilms -- Films et Utilisateurs
(
	f_id int,
	u_id int,
	mark float,
	primary key(f_id, u_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(u_id) references Utilisateurs(u_id) on delete set null,
	CHECK (mark >=0 AND mark<=5)

)

create table Castings --Films et Artistes
(
	f_id int,
	a_id int, 
	primary key(f_id, u_id),
	foreign key(f_id) references Films(f_id) on delete cascade,
	foreign key(a_id) references Artistes(a_id) on delete cascade
)