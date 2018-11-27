SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON  p1.country_code = p2.country_code;

/*Self Join*/
SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON  p1.country_code = p2.country_code
    AND p1.year = p2.year - 5;

/*Self Join*/

SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015,
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
FROM populations AS p1
INNER JOIN populations AS p2
ON  p1.country_code = p2.country_code
    AND p1.year = p2.year - 5;

SELECT name, continent, code, surface_area,
        -- first case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- second case
        WHEN surface_area > 350000 THEN 'medium'
        -- else clause + end
        ELSE 'small' 
        END AS geosize_group
FROM countries; 

SELECT name, continent, code, surface_area,
    CASE WHEN surface_area > 2000000 THEN 'large'
       WHEN surface_area > 350000 THEN 'medium'
       ELSE 'small' 
       END AS geosize_group
INTO countries_plus
FROM countries;


SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' 
        END AS popsize_group
FROM populations
WHERE year = 2015;

SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' 
        END AS popsize_group
INTO pop_plus
FROM populations
WHERE year = 2015;

/*Starting with V*/

SELECT countries.name, code, languages.name AS language
FROM languages
FULL JOIN countries
USING (code)
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

/*Use LIKE to choose the Melanesia and Micronesia regions (Hint: 'M%esia'). - PostgreSQL
SELECT c1.name AS country, region, l.name AS language,
       frac_unit, basic_unit
FROM countries AS c1
FULL JOIN languages AS l
USING (code)
FULL JOIN currencies AS c2
USING (code)
WHERE region LIKE 'M%esia'; */

/*Cross joins - cross joins do not use ON or Using */

SELECT c.name AS city, l.name AS language
FROM cities AS c        
CROSS JOIN languages AS l
WHERE c.name LIKE 'Hyder%';

/*Union all */
-- pick specified columns from 2010 table
SELECT *
-- 2010 table will be on top
FROM economies2010
-- which set theory clause?
UNION ALL
-- pick specified columns from 2015 table
SELECT *
-- 2015 table on the bottom
FROM economies2015
-- order accordingly
ORDER BY code, year;

/*Determine all (non-duplicated) country codes in either the cities or the currencies table.*/
SELECT country_code 
FROM cities
UNION
SELECT code AS country_code
FROM currencies
ORDER BY country_code;

SELECT code, year
FROM economies
UNION ALL
SELECT country_code AS code, year
FROM populations
ORDER BY code, year;

/*Intersect and EXCEPT*/
