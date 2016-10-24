### Chapter 11 Date and Time Functions

SELECT NOW();  # output is DATETIME format

INSERT INTO bird_sightings
(bird_id, human_id, time_seen, location_gps)
VALUES
(104, 34, NOW(), '47.318875; 8.580119');

### Synonyms for NOW():
### CURRENT_TIME_STAMP(), LOCALTIME(), LOCALTIMESTAMP()

### SYSDATE() function records the time at which the function
### executed, not the end of the statement
### NOW() records the time at the start of the SQL statement

SELECT NOW(), SLEEP(4) AS 'Zzzz', SYSDATE(), SLEEP(2) AS 'Zzz', SYSDATE();

### Comparison of temporal functions

SELECT NOW(), CURDATE(), CURTIME();

### UNIX_TIMESTAMP() returns number of seconds since Jan 1 1970
SELECT UNIX_TIMESTAMP(), NOW();

SELECT (2016 - 1970) AS Simple,
UNIX_TIMESTAMP() AS 'Seconds since Epoch',
ROUND(UNIX_TIMESTAMP() / 60 / 60 / 24 / 365.25) AS Complicated;

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
ROUND((UNIX_TIMESTAMP() - UNIX_TIMESTAMP(time_seen)) / 60 / 60 / 24)
AS 'Days Since Spotted'
FROM bird_sightings JOIN humans USING(human_id)
WHERE bird_id = 309;

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
time_seen, DATE(time_seen), TIME(time_seen)
FROM bird_sightings
JOIN humans USING(human_id)
WHERE bird_id = 309;

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
time_seen, HOUR(time_seen), MINUTE(time_seen), SECOND(time_seen)
FROM bird_sightings
JOIN humans USING(human_id)
WHERE bird_id = 309 \G

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
time_seen, YEAR(time_seen), MONTH(time_seen), DAY(time_seen), MONTHNAME(time_seen), DAYNAME(time_seen)
FROM bird_sightings
JOIN humans USING(human_id)
WHERE bird_id = 309 \G

## Retrieve a list of endangered birds spotted by members

SELECT common_name AS 'Endangered Bird',
CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
CONCAT(DAYNAME(time_seen), ', ', MONTHNAME(time_seen), SPACE(1),
    DAY((time_seen)), ', ', YEAR(time_seen)) AS 'Date Spotted',
CONCAT(HOUR(time_seen), ':', MINUTE(time_seen),
    IF(HOUR(time_seen) < 12, 'A.M.', 'P.M.')) AS 'Time Spotted'
FROM bird_sightings
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.conservation_status USING(conservation_status_id)
WHERE conservation_category = 'Threatened' LIMIT 3;

SELECT time_seen,
EXTRACT(YEAR_MONTH FROM time_seen) AS 'Year & Month',
EXTRACT(MONTH FROM time_seen) AS 'Month Only',
EXTRACT(HOUR_MINUTE FROM time_seen) AS 'Hour & Minute',
EXTRACT(HOUR FROM time_seen) AS 'Hour Only'
FROM bird_sightings JOIN humans USING(human_id)
LIMIT 3;

SELECT common_name AS 'Endangered Bird',
CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
DATE_FORMAT(time_seen, '%W, %M %e, %Y') AS 'Date Spotted',
TIME_FORMAT(time_seen, '%l:%i %p') AS 'Time Spotted'
FROM bird_sightings
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.conservation_status USING(conservation_status_id)
WHERE conservation_category = 'Threatened' LIMIT 3;

SELECT GET_FORMAT(DATE, 'USA');

SELECT GET_FORMAT(DATE, 'USA'), GET_FORMAT(TIME, 'USA');

SELECT DATE_FORMAT(CURDATE(), GET_FORMAT(DATE, 'EUR'))
AS 'Date in Europe',
DATE_FORMAT(CURDATE(), GET_FORMAT(DATE, 'USA'))
AS 'Date in US',
REPLACE(DATE_FORMAT(CURDATE(), GET_FORMAT(DATE, 'USA')), '.', '-')
AS 'Another Date in US';

SHOW VARIABLES LIKE 'time_zone';

