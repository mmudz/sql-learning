-- 02. Show the name for the countries that have a population of at least 200 million.

SELECT name FROM world
WHERE population >= 200000000;

-- 03. Give the name and the per capita GDP for those countries with a population of at least 200 million.

SELECT 
name, 
gdp / population as per_capita_gdp
FROM world
WHERE population >= 200000000;

-- 04. Show the name and population in millions for the countries of the continent 'South America'. Divide the population by 1000000 to get population in millions.

SELECT
name, 
population / 1000000 AS pop_in_mil
FROM world
WHERE continent = 'South America'

--05. Show the name and population for France, Germany, Italy

SELECT
name,
population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');

-- 06. Show the countries which have a name that includes the word 'United'

SELECT name
FROM world
WHERE name LIKE '%United%'


