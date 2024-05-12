create table Discussions
(
	d_id serial,
	label varchar(100) not null,
	primary key(d_id) --plusiers discussions peuvent avoir le même nom, comme sur beaucoup de réseaux sociaux
)

create table Annonces -- Discussions et Evenements
(
	e_id int unique, 
	d_id int unique, 
	foreign key(e_id) references Evenements(e_id) on delete cascade,
	foreign key(d_id) references Discussions(d_id) on delete cascade
)