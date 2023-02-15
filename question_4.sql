--4.
--A.Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery".
SELECT  playerid, --Did not make DISTINCT because many players had multiple 						positions
				yearid,
				pos,
				po,
				CASE WHEN pos = 'OF' THEN 'Outfield'
				WHEN pos = 'SS' OR pos= '1B' OR pos = '2B' OR pos= '3B'  THEN 'Infield'
				WHEN pos = 'P' OR pos = 'C' THEN 'Battery' END AS position
FROM fielding;
--B.Determine the number of putouts made by each of these three groups in 2016.
WITH position AS (SELECT  playerid,
						yearid,
						pos,
						po,
						CASE WHEN pos = 'OF' THEN 'Outfield'
						WHEN pos = 'SS' OR pos= '1B' OR pos = '2B' OR pos= '3B'  THEN 'Infield'
						WHEN pos = 'P' OR pos = 'C' THEN 'Battery' END AS position
				FROM fielding)
SELECT position,
	COUNT(f.po) AS po_per_position
FROM position
	INNER JOIN fielding As f
	USING(playerid)
WHERE f.yearid = 2016
GROUP BY position;
--ANSWER: There were 5,482 putouts in the battery position, 8,232 putouts in the infield position and 2,896 in the outfield position