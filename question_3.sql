--3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
SELECT *
FROM schools
	INNER JOIN collegeplaying
	USING(schoolid)
WHERE schoolname ILIKE '%vander%';

--This is the query used to produce the data for question 3.
SELECT playerid,
	schoolname, 
	namefirst,
	namelast,
	SUM(salary)::numeric::money AS total_salary
FROM schools
	INNER JOIN collegeplaying
	USING(schoolid)
		LEFT JOIN people
		USING (playerid)
			FULL JOIN salaries
			USING(playerid)
WHERE schoolname ILIKE '%vander%'
GROUP BY playerid, schoolname, namefirst, namelast 
ORDER BY total_salary DESC NULLS LAST;

--ANSWER: David Price went to Vanderbilt University and earned a total salary of $245,553,88.00