--1
--total percentage of person being affected worldwide
SELECT SUM(population) AS World_Population,SUM(new_cases) AS Total_affected, SUM(CONVERT(int, new_deaths)) AS Total_Death 

FROM PortfolioProject1..coviddeath
