SELECT *
FROM people;


SELECT *
FROM people
	INNER JOIN batting
	USING (playerid)
		INNER JOIN teams
		USING(yearid,teamid)
WHERE height = 
	(SELECT MIN(height)
	FROM people);