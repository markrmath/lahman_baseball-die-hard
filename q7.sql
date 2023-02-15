-- 7a. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?

SELECT *
FROM teams
WHERE wswin = 'N'
	  AND yearid >= 1970
ORDER BY w DESC
LIMIT 1;

-- The Seattle Mariners, one of the baseball's more cursed franchises, won 116 games in 2001 but failed to the world series.

-- 7b. What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case.

SELECT *
FROM teams
WHERE wswin = 'Y'
	  AND yearid >= 1970
ORDER BY w
LIMIT 1;

-- The LA Dodgers won in 1981 with only 63 wins.
-- As to the why, all the teams that year played about 105-110 games as opposed to the 162 played in other years.
-- A strike in 1981 caused over a third of the games to be cancelled.

-- 7c. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series?
-- What percentage of the time?

WITH league_win_rank AS (SELECT name, --window function to cut out a lot of clutter and give each team a rank compared to the whole league, not just their division
	  					 		w,
						 		wswin, 
						 		RANK() OVER (PARTITION BY yearid ORDER BY w DESC) AS total_league_win_rank
						 FROM teams
						 WHERE yearid <> 1981
							  AND yearid >= 1970
						ORDER BY total_league_win_rank) 
SELECT COUNT(*) AS wswins_for_team_w_most_wins, --note: one year didn't have a world series due to strike but count ignores nulls
	   ROUND((COUNT(*)*1.0/46) * 100, 2) AS wswins_for_team_w_most_wins_percentage -- I  counted the amount of years not in sql because its not like it could be different.
FROM league_win_rank
WHERE wswin = 'Y'
	  AND total_league_win_rank = 1;

-- The team with the most amount of wins won the world series 12/46 seasons (excluding 1981), or 26.09% of seasons checked.