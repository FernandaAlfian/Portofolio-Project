/* 
		Uber Analysis
	DATA CLEANING AND DATA EXPLORATION 
		in SQL Queries

*/

SELECT *
FROM UberAnalysis.dbo.Uber


---	DATA CLEANING	---


-- Change pickup_datetime to Date
-----------------------------------------------------------------
SELECT pickup_datetime
FROM UberAnalysis.dbo.Uber

SELECT PARSENAME(REPLACE(pickup_datetime, ' ', '.') , 3),
	   PARSENAME(REPLACE(pickup_datetime, ' ', '.') , 2),
	   PARSENAME(REPLACE(pickup_datetime, ' ', '.') , 1)
FROM UberAnalysis.dbo.Uber




ALTER TABLE dbo.Uber
Add Pickup_Date date

Update dbo.Uber
SET Pickup_Date = PARSENAME(REPLACE(pickup_datetime, ' ', '.') , 3)



-- Change pickup_datetime to Time
-----------------------------------------------------------------

ALTER TABLE dbo.Uber
Add Pickup_Hour time

Update dbo.Uber
SET Pickup_Hour =  PARSENAME(REPLACE(pickup_datetime, ' ', '.') , 2)



SELECT CONVERT(varchar, Pickup_Hour, 108)
FROM UberAnalysis.dbo.Uber

UPDATE dbo.Uber
SET Pickup_Hour = CONVERT(varchar, Pickup_Hour, 108)




-- Clean the null value on pickup_dropoff longitude and latitude
-----------------------------------------------------------------

