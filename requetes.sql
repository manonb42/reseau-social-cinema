----- requêtes qui porte sur au moins 3 tables
SELECT DISTINCT F.titre
FROM Utilisateurs U NATURAL JOIN Avis a NATURAL JOIN Film F
WHERE A.notation = 5 
AND U.role = 'VIP'
-- selectionne les films qui ont reçu la notation 5/5 par au moins un utilisateur VIP

SELECT DISTINCT A.a_id, A.prenom, A.nom
FROM Artistes A NATURAL JOIN Casting C NATURAL JOIN Films F
WHERE A.a_id = F.realisateur
--sélectionne les artistes qui ont joué dans un film qu'ils ont eux même réalisé



----- requêtes avec une auto-jointure
SELECT D1.label
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



----- requête avec une sous requête dans le FROM
SELECT  F.f_id, F.titre
FROM 	(
	SELECT DISTINCT P.f_id AS f_id
	FROM Programme P NATURAL JOIN Evenements E
	WHERE E.prix >= 50
	) AS tres_cher NATURAL JOIN Films ; 


----- idem mais version avec sous requête dans le WHERE 
SELECT F.f_id, F.titre
FROM Films F
WHERE F.f_id IN 
		( SELECT F1.f_id 
		  FROM Programme P NATURAL JOIN Evenements E
		  WHERE  E.prix >= 50 );	


----- requête avec une sous requête corrélée
SELECT U.login
FROM Utilisateurs U 
WHERE EXISTS 
		 ( SELECT * FROM Publications P
		   WHERE EXTRACT(YEAR FROM P.date_publication) = 2012 
		   AND P.auteur = U.u_id ) ;




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
	     


--
