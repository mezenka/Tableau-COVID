--Data queries for Tableau visualizations
--1. Total covid cases, covid deaths, death percentage
SELECT 
	SUM(new_cases) AS covid_cases,
	SUM(cast(new_deaths AS INT)) as deaths,
	SUM(cast(new_deaths AS INT))/SUM(New_Cases)*100 AS deaths_prct
FROM a001covid.dbo.CovidDeaths
WHERE continent IS NOT NULL

--check for NULL data
/*
SELECT 
	continent,
	location,
	SUM(new_cases) AS covid_cases,
	SUM(cast(new_deaths AS INT)) as deaths,
	SUM(cast(new_deaths AS INT))/SUM(New_Cases)*100 AS deaths_prct
FROM a001covid.dbo.CovidDeaths
GROUP BY continent, location
HAVING SUM(cast(new_deaths AS INT)) IS NOT NULL
*/

--2. Total deaths count by continent

SELECT
	location,
	MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM a001covid.dbo.CovidDeaths
WHERE continent IS NULL AND location NOT IN ('European Union', 'International', 'World')
GROUP BY location
ORDER BY total_deaths_count DESC

/*
--to check SELECT MAX(CAST(total_deaths AS INT)) FROM a001covid.dbo.CovidDeaths
--gives 15 'International' and extra 17 in an undefined Asian location
--alternatively without 'International' -- still extra 17
SELECT
	location,
	SUM(CAST(new_deaths AS INT)) AS tot_deaths_count
FROM a001covid.dbo.CovidDeaths
WHERE continent IS NULL AND location NOT IN ('European Union', 'World')
GROUP BY location
ORDER BY tot_deaths_count DESC
*/

--3. Percent of population infected by country

SELECT
	continent,
	location,
	population,
	MAX(total_cases) AS MaxCovidCases,
	MAX((total_cases/population)*100) AS PopulationInfectedPrcnt
FROM a001covid.dbo.CovidDeaths
GROUP BY continent,location, population
ORDER BY PopulationInfectedPrcnt DESC


--4. Infected Timeseries PerCent

SELECT
	location,[
	population,
	CAST(date AS date) date,
	MAX(total_cases) AS MaxCovidCases,
	MAX((total_cases/population)*100) AS PopulationInfectedPrcnt
FROM a001covid.dbo.CovidDeaths
GROUP BY location, population, date
ORDER BY location, date

