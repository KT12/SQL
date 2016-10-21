### Chapter 9 Joining and Subquerying Data

SELECT 'Pelecanidae' AS 'Family',
    COUNT(*) AS 'Species'
    FROM birds, bird_families AS families
    WHERE birds.family_id = families.family_id
    AND families.scientific_name = 'Pelecanidae'
UNION
    SELECT 'Ardeidae',
    COUNT(*)
    FROM birds, bird_families AS families
    WHERE birds.family_id = families.family_id
    AND families.scientific_name = 'Ardeidae';

SELECT families.scientific_name AS 'Family',
    COUNT(*) AS 'Species'
    FROM birds, bird_families AS families, bird_orders AS orders
    WHERE birds.family_id = families.family_id
    AND families.order_id = orders.order_id
    AND orders.scientific_name = 'Pelecaniformes'
    GROUP BY families.family_id
UNION
    SELECT families.scientific_name, COUNT(*)
    FROM birds, bird_families AS families, bird_orders AS orders
    WHERE birds.family_id = families.family_id
    AND families.order_id = orders.order_id
    AND orders.scientific_name = 'Suliformes'
    GROUP BY families.family_id;

SELECT * FROM
(
SELECT families.scientific_name AS 'Family',
    COUNT(*) AS 'Species'
    FROM birds, bird_families AS families, bird_orders AS orders
    WHERE birds.family_id = families.family_id
    AND families.order_id = orders.order_id
    AND orders.scientific_name = 'Pelecaniformes'
    GROUP BY families.family_id
UNION
    SELECT families.scientific_name, COUNT(*)
    FROM birds, bird_families AS families, bird_orders AS orders
    WHERE birds.family_id = families.family_id
    AND families.order_id = orders.order_id
    AND orders.scientific_name = 'Suliformes'
    GROUP BY families.family_id) as derived_1
ORDER BY Family;

SELECT book_id, title, status_name
FROM books JOIN status_names
WHERE status = status_id;

SELECT book_id, title, status_name
FROM books
JOIN status_names ON (status = status_id);

SELECT common_name, conservation_state
FROM birds
JOIN conservation_status
ON(birds.conservation_status_id = conservation_status.conservation_status_id)
WHERE conservation_category = 'Threatened'
AND common_name LIKE '%Goose%';

SELECT common_name, conservation_state
FROM birds
JOIN conservation_status
ON(birds.conservation_status_id = conservation_status.conservation_status_id)
WHERE conservation_category = 'Threatened';

SELECT common_name AS 'Bird',
bird_families.scientific_name AS 'Family', conservation_state AS 'Status'
FROM birds
JOIN conservation_status USING(conservation_status_id)
JOIN bird_families USING(family_id)
WHERE conservation_category = 'Threatened'
AND common_name REGEXP 'Goose|Duck'
ORDER BY Status, Bird;

SELECT common_name AS 'Bird from Anatidae',
conservation_state AS 'Conservation Status'
FROM birds
JOIN conservation_status AS states USING(conservation_status_id)
JOIN bird_families USING(family_id)
WHERE conservation_category = 'Threatened'
AND bird_families.scientific_name = 'Anatidae'
ORDER BY states.conservation_status_id DESC, common_name ASC;

SELECT CONCAT(name_first, ' ', name_last) AS Birder,
common_name AS Bird, location_gps AS 'Location of Sighting'
FROM birdwatchers.humans
JOIN birdwatchers.bird_sightings USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.bird_families USING(family_id)
WHERE country_id = 'ru'
AND bird_families.scientific_name = 'Scolopacidae'
ORDER BY Birder;

SELECT common_name as 'Bird',
conservation_state AS 'Status'
FROM birds
LEFT JOIN conservation_status USING(conservation_status_id)
WHERE common_name LIKE '%Egret%'
ORDER BY Status, Bird;

SELECT common_name, conservation_state
FROM birds
LEFT JOIN conservation_status USING(conservation_status_id)
JOIN bird_families USING(family_id)
WHERE bird_families.scientific_name = 'Ardeidae';

### SUBQUERIES

SELECT scientific_name AS Family
FROM bird_families
WHERE order_id = 
    (SELECT order_id
    FROM bird_orders
    WHERE scientific_name = 'Galliformes');


SELECT * FROM 
    (SELECT common_name AS 'Bird',
    families.scientific_name AS 'Family'
    FROM birds
    JOIN bird_families AS families USING(family_id)
    JOIN bird_orders AS orders USING(order_id)
    WHERE common_name <> ''
    AND families.scientific_name IN
        (SELECT DISTINCT families.scientific_name AS 'Family'
        FROM bird_families AS families
        JOIN bird_orders AS orders USING(order_id)
        WHERE orders.scientific_name = 'Galliformes'
        ORDER BY Family)
    ORDER BY RAND()) AS derived_1
GROUP BY (Family);

SELECT family AS 'Bird Family',
COUNT(*) AS 'Number of Birds'
FROM
    (SELECT families.scientific_name AS family
    FROM birds
    JOIN bird_families AS families USING(family_id)
    WHERE families.scientific_name IN('Pelecanidae', 'Ardeidae')) AS derived_1
GROUP BY family;

SELECT family AS 'Bird Family',
COUNT(*) AS 'Number of Birds'
FROM
    (SELECT families.scientific_name AS family
    FROM birds
    JOIN bird_families AS families USING(family_id)) AS derived_1
GROUP BY family;


### Exercises

### 1

SELECT CONCAT(name_first, ' ', name_last) AS Birder,
COUNT(*) AS Points
FROM birdwatchers.humans
JOIN birdwatchers.bird_sightings USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.bird_families USING(family_id)
WHERE rookery.bird_families.scientific_name = 'Galliformes'
ORDER BY Birder;

### 2

SELECT * FROM
(
SELECT CONCAT(name_first, ' ', name_last) AS Birder,
COUNT(DISTINCT birdwatchers.bird_sightings.bird_id) AS Points
FROM birdwatchers.humans
JOIN birdwatchers.bird_sightings USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.bird_families USING(family_id)
WHERE rookery.bird_families.scientific_name = 'Galliformes')
AS derived_1
WHERE Points > 5
ORDER BY Birder;
