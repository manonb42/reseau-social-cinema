CREATE TABLE ArtistesTemp (a_id INT, nom VARCHAR(100), prenom VARCHAR(100), birth DATE, pays VARCHAR(100));

\COPY ArtistesTemp FROM 'artistes.csv' WITH csv;

INSERT INTO Artistes (nom,prenom,birth,pays)
SELECT nom,prenom,birth,pays FROM ArtistesTemp;

DROP TABLE ArtistesTemp;
