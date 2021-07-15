--SELECT *
--FROM PortfolioProject1..coviddeath
--ORDER by 3,4

--SELECT *
--FROM PortfolioProject1..covidvaccination
--ORDER by 3,4

-- Select data that I am going to us

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject1..coviddeath
ORDER BY 1,2 -- Makes it ordered according to 1st and 2nd column consecutively


-- Looking at total cases VS total deaths
SELECT Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as covid_death_percentage
FROM PortfolioProject1..coviddeath
ORDER BY 1,2

-- Looking at total cases VS total deaths with a change in where clause to meet approximation
SELECT Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as covid_death_percentage
FROM PortfolioProject1..coviddeath
where [location] LIKE '%desh'
ORDER BY 1,2

-- Looking at total cases VS Pupulation with a change in where clause to meet approximation
SELECT [date], population, total_cases, (total_cases/population)*100 as PERCENT_Being_Affected
FROM PortfolioProject1..coviddeath
order by PERCENT_Being_Affected

-- Looking at total cases VS Pupulation with a change in where clause to meet approximation
-- Shows the stat for Bangladesh here.
-- Covid affection is still under 1% of the total population
SELECT [date], population, total_cases, (total_cases/population)*100 as PERCENT_Being_Affected
FROM PortfolioProject1..coviddeath
where location like '%desh'
order by PERCENT_Being_Affected DESC

--Looking at highest Infection rate considering the population
-- From the result, we can see, the highest infection rate is in Andorra, A country in Europe
-- Lowest Infection Rate is in Tanzania, A country in Africa
SELECT Location, Population, MAX(total_cases) as HighestInfectionRate, MAX((total_cases/population)*100) as Highest_Percentage_Affection
FROM PortfolioProject1..coviddeath
GROUP BY Location,Population
ORDER BY 4 DESC


--looking at countries with maximum death counts per country
--USA has the highest Number. Vanuatu has the lowest
SELECT location, MAX(cast(total_deaths as int)) as death -- total death is a char type data, casted into Integer
FROM PortfolioProject1..coviddeath
WHERE continent is not NULL
GROUP BY location
ORDER BY [death] DESC


--looking at countries with maximum death counts per continent
--North America has the highest Number. Ocenia   has the lowest
SELECT continent, MAX(cast(total_deaths as int)) as death -- total death is a char type data, casted into Integer
FROM PortfolioProject1..coviddeath
WHERE continent is not NULL
GROUP BY continent
ORDER BY [death] DESC

--looking at countries with death Rates
SELECT location, MAX((CAST(total_deaths as int)/population)*100) as death_rate
FROM PortfolioProject1..coviddeath
WHERE continent IS NOT NULL
GROUP by location
ORDER BY 2 DESC

--looking at countries with death Rates
-- Though the deases affected mostly in north america, but the death rate is greater in south america.
SELECT continent, MAX((CAST(total_deaths as int)/population)*100) as death_rate
FROM PortfolioProject1..coviddeath
WHERE continent IS NOT NULL
GROUP by continent
ORDER BY 2 DESC

--Looking at death rate vs affection rate
-- Interesting part here, is that the rate of people being affected and death rate....
--aren't the same!
SELECT location, MAX((total_cases/population)*100) as Highest_Percentage_Affection, MAX((CAST(total_deaths as int)/population)*100) as death_rate
FROM PortfolioProject1..coviddeath
WHERE continent IS NOT NULL
GROUP by location
ORDER BY 3 DESC

-- Let's look at the same thing with continet
-- Highest rate of affection is in Europe and death rate is in South America
SELECT continent, MAX((total_cases/population)*100) as Highest_Percentage_Affection, MAX((CAST(total_deaths as int)/population)*100) as death_rate
FROM PortfolioProject1..coviddeath
WHERE continent IS NOT NULL
GROUP by continent
ORDER BY 3 DESC

--Global Numbers
--Death Percenatge per day

SELECT date, SUM(new_cases), sum(cast(new_deaths as int)) as totaldeath, (sum(cast(new_deaths as int))/SUM(new_cases))*100 as dailyDeathRate
FROM PortfolioProject1..coviddeath
WHERE continent is not NULL
GROUP BY [date]
ORDER by 1, 2


--So far total death percentage worldwide
SELECT SUM(new_cases) as total_case, SUM(CAST(new_deaths as int)) as total_death, (SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
FROM PortfolioProject1..coviddeath