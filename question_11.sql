--11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.

--Query used to produce the total teams salary for each year from 2000 and later
SELECT teamid,
	w,
	teams.yearid,
	SUM(salary) AS total_salary
FROM teams
	INNER JOIN salaries
	USING(yearid, teamid) --Matched on two to not bring a lot of data over
WHERE yearid >= 2000
GROUP BY w, teamid, teams.yearid
ORDER BY teamid, yearid DESC;


--For further analysis of the correlation between number of wins and the team salary, I have completed the below query:
WITH total_team_salary AS (SELECT teamid,
							w,
							teams.yearid,
							SUM(salary) AS total_salary
						   FROM teams
							INNER JOIN salaries
							USING(yearid, teamid) 
						  WHERE yearid >= 2000
						  GROUP BY w, teamid, teams.yearid
						  ORDER BY teamid, yearid DESC)

SELECT CORR(w,total_salary)
FROM total_team_salary;

--ANSWER: The correlation coefficient is .34 which would be considered to have a low correlation