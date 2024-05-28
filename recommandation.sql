PREPARE recommandations(INT) AS

WITH 
followed_artists AS 
(
	SELECT C.a_id
	FROM ComptesArtistes C, Relations R
	WHERE R.followed = C.u_id 
	AND R.follower = $1
),
films_liked_by_friends AS
(
	SELECT F.f_id
	FROM Films F NATURAL JOIN AvisFilms A
	WHERE A.u_id IN (SELECT id1 FROM Amis WHERE id2 = $1)
	OR A.u_id IN (SELECT id2 FROM Amis WHERE id1 = $1)
	AND A.notation >= 3
),
films_from_events_liked_by_friends AS
(
	SELECT F.f_id
	FROM Films F NATURAL JOIN Programmes P NATURAL JOIN Evenements E NATURAL JOIN AvisEvenements A
	WHERE A.u_id IN (SELECT id1 FROM Amis WHERE id2 = $1)
	OR A.u_id IN (SELECT id2 FROM Amis WHERE id1 = $1)
	AND A.notation >= 4
),
films_with_followed_artists AS 
(
	SELECT F.f_id
	FROM Films F NATURAL JOIN Staff S 
	WHERE S.a_id IN (SELECT a_id FROM followed_artists)
),
films_recommandes AS
(
SELECT F.f_id,
	   F.titre, 
	    (CASE 
		    WHEN (F.f_id IN (SELECT f_id FROM films_liked_by_friends)) THEN 1.0
		    ELSE 0.0
	    END +
	    CASE 
		    WHEN (F.f_id IN (SELECT f_id FROM films_from_events_liked_by_friends)) THEN 0.5
		    ELSE 0.0
	    END +
	    CASE 
		    WHEN (F.f_id IN (SELECT f_id FROM films_with_followed_artists)) THEN 2.0
		    ELSE 0.0
	    END) AS indice
FROM Films F
)

SELECT f_id,titre, indice
FROM films_recommandes
WHERE indice <> 0;