WITH RowNumCTE AS
(
SELECT *, ROW_NUMBER () 
			OVER (PARTITION BY pickup_longitude,
							   pickup_latitude,
							   dropoff_longitude,
							   dropoff_latitude
					ORDER BY UserID ) row_num
FROM UberAnalysis.dbo.Uber
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY UserID

-- REMOVE 0 VALUE
WITH RowNumCTE AS
(
SELECT *, ROW_NUMBER () 
			OVER (PARTITION BY pickup_longitude,
							   pickup_latitude,
							   dropoff_longitude,
							   dropoff_latitude
					ORDER BY UserID ) row_num
FROM UberAnalysis.dbo.Uber
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY UserID







/*		DATA EXPLORATION 


Create Pickup_Date to Day
Grouping Pickup_Date to Weekday-Weekend

Grouping Rush Hours on Pickup_Hour
Grouping Pickup_Hour to Morning (6-12 AM), Afternoon (12 - 5 PM), Evening (5 - 8 PM), and Night (8 PM - 5 AM)

Create KM from pickup and dropoff lat_long

*/




--Create Pickup_Date to Day
-----------------------------------------------------------------

SELECT DATENAME(Weekday, Pickup_Date) as DayName
FROM UberAnalysis.dbo.Uber

ALTER TABLE dbo.Uber
Add DayName char(255)

UPDATE dbo.Uber
SET DayName = DATENAME(Weekday, Pickup_Date)


--Grouping Pickup_Date to Weekday-Weekend
-----------------------------------------------------------------


SELECT DATENAME(Weekday, Pickup_Date) as DayName,
	CASE WHEN DATEPART(Weekday, Pickup_Date) IN (7,1) THEN 'Weekend'
		 ELSE 'Weekday'
		 END as Weekend_Weekday
FROM UberAnalysis.dbo.Uber


ALTER TABLE dbo.Uber
Add Weekend_Weekday char(255)

UPDATE dbo.Uber
SET Weekend_Weekday = CASE WHEN DATEPART(Weekday, Pickup_Date) IN (7,1) THEN 'Weekend'
							 ELSE 'Weekday'
							 END


SELECT *
FROM UberAnalysis.dbo.Uber






--Grouping Rush Hours on Pickup_Hour
-- Peak Hour arroung  6–10 AM (6:00–10:00) and 3–7 PM (15:00–19:00)  (Based Google)
-----------------------------------------------------------------
SELECT Pickup_Hour,DATEPART(Hour, Pickup_Hour) as DayTime
FROM UberAnalysis.dbo.Uber


SELECT Pickup_Hour,
	   CASE WHEN Pickup_Hour BETWEEN '06:00' AND '10:00' THEN 'PeakHours'
			WHEN Pickup_Hour BETWEEN '15:00' AND '19:00' THEN 'PeakHours'
			ELSE 'Non_PeakHours'
			END
FROM UberAnalysis.dbo.Uber



ALTER TABLE dbo.Uber
ADD PeakHours char(225)

UPDATE dbo.Uber
SET PeakHours =  CASE WHEN Pickup_Hour BETWEEN '06:00' AND '10:00' THEN 'PeakHours'
			WHEN Pickup_Hour BETWEEN '15:00' AND '19:00' THEN 'PeakHours'
			ELSE 'Non_PeakHours'
			END





--Grouping Pickup_Hour to Morning (6-12 AM), Afternoon (12 - 5 PM), Evening (5 - 8 PM), and Night (8 PM - 5 AM)
-----------------------------------------------------------------
SELECT Pickup_Hour,DATEPART(Hour, Pickup_Hour) as DayTime
FROM UberAnalysis.dbo.Uber


SELECT Pickup_Hour,
	   CASE WHEN Pickup_Hour BETWEEN '06:00' AND '11:59' THEN 'Morning'
			WHEN Pickup_Hour BETWEEN '12:00' AND '16:59' THEN 'Afternoon'
			WHEN Pickup_Hour BETWEEN '17:00' AND '19:59' THEN 'Evening'
			ELSE 'Night'
			END
FROM UberAnalysis.dbo.Uber



ALTER TABLE dbo.Uber
ADD DayTime char(225)

UPDATE dbo.Uber
SET DayTime =  CASE WHEN Pickup_Hour BETWEEN '06:00' AND '11:59' THEN 'Morning'
			WHEN Pickup_Hour BETWEEN '12:00' AND '16:59' THEN 'Afternoon'
			WHEN Pickup_Hour BETWEEN '17:00' AND '19:59' THEN 'Evening'
			ELSE 'Night'
			END


SELECT *
FROM UberAnalysis.dbo.Uber







--Create KM from pickup and dropoff lat_long
-----------------------------------------------------------------
DECLARE @source geography = POINT(pickup_longitude, pickup_latitude)
DECLARE @target geography = POINT(dropoff_longitude, dropoff_latitude)	
    
SELECT @source.STDistance(@target)
FROM UberAnalysis.dbo.Uber


SELECT *, (((acos(sin((CAST(pickup_latitude as numeric(20,15))*pi()/180))) * sin((CAST(dropoff_latitude as numeric(20,15))*pi()/180)) + 
				cos((CAST(pickup_latitude as numeric(20,15))*pi()/180)) * cos((CAST(dropoff_latitude as numeric(20,15))*pi()/180)) * 
				cos(((CAST(pickup_longitude as numeric(20, 15)) - CAST(dropoff_longitude as numeric(20,15))) * pi()/180)))) * 
				180/pi()) * 60 * 1.1515 * 1.609344) as Distance 
FROM UberAnalysis.dbo.Uber
--WHERE Distance <= 1



SELECT ,CAST(pickup_longitude as numeric(20, 15)), CAST(pickup_latitude as numeric(20,15)), CAST(dropoff_longitude as numeric(20,15)), CAST(dropoff_latitude as numeric(20,15))
FROM UberAnalysis.dbo.Uber


---------- FAILED TO KNOW THE DISTANCE BETWEEN TWO LATITUDE & LONGITUDE ----------------------



/* 

1. COUNT UserID
2. Total fare_amount
3. Comparation between Average(fare_amount) for each DayName
4. Comparation between Average(fare_amount) and Weekend_Weekday
5. Comparation between Average(fare_amount) and DayTime
6. Comparation between Average(fare_amount) and PeakHours and Non_PeakHours
7. Comparation between Average(fare_amount) and passenger_count
8. Total Passanger_count


*/

SELECT *
FROM UberAnalysis.dbo.Uber


--1. COUNT UserID
-----------------------------------------------------------------
SELECT COUNT(UserID) as Total_Customer
FROM UberAnalysis.dbo.Uber


--2. Total fare_amount
-----------------------------------------------------------------
SELECT SUM(fare_amount) as Total_fare_amount
FROM UberAnalysis.dbo.Uber


--3. Comparation between Average(fare_amount) for each DayName
-----------------------------------------------------------------
SELECT DayName, SUM(fare_amount) as Total_fare_amount,AVG(fare_amount) as Average_fare_amount
FROM UberAnalysis.dbo.Uber
GROUP BY DayName
--ORDER BY 1


--4. Comparation between Average(fare_amount) and Weekend_Weekday
-----------------------------------------------------------------
SELECT Weekend_Weekday, SUM(fare_amount) as Total_fare_amount, AVG(fare_amount) as Average_fare_amount
FROM UberAnalysis.dbo.Uber
GROUP BY Weekend_Weekday
--ORDER BY 1


--5. Comparation between Average(fare_amount) and DayTime
-----------------------------------------------------------------
SELECT DayTime, SUM(fare_amount) as Total_fare_amount, AVG(fare_amount) as Average_fare_amount
FROM UberAnalysis.dbo.Uber
GROUP BY DayTime
--ORDER BY 1


--6. Comparation between Average(fare_amount) and PeakHours and Non_PeakHours
-----------------------------------------------------------------
SELECT PeakHours, SUM(fare_amount) as Total_fare_amount, AVG(fare_amount) as Average_fare_amount
FROM UberAnalysis.dbo.Uber
GROUP BY PeakHours
--ORDER BY 1


--7. Comparation between Average(fare_amount) and passenger_count
-----------------------------------------------------------------
SELECT passenger_count, SUM(fare_amount) as Total_fare_amount, AVG(fare_amount) as Average_fare_amount
FROM UberAnalysis.dbo.Uber
--WHERE passenger_count != 208
GROUP BY passenger_count
ORDER BY 1


--8. Total Passanger_count
-----------------------------------------------------------------
SELECT passenger_count, COUNT(passenger_count)
FROM UberAnalysis.dbo.Uber
GROUP BY passenger_count
ORDER BY 1


-----------------------------------------------------------------
-- Delete Unused Columns
SELECT *
FROM UberAnalysis.dbo.Uber

ALTER TABLE dbo.Uber
DROP COLUMN pickup_datetime

-- Key also need to be deleted, but it's name cannot be read from sql

