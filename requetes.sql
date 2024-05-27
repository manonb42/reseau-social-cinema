----- REQUETES SUR AU MOINS 3 TABLES
-- films qui ont reçu la notation 5/5 par au moins un utilisateur certifié
SELECT DISTINCT F.f_id, F.titre
FROM Utilisateurs U NATURAL JOIN AvisFilms A NATURAL JOIN Films F
WHERE A.mark = 5 
AND U.attribution= 'certifié';


----- REQUETES AVEC UNE AUTOJOINTURE

--selectionne les couples d'utilisateurs qui sont amis
CREATE VIEW Amis (u_id1, u_id2) AS
(
SELECT U1.pseudo, U2.pseudo
FROM Relations R1, Relations R2, Utilisateurs U1, Utilisateurs U2
WHERE R1.follower = R2.followed AND R1.followed = R2.follower
AND R1.follower < R1.followed
AND U1.u_id = R1.follower AND U2.u_id=R1.followed
);

--l'utilisateur qui a le plus d'amis


-- artistes qui ont été à la fois acteur et réalisateur d'un même film
SELECT DISTINCT A.nom, A.prenom, F.titre
FROM Artistes A, Staff S1, Staff S2, Films F
WHERE A.a_id = S1.a_id AND A.a_id = S2.a_id AND S1.f_id = F.f_ID AND S2.f_id = F.f_id
AND S1.fonction = 'acteur'
AND S2.fonction = 'réalisateur';


----- AVEC SOUS REQUETE DANS LE FROM
-- films diffusés dans des événements à plus de 50€
SELECT  F.f_id, F.titre
FROM 	
	(
	SELECT DISTINCT P.f_id
	FROM Programmes P NATURAL JOIN Evenements E
	WHERE E.prix > 200
	) AS tres_cher NATURAL JOIN Films F; 


----- AVEC SOUS REQUETE DANS LE WHERE
-- films diffusés dans des événements à plus de 50€
SELECT F.f_id, F.titre
FROM Films F
WHERE F.f_id IN 
		( SELECT P.f_id 
		  FROM Programmes P NATURAL JOIN Evenements E
		  WHERE  E.prix > 200 );	



----- AVEC SOUS REQUETE CORRELEE
-- utilisateurs qui ont fait deux publications à moins d'une minute d'intervalle
SELECT U.pseudo
FROM Utilisateurs U 
WHERE EXISTS 
		 ( SELECT * FROM Publications P1, Publications P2
		   WHERE P1.p_id <> P2.p_id
		   AND P1.u_id = P2.u_id 
		   AND EXTRACT(YEAR FROM P1.date_publication) = EXTRACT(YEAR FROM P2.date_publication)
		   AND EXTRACT(MONTH FROM P1.date_publication) = EXTRACT(MONTH FROM P2.date_publication)
		   AND EXTRACT(DAY FROM P1.date_publication) = EXTRACT(DAY FROM P2.date_publication)
		   AND EXTRACT(HOUR FROM P1.date_publication) = EXTRACT(HOUR FROM P2.date_publication)
		   AND EXTRACT(MINUTE FROM P1.date_publication) - EXTRACT(MINUTE FROM P2.date_publication) <= 1
		   AND P1.u_id = U.u_id );


----- AVEC GROUP BY ET HAVING
-- les publications qui comptent au moins 5 coeurs
SELECT R.p_id, COUNT(*)
FROM Reactions R
WHERE R.emoji = 'like'
GROUP BY R.p_id
HAVING COUNT(*) >= 5;

--les films dont la note moyenne individuelle est superieure à la note moyenne générale de toute la table
SELECT A.f_id, CAST(SUM(A.mark)/COUNT(*) AS DECIMAL(3,2)) AS moyenne_individuelle
FROM AvisFilms A
GROUP BY A.f_id
HAVING SUM(A.mark)/COUNT(*) >= (SELECT SUM(mark)/COUNT(*) FROM AvisFilms);


----- AVEC CALCUL DE DEUX AGRÉGATS
-- la moyenne des notes maximales attribuées aux films
WITH notes_max AS
(
SELECT A.f_id, MAX(A.mark) AS note
FROM AvisFilms A 
GROUP BY A.f_id
)
SELECT AVG(note) as note_max_moyenne
FROM notes_max;


