-- 02. Show who won the 1962 prize for literature.

SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'literature'

-- 03. Show the year and subject that won 'Albert Einstein' his prize.

SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein'

-- 04. Give the name of the 'peace' winners since the year 2000, including 2000.

SELECT winner
FROM nobel
WHERE subject = 'peace' 
AND yr >= 2000

-- 05. Show all details (yr, subject, winner) of the literature prize winners for 1980 to 1989 inclusive.

SELECT 
yr,
subject,
winner
FROM nobel
WHERE yr BETWEEN 1980 AND 1989
AND subject = 'literature'


