--1
--looking at people being affected and death percentage, as per people being affected
SELECT SUM(population) AS World_Population,SUM(new_cases) AS Total_affected, 
    SUM(CONVERT(int, new_deaths))   AS Total_Death, 
    (SUM(CONVERT(int, new_deaths))/SUM(new_cases))*100 AS Death_Percentage

FROM PortfolioProject1..coviddeath
WHERE continent is not NULL


--2
-- looking at percentage of people being vaccinated vs people being affected
SELECT d.[location], population,
    SUM(d.new_cases) as TOTAL_CASES, 
    SUM(CONVERT(int, v.new_vaccinations)) as TOTAL_VACCINATED,
    (SUM(CONVERT(int, v.new_vaccinations))/population)*100 as POP_VAC_PERCENTAGE

FROM PortfolioProject1..coviddeath AS d
INNER JOIN PortfolioProject1..covidvaccination AS v
    ON d.[location] = v.[location]
    AND d.[date] = v.[date]
    WHERE d.continent IS NOT NULL
GROUP BY d.[location], population
ORDER BY 4 DESC


--3
-- looking at contamination and death rate across continents
SELECT continent,
    SUM(population) AS CONTINENT_POPULATION,
    SUM(new_cases) AS CASES,
    SUM(CAST(new_deaths as int)) AS DEATHS,
    (SUM(new_cases)/SUM(population)) AS CONTAMINATION_RATE,
    (SUM(CAST(new_deaths as int))/SUM(population)) AS DEATH_RATE

FROM PortfolioProject1..coviddeath

WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 1 
