CREATE TABLE Films
(
	titre VARCHAR(100),
	realisateur_id INT,
	date_sorie DATE,
	PRIMARY KEY (titre)
    	FOREIGN KEY (realisateur_id) REFERENCES Artistes(artiste_id)
    	--UNIQUE(titre, realisateur_id) ne sert à rien car titre étant unique, (titre, realisateur_id) le sera aussi
)

CREATE TABLE Genres
(
	label VARCHAR(100) PRIMARY KEY
)

CREATE TABLE SousGenres
(
	label VARCHAR(100),
   	genre VARCHAR(100),
	PRIMARY KEY (label),
	FOREIGN KEY(genre) REFERENCES Genres(label)
)

CREATE TABLE AppartenancesGenres
(
	titre VARCHAR(100),
	genre VARCHAR(100),
	PRIMARY KEY (titre,genre),
	FOREIGN KEY (titre) REFERENCES Film(titre),
	FOREIGN KEY (genre) REFERENCES Genres(label)
)

CREATE TABLE AppartenanceSousGenre
(
	titre VARCHAR(100),
	sousgenre VARCHAR(100), 
	PRIMARY KEY (titre,sousgenre), 
	FOREIGN KEY (titre) REFERENCES Film(titre),
	FOREIGN KEY (sousgenre) REFERENCES SousGenres(label)

)

CREATE TABLE Artistes
(
    	artiste_id INT PRIMARY KEY,
   	prenom VARCHAR(100) NOT NULL,
   	nom VARCHAR(100) NOT NULL,
    	date_naissance DATE,
	PRIMARY KEY (artiste_id)
)

CREATE TABLE Utilisateurs
(
    	u_id SERIAL PRIMARY KEY,
    	categorie VARCHAR(100), /* random, artiste .. */
    	u_login VARCHAR(100) NOT NULL UNIQUE,
    	email VARCHAR(100) NOT NULL UNIQUE,
    	nom VARCHAR(100) NOT NULL, 
    	prenom VARCHAR(100) NOT NULL, 
    	mdp VARCHAR(100) NOT NULL, 
    	pays VARCHAR(100), 
    	date_naissance DATE
)

CREATE TABLE Vip
(
	u_id INT,
	PRIMARY KEY (u_id)
	FOREIGN KEY (u_id) REFERENCES Utilisateurs(u_id)
)

CREATE TABLE Follow
(
    	u_id_follower INT, 
    	u_id_following INT,
	PRIMARY KEY(u_id_follower, u_id_following),
	FOREIGN_KEY (u_id_follower) REFERENCES Utilisateurs(u_id),
	FOREIGN KEY (u_id_following) REFERENCES Utilisateurs(u_id),
	CHECK u_id_following <> u_id_follower
	
)

CREATE TABLE Avis
(
	titre VARCHAR(100),
	auteur_id INT,
	commentaire text,
	notation INT,
	CHECK ( commentaire IS NOT NULL OR notation IS NOT NULL)
)

CREATE TABLE Publications
(
    	publication_id SERIAL, 
    	date_publication DATETIME NOT NULL, 
    	auteur_id INT NOT NULL, 
    	discussion_id INT NOT NULL,
	PRIMARY KEY (publication_id),
    	FOREIGN KEY (auteur_id) REFERENCES Utilisateurs(u_id), 
    	FOREIGN KEY (discussion_id) REFERENCES Discussions(discussion_id), 
    	FOREIGN KEY (answer_to_publication_id) REFERENCES Publications(publication_id)
    
)

CREATE TABLE Reponses
(
	message_pere INT,
	message_fil INT,
	PRIMARY KEY (message_pere, message_fils)
	FOREIGN KEY (message_pere) REFERENCES Publications(publication_id),
	FOREIGN KEY (message_fils) REFERENCES Publications(publication_id),
	CHECK message_fils > message_pere
)

CREATE TABLE Discussions
(
    	discussion_id INT PRIMARY KEY, 
    	label VARCHAR(255) 
)

CREATE TABLE Reactions
(
	publication_id INT NOT NULL,
   	u_id INT NOT NULL,
    	r_type VARCHAR(255) NOT NULL,
    	PRIMARY KEY(publication_id, u_id, r_type), 
    	FOREIGN KEY (u_id) REFERENCES Utilisateurs(u_id), 
    	FOREIGN KEY (publication_id) REFERENCES Publications(publication_id)
)

CREATE TABLE Participation
(
	user_id INT, 
    	event_id INT, 
    	inscrit BOOLEAN NOT NULL, 
    	interesse BOOLEAN NOT NULL,
    	FOREIGN KEY (user_id) REFERENCES Utilisateurs(u_id), 
	CHECK inscrit<>interesse

)


CREATE TABLE Archives_web
(
    	event_id INT NOT NULL, 
    	lien_web VARCHAR(255), 
    	FOREIGN KEY (event_id) REFERENCES Evenements_Passes(event_id)
)


CREATE TABLE Evenements_Futurs 
(
    	event_id INT PRIMARY KEY, 
    	nom VARCHAR(100) NOT NULL, 
    	date_event DATETIME CHECK (DATEDIFF(CAST(NOW() AS DATETIME), date)<=0), /* verifier que ça marche*/
    	lieu VARCHAR(255),
    	nb_places INT,
    	prix FLOAT
)

CREATE TABLE Evenements_Passes
(
    	event_id INT PRIMARY KEY, 
    	nom VARCHAR(100) NOT NULL, 
    	date_event DATETIME CHECK (DATEDIFF(CAST(NOW() AS DATETIME), date)>0), /* verifier que ça marche*/
    	lieu VARCHAR(255),
    	nb_participants INT
)

CREATE TABLE Annonce
(
	event_id INT UNIQUE,
	discussion_id INT UNIQUE,
	FOREIGN KEY (event_id) REFERENCES Evenements_Futurs(event_id),
	FOREIGN KEY (discussion_id) REFERENCES Discussions(discussion_id),
	
)


