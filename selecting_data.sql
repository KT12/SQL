### Chapter 7: Selecting Data

SELECT common_name, scientific_name
FROM birds WHERE family_id = 103
LIMIT 3;

SELECT common_name, scientific_name
FROM birds WHERE family_id = 103
ORDER BY common_name
LIMIT 3;

SELECT * FROM bird_families
WHERE scientific_name
IN ('Charadriidae', 'Haematopodidae', 'Recurvirostridae', 'Scolopacidae');

SELECT common_name, scientific_name, family_id
FROM birds
WHERE family_id IN (103, 160, 162, 164)
ORDER BY common_name
LIMIT 3;

SELECT common_name, scientific_name, family_id
FROM birds
WHERE family_id IN (103, 160, 162, 164)
AND common_name != '' ## not the same as NULL, depends on default
ORDER BY common_name
LIMIT 3;
### Limit 3 same as Limit 0, 3
### 0 is starting point (do not skip rows)

SELECT common_name, scientific_name, family_id
FROM birds
WHERE family_id IN (103, 160, 162, 164)
AND common_name != ''
ORDER BY common_name
LIMIT 3, 2;


SELECT common_name AS 'Bird',
bird_families.scientific_name AS 'Family'
FROM birds, bird_families
WHERE birds.family_id = bird_families.family_id
AND order_id = 102
AND common_name <> ''
ORDER BY common_name LIMIT 10;

SELECT common_name AS 'Bird',
bird_families.scientific_name AS 'Family'
FROM birds, bird_families
WHERE birds.family_id = bird_families.family_id
AND order_id = 103
ORDER BY 'Bird' DESC
LIMIT 20;

SELECT common_name AS 'Bird',
bird_families.scientific_name AS 'Family'
FROM birds, bird_families
WHERE birds.family_id = bird_families.family_id
AND order_id = 103
ORDER BY common_name DESC
LIMIT 25;

SELECT common_name AS 'Bird',
bird_families.scientific_name AS 'Family'
FROM birds, bird_families
WHERE birds.family_id = bird_families.family_id
AND order_id = 103
ORDER BY common_name
LIMIT 25;

SELECT common_name AS 'Bird',
families.scientific_name AS 'Family',
orders.scientific_name AS 'Order'
FROM birds, bird_families AS families, bird_orders AS orders
WHERE birds.family_id = families.family_id
AND families.order_id = orders.order_id
AND families.order_id = 103
AND common_name <> ''
ORDER BY common_name
LIMIT 10, 5;

SELECT common_name AS 'Bird',
families.scientific_name AS 'Family',
orders.scientific_name AS 'Order'
FROM birds, bird_families AS families, bird_orders AS orders
WHERE birds.family_id = families.family_id
AND families.order_id = orders.order_id
AND common_name LIKE 'Least%'
ORDER BY orders.scientific_name, families.scientific_name, common_name
LIMIT 10;


SELECT common_name AS 'Birds Great and Small'
FROM birds
WHERE common_name REGEXP 'Great|Least'
ORDER BY family_id LIMIT 30;

SELECT common_name AS 'Birds Great and Small'
FROM birds
WHERE common_name REGEXP 'Great|Least'
AND common_name NOT REGEXP 'Greater'
ORDER BY family_id LIMIT 30;

SELECT common_name AS 'Hawks'
FROM birds
WHERE common_name REGEXP BINARY 'Hawk'
AND common_name NOT REGEXP 'Hawk-Owl'
ORDER BY family_id
LIMIT 10;

SHOW CREATE DATABASE rookery \G

SHOW FULL COLUMNS
FROM birds LIKE 'common_name' \G

### If collation is set to latin1_bin, then BINARY not necessary
### for REGEXP case sensitivity

SELECT common_name AS 'Hawks'
FROM birds
WHERE common_name REGEXP '[[:space:]]Hawk|[[.hyphen.]]Hawk'
AND common_name NOT REGEXP 'Hawk-Owl|Hawk Owl'
ORDER BY family_id
LIMIT 10;
### Yields POSIX error

SELECT COUNT(*) FROM birds;

SELECT families.scientific_name AS 'Family',
COUNT(*) AS 'Number of Birds'
FROM birds, bird_families AS families
WHERE birds.family_id = families.family_id
AND families.scientific_name = 'Pelecanidae';

SELECT orders.scientific_name AS 'Order',
families.scientific_name AS 'Family',
COUNT(*) AS 'Number of Birds'
FROM birds, bird_families AS families, bird_orders AS orders
WHERE birds.family_id = families.family_id
AND families.order_id = orders.order_id
AND orders.scientific_name = 'Pelecaniformes';


SELECT orders.scientific_name AS 'Order',
families.scientific_name AS 'Family',
COUNT(*) AS 'Number of Birds'
FROM birds, bird_families AS families, bird_orders AS orders
WHERE birds.family_id = families.family_id
AND families.order_id = orders.order_id
AND orders.scientific_name = 'Pelecaniformes'
GROUP BY Family;


