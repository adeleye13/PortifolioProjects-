--SELECT*
--FROM [dbo].[CovidDeaths$]
--WHERE continent is not NULL
--ORDER BY 3, 4

--SELECT*
--FROM [dbo].[Covidvaccination$]
--ORDER BY 3, 4

--SELECT Location, Date, Total_Cases, New_Cases, total_deaths, population
--FROM [dbo].[CovidDeaths$]
 --WHERE continent is not NULL
--ORDER BY 1, 2


                      -- Total Cases VS Total Death

--SELECT Location, Date, Total_Cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--FROM [dbo].[CovidDeaths$]
--WHERE location like '%states%'
--AND continent is not NULL
--ORDER BY 1, 2


                         --Total Cases VS Population 
						 --Percentage of People got Covid 

--SELECT Location, Date, Population, Total_Cases, (total_cases/Population)*100 as PercentPopulationInfected
--FROM [dbo].[CovidDeaths$]
--WHERE location like '%states%'
--ORDER BY 1, 2

                              --Countries with Highest Infection Rate compared to Population

--SELECT Location, Population, Max(Total_Cases) as HigestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
--FROM [dbo].[CovidDeaths$]
----WHERE location like '%states%'
--GROUP BY Location, Population
--ORDER BY PercentPopulationInfected DESC


                           --Countries with Higest deathCount per Population

--SELECT Location,  Max (cast(Total_deaths as int))  as TotaldeathCount
--FROM [dbo].[CovidDeaths$]
----WHERE location like '%states%'
--WHERE continent is not NULL
--GROUP BY Location
--ORDER BY TotaldeathCount DESC





                                 --Lets Break things down by Continents


--SELECT continent,  Max (cast(Total_deaths as int))  as TotaldeathCount
--FROM [dbo].[CovidDeaths$]
----WHERE location like '%states%'
--WHERE continent is not NULL
--GROUP BY continent
--ORDER BY TotaldeathCount DESC





                             -- Showing continents with the highest death per Population
--SELECT continent,  Max (cast(Total_deaths as int))  as TotaldeathCount
--FROM [dbo].[CovidDeaths$]
----WHERE location like '%states%'
--WHERE continent is not NULL
--GROUP BY continent
--ORDER BY TotaldeathCount DESC


                                    --GLOBAL NUMBERS

--SELECT  SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths as int)) as Total_Death, SUM(CAST(new_deaths as int)) / SUM(New_cases)*100 as DeathPercentage
--FROM [dbo].[CovidDeaths$]
----WHERE location like '%states%'
--WHERE continent is not NULL
----Group by  Date
--ORDER BY 1, 2

                           
                                          


Select*
FROM [dbo].[Covidvaccination$]

Select*
FROM [dbo].[CovidDeaths$]

SELECT*
FROM [dbo].[Covidvaccination$]
JOIN [dbo].[CovidDeaths$]
ON [dbo].[Covidvaccination$].Location = [dbo].[CovidDeaths$].Location
AND [dbo].[Covidvaccination$].date = [dbo].[CovidDeaths$].date

                                   --Total POpulation Vs Vacination 
								   
SELECT dea.continent, dea.location, dea.date, dea.Population, Vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location
Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM [dbo].[CovidDeaths$] dea
JOIN [dbo].[Covidvaccination$]  Vac
    ON dea.Location = Vac.Location
    AND dea.date = vac.date  
	Where dea.continent is not null
	ORDER BY  2, 3


	-- USE CTE

	With PopVSVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.Population, Vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location
Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM [dbo].[CovidDeaths$] dea
JOIN [dbo].[Covidvaccination$]  Vac
    ON dea.Location = Vac.Location
    AND dea.date = vac.date  
	Where dea.continent is not null
	--ORDER BY  2, 3
	)

SELECT *, ( RollingPeopleVaccinated/Population)*100
FROM PopVSVac

                   --TEMP TABLE
DROP Table if exists #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.Population, Vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location
Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM [dbo].[CovidDeaths$] dea
JOIN [dbo].[Covidvaccination$]  Vac
    ON dea.Location = Vac.Location
    AND dea.date = vac.date  
	--Where dea.continent is not null
	--ORDER BY  2, 3

	
SELECT *, ( RollingPeopleVaccinated/Population)*100
FROM   #PercentagePopulationVaccinated


create View PercentagePopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.Population, Vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location
Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM [dbo].[CovidDeaths$] dea
JOIN [dbo].[Covidvaccination$]  Vac
    ON dea.Location = Vac.Location
    AND dea.date = vac.date  
	Where dea.continent is not null
	--ORDER BY  2, 3

	Select* 
	From PercentagePopulationVaccinated
