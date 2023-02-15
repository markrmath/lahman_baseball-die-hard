-- 6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful.
-- (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.

SELECT namefirst,
	   namelast,
	   sb,
	   cs,
	   sb+cs AS sba,
	   ROUND((sb * 1.0/(sb+cs)) * 100, 2) AS sb_success
FROM batting
INNER JOIN people
	USING(playerid)
WHERE yearid = 2016
	  AND sb+cs >= 20
ORDER BY sb_success DESC
LIMIT 1;

-- The answer is Chris Owings, who successfully stole bases 91.3% of the time.