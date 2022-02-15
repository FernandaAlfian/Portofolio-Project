/*  Credit Card Customer Data
		DOING DATA EXPLORING AND MANIPULATION
*/



-- Looking all of the data I have
SELECT * 
FROM CreditCard..BankChurners

/* 
Data Cleaning

Remove the duplicates if any
Check for the null values in each column
Drop unnecessary columns - There are 2 columns which seem unnessary
*/


SELECT CLIENTNUM, Attrition_Flag, Customer_Age, Gender, Education_Level, Marital_Status, Income_Category, Card_Category, Months_on_book,
		Total_Relationship_Count, Months_Inactive_12_mon, Contacts_Count_12_mon, Credit_Limit, Total_Revolving_Bal, Total_Trans_Amt, Total_Trans_Ct
FROM CreditCard..BankChurners
WHERE CLIENTNUM is null;
-- All ClientNum are unique 




/*
DATA EXPLORATION

Total Customers
Proportion of existing and attrited customers count
Proportion of entire education levels
Proportion of education level by existing and attrited customer
Proportion of marital status by attrited and existing customers
Proportion of income category
Proportion of income category by customer
Customer age count by customer
Proportion of card category based on number of customers
Proportion of total revolving balance by existing and attrited customer
Total Credit Limit
Proportion of Credit Limit by existing and attrited customer

*/

SELECT CLIENTNUM, Attrition_Flag, Customer_Age, Gender, Education_Level, Marital_Status, Income_Category, Card_Category, Months_on_book,
		Total_Relationship_Count, Months_Inactive_12_mon, Contacts_Count_12_mon, Credit_Limit, Total_Revolving_Bal, Total_Trans_Amt, Total_Trans_Ct
FROM CreditCard..BankChurners



--Total Customers
SELECT COUNT(CLIENTNUM) as CLIENTNUM
FROM CreditCard..BankChurners

--Proportion of existing and attrited customers count
SELECT Attrition_Flag,
		COUNT(Attrition_Flag) as COUNT_CustomerType,
		SUM(COUNT(CLIENTNUM)) OVER () COUNT_CLIENTNUM,
		CAST(COUNT(Attrition_Flag)*100.0/SUM(COUNT(CLIENTNUM)) OVER () AS decimal(18,2)) as Percent_CustomerType
FROM CreditCard..BankChurners
GROUP BY Attrition_Flag


--Proportion of entire education levels
SELECT Education_Level,
		COUNT(Education_Level) as COUNT_EducationLevel,
		CAST(COUNT(Education_Level)*100.0/SUM(COUNT(Education_Level)) OVER () AS decimal(18,2)) as Percent_EducaitonLevel
FROM CreditCard..BankChurners
GROUP BY Education_Level
ORDER BY 3 DESC

--Proportion of education level by existing and attrited customer
SELECT Education_Level, Attrition_Flag,
		COUNT(Education_Level) as Count_EducationLevel,
		SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Education_Level) as TotalPerEducationLevel,
		CAST(COUNT(Education_Level)*100.0/SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Education_Level) AS decimal(18,2)) as Percent_EducaitonLevel
FROM CreditCard..BankChurners
GROUP BY Education_Level, Attrition_Flag
ORDER BY 1,2 


--Proportion of marital status
SELECT Marital_Status,
		COUNT(Marital_Status) as COUNT_MaritalStatus,
		CAST(COUNT(Marital_Status)*100.0/SUM(COUNT(Marital_Status)) OVER () AS decimal(18,2)) as Percent_Marital_Status
FROM CreditCard..BankChurners
GROUP BY Marital_Status
ORDER BY 3 DESC


--Proportion of marital status by attrited and existing customers
SELECT Marital_Status, Attrition_Flag,
		COUNT(Marital_Status) as Count_MartialStatus,
		SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Marital_Status) as TotalPerMartialStatus,
		CAST(COUNT(Marital_Status)*100.0/SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Marital_Status) AS decimal(18,2)) as Percent_MartialStatus
FROM CreditCard..BankChurners
GROUP BY Marital_Status, Attrition_Flag
ORDER BY 1,2 


--Proportion of income category
SELECT Income_Category,
		COUNT(Income_Category) as COUNT_IncomeCategory,
		CAST(COUNT(Income_Category)*100.0/SUM(COUNT(Income_Category)) OVER () AS decimal(18,2)) as Percent_IncomeCategory
FROM CreditCard..BankChurners
GROUP BY Income_Category
ORDER BY 3 DESC


--Proportion of income category by customer
SELECT Income_Category, Attrition_Flag,
		COUNT(Income_Category) as Count_IncomeCategory,
		SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Income_Category) as TotalPerIncomeCategory,
		CAST(COUNT(Income_Category)*100.0/SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Income_Category) AS decimal(18,2)) as Percent_IncomeCategory
FROM CreditCard..BankChurners
GROUP BY Income_Category, Attrition_Flag
ORDER BY 1,2 


--Customer age count by customer
SELECT COUNT(Customer_Age) as CountAge, MIN(Customer_Age) as MinAge, MAX(Customer_Age) as MaxAge
FROM CreditCard..BankChurners

