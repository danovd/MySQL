<!--Database Basics MySQL Retake Exam - 06 August 2021


<!--1.
CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);
CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
);
CREATE TABLE offices(
id INT PRIMARY KEY AUTO_INCREMENT,
workspace_capacity INT NOT NULL,
website VARCHAR(50),
address_id INT NOT NULL
);
CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
age INT NOT NULL,
salary DECIMAL(10,2) NOT NULL,
job_title VARCHAR(20) NOT NULL,
happiness_level CHAR(1) NOT NULL,
CHECK (happiness_level IN ('L', 'N', 'H'))
);
CREATE TABLE teams(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL,
office_id INT NOT NULL,
leader_id INT UNIQUE NOT NULL
);
CREATE TABLE games(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) UNIQUE NOT NULL,
`description` TEXT,
rating FLOAT DEFAULT 5.5 NOT NULL,
budget DECIMAL(10,2) NOT NULL,
release_date DATE,
team_id INT NOT NULL 
);
CREATE TABLE games_categories(
game_id INT NOT NULL,
category_id INT NOT NULL
);

ALTER TABLE games_categories
ADD CONSTRAINT fk_category
FOREIGN KEY (category_id)
REFERENCES categories(id),
ADD CONSTRAINT fk_game
FOREIGN KEY (game_id)
REFERENCES games(id);

ALTER TABLE teams
ADD CONSTRAINT fk_employees
FOREIGN KEY (leader_id)
REFERENCES employees(id),
ADD CONSTRAINT fk_office
FOREIGN KEY (office_id)
REFERENCES offices(id);

ALTER TABLE offices
ADD CONSTRAINT fk_address
FOREIGN KEY (address_id)
REFERENCES addresses(id);

ALTER TABLE games
ADD CONSTRAINT fk_teams
FOREIGN KEY (team_id)
REFERENCES teams(id);

ALTER TABLE games_categories
ADD PRIMARY KEY (game_id, category_id);


<!--2.
INSERT INTO games (`name`, `rating`, `budget`, `team_id`)
SELECT LOWER(REVERSE(SUBSTRING(t.`name`, 2))), t.id, t.leader_id * 1000, t.id
FROM teams AS t
WHERE t.id BETWEEN 1 AND 9;


<!--3.
UPDATE employees AS e 
RIGHT JOIN teams AS t ON t.leader_id = e.id
SET e.salary = e.salary + 1000
WHERE e.salary < 5000;


<!--4.
DELETE g FROM games AS g
LEFT JOIN games_categories AS gc ON g.id = gc.game_id
WHERE gc.category_id IS NULL AND g.release_date IS NULL


<!--5.
SELECT first_name, last_name, age, salary, happiness_level FROM employees
ORDER BY salary, id;


<!--6.
SELECT t.`name` AS team_name, a.`name` AS address_name, CHAR_LENGTH(a.`name`) AS count_of_characters
FROM teams AS t
JOIN offices AS o ON t.office_id = o.id
JOIN addresses AS a ON o.address_id = a.id
WHERE o.website IS NOT NULL
ORDER BY t.`name`, a.`name`;


<!--7.
SELECT c.`name` AS `name`, count(gc.game_id) AS games_count, ROUND(AVG(g.budget), 2)AS avg_budget, MAX(g.rating)AS max_rating
FROM categories AS c
JOIN games_categories AS gc ON c.id = gc.category_id
JOIN games AS g ON g.id = gc.game_id
GROUP BY c.`name`
HAVING max_rating >= 9.5
ORDER BY games_count DESC, name ASC;


<!--8.
SELECT g.`name` AS `name`, g.`release_date` AS `release_date`,  
concat(LEFT(g.`description`, 10), '...' ) AS summary, 
(CASE 
WHEN MONTH(release_date) IN(1,2,3) THEN 'Q1'
WHEN MONTH(release_date) IN(4,5,6) THEN 'Q2' 
WHEN MONTH(release_date) IN(7,8,9) THEN 'Q3'
WHEN MONTH(release_date) IN(10,11,12) THEN 'Q4'
END) AS `quarter`,
t.`name` AS team_name FROM games AS g
JOIN teams AS t ON g.team_id = t.id
WHERE YEAR(release_date) = 2022 
AND MONTH(release_date)%2 = 0 
AND g.`name` LIKE '%2'
ORDER BY `quarter`


<!--9.
SELECT g.`name` AS `name`, 
(CASE 
WHEN g.budget < 50000 THEN 'Normal budget'
ELSE 'Insufficient budget'
END
) AS budget_level, t.`name` AS team_name, a.`name` AS address_name
FROM games AS g
JOIN teams AS t ON g.team_id = t.id
JOIN offices AS o ON t.office_id = o.id
JOIN addresses AS a ON o.address_id = a.id
LEFT JOIN games_categories AS gc ON g.id = gc.game_id
WHERE g.release_date IS NULL AND gc.game_id IS NULL
ORDER BY `name`


<!--10.
CREATE FUNCTION udf_game_info_by_name (_name VARCHAR (20))
RETURNS TEXT
DETERMINISTIC
BEGIN
DECLARE result TEXT;
SET result = (
SELECT concat('The ' , g.`name`, ' is developed by a ', t.`name`, ' in an office with an address ', a.`name`) AS info
FROM games AS g
JOIN teams AS t ON g.team_id = t.id
JOIN offices AS o ON t.office_id = o.id
JOIN addresses AS a ON o.address_id = a.id
WHERE g.`name` = _name
); 
RETURN result;
END


<!--11.
CREATE PROCEDURE udp_update_budget(min_game_rating FLOAT)
BEGIN
    UPDATE games AS g
    LEFT JOIN games_categories AS gc ON g.id = gc.game_id
    SET g.budget = g.budget + 100000, g.release_date = DATE_ADD(g.release_date, INTERVAL 1 YEAR)
    WHERE gc.category_id IS NULL AND g.rating > min_game_rating AND g.release_date IS NOT NULL;
END


