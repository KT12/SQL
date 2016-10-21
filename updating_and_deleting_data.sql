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


