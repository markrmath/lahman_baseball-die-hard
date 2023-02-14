--2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?

SELECT *
FROM people
	INNER JOIN batting
	USING (playerid)
		INNER JOIN teams
		USING(yearid,teamid)
WHERE height = 
	(SELECT MIN(height)
	FROM people);