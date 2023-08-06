-- Use database
use divvy;

-- Show table
select * from rides;

-- Member/Casual count every month for two years
SELECT YEAR(started_at) AS Y, MONTH(started_at) AS M, COUNT(CASE WHEN member_casual = 'member' THEN 1 END ) AS Member_Count, COUNT(CASE WHEN member_casual = 'CASUAL' THEN 1 END ) AS Casual_Count FROM rides  group by Y,M order by Y,M;

-- Delete rows that are not reasonable
DELETE FROM rides WHERE duration_time = 0;
DELETE FROM rides WHERE duration_TIME > TIME('05:00:00');
DELETE FROM rides WHERE duration_TIME < TIME('00:01:00');


-- add time period column into table
ALTER TABLE rides ADD time_period VARCHAR(20);
UPDATE rides SET time_period = CASE 
    WHEN HOUR(started_at) < 12 THEN 'Morning'
    WHEN HOUR(started_at) < 18 THEN 'Afternoon'
    ELSE 'Evening'
  END;
  
  -- Add day of the week into table
  ALTER TABLE rides ADD DOTW VARCHAR(20);
UPDATE rides SET DOTW = DAYNAME(started_at);

-- KPI Export Main table
select ride_id, rxideable_type, started_at, member_casual, duration_time, 
(case 
when month(started_at) in (1,2,3) then "Q1"
when month(started_at) in (4,5,6) then "Q2"
when month(started_at) in (7,8,9) then "Q3"
when month(started_at) in (10,11,12) then "Q4"
else 'None'
End) as Quarter
from rides
INTO OUTFILE 'kpi.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- KPI Export time table
select ride_id, time_period, DOTW from rides
INTO OUTFILE 'time.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- KPI Export geo table
select ride_id, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng from rides
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/geo.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- KPI Export duration table
select ride_id, time_to_sec(duration_time) from rides
INTO OUTFILE 'duration.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Different type of bike type
SELECT DISTINCT(rideable_type) FROM rides;

-- Different Types of Bike counts
SELECT COUNT(CASE WHEN rideable_type = 'classic_bike' THEN 1 END ) AS Classic_Count, COUNT(CASE WHEN rideable_type = 'electric_bike' THEN 1 END ) AS Electric_Count, COUNT(CASE WHEN rideable_type = 'docked_bike' THEN 1 END ) AS Docked_Count FROM rides;

-- Average Ride Time
SELECT member_casual, round((AVG(duration_time)/60),2) AS Average_Ride_Time FROM rides GROUP BY member_casual;
SELECT member_casual, Max(duration_time) AS Longest_Ride_Time, MIN(duration_time) AS Shortest_Ride_Time FROM rides GROUP BY member_casual;
SELECT member_casual, rideable_type, round((AVG(duration_time)/60),2) FROM rides GROUP BY member_casual, rideable_type;


