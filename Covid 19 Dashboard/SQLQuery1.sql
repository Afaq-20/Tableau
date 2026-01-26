SELECT
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    (SUM(new_deaths) * 100.0 / NULLIF(SUM(new_cases), 0)) AS DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent IS NOT NULL;

-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT 
    country AS continent,
    SUM(new_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE country IN (
    'Africa',
    'Asia',
    'Europe',
    'North America',
    'South America',
    'Oceania'
)
GROUP BY country
ORDER BY TotalDeathCount DESC;


--3.

Select country, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by country, Population
order by PercentPopulationInfected desc


-- 4.


Select country, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where country like '%states%'
Group by country, Population, date
order by PercentPopulationInfected desc












-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out


-- 1.

Select dea.continent, dea.country, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.country = vac.country
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.country, dea.date, dea.population
order by 1,2,3




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--Where country like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  country


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths$
----Where country like '%states%'
--where country = 'World'
----Group By date
--order by 1,2


-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select country, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where country like '%states%'
Where continent is null 
and country not in ('World', 'European Union', 'International')
Group by country
order by TotalDeathCount desc



-- 4.

Select country, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where country like '%states%'
Group by country, Population
order by PercentPopulationInfected desc



-- 5.

--Select country, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths$
----Where country like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select country, date, population, total_cases, total_deaths
From PortfolioProject..CovidDeaths$
--Where country like '%states%'
where continent is not null 
order by 1,2


-- 6. 


With PopvsVac (Continent, country, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.country, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.country Order by dea.country, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations vac
	On dea.country = vac.country
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


-- 7. 

Select country, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where country like '%states%'
Group by country, Population, date
order by PercentPopulationInfected desc



