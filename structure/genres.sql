create table Genres
(
	g_id serial,
	label varchar(100) unique not null,
	primary key(g_id)
)

create table ParentGenre -- Genres et Genres
(
	genre_parent int,
	genre_enfant int,
	primary key(genre_parent, genre_enfant),
	foreign key(genre_parent) references Genres(g_id) on delete cascade,
	foreign key(genre_enfant) references Genres(g_id) on delete cascade,
	CHECK (genre_parent <> genre_enfant) -- le souci c'est qu'il peut y avoir le couple (A,B) et le couple (B,A)
	--CHECK genre_parent > genre_enfant : le souci c'est que ça demande une insertion chronologique/hiérarchique des genres
)