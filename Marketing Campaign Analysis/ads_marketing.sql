CREATE SCHEMA IF NOT EXISTS marketing_division;

USE marketing_division;

-- Create Table
CREATE TABLE IF NOT EXISTS marketing_division.ads_marketing (
    Date_Time DATE,
    Ad_Type VARCHAR(50),
    Impression INT,
    Reach INT,
    Engagement INT,
    Click INT,
    Cost INT,
    Ad_Recall INT
);

-- Importing data from csv file


SELECT *
FROM ads_marketing
LIMIT 5;

SELECT *
		, date_format(Date_Time, '%M') as Month
        , Impression/Reach as Frequency_Rate
        , Engagement/Reach as Engagement_Rate
        , Ad_Recall/Reach as Ad_Recall_Rate
		, (Cost/Impression)*1000 as CPM
        , Click/Impression as CTR
        , Cost/Click as CPC
FROM ads_marketing
ORDER BY date_time ASC;

-- This data need to be visualized in tableau 
