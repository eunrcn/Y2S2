-- Q1
SELECT DISTINCT pname AS name, (2023 - birth) AS age
FROM   People
WHERE  death IS NULL;

/*
98.83% got correct
- not checking if the person is still alive (death IS NULL)
- invalid check if the person is still alive (death = NULL)
*/



-- Q2
SELECT DISTINCT tname AS title, syear
FROM   Titles
WHERE  syear >= 1960
  AND  tid NOT IN (
    SELECT tid FROM TvSeries
);

/*
98.24% got correct
- not using DISTINCT as there is no guarantee name/year combo is unique
- invalid construction of tid for TvSeries (e.g., not using query but tuple construction, using episode tid, etc)
*/



-- Q3
SELECT DISTINCT P.pname AS director, T.tname AS title
FROM   Produces P, Titles T, Genres G
WHERE  P.tid = T.tid
  AND  G.tid = T.tid
  AND  P.task = 'director'
  AND  G.genre = 'Drama';

/*
94.13% got correct
- missing check on Drama
- missing check on director
- invalid joining of table (requires at least 3 tables)
*/


-- Q4
SELECT DISTINCT P1.pname AS name, P1.birth, P1.death
FROM   People P1
       LEFT JOIN PlaysIn P2
       ON P1.pname = P2.pname
       LEFT JOIN Titles T
       ON P2.tid = T.tid
WHERE  T.tid IS NULL;

/*
97.65% got correct
- check non-existence with Produces table (insufficient, need to actually check with PlaysIn)
- check using count
*/


-- Q5
SELECT DISTINCT P.pname AS name,
                COUNT(DISTINCT T.tid),
                MIN(T.syear) AS earliest,
                MAX(T.runtime) AS longest
FROM   PlaysIn P, Titles T
WHERE  P.tid = T.tid
GROUP BY P.pname;

/*
96.77% got correct
- invalid counting
- invalid grouping
*/


-- Q6
SELECT DISTINCT P.pname AS name, COUNT(DISTINCT T.tid)
FROM   PlaysIn P, Titles T
WHERE  P.tid = T.tid
  AND  T.syear >= 1950
GROUP BY P.pname
HAVING   COUNT(DISTINCT T.tid) >= (
  SELECT COUNT(DISTINCT T1.tid)
  FROM   PlaysIn P1, Titles T1
  WHERE  P1.tid = T1.tid
    AND  P1.pname = 'Marlene Dietrich'
);

/*
84.46% got correct
- hardcoding 3 (not using Marlene Dietrich)
*/


-- Q7
SELECT *
FROM   People P
WHERE  P.pname LIKE '% % %';

/*
75.66% got correct
- can be solved simply with LIKE, using technique not taught in class is not allowed as per
https://canvas.nus.edu.sg/courses/52825/discussion_topics
*/


-- Q8
SELECT DISTINCT T.tname AS title,
                E.season,
                E.epnum AS episode,
                E.epname AS name
FROM   Titles T, TvSeries TV, Episodes E
WHERE  T.tid = TV.tid
  AND  E.tid = TV.tid
  AND  T.eyear IS NOT NULL
ORDER BY T.tname ASC,
         season  DESC,
         epnum   ASC;

/*
87.68% got correct
NOTE:
  There is an ambiguity what is there is a TV series without any episode?
  We accept both.
- CTE started to be seen frequently here
*/


-- Q9
SELECT DISTINCT G.genre, COUNT(DISTINCT T.tid) AS count
FROM   Titles T, Genres G
WHERE  T.tid = G.tid
GROUP BY G.genre
HAVING COUNT(DISTINCT T.tid) IN (
  SELECT DISTINCT COUNT(DISTINCT T.tid)
  FROM   Titles T, Genres G
  WHERE  T.tid = G.tid
  GROUP BY G.genre
  HAVING COUNT(DISTINCT T.tid) >= 5
  LIMIT 3
)
ORDER BY count   DESC,
         G.genre ASC;

/*
82.99% got correct
- mainly error due to CTE
- also many uses DENSE_RANK or other similarly not taught concept
*/


-- Q10
--- (a) Double Negation
SELECT DISTINCT P1.pname AS name, G1.genre
FROM   PlaysIn P1, Titles T1, Genres G1
WHERE  P1.tid = T1.tid
  AND  T1.tid = G1.tid
  AND  P1.pname <> 'James Dean'
  AND  NOT EXISTS (
  SELECT 1
  FROM   PlaysIn P2, Titles T2, Genres G2
  WHERE  P2.tid = T2.tid
    AND  T2.tid = G2.tid
    AND  P2.pname = 'James Dean'
    AND  NOT EXISTS (
    SELECT 1
    FROM   PlaysIn P3, Titles T3, Genres G3
    WHERE  P3.tid = T3.tid
      AND  T3.tid = G3.tid
      AND  P3.pname = P1.pname
      AND  G3.genre = G2.genre
  )
);

--- (b) Cardinality
SELECT DISTINCT P0.pname AS name, G0.genre
FROM   PlaysIn P0, Titles T0, Genres G0
WHERE  P0.tid = T0.tid
  AND  T0.tid = G0.tid
  AND  P0.pname <> 'James Dean'
  AND  (
    (SELECT COUNT (*) FROM (
      SELECT DISTINCT G.genre
      FROM   PlaysIn P, Titles T, Genres G
      WHERE  P.tid = T.tid
        AND  T.tid = G.tid
        AND  P.pname = 'James Dean'
      
      UNION
      
      SELECT G.genre
      FROM   PlaysIn P, Titles T, Genres G
      WHERE  P.tid = T.tid
        AND  T.tid = G.tid
        AND  P.pname = P0.pname
    ) AS T1) = (
    SELECT COUNT (DISTINCT G.genre)
    FROM   PlaysIn P, Titles T, Genres G
    WHERE  P.tid = T.tid
      AND  T.tid = G.tid
      AND  P.pname = P0.pname
    )
);

/*
92.38% got correct
- testing universal quantification (either double negation or cardinality solution are accepted)
- if James Dean does not play in any, then the output is everyone
*/