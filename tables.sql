CREATE TABLE Films
(
    titre VARCHAR(100) PRIMARY KEY,
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
    genre_id INT PRIMARY KEY,
    label VARCHAR(100)
)

/* est ce que c'est utile ? */
CREATE TABLE Sous_genres
(
    sous_genre_id INT PRIMARY KEY,
    /* genre_id */
    label VARCHAR(100)
)

CREATE TABLE Artistes
(
    artiste_id INT PRIMARY KEY,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    date_naissance DATE, 
    categorie_id INT /* est ce qu'on garde int ? */
)

CREATE TABLE Utilisateurs
(
    u_id INT PRIMARY KEY,
    categorie_id INT, /* random, artiste .. */
    u_login VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL, 
    prenom VARCHAR(100) NOT NULL, 
    mdp VARCHAR(100) NOT NULL, 
    pays VARCHAR(100), 
    date_naissance DATE
    /* ajouter role_id */
)

CREATE TABLE Follow
(
    u_id_followers INT NOT NULL, 
    u_id_following INT NOT NULL
)

CREATE TABLE Publications
(
    publication_id INT PRIMARY KEY, 
    date_publication DATETIME NOT NULL, 
    auteur_id INT NOT NULL, 
    discussion_id INT NOT NULL,
    answer_to_publication_id INT, 
    FOREIGN KEY (auteur_id) REFERENCES Utilisateurs(u_id), 
    FOREIGN KEY (discussion_id) REFERENCES Discussions(discussion_id), 
    FOREIGN KEY (answer_to_publication_id) REFERENCES Publications(publication_id)
    
)

CREATE TABLE Discussions
(
    discussion_id INT PRIMARY KEY, 
    label VARCHAR(255) 
)

CREATE TABLE REACTION
(
    publication_id INT NOT NULL,
    u_id INT NOT NULL,
    r_type VARCHAR(255) NOT NULL, 
    FOREIGN KEY (u_id) REFERENCES Utilisateurs(u_id), 
    FOREIGN KEY (publication_id) REFERENCES Publications(publication_id), 
)

CREATE TABLE Participation
(
    user_id INT, 
    event_id INT, 
    inscrit INT, 
    interesse INT, /* CHECK IF INSCRIT THEN !INTERESSE ELSE INTERESSE ? */
    FOREIGN KEY (user_id) REFERENCES Utilisateurs(u_id), 
    FOREIGN KEY (event_id) REFERENCES Evenements_Futurs(event_id)
)


CREATE TABLE Archives_web
(
    event_id INT NOT NULL, 
    lien_web VARCHAR(255), 
    FOREIGN KEY (event_id) REFERENCES Evenements_Passes(event_id)
)


/* voir s'il vaut pas mieux faire de l'heritage de table pour les evenements */

CREATE TABLE Evenements_Futurs 
(
    event_id INT PRIMARY KEY, 
    nom VARCHAR(100) NOT NULL, 
    date DATETIME CHECK (DATEDIFF(CAST(NOW() AS DATETIME), date)<=0), /* verifier que ça marche*/
    lieu VARCHAR(255),
    nb_places INT,
    prix INT
)

CREATE TABLE Evenements_Passes
(
    event_id INT PRIMARY KEY, 
    nom VARCHAR(100) NOT NULL, 
    date DATETIME CHECK (DATEDIFF(CAST(NOW() AS DATETIME), date)>0), /* verifier que ça marche*/
    lieu VARCHAR(255),
    nb_participants INT
)