SELECT common_name AS 'Bird',
CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
DATE_FORMAT(time_seen, '%r') AS 'System Time Spotted',
DATE_FORMAT(CONVERT_TZ(time_seen, 'US/Eastern', 'Europe/Rome'), '%r%')
AS 'Birder Time Spotted'
FROM bird_sightings
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.conservation_status USING(conservation_status_id)
LIMIT 3;

UPDATE humans
SET membership_expiration = DATE_ADD(membership_expiration, INTERVAL 3 MONTH)
WHERE country_id = 'uk'
AND membership_expiration > CURDATE();

UPDATE humans
SET membership_expiration = DATE_SUB(membership_expiration, INTERVAL 1 YEAR)
WHERE CONCAT(name_first, SPACE(1), name_last) = 'Melissa Lee';

UPDATE bird_sightings
SET time_seen = DATE_ADD(time_seen, INTERVAL '1 2' DAY_HOUR)
WHERE sighting_id = 16;

SELECT TIME(NOW()),
TIME_TO_SEC(NOW()),
TIME_TO_SEC(NOW()) / 60 / 60 AS 'Hours';

SELECT CURDATE() AS 'Today',
DATE_FORMAT(membership_expiration, '%M %e, %Y')
  AS 'Date Membership Expires',
DATEDIFF(membership_expiration, CURDATE())
  AS 'Days Until Expiration'
FROM humans
WHERE human_id = 4;

CREATE TABLE birding_events
(event_id INT AUTO_INCREMENT KEY,
event_name VARCHAR(255),
event_description TEXT,
meeting_point VARCHAR(255),
event_date DATE,
start_time TIME);

INSERT INTO birding_events
VALUES
(NULL,
'Sandpipers in San Diego',
'Birdwatching Outing in SD.  Light lunch.',
'Hotel del Coronado, deck near entrance to restaurant.',
'2014-06-15',
'09:00:00');

SELECT NOW(), event_date, start_time,
DATEDIFF(event_date, DATE(NOW())) AS 'Days to Event',
TIMEDIFF(start_time, TIME(NOW())) AS 'Time to Start'
FROM birding_events;

SELECT NOW(), event_date, start_time,
CONCAT(DATEDIFF(event_date, DATE(NOW())), ' Days, ',
        DATE_FORMAT(TIMEDIFF(start_time, TIME(NOW())), '%k hours, %i minutes'))
    AS 'Time to Event'
FROM birding_events;

ALTER TABLE birding_events
ADD COLUMN event_datetime DATETIME;

UPDATE birding_events
SET event_datetime = CONCAT(event_date, SPACE(1), start_time);

SELECT event_date, start_time, event_datetime
FROM birding_events;

SELECT NOW(), event_datetime, 
CONCAT(DATEDIFF(event_datetime, NOW()), ' Days, ',
    TIME_FORMAT(TIMEDIFF(TIME(event_datetime), CURTIME()),
        '%k hours, %i minutes'))
AS 'Time to Event'
FROM birding_events;

ALTER TABLE birding_events
DROP COLUMN event_date, 
DROP COLUMN start_time;

### Exercises
### 1


SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
DATE_FORMAT(join_date, '%a., %b. %e, %Y') AS 'Date Joined',
DATE_FORMAT(membership_expiration, '%a., %b. %e, %Y') AS 'Membership Expiration Date'
FROM humans
WHERE country_id = 'uk';

### 2
SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
membership_expiration AS 'Membership Expiration Date'
FROM humans
order by membership_expiration;

UPDATE humans
SET membership_expiration = ADDDATE(membership_expiration, INTERVAL 1 MONTH),
membership_expiration = ADDDATE(membership_expiration, INTERVAL 15 DAY)
WHERE membership_expiration > '2014-06-30';

UPDATE humans
SET membership_expiration = DATE_SUB(membership_expiration, INTERVAL 5 DAY)
WHERE membership_expiration > '2014-06-30';

UPDATE humans
SET membership_expiration = ADDDATE(membership_expiration, INTERVAL -10 DAY)
WHERE membership_expiration > '2014-06-30';

