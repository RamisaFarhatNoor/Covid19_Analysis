Use covid;



SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    new_cases,
    population
FROM
    covid_deaths;

-- How many people are dying out of total cases?
-- death rate in the US
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases)*100, 3) AS death_percentage
FROM
    covid_deaths
WHERE location like '%states%';


-- finding out when the amount of cases hit the peak in USA
--  1. The latest peak date
 SELECT 
	location
    , max(total_cases) as number_of_cases
    , min(date) as peak_date
FROM 
	covid_deaths
WHERE location like 'United States'
GROUP BY location;


-- The time frame of the spike in numbers in the US
SELECT 
    location, total_cases AS number_of_cases, date AS peak_date
FROM
    covid_deaths
WHERE
    (location , total_cases) IN (SELECT 
            location, MAX(total_cases) AS number_of_cases
        FROM
            covid_deaths
        WHERE
            location LIKE 'United States'
        GROUP BY location);
        
	
-- Number of total cases vs population 

SELECT 
    location,
    date,
    ROUND((total_cases / population) * 100, 2) AS infection_rate
FROM
    covid_deaths
    ;
   set sql_mode = '';  
 -- Highest Infection rate per population in every country

 SELECT
    location,
    population,
    MAX(total_cases) AS highest_infection_count,
    CASE
        WHEN population = 0 THEN 0
        ELSE MAX(total_cases / population) * 100
    END AS highest_infection_rate
FROM
    covid_deaths
WHERE continent != ''    -- ignoring empty values
GROUP BY location
ORDER BY highest_infection_rate DESC , population;

 -- Highest Death rate per population in every country
SELECT 
    location,
    population,
    MAX(total_deaths) AS highest_death_count,
    CASE
        WHEN population = 0 THEN 0
        ELSE (MAX(total_deaths / population) * 100)
    END AS highest_death_rate
FROM
    covid_deaths
WHERE continent != ''	-- ignoring empty values
GROUP BY location
ORDER BY highest_death_rate DESC , population;

-- Total death counts for every country

SELECT 
    continent, location, MAX(total_deaths) AS total_deaths
FROM
    covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY continent, total_deaths desc;


-- Total death counts for every continent

SELECT 
    continent, MAX(total_deaths) AS total_deaths
FROM
    covid_deaths
GROUP BY continent
ORDER BY total_deaths desc;

-- global death percentage

SELECT
	date,
    year(date) as year,
    month(date) as month,
    SUM(new_cases) AS number_of_cases,
    SUM(new_deaths) AS number_of_deaths,
    ROUND(SUM(new_deaths) / SUM(new_cases) * 100, 3) AS global_deathpercentage
FROM
    covid_deaths
WHERE continent Not Like ''
GROUP BY year, month 
ORDER BY 1,2;

-- overall global death percentage in last 3 years


SELECT 
    YEAR(date) AS years,
    SUM(new_cases) AS number_of_cases,
    SUM(new_deaths) AS number_of_deaths,
    ROUND(SUM(new_deaths) / SUM(new_cases) * 100,
            3) AS global_deathpercentage_yearly
FROM
    covid_deaths
WHERE
    continent NOT LIKE ''
GROUP BY years
ORDER BY years;

-- global death percentage of 3 years

SELECT 
    SUM(new_cases) AS number_of_cases,
    SUM(new_deaths) AS number_of_deaths,
    ROUND(SUM(new_deaths) / SUM(new_cases) * 100,
            3) AS global_deathpercentage
FROM
    covid_deaths
WHERE continent Not Like '';


-- overall death percentage in the last 3 years in every continent

 SELECT
	continent,
    YEAR(date) AS years,
    SUM(new_cases) AS number_of_cases,
    SUM(new_deaths) AS number_of_deaths,
    ROUND(SUM(new_deaths) / SUM(new_cases) * 100,
            3) AS global_deathpercentage_yearly
FROM
    covid_deaths
WHERE
    continent NOT LIKE ''
GROUP BY continent, years
ORDER BY years;
 
-- how many covid patient was hospitalized

SELECT 
    YEAR(date) AS years,
    location,
    MAX(total_cases) AS total_cases,
    hosp_patients,
    CASE
        WHEN total_cases = 0 THEN 0
        ELSE ROUND(hosp_patients / total_cases * 100, 2)
    END AS hospitalization_rate_percentage
FROM
    covid_deaths
WHERE
    continent NOT LIKE ''
GROUP BY years , location;
-- Note:: due to lack of records it's not possible to decode this result




-- Checking if there's a specific season every year when the number of patitents hit the peak in every country

SELECT 
    location,
    YEAR(date) AS years,
    MONTH(date) AS months,
    sum(new_cases) as monthly_new_cases
FROM
    covid_deaths
WHERE continent not like ''
GROUP BY years , months , location
ORDER BY location , years , months
;
    
    


        

