CREATE TABLE Films
(
    titre VARCHAR(100) PRIMARY KEY NOT NULL,
    realisateur_id INT,
    date_sortie DATE,
    genre_id INT NOT NULL,
    sous_genre_id INT,
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id), 
    FOREIGN KEY (sous_genre_id) REFERENCES Sous_genres(sous_genre_id),
    FOREIGN KEY (realisateur_id) REFERENCES Artistes(artiste_id)
)

CREATE TABLE Genres
(
    genre_id INT PRIMARY KEY NOT NULL,
    label VARCHAR(100)
)

CREATE TABLE Sous_genres
(
    sous_genre_id INT PRIMARY KEY NOT NULL,
    label VARCHAR(100)
)

CREATE TABLE Artistes
(
    artiste_id INT PRIMARY KEY NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    date_naissance DATE, 
    categorie_id INT 
)

CREATE TABLE Utilisateurs
(
    u_id INT PRIMARY KEY NOT NULL,
    categorie_id INT PRIMARY KEY NOT NULL, 
    u_login VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL, 
    prenom VARCHAR(100) NOT NULL, 
    mdp VARCHAR(100) NOT NULL, 
    pays VARCHAR(100), 
    date_naissance DATE
)

CREATE TABLE Followers
(
    u_id_followed INT PRIMARY KEY NOT NULL, 
    u_id_following INT PRIMARY KEY NOT NULL
)

CREATE TABLE Publications
(
    publication_id INT PRIMARY KEY NOT NULL, 
    auteur_id INT NOT NULL, 
    date_publication DATE NOT NULL, 
    /*
    discussion_id (obigatoire si premier niveau)
    answer_ta_pub_id (obligatoire si second niveau)
    sujet
    imagine 
    film_titre
    artiste_id
    ...
    */
    FOREIGN KEY (auteur_id) REFERENCES Utilisateurs(u_id)
    
)

CREATE TABLE Discussions
(
    discussions_id INT PRIMARY KEY NOT NULL, 
    label VARCHAR(255) 
)

CREATE TABLE REACTION
(
    publication_id INT PRIMARY KEY NOT NULL,
    u_id INT PRIMARY KEY NOT NULL,
    r_type VARCHAR(255) NOT NULL, 
    FOREIGN KEY (u_id) REFERENCES Utilisateurs(u_id)
)

CREATE TABLE Participation
(
    user_id INT PRIMARY KEY NOT NULL, 
    event_id INT PRIMARY KEY NOT NULL, 
    inscrit INT, 
    interesse INT, 
    /* CHECK IF INSCRIT THEN !INTERESSE ELSE INTERESSE ? */
)


CREATE TABLE Archives_web
(
    event_id INT PRIMARY KEY NOT NULL, 
    lien_web VARCHAR(255) PRIMARY KEY NOT NULL
)



CREATE TABLE Evenements_Futurs 
(
    event_id INT PRIMARY KEY NOT NULL, 
    nom VARCHAR(100) NOT NULL, 
    date DATE, 
    lieu VARCHAR(255),
    nb_places INT,
    prix INT
    /* CHECK DATE > AJD */
)

CREATE TABLE Evenements_Passes
(
    event_id INT PRIMARY KEY NOT NULL, 
    nom VARCHAR(100) NOT NULL, 
    date DATE, 
    lieu VARCHAR(255),
    nb_participants INT
)

