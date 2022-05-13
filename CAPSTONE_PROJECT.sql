--Combine all the twelve dataset into one(1)
INSERT INTO t1
SELECT *
FROM t12; 

-- Altering datatype
ALTER Table t1
ALTER COLUMN Start_station_id nvarchar(255);

SELECT COUNT(*) FROM t1;

SELECT DISTINCT * FROM t1;

------Remove Nulls----
SELECT * INTO Not_Null
FROM 
(
SELECT * 
FROM t1
WHERE start_station_name IS NOT NULL
AND end_station_name IS NOT NULL
AND start_station_id IS NOT NULL
AND end_station_id IS NOT NULL
)A

SELECT * FROM Not_Null;
 
SELECT *INTO final_data
FROM
(
SELECT
started_at,
ended_at, 
start_station_name,
end_station_name,
rideable_type AS bike_type,
member_casual AS user_type,
CAST(started_at as date)as start_date,
CAST(ended_at as date) as end_date,
CONVERT(VARCHAR(10), CAST(started_at AS TIME),0)as start_time,
CONVERT(VARCHAR(10), CAST(ended_at AS TIME),0)as end_time
FROM Not_Null
)B

select * from final_data
--------------------DATA ANALYSIS-------------

--------Total Rides
SELECT Count(*) FROM final_data;

-----------Number of Rides by Month-----------

SELECT DISTINCT DATENAME(month,start_date)as Month,count(*)as no_of_rides
FROM final_data
group by DATENAME(month,start_date)
order by 1;

--Number of Rides By Month,User_type,And Bike_type--
SELECT DISTINCT DATENAME(month,start_date)as Month,count(*)as no_of_rides,bike_type,user_type
FROM final_data
group by DATENAME(month,start_date),user_type,bike_type
order by 1;

--Rides per Members
SELECT DISTINCT user_type,count(*)as no_of_rides
FROM final_data
WHERE user_type = 'member'
group by user_type;

--Rides per Casual
SELECT DISTINCT user_type,count(*)as no_of_rides
FROM final_data
WHERE user_type = 'casual'
group by user_type;

--Casual rides by month
SELECT DISTINCT user_type,DATENAME(month,start_date)as Month,count(*)as no_of_rides
FROM final_data
WHERE user_type = 'casual'
group by user_type,DATENAME(month,start_date);

--Member rides by Month
SELECT DISTINCT user_type,DATENAME(month,start_date)as Month,count(*)as no_of_rides
FROM final_data
WHERE user_type = 'member'
group by user_type,DATENAME(month,start_date);

--Member rides by bike type
SELECT DISTINCT bike_type,user_type,count(*)as no_of_rides
FROM final_data
WHERE user_type ='member'
group by bike_type,user_type;

--casual rides by bike type
SELECT DISTINCT bike_type,user_type,count(*)as no_of_rides
FROM final_data
WHERE user_type ='casual'
group by bike_type,user_type;

--Bike type by Month
SELECT DISTINCT bike_type,DATENAME(month,start_date)as Month,count(*)as no_of_rides
FROM final_data
group by bike_type,DATENAME(month,start_date)
Order by bike_type;

--Rides by Weekday
--Shows the Total Number of Rides by Days of the Week
SELECT DISTINCT DATENAME(weekday, start_date)as Day_of_week, Count (*) as Total_no_of_rides
FROM final_data
group by DATENAME(weekday, start_date)
order by 2 desc;

--Casual Rides by Weekday
SELECT DISTINCT user_type,DATENAME(weekday, start_date)as Day_of_week, Count (*) as Total_no_of_rides
FROM final_data
WHERE user_type ='casual'
group by DATENAME(weekday, start_date),user_type
order by 3;

--Member Rides by Weekday
SELECT DISTINCT user_type,DATENAME(weekday, start_date)as Day_of_week, Count (*) as Total_no_of_rides
FROM final_data
WHERE user_type ='member'
group by DATENAME(weekday, start_date),user_type
order by 3;

--Rides by weekends and weekdays
SELECT
Count (*) as Total_no_of_rides,
DATENAME(dw, start_date) DayofWeek,
CHOOSE(DATEPART(dw, start_date), 'WEEKEND','Weekday',
'Weekday','Weekday','Weekday','Weekday','WEEKEND') WorkDay
FROM final_data
GROUP BY Start_date,DATENAME(dw, start_date)
order by WorkDay;

--Total number of rides taken by Causual riders on weekends and week days
SELECT 
Count (*) as Total_no_of_rides,
DATENAME(dw, start_date) DayofWeek, 
CHOOSE(DATEPART(dw, start_date), 'WEEKEND','Weekday',
'Weekday','Weekday','Weekday','Weekday','WEEKEND') WorkDay
FROM final_data
WHERE user_type ='casual'
GROUP BY Start_date,DATENAME(dw, start_date),user_type,DATENAME(dw, start_date)
order by DayofWeek;

--Total number of rides taken by member riders on weekends and week days
SELECT 
Count (*) as Total_no_of_rides,
DATENAME(dw, start_date) DayofWeek, 
CHOOSE(DATEPART(dw, start_date), 'WEEKEND','Weekday',
'Weekday','Weekday','Weekday','Weekday','WEEKEND') WorkDay
FROM final_data
WHERE user_type ='member'
GROUP BY Start_date,DATENAME(dw, start_date),user_type,DATENAME(dw, start_date)
order by DayofWeek;


--Rides by Usertype and Biketype
SELECT user_type,bike_type,Count(*) as Total_no_of_rides
FROM final_data
GROUP BY user_type,bike_type
ORDER BY 1,2;

--Bike type by user type
SELECT bike_type, count(bike_type)as number_of_rides,user_type
FROM final_data
GROUP BY bike_type,user_type;

--Average ride by user type

SELECT AVG(DATEDIFF(Minute,started_at,ended_at) as Duration 
FROM final_data;


WITH datareworked AS
(
SELECT 
user_type,
bike_type,
DATEDIFF(Minute,started_at,ended_at) as Duration
FROM final_data
)
SELECT  AVG(Duration) as average_ride,user_type
FROM datareworked
GROUP BY user_type;

------Average ride by bike type---
WITH datareworked AS
(
SELECT 
user_type,
bike_type,
DATEDIFF(Minute,started_at,ended_at) as Duration
FROM final_data
)
SELECT  AVG(Duration) as average_ride,bike_type
FROM datareworked
GROUP BY bike_type;