CREATE TABLE Films
(
    film_id INT PRIMARY KEY, 
    titre VARCHAR(100),
    realisateur_id INT,
    date_sortie DATE,
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id), 
    FOREIGN KEY (sous_genre_id) REFERENCES Sous_genres(sous_genre_id),
    FOREIGN KEY (realisateur_id) REFERENCES Artistes(artiste_id)
)

CREATE TABLE Films_Genres 
(
    film_id INT,
    genre_id INT, 
    PRIMARY KEY(film_id, genre_id), 
    FOREIGN KEY(film_id) REFERENCES Films(film_id), 
    FOREIGN KEY(genre_id) REFERENCES Genres(genre_id)
)

CREATE TABLE Films_Sous_Genres
(
    film_id INT,
    sous_genre_id INT, 
    PRIMARY KEY(sous_genre_id, genre_id), 
    FOREIGN KEY(sous_genre_id) REFERENCES Sous_genres(sous_genre_id), 
    FOREIGN KEY(film_id) REFERENCES Films(film_id)
)

CREATE TABLE Genres
(
    genre_id INT PRIMARY KEY,
    label VARCHAR(100)
)

CREATE TABLE Sous_genres
(
    sous_genre_id INT PRIMARY KEY,
    genre_id INT,
    label VARCHAR(100), 
    FOREIGN KEY(genre_id) REFERENCES Genres(genre_id)
)

CREATE TABLE Utilisateurs
(
    u_id SERIAL PRIMARY KEY,
    categorie_id VARCHAR(100), /* random, artiste .. */
    u_login VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL, 
    prenom VARCHAR(100) NOT NULL, 
    mdp VARCHAR(100) NOT NULL, 
    pays VARCHAR(100), 
    date_naissance DATE,
    role_id VARCHAR(100) NOT NULL
)

CREATE TABLE Notation
(
    film_id INT,
    u_id INT, 
    note FLOAT NOT NULL,
    PRIMARY KEY(film_id, u_id), 
    FOREIGN KEY(film_id) REFERENCES Films(film_id), 
    FOREIGN KEY(u_id) REFERENCES Utilisateurs(u_id)
)

CREATE TABLE Artistes
(
    artiste_id INT PRIMARY KEY,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    date_naissance DATE, 
    categorie_id VARCHAR(100) NOT NULL
)

CREATE TABLE Casting
(
    film_id INT,
    artiste_id INT, 
    PRIMARY KEY(film_id, artiste_id), 
    FOREIGN KEY(film_id) REFERENCES Films(film_id), 
    FOREIGN KEY(artiste_id) REFERENCES Artistes(artiste_id) 
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

CREATE TABLE Reaction
(
    publication_id INT NOT NULL,
    u_id INT NOT NULL,
    r_type VARCHAR(255) NOT NULL,
    PRIMARY KEY(publication_id, u_id, r_type), 
    FOREIGN KEY (u_id) REFERENCES Utilisateurs(u_id), 
    FOREIGN KEY (publication_id) REFERENCES Publications(publication_id), 
)

CREATE TABLE Participation
(
    user_id INT, 
    event_id INT, 
    inscrit INT, 
    interesse INT, /* CHECK IF INSCRIT THEN !INTERESSE ELSE INTERESSE ? */
    PRIMARY KEY(user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES Utilisateurs(u_id), 
    FOREIGN KEY (event_id) REFERENCES Evenements_Futurs(event_id)
)


CREATE TABLE Archives_web
(
    event_id INT NOT NULL, 
    lien_web VARCHAR(255), 
    PRIMARY KEY(event_id, lien_web),
    FOREIGN KEY (event_id) REFERENCES Evenements_Passes(event_id)
)


CREATE TABLE Evenements_Futurs 
(
    event_id INT PRIMARY KEY, 
    nom VARCHAR(100) NOT NULL, 
    date DATETIME CHECK (DATEDIFF(CAST(NOW() AS DATETIME), date)<=0), /* verifier que ça marche*/
    lieu VARCHAR(255),
    nb_places INT,
    prix FLOAT
)

CREATE TABLE Evenements_Passes
(
    event_id INT PRIMARY KEY, 
    nom VARCHAR(100) NOT NULL, 
    date DATETIME CHECK (DATEDIFF(CAST(NOW() AS DATETIME), date)>0), /* verifier que ça marche*/
    lieu VARCHAR(255),
    nb_participants INT
)

CREATE TABLE Annonces
(
    event_id INT,
    discussion_id INT, 
    PRIMARY KEY(event_id, discussion_id), 
    FOREIGN KEY(event_id) REFERENCES Evenements_Futurs(event_id), 
    FOREIGN KEY(discussion_id) REFERENCES Discussions(discussion_id)
)

CREATE TABLE Programme
(
    event_id INT,
    film_id INT, 
    PRIMARY KEY(event_id, film_id), 
    FOREIGN KEY(event_id) REFERENCES Evenements_Futurs(event_id), 
    FOREIGN KEY(film_id) REFERENCES Films(film_id)
)

