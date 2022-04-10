-- Select data we are using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Milestone_Proj_DSC680..covid_Deaths
ORDER BY 1,2

-- Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS mortality_rate
FROM Milestone_Proj_DSC680..covid_Deaths
ORDER BY 1,2

-- Countries with highest death count

SELECT location, MAX(CAST(total_deaths as INT)) AS total_death_count
FROM Milestone_Proj_DSC680..covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Vaccination rates

WITH PopVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_Vacc_Count)
AS
(
SELECT deaths.continent, deaths.Location, deaths.date, deaths.population, vacc.new_vaccinations
,SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (PARTITION BY deaths.Location ORDER BY deaths.Location, deaths.date) AS rolling_vacc_count
FROM Milestone_Proj_DSC680..covid_Deaths AS deaths
JOIN Milestone_Proj_DSC680..covid_Vaccinations AS vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL


)
SELECT *, (Rolling_Vacc_Count/Population)*100 AS Vaccination_Rate
FROM PopVac
