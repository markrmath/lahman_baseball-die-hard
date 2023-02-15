-- 1. What range of years for baseball games played does the provided database cover?

SELECT MIN(yearid), MAX(yearid)
FROM teams;
-- the database covers from year 1871 to 2016.