-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. 
-- Do the same for home runs per game. Do you see any trends?

SELECT CASE WHEN RIGHT(yearid::text, 2)::integer BETWEEN 10 AND 19 THEN '2010s' --case when 
	   		WHEN RIGHT(yearid::text, 2)::integer BETWEEN 20 AND 29 THEN '1920s'
			WHEN RIGHT(yearid::text, 2)::integer BETWEEN 30 AND 39 THEN '1930s'
			WHEN RIGHT(yearid::text, 2)::integer BETWEEN 40 AND 49 THEN '1940s'
			WHEN RIGHT(yearid::text, 2)::integer BETWEEN 50 AND 59 THEN '1950s'
			WHEN RIGHT(yearid::text, 2)::integer BETWEEN 60 AND 69 THEN '1960s'
			WHEN RIGHT(yearid::text, 2)::integer BETWEEN 70 AND 79 THEN '1970s'
			WHEN RIGHT(yearid::text, 2)::integer BETWEEN 80 AND 89 THEN '1980s'
			WHEN RIGHT(yearid::text, 2)::integer BETWEEN 90 AND 99 THEN '1990s'
			WHEN RIGHT(yearid::text, 2)::integer BETWEEN 00 AND 09 THEN '2000s'
			ELSE 'error' END AS decade,
	   ROUND(AVG(soa * 1.0/g), 2) AS strikeouts_per_game, --soa is strikeouts (pitched, which doesn't matter), so we get the average strikeouts per game, rounded to 2 decimal points. The * 1.0 is just to get out of integers-only.
	   ROUND(AVG(HR * 1.0/g), 2) AS homeruns_per_game --homeruns per game, same format as above
FROM teams
WHERE yearid > 1919
GROUP BY decade
ORDER BY decade;

-- Its not a perfect correlation, but both the strikeouts per game and homeruns per game have risen steadily since 1920.