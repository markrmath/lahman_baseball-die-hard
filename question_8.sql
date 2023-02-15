--8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.


WITH top_attendance_2016 AS (SELECT park_name,
							 		team,
	   			       		   		homegames.attendance/games AS avg_attendance
  					      	   FROM homegames
  	   						   		INNER JOIN parks
	                           		USING(park)
   						      WHERE games >= 10 AND year = 2016
 							  ORDER BY avg_attendance DESC
 							  LIMIT 5)
 
SELECT park_name, 
	   teams.name, 
	   avg_attendance 
  FROM top_attendance_2016
	   JOIN teams
	   ON teams.teamid = top_attendance_2016.team
 WHERE yearid = 2016; 
 
--Top 5 parks by attendance and their teams are: Dodger Stadium - Los Angeles Dodgers, Busch Stadium III - St. Louis Cardinals, Rogers Centre - Toronto Blue Jays, AT&T Park - San Francisco Giants, Wrigley Field - Chicago Cubs


--Lowest 5 avg_attendance

WITH bottom_attendance_2016 AS (SELECT park_name,
							 		team,
	   			       		   		homegames.attendance/games AS avg_attendance
  					      	   FROM homegames
  	   						   		INNER JOIN parks
	                           		USING(park)
   						      WHERE games >= 10 AND year = 2016
 							  ORDER BY avg_attendance ASC
 							  LIMIT 5)
 
SELECT park_name, 
	   teams.name, 
	   avg_attendance 
  FROM bottom_attendance_2016
	   JOIN teams
	   ON teams.teamid = bottom_attendance_2016.team
 WHERE yearid = 2016; --Bottom 5 parks by attendance and their teams are: Tropicana Field - Tampa Bay Rays, Oakland-Alameda County Coliseum - Oakland Athletics, Progressive Field - Cleveland Indians, Marlins Park - Miami Marlins, U.S. Cellular Field - Chicago White Sox. 


 
