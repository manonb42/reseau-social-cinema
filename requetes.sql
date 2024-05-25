----- REQUETES SUR AU MOINS 3 TABLES
SELECT DISTINCT F.f_id, F.titre
FROM Utilisateurs U NATURAL JOIN AvisFilms A NATURAL JOIN Films F
WHERE A.notation = 5 
AND U.hierarchie= 'certifie';
-- films qui ont reçu la notation 5/5 par au moins un utilisateur certifié


----- REQUETES AVEC UNE AUTOJOINTURE
SELECT DISTINCT D1.label
FROM Discussions D1, Discussions D2
WHERE D1.d_id <> D2.d_id
AND D1.label = D2.label ;
--selectionne les (noms de) discussions qui ont le même nom

SELECT U1.u_id, U2.u_id
FROM Follow F1, Follow F2
WHERE F1.follower = U1.u_id AND F1.followed = U2.u_id 
AND F2.follower = U2.u_id AND F2.followed = U1.u_id 
AND U1.u_id > U2.u_id ;
-- selectionne les couples d'amis (ceux qui se follow réciproquement)

SELECT DISTINCT A.nom, A.prenom, F.titre
FROM Artistes A, Staff S1, Staff S2, Films F
WHERE A.a_id = S1.a_id AND A.a_id = S2.a_id AND S1.f_id = F.f_ID AND S2.f_id = F.f_id
AND S1.fonction = 'acteur'
AND S2.fonction = 'realisateur';
-- artistes qui ont été à la fois acteur et réalisateur d'un même film


----- AVEC SOUS REQUETE DANS LE FROM
SELECT  F.f_id, F.titre
FROM 	
	(
	SELECT DISTINCT P.f_id
	FROM Programme P NATURAL JOIN Evenements E
	WHERE E.prix >= 50
	) AS tres_cher NATURAL JOIN Films; 
-- films diffusés dans des événements à plus de 50€


----- AVEC SOUS REQUETE DANS LE WHERE
SELECT F.f_id, F.titre
FROM Films F
WHERE F.f_id IN 
		( SELECT F1.f_id 
		  FROM Programme P NATURAL JOIN Evenements E
		  WHERE  E.prix >= 50 );	
-- films diffusés dans des événements à plus de 50€


----- AVEC SOUS REQUETE CORRELEE
SELECT U.login
FROM Utilisateurs U 
WHERE EXISTS 
		 ( SELECT * FROM Publications P
		   WHERE EXTRACT(YEAR FROM P.date_publication) = 2012 
		   AND P.auteur = U.u_id );

----- AVEC GROUP BY ET HAVING
SELECT R.p_id, COUNT(*)
FROM Reactions R
WHERE R.emoji = 'heart'
GROUP BY R.p_id
HAVING COUNT(*) >= 5;
-- les publications qui comptent au moins 5 coeurs

SELECT A.f_id, SUM(A.notation)/COUNT(*) as moyenne
FROM AvisFilms A
GROUP BY A.f_id
HAVING SUM(A.notation)/COUNT(*) >= (SELECT SUM(notation)/COUNT(*) FROM AvisFilms);
--les films dont la note moyenne est superieure à la note moyenne de toute la table


----- AVEC CALCUL DE DEUX AGRÉGATS
WITH notes_maximales AS
(
SELECT A.f_id, MAX(A.notation) AS note
FROM AvisFilms A 
GROUP BY A.f_id
)
SELECT AVG(note)
FROM notes_maximales;
-- la moyenne des notes maximales attribuées aux films

----- AVEC UNE JOINTURE EXTERNE
SELECT E.nom, U.login
FROM Entreprises E NATURAL JOIN CompteEntreprise CE LEFT JOIN Utilisateurs U ON CE.u_id = U.u_id;
-- toutes les entreprises de la base de donnée et leur compte associé si elles en ont un

-- realisateurs dont tous les films commencent par le mot 'The'
SELECT A.prenom, A.nom
FROM Artistes A, Films F 
WHERE A.a_id = F.realisateur 
AND NOT EXISTS ( SELECT *  FROM Films F1 WHERE F1.realisateur=F.realisateur AND F1.titre NOT LIKE 'The%' )


SELECT A.prenom, A.nom
FROM (
	SELECT DISTINCT F.realisateur as r_id
	FROM Films F
	WHERE (SELECT COUNT(F1.f_id) FROM Films F1 WHERE F1.realisateur = F.realisateur AND F1.titre LIKE 'The%') 
	=   (SELECT COUNT(F1.f_id) FROM Films F1 WHERE F1.realisateur = F.realisateur) 
	) as realisent_que_des_The, Artistes A
WHERE A.a_id = reaslisent_que_des_The.r_id ;
	     
