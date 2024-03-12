SELECT AVG(rating) AS average_rating FROM Titles;


SELECT DISTINCT p.pname, t.tname
FROM Produces p 
JOIN Titles t ON p.tid = t.tid
WHERE p.tid IN (SELECT tid FROM Titles WHERE rating > 8);

Actors and Directors for Action Films
SELECT p.pname AS Actor, pd.pname AS Director, t.tname
FROM Titles t
JOIN PlaysIn pi ON t.tid = pi.tid
JOIN People p ON pi.pname = p.pname
LEFT JOIN Produces pd ON t.tid = pd.tid AND pd.task = 'Director'
WHERE t.votes > 6
AND t.tid 
IN (SELECT tid FROM Genres WHERE genre = 'Action');

SELECT DISTINCT p.pname
FROM People p
JOIN PlaysIn pi ON p.pname = pi.pname
JOIN Produces pd ON pi.tid = pd.tid
WHERE pd.pname = 'Christopher Nolan';

SELECT DISTINCT p.pname
FROM People p, PlaysIn pi, Produces pd
WHERE p.pname = pi.pname 
AND pi.tid = pd.tid 
AND pd.pname = 'Ingmar Bergman';


SELECT g.genre, AVG(t.runtime) AS average_runtime
FROM Titles t
JOIN Genres g ON t.tid = g.tid
GROUP BY g.genre
ORDER BY g.genre;
// 
ORDER BY AVG(t.runtime) DESC;

//Calculate the total number of votes and the average rating for movies released before the year 2000.
SELECT SUM(votes) AS total_votes, AVG(rating) AS average_rating
FROM Titles
WHERE syear < 2000;

//List the top 3 genres with the highest average ratings, along with the corresponding average ratings.
SELECT g.genre, AVG(t.rating) AS average_rating
FROM Titles t
JOIN Genres g ON t.tid = g.tid
GROUP BY g.genre
ORDER BY average_rating DESC
LIMIT 3;

//Find the names of people who have played in both 'Action' and 'Drama' genres.
SELECT pname
FROM PlaysIn
WHERE tid IN (SELECT tid FROM Genres WHERE genre = 'Action')
   AND pname IN (SELECT pname FROM PlaysIn WHERE tid IN (SELECT tid FROM Genres WHERE genre = 'Drama'));

//Retrieve the names of people who have both acted in and produced movies
SELECT DISTINCT p.pname
FROM People p, PlaysIn pi, Produces pd
WHERE p.pname = pi.pname
AND pi.tid = pd.tid;


//Calculate the total number of episodes for each TV series, but only include TV series with more than 3 seasons.
SELECT ts.tid, t.tname, COUNT(*) AS total_episodes
FROM TvSeries ts
JOIN Titles t ON ts.tid = t.tid
JOIN Episodes e ON ts.tid = e.tid
GROUP BY ts.tid, t.tname
HAVING COUNT(DISTINCT e.season) > 3;

