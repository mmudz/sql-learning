-- 01. Find the country that start with Y

SELECT name FROM world
  WHERE name LIKE 'Y%';

-- 02. Find the countries that end with y

SELECT name FROM world
  WHERE name LIKE '%Y';

-- 03. Find the countries that contain the letter x

SELECT name FROM world
  WHERE name LIKE '%X%';

-- 04. Find the countries that end with land

SELECT name FROM world
  WHERE name LIKE '%land';

-- 05. Find the countries that start with C and end with ia

  SELECT name FROM world
    WHERE name LIKE 'C%ia';

-- 06. Find the country that has oo in the name
  SELECT name FROM world
    WHERE name LIKE '%oo%';

-- 07. Find the countries that have three or more a in the name

SELECT name FROM world
  WHERE name LIKE '%a%a%a%'

-- 08. Find the countries that have "t" as the second character.
  
SELECT name FROM world
    WHERE name LIKE '_t%';
