### Chapter 12: Aggregate and Numeric Functions

SELECT COUNT(*) FROM birds;

UPDATE birds
SET common_name = NULL
WHERE common_name = '';

SELECT COUNT(common_name)
FROM birds;

SELECT COUNT(*)
FROM birds
WHERE common_name IS NULL;

SELECT COUNT(*)
FROM birds
WHERE common_name IS NOT NULL;

SELECT COUNT(*)
FROM birds
GROUP BY family_id;

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds JOIN bird_families USING(family_id)
GROUP BY birds.family_id;

### Next query includes birds which do not have matching values in bird_families

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds LEFT JOIN bird_families USING(family_id)
GROUP BY birds.family_id;

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds LEFT JOIN bird_families USING(family_id)
GROUP BY bird_families.scientific_name;

# WITH ROLLUP gives TOTAL row last, with NULL label

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds LEFT JOIN bird_families USING(family_id)
GROUP BY bird_families.scientific_name WITH ROLLUP;

# Include ROLLUP with proper label, count by orders of birds

SELECT IFNULL(bird_orders.scientific_name, '') AS 'Bird Order',
IFNULL (bird_families.scientific_name, 'Total: ') AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds
JOIN bird_families USING(family_id)
JOIN bird_orders USING(order_id)
GROUP BY bird_orders.scientific_name, bird_families.scientific_name
WITH ROLLUP;

SELECT common_name AS 'Bird',
MAX(SUBSTRING(location_gps, 1, 11)) AS 'Furthest North',
MIN(SUBSTRING(location_gps, 1, 11)) AS 'Furthest South'
FROM birdwatchers.bird_sightings
JOIN rookery.birds USING(bird_id)
WHERE location_gps IS NOT NULL
GROUP BY bird_id;

# Concatenating a Group

SELECT bird_orders.scientific_name AS 'Bird Order',
GROUP_CONCAT(bird_families.scientific_name)
AS 'Bird Families in Order'
FROM rookery.bird_Families
JOIN rookery.bird_orders USING(order_id)
WHERE bird_orders.scientific_name = 'Charadriiformes'
GROUP BY order_id \G

# Numeric Functions

SELECT IFNULL(COLUMN_GET(choices, answer AS CHAR), 'total')
AS 'Birding Site', COUNT(*) AS 'Votes'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer WITH ROLLUP;

SET @fav_site_total =
(SELECT COUNT(*)
    FROM survey_answers
    JOIN survey_questions USING(question_id)
    WHERE survey_id = 1
    AND question_id = 1);

SELECT @fav_site_total;

### EXERCISES
### 1

SELECT COUNT(common_name)
FROM birds
WHERE common_name LIKE '%Least%';

SELECT COUNT(common_name)
FROM birds
WHERE common_name LIKE '%Great%';

### 2

SELECT
   (SELECT COUNT(common_name)
    FROM birds
    WHERE common_name LIKE '%Least%') AS Least,
   (SELECT COUNT(common_name)
    FROM birds
    WHERE common_name LIKE '%Great%') AS Great;

### 3

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species',
COUNT(*)/ (SELECT COUNT(common_name) FROM birds) AS 'Percent of Species'
FROM birds LEFT JOIN bird_families USING(family_id)
GROUP BY birds.family_id
WITH ROLLUP;

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species',
CONCAT(ROUND(100 * COUNT(*)/ (SELECT COUNT(common_name) FROM birds), 1), '%') AS 'Percent of Species'
FROM birds LEFT JOIN bird_families USING(family_id)
GROUP BY birds.family_id;

### 5

SELECT human_id, 
PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01')) AS 'Delta Month'
FROM humans
WHERE SIGN(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) > 0;

### 6

SELECT human_id, 
IF(SIGN(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) > 0,
    PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01')),
    CONCAT(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01')), ' - expired'))
    AS 'Delta Month'
FROM humans;

### 7

SELECT
    (SELECT AVG(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) 
    FROM humans
    WHERE SIGN(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) > 0) AS 'Average Time Left',

    (SELECT AVG(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) 
    FROM humans
    WHERE SIGN(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) < 0) AS 'Average Expired Time',

    (SELECT MAX(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) 
    FROM humans
    WHERE SIGN(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) < 0) AS 'Max Expired Time',

    (SELECT MIN(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) 
    FROM humans
    WHERE SIGN(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM membership_expiration), EXTRACT(YEAR_MONTH FROM '2014-01-01'))) < 0) AS 'Min Expired Time';
