CREATE DATABASE Divvy;
USE Divvy;
CREATE TABLE rides (
  ride_id varchar(25) PRIMARY KEY,
  rideable_type VARCHAR(25),
  started_at DATETIME,
  ended_at DATETIME,
  start_station_name VARCHAR(255),
  start_station_id VARCHAR(50),
  end_station_name VARCHAR(255),
  end_station_id VARCHAR(50),
  start_lat DECIMAL(10, 8),
  start_lng DECIMAL(11, 8),
  end_lat DECIMAL(10, 8),
  end_lng DECIMAL(11, 8),
  member_casual VARCHAR(10),
  started_at_time DATETIME,
  ended_at_time DATETIME,
  duration_time TIME
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/divvy_2021-2022.csv' IGNORE 
INTO TABLE rides
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';


