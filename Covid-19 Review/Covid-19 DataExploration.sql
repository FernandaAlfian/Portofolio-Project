/* PILOT PROJECT COVID-19 
		DATA EXPLORATION  
		
		*/







-- Make sure all of the data are available

SELECT *
FROM FirstProject..CovidVacinations
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM FirstProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--Checking the data from null values
-- Check the continent and location
-- There are duplicates continent in location-continent tables
SELECT DISTINCT location
FROM FirstProject..CovidDeaths
WHERE continent is null

SELECT DISTINCT continent
FROM FirstProject..CovidDeaths
--WHERE continent is null

-- Looking for location based on their income
SELECT DISTINCT location
FROM FirstProject..CovidDeaths
WHERE location like '%income%'




/* OVERVIEW DATA
- Total Cases
- New Cases
- TOP 10 Cases over the world
- Positive Rate 
*/

SELECT *
FROM FirstProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

-- Total Cases, Total New Cases
SELECT SUM(total_cases) as Total_Cases, SUM(new_cases) as New_Cases
FROM FirstProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--TOP 10 Total Cases LAST date
SELECT TOP 10
		location, SUM(total_cases) as Total_Cases
FROM FirstProject..CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY Total_Cases desc

-- Total Cases around the world by date
SELECT location, CAST(date as DATE) as date, SUM(total_cases) as Total_Cases
FROM FirstProject..CovidDeaths
WHERE continent is not null
GROUP BY Location, date
ORDER BY 2 asc,3 desc

-- Positive Rate
-- Join with CovVaccinated Data
SELECT d.location, CONVERT(DATE, d.date) as date, d.population, d.new_cases, v.new_tests, (d.new_cases/v.new_tests)*100 as positive_rate
FROM FirstProject..CovidVacinations v
JOIN  FirstProject..CovidDeaths d
ON v.location = d.location
AND v.date = d.date
WHERE d.continent is not null
ORDER BY 1,2





/* Looking for Worldwide Vaccinated Data
-Population
-Rolling People Vaccinated by their location
-Percent of people vaccinated */

SELECT *
FROM FirstProject..CovidVacinations
WHERE continent is not null
ORDER BY 3,4


-- Population
SELECT continent, location, date, population, people_vaccinated, new_vaccinations
FROM FirstProject..CovidVacinations
WHERE continent is not null
ORDER BY 1,2

-- People Vaccinated
SELECT continent, location, date, population, people_vaccinated
FROM FirstProject..CovidVacinations
WHERE continent is not null

-- Percent People Vaccinated
-- PeopleVaccinated/Populatin
SELECT continent, location, date, population, people_vaccinated, (people_vaccinated/population)*100 as Percent_Vaccinated
FROM FirstProject..CovidVacinations
WHERE continent is not null

--TOP 10 PeopleVaccinated
WITH PercVac (continent, location, date, population, people_vaccinated, Percent_Vaccinated)
AS
(
SELECT continent, location, date, population, people_vaccinated, (people_vaccinated/population)*100 as Percent_Vaccinated
FROM FirstProject..CovidVacinations
--ORDER BY Percent_Vaccinated
WHERE continent is not null
)
SELECT TOP 10 
		location, MAX(Percent_Vaccinated) as MAX_PercentVaccinated
FROM PercVac
GROUP BY location
ORDER BY MAX_PercentVaccinated desc





/* Is higher income got lower chance covid?
Is higher income more vaccinated than lower income?
-Total Cases per Income
-New Cases per Income
-Total Cases per Income Category by Years
-People Vaccinated per Income
-Total Deaths
*/

SELECT DISTINCT location
FROM FirstProject..CovidDeaths
WHERE location like '%income%'

SELECT *
FROM FirstProject..CovidDeaths
WHERE location like '%income%'


-- Looking for total cases per income
SELECT location, date, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) as Total_Cases
FROM FirstProject..CovidDeaths
WHERE location like '%income%'
ORDER BY 1,2


-- Max total cases per income
WITH MAXCase (location, date, new_cases, Total_Cases)
AS
(
SELECT location, date, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) as Total_Cases
FROM FirstProject..CovidDeaths
WHERE location like '%income%'
--ORDER BY 1,2
)
SELECT location, MAX(Total_Cases) as Total_Cases
FROM MAXCase
GROUP BY location
ORDER BY 1

-- Simple Query
SELECT location, SUM(new_cases) as Total_Cases
FROM FirstProject..CovidDeaths
WHERE location like '%income%'
GROUP BY location
--ORDER BY 1,2


-- Max total cases per income and years
-- Group by location and years
SELECT location, DATEPART(year, date) as dateyears, SUM(new_cases) as Total_Cases
FROM FirstProject..CovidDeaths
WHERE location like '%income%'
GROUP BY location, DATEPART(year, date)
ORDER BY 2,1



-- Looking for total death per income category
SELECT location, date, total_deaths
FROM FirstProject..CovidDeaths
WHERE location like '%income%'
ORDER BY 1,2

-- Max total death per income category
SELECT location,  DATEPART(year, date) as dateyears, MAX(total_deaths) as Total_deaths
FROM FirstProject..CovidDeaths
WHERE location like '%income%'
GROUP BY location, DATEPART(year, date)
ORDER BY 2,1


-- People Vaccinated by income category
SELECT location, date, population, people_vaccinated
FROM FirstProject..CovidVacinations
WHERE location like '%income%'
ORDER BY 1,2

-- Percent People Vaccinated by income category
SELECT location, date, population, people_vaccinated, (people_vaccinated/population)*100 as PercentPeopleVacc
FROM FirstProject..CovidVacinations
WHERE location like '%income%'
ORDER BY 1,2

-- Percent People Vaccinated by income category
SELECT c.location, c.dateyears, MAX(c.PercentPeopleVacc) as MaxPercentVacc
FROM (SELECT location, DATEPART(year, date) as dateyears, population, people_vaccinated, (people_vaccinated/population)*100 as PercentPeopleVacc
		FROM FirstProject..CovidVacinations
		WHERE location like '%income%'
		--ORDER BY 1,2
		) c
GROUP BY c.location, c.dateyears
ORDER BY 2,3 desc

