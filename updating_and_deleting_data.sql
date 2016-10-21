### Chapter 8: Updating and Deleting Data

UPDATE birdwatchers.humans
SET country_id = 'us';

SELECT human_id, name_first, name_last
FROM humans
WHERE name_first = 'Rusty'
AND name_last = 'Osborne';

UPDATE humans
SET name_last = 'Johnson'
WHERE human_id = 3;

SELECT human_id, name_first, name_last
FROM humans
WHERE human_id = 3;

UPDATE humans
SET formal_title = 'Ms.'
WHERE human_id IN(24, 32);

SHOW FULL COLUMNS
FROM humans
LIKE 'formal_title' \G

UPDATE humans
SET formal_title = 'Ms.'
WHERE formal_title IN ('Miss', 'Ms.');

ALTER TABLE humans
CHANGE COLUMN formal_title formal_title ENUM('Mr.', 'Ms.');
# Above breaks because of truncated data

# Do the three commands below instead
ALTER TABLE humans
CHANGE COLUMN formal_title formal_title ENUM('Mr.', 'Ms.', 'Mr', 'Ms');

UPDATE humans
SET formal_title = SUBSTRING(formal_title, 1, 2);

ALTER TABLE humans
CHANGE COLUMN formal_title formal_title ENUM('Mr', 'Ms');

CREATE TABLE prize_winners
(winner_id INT AUTO_INCREMENT PRIMARY KEY,
    human_id INT,
    winner_date DATE,
    prize_chosen VARCHAR(255),
    prize_sent DATE);

INSERT INTO prize_winners
(human_id)
SELECT human_id
FROM humans;

UPDATE prize_winners
SET winner_date = CURDATE()
WHERE winner_date IS NULL
ORDER BY RAND()
LIMIT 2;
### Text claimed there would be warnings but
### none observed

SHOW WARNINGS \G

UPDATE prize_winners, humans
SET winner_date = NULL,
    prize_chosen = NULL,
    prize_sent = NULL
WHERE country_id = 'uk'
AND prize_winners.human_id = humans.human_id;

SELECT * FROM prize_winners;

UPDATE prize_winners, HUMANS
SET winner_date = CURDATE()
WHERE winner_date = NULL
AND country_id = 'uk'
AND prize_winners.human_id = humans.human_id
ORDER BY RAND()
LIMIT 2;
### Yields error because usage of UPDATE and ORDER BY clauses
### cause problems with multiple tables

### Instead use subquery to work around

UPDATE prize_winners
SET winner_date = CURDATE()
WHERE winner_date IS NULL
AND human_id IN
    (SELECT human_id
    FROM humans
    WHERE country_id = 'uk'
    ORDER BY RAND())
LIMIT 2;

### 
ALTER TABLE humans
DROP COLUMN better_birders_site;

ALTER TABLE humans
ADD COLUMN better_birders_site TINYINT DEFAULT 0;

INSERT INTO humans
(formal_title, name_first, name_last, email_address, better_birders_site)
VALUES
('Mr', 'Barry', 'Pilson', 'barry@gomail.com', 1),
('Ms', 'Lexi', 'Hollar', 'alexandra@mysqlresources.com', 1),
('Mr', 'Ricky', 'Adams', 'ricky@gomail.com', 1)
ON DUPLICATE KEY
UPDATE better_birders_site = 2;

INSERT INTO prize_winners
(human_id)
SELECT human_id
FROM humans
WHERE better_birders_site = 1;

ALTER TABLE humans
ADD COLUMN possible_duplicate TINYINT DEFAULT 0;

CREATE TEMPORARY TABLE possible_duplicates
(name_1 varchar(25), name_2 varchar(25));

INSERT INTO possible_duplicates
SELECT name_first, name_last
FROM
    (SELECT name_first, name_last, COUNT(*) AS nbr_entries
    FROM humans
    GROUP BY name_first, name_last) AS derived_table
WHERE nbr_entries > 1;

UPDATE humans, possible_duplicates
SET possible_duplicate = 1
WHERE name_first = name_1
AND name_last = name_2;

DELETE FROM humans, prize_winners
USING humans JOIN prize_winners
WHERE name_first = 'Elena'
AND name_last = 'Bokova'
AND email_address LIKE '%yahoo.com'
AND humans.human_id = prize_winners.human_id;

### ALWAYS back up before using DELETE FROM

### 1

CREATE DATABASE backup;

CREATE TABLE backup.humans_copy
SELECT * FROM birdwatchers.humans;

CREATE TABLE backup.prize_winners_copy
SELECT * FROM birdwatchers.prize_winners;

SELECT * FROM backup.humans_copy;

SELECT * FROM backup.prize_winners_copy;

### 2

SELECT * FROM humans
WHERE country_id = 'au';

UPDATE humans
SET membership_type = 'premium',\
membership_expiration = DATE_ADD(CURDATE(), INTERVAL 1 YEAR)
WHERE country_id = 'au';

SELECT * FROM humans
WHERE country_id = 'au';

### 3

DELETE FROM humans, prize_winners
USING humans JOIN prize_winners
WHERE name_first = 'Barry'
AND name_last = 'Pilson'
AND humans.human_id = prize_winners.human_id;

SELECT * FROM humans;

SELECT * FROM prize_winners;

### 4
DELETE FROM humans;

DELETE FROM prize_winners;

SELECT * FROM humans;

SELECT * FROM prize_winners;

# Now that rows were deleted, replace them from backup

INSERT INTO humans
SELECT * FROM backup.humans_copy;

INSERT INTO prize_winners
SELECT * FROM backup.prize_winners_copy;

SELECT * FROM humans;

SELECT * FROM prize_winners;

DROP TABLE backup.humans_copy;

DROP TABLE backup.prize_winners_copy;
