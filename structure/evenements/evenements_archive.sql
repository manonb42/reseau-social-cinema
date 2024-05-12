create table Archives_web -- entité faible de Evenements
(
	e_id int,
	lien_web varchar(255) not null,
	primary key(e_id, lien_web),
	foreign key(e_id) references Evenements(e_id) on delete cascade
)