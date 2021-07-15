--COVID Vaccination exploration
SELECT *
FROM PortfolioProject1..covidvaccination

--Join The Both Table together
SELECT *
FROM PortfolioProject1..coviddeath as d
JOIN PortfolioProject1..covidvaccination as c
    on  d.[location] = c.[location]
    and d.date = c.date

--Looking at population vs Vaccination
SELECT d.continent, d.[location],d.date, d.population,c.new_vaccinations,
SUM(CONVERT(int, c.new_vaccinations)) over (PARTITION BY d.location) as ToTaLVaccination_By_Country
FROM PortfolioProject1..coviddeath as d
JOIN PortfolioProject1..covidvaccination as c
    on  d.[location] = c.[location]
    and d.date = c.date
    WHERE d.continent is not NULL
    AND c.new_vaccinations is not NULL
ORDER BY  2,3

----Looking at population vs Vaccination In Bangladesh and removing the null values
SELECT d.continent, d.[location],d.date, d.population,c.new_vaccinations,
SUM(CONVERT(int, c.new_vaccinations)) over (PARTITION BY d.location) as ToTaLVaccination_By_Country
FROM PortfolioProject1..coviddeath as d
JOIN PortfolioProject1..covidvaccination as c
    on  d.[location] = c.[location]
    and d.date = c.date
    WHERE d.continent is not NULL
    AND c.new_vaccinations is not NULL
    AND d.[location] = 'Bangladesh'
ORDER BY  1,2 


--The result above shows us the total at once. We want to have the total considering day by day push
SELECT d.continent, d.[location], d.[date], d.population,c.new_vaccinations,
SUM(CONVERT(int, c.new_vaccinations)) OVER (PARTITION by d.location order by d.location, d.date) as dailypush
FROM PortfolioProject1..coviddeath as d
JOIN PortfolioProject1..covidvaccination as c
    on  d.[location] = c.[location]
    and d.date = c.date
    WHERE d.continent is not NULL


--Day by Day Vaccine Push Record for Bangladesh
--The result above shows us the total at once. We want to have the total considering day by day push
SELECT d.continent, d.[location], d.[date], d.population,c.new_vaccinations,
SUM(CONVERT(int, c.new_vaccinations)) OVER (PARTITION by d.location order by d.date, d.location) as dailypush
FROM PortfolioProject1..coviddeath as d
JOIN PortfolioProject1..covidvaccination as c
    on  d.[location] = c.[location]
    and d.date = c.date
    WHERE d.continent is not NULL
    AND d.[location] = 'Bangladesh'

--Day to day push and looking at the percentage covered considering total population

--we need to use CTE here

--CTE
WITH popvsvac (continent,location,date,population,new_vaccinations, dailypush)
AS(
    SELECT d.continent, d.[location], d.[date], d.population,c.new_vaccinations,
    SUM(CONVERT(int, c.new_vaccinations)) OVER (PARTITION by d.location order by d.location, d.date) as dailypush
    FROM PortfolioProject1..coviddeath as d
    JOIN PortfolioProject1..covidvaccination as c
        on  d.[location] = c.[location]
        and d.date = c.date
        WHERE d.continent is not NULL
)
--Using the CTE as a table here and simply writing down the query.
SELECT *, (dailypush/population)*100
FROM popvsvac


-- Same query for Bangladesh
-- USING CTE(common table expression)

WITH banPopvsvac (continent,location, date, population, new_vaccinations, BangdailyPush)
AS
(
    SELECT d.continent, d.[location], d.[date], d.population, c.new_vaccinations,
    SUM(CAST(new_vaccinations as int)) over (PARTITION BY d.location ORDER BY d.location, d.date) as BangdailyPush
    FROM PortfolioProject1..coviddeath as d
    JOIN PortfolioProject1..covidvaccination as c
        ON c.[date] = d.[date]
        AND c.[location] = d.[location]
        AND c.[location] = 'Bangladesh'
)
SELECT *, (BangdailyPush/population)*100
FROM banPopvsvac


--Same task can be done with TEMP TABLE

--TEMP TABLE


DROP TABLE if EXISTS #POPVSVACTEMPTABLE
CREATE TABLE #POPVSVACTEMPTABLE
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccination NUMERIC,
    dailypush NUMERIC
)
INSERT INTO #POPVSVACTEMPTABLE
    SELECT d.continent, d.[location], d.[date], d.population,c.new_vaccinations,
    SUM(CONVERT(int, c.new_vaccinations)) OVER (PARTITION by d.location order by d.location, d.date) as dailypush
    FROM PortfolioProject1..coviddeath as d
    JOIN PortfolioProject1..covidvaccination as c
        on  d.[location] = c.[location]
        and d.date = c.date
        WHERE d.continent is not NULL

SELECT *, (dailypush/population)*100 as RollOutPercentage
FROM #POPVSVACTEMPTABLE
WHERE [location] = 'Bangladesh'
ORDER BY date