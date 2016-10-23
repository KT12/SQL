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

### Find comments with odd binary characters

SELECT sighting_id
FROM bird_sightings
WHERE CHARACTER_LENGTH(comments) <> LENGTH(comments);

CREATE FULLTEXT INDEX comment_index
ON bird_sightings (comments);

SELECT CONCAT(name_first, SPACE(1), name_last) AS Name,
common_name AS Bird,
SUBSTRING(comments, 1, 25) AS Comments
FROM birdwatchers.bird_sightings
JOIN birdwatchers.humans USING(human_id)
JOIN rookery.birds USING(bird_id)
WHERE MATCH(comments) AGAINST('beautiful');

SELECT INSERT(common_name, 6, 0, ' (i.e., Smallest)')
AS 'Smallest Bird'
FROM birds
WHERE common_name LIKE 'Least %';

SELECT common_name AS Original,
INSERT(common_name, LOCATE('Gt.', common_name), 3, 'Great') AS Adjusted
FROM birds
WHERE common_name REGEXP 'Gt.';

UPDATE birds
SET common_name = INSERT(common_name, LOCATE('Gt.', common_name), 3, 'Great')
WHERE common_name REGEXP 'Gt.';

SELECT common_name AS Original,
REPLACE(common_name, 'Gt.', 'Great') AS Replaced
FROM birds
WHERE common_name REGEXP 'Gt.';

UPDATE birds
SET common_name = REPLACED(common_name, 'Gt.', 'Great');

SELECT sorting_id, bird_name, bird_image
FROM bird_images
ORDER BY sorting_id
LIMIT 5;

# If data is read as characters and not numbers
# Sorting of numbers can be incorrect

SELECT sorting_id, bird_name, bird_image
FROM bird_images ORDER BY CAST(sorting_id AS INT)
LIMIT 5;

SELECT sorting_id, bird_name, bird_image
FROM bird_images
WHERE bird_name LIKE '%Plover%'
ORDER BY gender_age;

SELECT bird_name, gender_age, bird_image
FROM bird_images
WHERE bird_name LIKE '%Plover%'
ORDER BY CONVERT(gender_age, CHAR)
LIMIT 5;

SELECT bird_name, gender_age, bird_image
FROM bird_images
WHERE bird_name LIKE '%Plover%'
ORDER BY CONVERT(gender_age USING utf8)
LIMIT 5;


### Exercises
### 1

SELECT CONCAT(name_first, SPACE(1), name_last) as 'Full Name'
FROM humans
LIMIT 4;

SELECT CONCAT(name_first, SPACE(1), name_last) as 'Full Name'
FROM humans
WHERE  CONCAT(name_first, SPACE(1), name_last) IN \
('Lexi Hollar', 'Michael Zabaloui', 'Rusty Johnson')
LIMIT 4;

SELECT CONCAT(name_first, SPACE(1), name_last) as 'Full Name'
FROM humans
WHERE CONCAT(name_first, SPACE(1), name_last) IN \
('Lexi Hollar', 'Michael Zabaloui', 'Rusty Johnson')
ORDER BY 'Full Name'
LIMIT 4;

### 2

SELECT CONCAT(birds.common_name, ' (', birds.scientific_name, RPAD(')', 4, '.'), \
    RPAD(families.scientific_name, 15, '.'), orders.scientific_name) AS 'Bird Species'
FROM birds
JOIN bird_families AS families USING(family_id)
JOIN bird_orders AS orders USING(order_id)
LIMIT 10;

### 3

SELECT common_name FROM birds
WHERE common_name IN('Shrike');

SELECT common_name as Original,
REPLACE(common_name, '-', ' ') as Replaced
FROM birds
WHERE common_name IN('Shrike');

### 4

SELECT common_name
IF(LOCATE('-', common_name, LOCATE('Shrike', common_name)), REPLACE(common_name, '-', ' '), common_name)
FROM birds;
### uncertain

### 6

UPDATE humans
SET name_first = CONCAT(UCASE(SUBSTRING(name_first, 1, 1)), LCASE(SUBSTRING(name_first, 2))),
    name_last =  CONCAT(UCASE(SUBSTRING(name_last, 1, 1)), LCASE(SUBSTRING(name_last, 2)));
