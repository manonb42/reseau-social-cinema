----- REQUETES SUR AU MOINS 3 TABLES
-- films qui ont reçu la notation 5/5 par au moins un utilisateur certifié
SELECT DISTINCT F.f_id, F.titre
FROM Utilisateurs U NATURAL JOIN AvisFilms A NATURAL JOIN Films 
WHERE A.notation = 5 
AND U.hierarchie= 'certifié';


----- REQUETES AVEC UNE AUTOJOINTURE
--selectionne les (noms de) discussions qui ont le même nom
SELECT DISTINCT D1.label
FROM Discussions D1, Discussions D2
WHERE D1.d_id <> D2.d_id
AND D1.label = D2.label ;

--selectionne les couples d'utilisateurs qui sont amis
SELECT R1.follower, R2.followed
FROM Relation R1, Relation R2
WHERE R1.follower = R2.followed AND R1.followed = R2.follower
AND R1.follower > R2.followed --pour ne pas avoir (A,B) et (B,A)

-- artistes qui ont été à la fois acteur et réalisateur d'un même film
SELECT DISTINCT A.nom, A.prenom, F.titre
FROM Artistes A, Staff S1, Staff S2, Films F
WHERE A.a_id = S1.a_id AND A.a_id = S2.a_id AND S1.f_id = F.f_ID AND S2.f_id = F.f_id
AND S1.fonction = 'acteur'
AND S2.fonction = 'realisateur';


----- AVEC SOUS REQUETE DANS LE FROM
-- films diffusés dans des événements à plus de 50€
SELECT  F.f_id, F.titre
FROM 	
	(
	SELECT DISTINCT P.f_id
	FROM Programme P NATURAL JOIN Evenements E
	WHERE E.prix >= 50
	) AS tres_cher NATURAL JOIN Films; 


----- AVEC SOUS REQUETE DANS LE WHERE
-- films diffusés dans des événements à plus de 50€
SELECT F.f_id, F.titre
FROM Films F
WHERE F.f_id IN 
		( SELECT F1.f_id 
		  FROM Programme P NATURAL JOIN Evenements E
		  WHERE  E.prix >= 50 );	



----- AVEC SOUS REQUETE CORRELEE
-- films diffusés dans des événements à plus de 50€
SELECT U.pseudo
FROM Utilisateurs U 
WHERE EXISTS 
		 ( SELECT * FROM Publications P
		   WHERE EXTRACT(YEAR FROM P.date_publication) = 2012 
		   AND P.auteur = U.u_id );


----- AVEC GROUP BY ET HAVING
-- les publications qui comptent au moins 5 coeurs
SELECT R.p_id, COUNT(*)
FROM Reactions R
WHERE R.emoji = 'heart'
GROUP BY R.p_id
HAVING COUNT(*) >= 5;

--les films dont la note moyenne est superieure à la note moyenne de toute la table
SELECT A.f_id, SUM(A.notation)/COUNT(*) as moyenne
FROM AvisFilms A
GROUP BY A.f_id
HAVING SUM(A.notation)/COUNT(*) >= (SELECT SUM(notation)/COUNT(*) FROM AvisFilms);


----- AVEC CALCUL DE DEUX AGRÉGATS
-- la moyenne des notes maximales attribuées aux films
WITH notes_maximales AS
(
SELECT A.f_id, MAX(A.notation) AS note
FROM AvisFilms A 
GROUP BY A.f_id
)
SELECT AVG(note)
FROM notes_maximales;


----- AVEC UNE JOINTURE EXTERNE
-- toutes les entreprises de la base de donnée et leur compte associé si elles en ont un
SELECT E.nom, U.pseudo
FROM Entreprises E NATURAL JOIN CompteEntreprise CE LEFT JOIN Utilisateurs U ON CE.u_id = U.u_id;



----- REQUETES EQUIVALENTES AVEC CONDITION DE TOTALITE 
-- realisateurs dont tous les films commencent par le mot 'The'
SELECT A.a_id, A.prenom, A.nom
FROM Artistes A NATURAL JOIN Staff S NATURAL JOIN Films F 
WHERE S.fonction='réalisateur'
AND NOT EXISTS ( 
				SELECT *  
				FROM STAFF S1 NATURAL JOIN Films F1 
				WHERE S1.fonction='réalisateur'
				AND S1.a_id=S.a_id AND F1.titre NOT LIKE 'The%'
				);

SELECT S.id_a
FROM Staff S NATURAL JOIN Films F
WHERE S.fonction = 'réalisateur'
AND F.titre LIKE 'The%'
GROUP BY S.id_a
HAVING COUNT(*)
		= (SELECT COUNT(*) FROM Staff S1 NATURAL JOIN Films F1 WHERE S1.fonction='réalisateur' AND S1.a_id=S.a_id);


----- REQUETES EQUIVALENTES MAIS PAS S'IL Y A DES NULL
-- Le(s) utilisateur(s) le(s) plus vieux de tous

SELECT U.pseudo, U.birth
FROM Utilisateurs U;
WHERE U.birth >= ALL(SELECT birth FROM Utilisateurs);
-- renvoie la table vide

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE U.birth = (SELECT MAX(birth) FROM Utilisateurs);
-- ignore la valeur NULL 

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE NOT EXISTS (SELECT * FROM Utilisateurs U1 WHERE U1.birth > U.birth);
-- renvoie les doyens et tous les utilisateurs dont birth est NULL

----- MODIFICATIONS POUR QU'ELLES SOIENT EQUIVALENTES
SELECT U.pseudo, U.birth
FROM Utilisateurs U;
WHERE U.birth >= ALL(SELECT birth FROM Utilisateurs WHERE birth IS NOT NULL);

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE U.birth = (SELECT MAX(birth) FROM Utilisateurs WHERE birth IS NOT NULL);

SELECT U.pseudo, U.birth
FROM Utilisateurs U
WHERE U.birth IS NOT NULL
AND NOT EXISTS (SELECT * FROM Utilisateurs U1 WHERE U1.birth > U.birth);


----- REQUETE RECURSIVE 
--tous les couples de publications qui ont un lien de parenté vertical 
WITH RECURSIVE FilConversation(source,reponse) AS
(
	SELECT * FROM Conversations 
	UNION  -- ou UNION ALL ?
	SELECT 
	FROM Conversations C, FilConversation F
	WHERE V.reponse = A.source
) 
SELECT * FROM FilConversation;


----- REQUETE AVEC FENETRAGE

WITH Participation(e_id, nom, ville, effectif) AS
( 	
	SELECT Total.e_id, E.nom, E.ville, Total.effectif
	FROM
		( 
		SELECT P.e_id, COUNT(*) AS effectif
		FROM Participants P
		WHERE inscrit
		GROUP BY P.ent_id
		) AS Total NATURAL JOIN Evenements E
)

SELECT e_id, nom, effectif, ville, AVG(effectif) OVER (PARTITION BY ville) AS moyenne_ville
FROM Participation
ORDER BY ville;







	     