--Create Bins 3 Years
SELECT a.Customer_Age_Bins, COUNT(*) as Count_Age
FROM (
SELECT CASE WHEN Customer_Age <27 THEN '<26'
	WHEN Customer_Age >26 AND Customer_Age <30 THEN '27-29'
	WHEN Customer_Age >29 AND Customer_Age <33 THEN '30-32'
	WHEN Customer_Age >32 AND Customer_Age <36 THEN '33-35'
	WHEN Customer_Age >35 AND Customer_Age <39 THEN '36-38'
	WHEN Customer_Age >38 AND Customer_Age <42 THEN '39-41'
	WHEN Customer_Age >41 AND Customer_Age <45 THEN '42-44'
	WHEN Customer_Age >44 AND Customer_Age <48 THEN '45-47'
	WHEN Customer_Age >47 AND Customer_Age <51 THEN '48-50'
	WHEN Customer_Age >50 AND Customer_Age <54 THEN '51-53'
	WHEN Customer_Age >53 AND Customer_Age <57 THEN '54-56'
	WHEN Customer_Age >56 AND Customer_Age <60 THEN '57-59'
	WHEN Customer_Age >59 AND Customer_Age <62 THEN '60-61'
	WHEN Customer_Age >61 AND Customer_Age <65 THEN '62-64'
	WHEN Customer_Age >64 AND Customer_Age <68 THEN '65-67'
	WHEN Customer_Age >67 AND Customer_Age <71 THEN '68-70'
	WHEN Customer_Age >70 AND Customer_Age <73 THEN '71-73'
	ELSE '73>'
	END as Customer_Age_Bins
FROM CreditCard..BankChurners
) a
GROUP BY a.Customer_Age_Bins
ORDER BY a.Customer_Age_Bins



--Customer age count by attrited and existing customers
SELECT a.Attrition_Flag, a.Customer_Age_Bins, COUNT(*) as Count_Age,
		CAST(COUNT(a.Customer_Age_Bins)*100.0/SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY a.Customer_Age_Bins) AS decimal(18,2)) as Percent_AgebyAge,
		CAST(COUNT(a.Attrition_Flag)*100.0/SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY a.Attrition_Flag) AS decimal(18,2)) as Percent_AgebyCustType
FROM (
SELECT CLIENTNUM, Attrition_Flag,
CASE WHEN Customer_Age <27 THEN '<26'
	WHEN Customer_Age >26 AND Customer_Age <30 THEN '27-29'
	WHEN Customer_Age >29 AND Customer_Age <33 THEN '30-32'
	WHEN Customer_Age >32 AND Customer_Age <36 THEN '33-35'
	WHEN Customer_Age >35 AND Customer_Age <39 THEN '36-38'
	WHEN Customer_Age >38 AND Customer_Age <42 THEN '39-41'
	WHEN Customer_Age >41 AND Customer_Age <45 THEN '42-44'
	WHEN Customer_Age >44 AND Customer_Age <48 THEN '45-47'
	WHEN Customer_Age >47 AND Customer_Age <51 THEN '48-50'
	WHEN Customer_Age >50 AND Customer_Age <54 THEN '51-53'
	WHEN Customer_Age >53 AND Customer_Age <57 THEN '54-56'
	WHEN Customer_Age >56 AND Customer_Age <60 THEN '57-59'
	WHEN Customer_Age >59 AND Customer_Age <62 THEN '60-61'
	WHEN Customer_Age >61 AND Customer_Age <65 THEN '62-64'
	WHEN Customer_Age >64 AND Customer_Age <68 THEN '65-67'
	WHEN Customer_Age >67 AND Customer_Age <71 THEN '68-70'
	WHEN Customer_Age >70 AND Customer_Age <73 THEN '71-73'
	ELSE '73>'
	END as Customer_Age_Bins
FROM CreditCard..BankChurners
) a
GROUP BY a.Customer_Age_Bins, a.Attrition_Flag
ORDER BY 2,1

--Proportion of card category based on number of customers


SELECT Card_Category,
		COUNT(Card_Category) as COUNT_CardCategory,
		CAST(COUNT(Card_Category)*100.0/SUM(COUNT(Card_Category)) OVER () AS decimal(18,2)) as CardCategory
FROM CreditCard..BankChurners
GROUP BY Card_Category
ORDER BY 3 DESC


--Proportion of marital status by attrited and existing customers
SELECT Card_Category, Attrition_Flag,
		COUNT(Card_Category) as CountCardCategory,
		SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Card_Category) as TotalPerCardCategory,
		CAST(COUNT(Card_Category)*100.0/SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Card_Category) AS decimal(18,2)) as Percent_CardCategory,
		CAST(COUNT(Attrition_Flag)*100.0/SUM(COUNT(CLIENTNUM)) OVER (PARTITION BY Attrition_Flag) AS decimal(18,2)) as Percent_CardCategorybyCustType
FROM CreditCard..BankChurners
GROUP BY Card_Category, Attrition_Flag
ORDER BY 2,1




--Total revolving balance
SELECT SUM(Total_Revolving_Bal) as Total_Revolving_Bal
FROM  CreditCard..BankChurners


--Proportion of total revolving balance by existing and attrited customer
SELECT Attrition_Flag, SUM(Total_Revolving_Bal) as Total_Revolving_Bal,
		CAST(SUM(Total_Revolving_Bal) * 100.0 / SUM(SUM(Total_Revolving_Bal)) OVER () AS decimal(18,2)) AS Percentage_Total_Revolving_Bal
FROM  CreditCard..BankChurners
GROUP BY Attrition_Flag

-- Total Credit Limit
SELECT SUM(Credit_Limit) as Credit_Limit
FROM  CreditCard..BankChurners


--Proportion of Credit Limit by existing and attrited customer
SELECT Attrition_Flag, SUM(Credit_Limit) as Credit_Limit,
		CAST(SUM(Credit_Limit) * 100.0 / SUM(SUM(Credit_Limit)) OVER () AS decimal(18,2)) AS Percentage_CreditLimit
FROM  CreditCard..BankChurners
GROUP BY Attrition_Flag