----- AVEC UNE JOINTURE EXTERNE
-- toutes les entreprises de la base de donnée et leur compte associé si elles en ont un
SELECT E.nom, CE.u_id
FROM Entreprises E LEFT JOIN ComptesEntreprises CE ON CE.ent_id = E.ent_id

SELECT E.nom, U.pseudo, CE.u_id
FROM Utilisateurs U NATURAL JOIN ComptesEntreprises CE RIGHT JOIN Entreprises E ON CE.ent_id=E.ent_id;



----- REQUETES EQUIVALENTES AVEC CONDITION DE TOTALITE 
-- realisateurs dont tous les films commencent par le mot 'The'
SELECT A.a_id, A.prenom, A.nom, F.titre
FROM Artistes A NATURAL JOIN Staff S NATURAL JOIN Films F 
WHERE S.fonction='réalisateur'
AND NOT EXISTS ( 
				SELECT *  
				FROM STAFF S1 NATURAL JOIN Films F1 
				WHERE S1.fonction='réalisateur'
				AND S1.a_id=S.a_id AND F1.titre NOT LIKE 'The%'
				);

SELECT A.a_id, A.prenom, A.nom, F2.titre
FROM
	(
	SELECT S.a_id
	FROM Staff S NATURAL JOIN Films F
	WHERE S.fonction = 'réalisateur'
	AND F.titre LIKE 'The%'
	GROUP BY S.a_id
	HAVING COUNT(*)
			= (SELECT COUNT(*) FROM Staff S1 NATURAL JOIN Films F1 WHERE S1.fonction='réalisateur' AND S1.a_id=S.a_id)
	) AS TheMovies NATURAL JOIN Artistes A NATURAL JOIN Staff S2 NATURAL JOIN Films F2 
WHERE S2.fonction='réalisateur';


----- REQUETES EQUIVALENTES MAIS PAS S'IL Y A DES NULL
-- Le(s) utilisateur(s) le(s) plus vieux de tous

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE U.birth <= ALL(SELECT birth FROM Utilisateurs);
-- renvoie la table vide

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE U.birth = (SELECT MIN(birth) FROM Utilisateurs);
-- ignore la valeur NULL 

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE NOT EXISTS (SELECT * FROM Utilisateurs U1 WHERE U1.birth < U.birth);
-- renvoie les doyens et tous les utilisateurs dont birth est NULL

----- MODIFICATIONS POUR QU'ELLES SOIENT EQUIVALENTES
SELECT U.pseudo, U.birth
FROM Utilisateurs U;
WHERE U.birth <= ALL(SELECT birth FROM Utilisateurs WHERE birth IS NOT NULL);

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE U.birth = (SELECT MIN(birth) FROM Utilisateurs WHERE birth IS NOT NULL);

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE U.birth IS NOT NULL
AND NOT EXISTS (SELECT * FROM Utilisateurs U1 WHERE U1.birth < U.birth);


----- REQUETE RECURSIVE 
--tous les couples de publications qui ont un lien de parenté vertical 
WITH RECURSIVE FilConversation(source,reponse) AS
(
	SELECT * FROM Conversations 
	UNION  -- ou UNION ALL ?
	SELECT C.source, F.reponse
	FROM Conversations C, FilConversation F
	WHERE C.reponse = F.source
) 
SELECT * FROM FilConversation;

WITH RECURSIVE GenealogieDesGenres(genre,sousgenre) AS
(
	SELECT * FROM GenresParents
	UNION  -- ou UNION ALL ?
	SELECT GP.genre, GG.sousgenre
	FROM GenresParents GP, GenealogieDesGenres GG
	WHERE GP.sousgenre = GG.genre
) 
SELECT G1.nom, G2.nom FROM GenealogieDesGenres G, Genres G1, Genres G2
WHERE G1.g_id=G.genre
AND G2.g_id=G.sousgenre;


----- REQUETE AVEC FENETRAGE

WITH Participation(e_id, nom, lieu, effectif) AS
( 	
	SELECT Total.e_id, E.nom, E.lieu, Total.effectif
	FROM
		( 
		SELECT P.e_id, COUNT(*) AS effectif
		FROM Participants P
		WHERE inscrit
		GROUP BY P.e_id
		) AS Total NATURAL JOIN Evenements E
)

SELECT e_id, nom, effectif, lieu, CAST( AVG(effectif) OVER (PARTITION BY lieu) AS DECIMAL(3,2) ) AS moyenne_lieu
FROM Participation
ORDER BY lieu;







	     
