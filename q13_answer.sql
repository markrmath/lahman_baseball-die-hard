-- 13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective.
-- Investigate this claim and present evidence to either support or dispute this claim.

SELECT DISTINCT playerid
FROM appearances
INNER JOIN people
	USING (playerid)
WHERE throws = 'L'
	AND g_p > 0;
	
-- First, determine just how rare left-handed pitchers are compared with right-handed pitchers.

WITH distinct_appearance_pitchers AS (SELECT DISTINCT playerid
									   FROM appearances
									   WHERE g_p >= 10) 

SELECT DISTINCT throws,
				playerid,
	   			COUNT(*) OVER (PARTITION BY throws) AS pitchers_by_handedness,
				ROUND((COUNT(*) OVER (PARTITION BY throws)*1.0 / COUNT(*) OVER () * 100), 2) AS percentage_of_total_pitchers
FROM distinct_appearance_pitchers
INNER JOIN people
	USING (playerid)
WHERE throws IS NOT NULL
	AND throws <> 'S';
	
-- 72.62% of pitchers are right-handed, 27.38% are left. There are 6195 players in the dataset that have pitched at least five times.
-- I chose 10 times since there are instances where a non-pitcher will pitch (such as in the 16th inning of particularly long games).
-- That threshold could cut off some pitchers who played very little, but only a few hundred players were removed in total and the percentage changed less than a percent.
-- Are left-handed pitchers more likely to win the Cy Young Award?

SELECT DISTINCT people.throws,
	   COUNT(*) OVER (PARTITION BY throws) AS cy_young_winners,
	   ROUND((COUNT(*) OVER (PARTITION BY throws)*1.0 / COUNT(*) OVER ()) * 100, 2) AS percentage_of_total_winners
FROM awardsplayers
	INNER JOIN people
		USING (playerid)
WHERE awardid = 'Cy Young Award';

-- There are 37 left-handed Cy Young winners compared to 75 right-handed ones. This comes out to about 1/3 left and 2/3s right.
-- Not a large difference, but 33% of lefties have won compared to 27% of pitchers being left-handed is a slight preference to left-handers.

-- Are they more likely to make it into the hall of fame?

WITH distinct_appearance_pitchers AS (SELECT DISTINCT playerid
									   FROM appearances
									   WHERE g_p >= 10) --filtering out all players that aren't pitchers, same criteria as above
									   					-- it should be noted that at least babe ruth started as a pitcher, though he became famous as a hitter. 
														-- He pitched for several seasons, meaning there wasn't a good way to filter him, 
														-- and anyone who was in a similar boat, out from the data.
									   
SELECT people.throws,
	   people.namefirst || ' ' || people.namelast AS full_name,
	   COUNT(*) OVER (PARTITION BY throws) AS hof_members,
	   ROUND((COUNT(*) OVER (PARTITION BY throws)*1.0 / COUNT(*) OVER ()) * 100, 2) AS percentage_of_hof_pitchers
FROM halloffame
	INNER JOIN distinct_appearance_pitchers
		USING (playerid)
	INNER JOIN people
		USING (playerid)
WHERE inducted = 'Y'
	AND category = 'Player'; --I did this just in case some left-handed pitcher played a couple mediocre season but went on to be a HoF manager.
							 --There 5 HoF members removed, even though the percentages didn't change much
							 
-- In the Hall of Fame, there are 74 pitchers. 18 of these are lefties, and 56 right-handed.
-- That comes out to 24.32% lefties, and 75.68% right.
-- That's actually lower than the total percentage of left-handed pitchers in the league, though going from a sample composed of 1000s to one composed of dozens could account for that weirdness.
-- Either way, it doesn't seem like a disproportionate level of lefties reach the HoF.

-- However, Cy Young winners do appear to be skewed towards the lefties, so I'm going to look deeper into that.

-- First I'm going to look at players who won the Cy Young award multiple times.
-- Its possible that even though lefties aren't more likely to be successful, a few really good lefties are skewing the award average.

WITH cy_young_wins_total AS (SELECT playerid,
	   						 COUNT(*) AS number_of_cy_young_wins
					   		 FROM awardsplayers
							 WHERE awardid = 'Cy Young Award'
							 GROUP BY playerid)						 
SELECT people.throws,
	   COUNT(playerid) AS total_cy_young_winners,
	   SUM(number_of_cy_young_wins) AS total_cy_young_wins
FROM people
	INNER JOIN cy_young_wins_total
		USING (playerid)
WHERE number_of_cy_young_wins > 1
GROUP BY throws
ORDER BY total_cy_young_winners DESC;

SELECT 19*1.0/(34+19);

-- The results indicate that my previous hypothesis is correct. While 25~% of pitchers are lefties, and 1/3 of Cy Young winners have been left-handed,
-- if we look at the player who have won Cy Youngs multiple times, half of them are lefties (6 compared to 12), a much higher percentage compared to our larger sample size.
-- Among those who have won multiple awards, 35% of those awards have gone to lefties, which is similar to the total percentage of cy young winners as lefties.
-- To double-check, I'll look at the pitchers who have only won the Cy Young once to see if it supports this idea.

WITH cy_young_wins_total AS (SELECT playerid,
	   						 COUNT(*) AS number_of_cy_young_wins
					   		 FROM awardsplayers
							 WHERE awardid = 'Cy Young Award'
							 GROUP BY playerid)						 
SELECT DISTINCT people.throws,
	   COUNT(playerid) OVER (PARTITION BY throws) AS cy_young_winners,
	   ROUND((COUNT(playerid) OVER (PARTITION BY throws)*1.0 / COUNT(*) OVER ()) * 100, 2) AS percentage_of_cy_young_pitchers
FROM people
	INNER JOIN cy_young_wins_total
		USING (playerid)
WHERE number_of_cy_young_wins = 1;

-- Here our hypothesis is also supported.
-- Out of the 59 pitchers who have only won the Cy Young once, the ratio of lefties to righties is 30.5%:69.50%
-- This is slightly skewed towards lefties compared to the larger data, but that could explained by random chance due to sample size.
-- For the record, only one less left-handed pitcher winning compared to a right-hander puts the percentage at 28.81%
-- which is nearly identical to the amount of left-handed pitchers in the league at large.