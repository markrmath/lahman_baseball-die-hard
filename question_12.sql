--12. In this question, you will explore the connection between number of wins and attendance.
    
      --a. Does there appear to be any correlation between attendance at home games and number of wins? 
	
WITH home_games AS (SELECT attendance/ghome AS avg_home_attendance,
	   			           yearid, teamid, g, ghome, attendance, w
  				      FROM teams
				     WHERE ghome IS NOT NULL AND attendance > 0)
					 
SELECT CORR(avg_home_attendance, w)
  FROM home_games; --Correlation coefficient of +.36 suggest some correlation between wins and average home game attendance.

	  
	  --b.1 Do teams that win the world series see a boost in attendance the following year? 


WITH wswinners AS (SELECT yearid AS winningyear, teamid, wswin AS wswin1, attendance AS winningattendance 
				     FROM teams
				    WHERE wswin = 'Y' AND attendance IS NOT NULL)

SELECT winningyear, wswinners.teamid, winningattendance, -- winning year stats
	   teams.yearid AS nextyear, teams.attendance AS nextyearattendance, --following year stats
	   teams.attendance - winningattendance AS attendancediff --difference in attendance between years
  FROM wswinners
	   LEFT JOIN teams 
	   ON teams.teamid = wswinners.teamid AND winningyear + 1 = yearid --joining for the next years data on teamid and year+1
 ORDER BY attendancediff DESC NULLS LAST;


--57 World Series winners saw an increase of attendance, 55 did not see an increase in attendance. 
--There is no obvious corrrelation between a World Series win and attendance. 

	  --b.2 What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.
   

WITH po AS (SELECT yearid AS winningyear, teamid, divwin AS divwin1, wcwin AS wcwin1, attendance AS winningattendance 
				     FROM teams
				    WHERE divwin = 'Y' OR wcwin = 'Y' AND attendance IS NOT NULL)

SELECT winningyear, po.teamid, winningattendance,
	   teams.yearid AS nextyear, teams.attendance AS nextyearattendance, 
	   teams.attendance - winningattendance AS attendancediff 
  FROM po
	   LEFT JOIN teams 
	   ON teams.teamid = po.teamid AND winningyear + 1 = yearid 
 ORDER BY attendancediff DESC NULLS LAST;
 
	   
 --162 teams who made the playoffs saw an increase in attendance the next year. 
 --128 teams who made the playoffs did not increase in attendance for the next year.
 --There is evidence to suggest a correlation between teams that made the playoffs and future attendance. 