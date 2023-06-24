7
#7.1
SELECT `title` FROM `books`
WHERE SUBSTRING(`title`, 1, 3) = 'The';
#7.2
SELECT REPLACE(`title`, "The", "***")
FROM `books`
WHERE SUBSTRING(`title`, 1, 3) = "The";

#7.3
SELECT round(SUM(`cost`), 2)
FROM `books`;

#7.4
SELECT concat_ws(" ", first_name, last_name) AS 'Full Name', 
TIMESTAMPDIFF(DAY, `born`, `died`) AS 'Days lived'
FROM `authors`; 

# 7.4 SELECT concat_ws(" ", first_name, last_name) AS 'Full Name', 
TIMESTAMPDIFF(DAY, `born`, `died`) AS 'Days lived'
FROM `authors`;
# 7.5 SELECT `title` 
FROM `books`
WHERE `title` LIKE 'Harry Potter%'
