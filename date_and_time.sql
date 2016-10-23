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


