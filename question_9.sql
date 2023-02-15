--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

WITH moty AS (SELECT namefirst||' '||namelast AS full_name,
       			     teams.name AS team_name,
	   				 tsn_winners.lgid AS league,
			  	     playerid
  		        FROM (SELECT playerid, lgid, yearid
		  			    FROM awardsmanagers
	     		       WHERE awardid = 'TSN Manager of the Year'AND lgid IN('NL', 'AL')
					   GROUP BY playerid, lgid, yearid) AS tsn_winners
	   			     INNER JOIN people
	   		         USING(playerid)
	   				 INNER JOIN managers
	   			     USING(playerid, yearid)
 	   			     INNER JOIN teams
	   		   	 	 USING(teamid, yearid)), --Manager of the year winners for National and American leagues. 


lgid_count AS (SELECT playerid, 
			   		  CASE WHEN COUNT(DISTINCT lgid) = 2 THEN 'Y' ELSE 'N' END AS both_leagues
				 FROM awardsmanagers
				WHERE lgid IN('NL', 'AL') AND awardid = 'TSN Manager of the Year'
				GROUP BY playerid) --Categorizing managers by the number of leagues they played in.


SELECT full_name, team_name, league
  FROM lgid_count
	   INNER JOIN moty
	   USING(playerid)  --Joining both tables created above
 WHERE both_leagues = 'Y' --Filtering to only managers that have awards in both leagues. 
 GROUP BY full_name, team_name, league;
 
 --Davey Johnson has won 'TSN Manager of the Year' award in both leagues with the Baltimore Orioles and Washington Nationals
 --Jim Leyland has won 'TSN Manager of the Year' award in both leagues with the Detroit Tigers and Pittsburgh Pirates






