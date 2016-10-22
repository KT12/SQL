### Chapter 10 String Functions

SELECT CONCAT(formal_title, '. ', name_first, SPACE(1), name_last) AS Birder,
CONCAT(common_name, ' - ', birds.scientific_name) AS Bird,
    time_seen AS 'When Spotted'
    FROM birdwatchers.bird_sightings
    JOIN birdwatchers.humans USING(human_id)
    JOIN rookery.birds USING(bird_id)
    GROUP BY human_id DESC
    LIMIT 4;

SELECT LCASE(common_name) AS Species,
UCASE(bird_families.scientific_name) AS Family
FROM birds
JOIN bird_families USING(family_id)
WHERE common_name LIKE '%Wren%'
ORDER BY Species
LIMIT 5;

SELECT LCASE(common_name) AS Species,
UCASE(bird_families.scientific_name) AS Family
FROM birds
JOIN bird_families USING(family_id)
WHERE common_name LIKE '%Duck%'
ORDER BY Species
LIMIT 5;

### Aliases do not need to be enlosed in quotes if they do not include spaces
SELECT QUOTE(common_name) as Common_name
FROM birds
WHERE common_name LIKE '%Prince%'
ORDER BY common_name;

SELECT QUOTE(common_name) as 'Common name'
FROM birds
WHERE common_name LIKE '%Red%'
ORDER BY common_name DESC
LIMIT 24;

### note how any single quotes in the common name are escaped
### this is to avoid problems if the value is passed to another program

SELECT QUOTE(common_name) as 'Common name'
FROM birds
WHERE common_name LIKE '%Duck%'
ORDER BY common_name DESC;

UPDATE humans
SET name_first = TRIM(name_first),
name_last = TRIM(name_last);

SELECT CONCAT(RPAD(common_name, 20, '.'),
    RPAD(Families.scientific_name, 15, '.'),
    Orders.scientific_name) AS Birds
FROM birds
JOIN bird_families AS Families USING(family_id)
JOIN bird_orders AS Orders
WHERE common_name <> ''
AND Orders.scientific_name = 'Ciconiiformes'
ORDER BY common_name LIMIT 3;

### Searching Strings and Using Lengths

SELECT common_name AS 'Avocet'
FROM birds
JOIN bird_families USING(family_id)
WHERE bird_families.scientific_name = 'Recurvirostridae'
AND birds.common_name LIKE '%Avocet%';

# Now return results without 'Avocet'

SELECT
SUBSTRING(common_name, 1, LOCATE(' Avocet', common_name)) AS 'Avocet'
FROM birds
JOIN bird_families USING(family_id)
WHERE bird_families.scientific_name = 'Recurvirostridae'
AND birds.common_name LIKE '%Avocet%';

SELECT human_id,
CONCAT(name_first, SPACE(1), name_last) AS Name,
join_date
FROM humans
WHERE country_id = 'ru'
ORDER BY join_date;

SELECT FIND_IN_SET('Anahit Vanetsyan', Names) AS Position
FROM 
(SELECT GROUP_CONCAT(Name ORDER BY join_date) AS Names
    FROM 
    (SELECT CONCAT(name_first, SPACE(1), name_last) AS Name,
        join_date
        FROM humans
        WHERE country_id = 'ru')
    AS derived_1)
AS derived_2;

SELECT IF((CHAR_LENGTH(comments) > 100), 'long', 'short')
FROM bird_sightings
WHERE sighting_id = 2;
