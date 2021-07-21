--1
--looking at people being affected and death percentage, as per people being affected
SELECT SUM(population) AS World_Population,SUM(new_cases) AS Total_affected, 
SUM(CONVERT(int, new_deaths))   AS Total_Death, 
(SUM(CONVERT(int, new_deaths))/SUM(new_cases))*100 AS Death_Percentage

FROM PortfolioProject1..coviddeath
WHERE continent is not NULL
