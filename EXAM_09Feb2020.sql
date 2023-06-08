<!-- Database Basics MySQL Exam - 9 Feb 2020

<!--1
# DROP DATABASE fsd;
# CREATE DATABASE fsd;
# use fsd;

CREATE TABLE countries(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL
);

CREATE TABLE towns(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
country_id INT NOT NULL,
CONSTRAINT fk_towns_countries
FOREIGN KEY (country_id)
REFERENCES countries(id)
);

CREATE TABLE stadiums(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
capacity INT NOT NULL,
town_id INT NOT NULL,
CONSTRAINT fk_stadiums_towns
FOREIGN KEY (town_id)
REFERENCES towns(id)
);

CREATE TABLE teams (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
established DATE NOT NULL,
fan_base BIGINT(20) NOT NULL,
stadium_id INT NOT NULL,
CONSTRAINT fk_teams_stadiums
FOREIGN KEY (stadium_id)
REFERENCES stadiums(id)
);

CREATE TABLE skills_data(
id INT PRIMARY KEY AUTO_INCREMENT,
dribbling INT DEFAULT(0),
pace INT DEFAULT(0),
passing INT DEFAULT(0),
shooting INT DEFAULT(0),
speed INT DEFAULT(0),
strength INT DEFAULT(0)
);

CREATE TABLE coaches (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(10, 2) NOT NULL DEFAULT(0),
coach_level INT NOT NULL DEFAULT(0)
);

CREATE TABLE players (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
age INT NOT NULL DEFAULT(0),
position CHAR(1) NOT NULL,
salary DECIMAL(10,2) NOT NULL DEFAULT(0),
hire_date DATETIME,
skills_data_id INT NOT NULL,
team_id INT,
CONSTRAINT fk_players_skills_data
FOREIGN KEY (skills_data_id)
REFERENCES skills_data(id),
CONSTRAINT fk_players_teams
FOREIGN KEy (team_id)
REFERENCES teams(id)
);

CREATE TABLE players_coaches(
player_id INT,
coach_id INT,
CONSTRAINT fk_players_coaches_players
FOREIGN KEY (player_id)
REFERENCES players(id),
CONSTRAINT fk_players_coaches_coaches
FOREIGN KEY (coach_id)
REFERENCES coaches(id)
);


<!--2
INSERT INTO coaches(first_name, last_name, salary, coach_level)(
SELECT 
	p.first_name, p.last_name, (p.salary * 2), CHAR_LENGTH(p.first_name) AS coach_level
    FROM players AS p
    WHERE p.age >= 45);


<!--3
UPDATE coaches AS c
SET c.coach_level = c.coach_level + 1
WHERE c.id IN (SELECT coach_id FROM players_coaches) AND first_name LIKE 'A%';


<!--4
DELETE FROM players WHERE age >= 45;


<!--5
SELECT first_name, age, salary FROM players
ORDER BY salary DESC


<!--6
SELECT p.id, concat_ws(' ', first_name, last_name) AS full_name, p.age, p.`position`, p.hire_date FROM players AS p
JOIN skills_data AS sd ON p.skills_data_id = sd.id
WHERE  p.hire_date is null and p.age < 23 AND p.`position` = 'A' and sd.strength > 50 
ORDER BY p.salary, p.age;


<!--7
SELECT t.`name` AS team_name, t.established, t.fan_base, COUNT(p.id) AS players_count FROM teams AS t
LEFT JOIN players AS p ON t.id = p.team_id
GROUP BY t.id
ORDER BY players_count DESC, t.fan_base DESC;


<!--8
SELECT   MAX(sd.speed) max_speed, t.`name` AS town_name FROM towns AS t
left JOIN stadiums AS s ON t.id = s.town_id
left JOIN teams AS tem ON s.id = tem.stadium_id
left JOIN players AS p ON tem.id = p.team_id
left JOIN skills_data sd ON p.skills_data_id = sd.id
wHERE tem.`name` != 'Devify'
GROUP BY t.id
ORDER BY max_speed DESC, town_name


<!--9
SELECT c.`name`, COUNT(p.id) AS total_count_of_players, SUM(p.salary) 
AS total_sum_of_salaries FROM countries AS c
left JOIN towns AS `tw` ON c.id = `tw`.country_id
left JOIN  stadiums AS s ON  s.town_id = `tw`.id
left JOIN teams AS t ON t.stadium_id= s.id
left JOIN players AS p ON  p.team_id = t.id
GROUP BY c.id
ORDER BY total_count_of_players DESC, c.`name`;


<!--10
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30)) 
RETURNS INT 
DETERMINISTIC
BEGIN
DECLARE number_of_players INT;
SET number_of_players := (SELECT count(p.id) FROM players AS p
JOIN teams AS t ON p.team_id = t.id
JOIN stadiums s ON t.stadium_id = s.id
WHERE s.`name` = stadium_name
);
RETURN number_of_players;
END


<!--11
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
BEGIN
SELECT concat_ws(' ', p.first_name, p.last_name) AS full_name,
p.age, p.salary, sd.dribbling, sd.speed, t.`name` AS team_name
FROM players AS p
JOIN skills_data AS sd ON p.skills_data_id = sd.id
JOIN teams AS t ON t.id = p.team_id
WHERE sd.dribbling > min_dribble_points AND t.`name` = team_name
AND sd.speed > (SELECT AVG(s.speed) FROM skills_data AS s
JOIN players AS pp ON pp.skills_data_id = s.id)
ORDER BY sd.speed DESC LIMIT 1;
END
