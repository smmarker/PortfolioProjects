SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations$
--ORDER BY 3,4

--Select data that we are going to be using

SELECT date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2

--Looking at total cases vs total deaths
--Shows percentage of death in total cases
SELECT date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--Total cases vs Population
--Shows percentage of population that contracted covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionRate
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states%'
ORDER BY InfectionRate DESC, location

--Countries with Highest Infection Rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases)/population)*100 AS InfectionRate
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY InfectionRate DESC

--Countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--BREAK DOWN BY CONTINENT
--continents with highest death count per population

SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


--Global numbers

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

--toal population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--AND vac.new_vaccinations is not null
ORDER BY 2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--AND vac.new_vaccinations is not null
ORDER BY 2,3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--AND vac.new_vaccinations is not null-just checking data
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS RollingPeopleVaccinatedPercentage
FROM PopvsVac
--WHERE (RollingPeopleVaccinated/population)*100 IS NOT NULL --DATA CHECK



--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--AND vac.new_vaccinations is not null-just checking data
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100 AS RollingPeopleVaccinatedPercentage
FROM #PercentPopulationVaccinated



--Creating view to store data for later visualizations

Create View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--AND vac.new_vaccinations is not null-just checking data
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated

--new view

Create View PercentPeopleVaccinatedTotal AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) 
OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
AND vac.new_vaccinations is not null

--view of death rates

Create View DeathPercentage AS
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
--ORDER BY 1,2

Create View DeathPercentageLocation3 AS
SELECT location, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
--ORDER BY 1,2
