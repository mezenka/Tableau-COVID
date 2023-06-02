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

--5. Maximum percent of population vaccinated

SELECT 
	d.continent,
	d.location,
	MAX(CAST(v.total_vaccinations AS INT)) AS vaccinated_total,
	MAX(population) AS population,
	MAX(CAST(v.total_vaccinations AS INT))/MAX(population) AS vaccinated_prcnt
FROM a001covid.dbo.CovidDeaths d
JOIN a001covid.dbo.CovidVaccinations v
ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
GROUP BY d.continent,d.location
--HAVING MAX(CAST(v.total_vaccinations AS INT))/MAX(population) IS NOT NULL
ORDER BY MAX(CAST(v.total_vaccinations AS INT))/MAX(population) DESC


--6. Covid dynamics: global tested vs infected vs dead vs vaccinated
--this crap just refuses to work!!!!!
/*
CREATE VIEW PopulationVaccinatedPcnt AS
	SELECT 
	d.continent,
	d.location,
	d.date,
	d.population,
	v.new_vaccinations,
	SUM(CAST(v.new_vaccinations AS INT)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS vacc_aggr
		FROM a001covid.dbo.CovidDeaths d
		JOIN a001covid.dbo.CovidVaccinations v
		ON d.location = v.location AND d.date = v.date
		WHERE d.continent IS NOT NULL
*/--SELECT * FROM PopulationVaccinatedPcnt

/*
SELECT
	cast(d.date AS date) AS date,
	--SUM(CAST(v.total_tests_per_thousand AS FLOAT))*1000 AS tested,
	--SUM(CAST(v.new_tests_smoothed AS INT)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS tested,

	SUM(d.total_cases) AS infected,
	SUM(CAST(d.total_deaths AS INT)) AS dead,
	SUM(CAST(v.new_vaccinations AS INT)) AS vaccinated
	FROM a001covid.dbo.CovidDeaths d
	INNER JOIN --a001covid.dbo.CovidVaccinations v
		PopulationVaccinatedPcnt v
ON d.location = v.location AND d.date = v.date
WHERE d.continent LIKE 'North America' --AND d.date < '2021-04-28'
GROUP BY d.date--,SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date)
ORDER BY d.date
*/
SELECT * FROM a001covid.dbo.CovidVaccinations
ORDER BY date,location