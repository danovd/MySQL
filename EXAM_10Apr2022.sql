<!-- Database Basics MySQL Retake Exam - 10 April 2022

<!--1.
DROP DATABASE softuni_imdb’s ;
CREATE DATABASE softuni_imdb’s;
use softuni_imdb’s ; 


CREATE TABLE countries (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) UNIQUE NOT NULL,
`continent` VARCHAR(30) NOT NULL,
`currency` VARCHAR(5) NOT NULL
);

CREATE TABLE genres(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE actors(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50) NOT NULL, 
`last_name` VARCHAR(50) NOT NULL, 
`birthdate` DATE NOT NULL,
`height` INT,
`awards` INT,
`country_id` INT NOT NULL 
);

CREATE TABLE movies_additional_info(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`rating` DECIMAL(10, 2) NOT NULL,
`runtime` INT NOT NULL,
`picture_url` VARCHAR(80) NOT NULL,
`budget` DECIMAL(10, 2),
`release_date` DATE NOT NULL,
`has_subtitles` BOOLEAN,
`description` TEXT
);

CREATE TABLE movies(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(70) NOT NULL UNIQUE,
`country_id` INT NOT NULL,
`movie_info_id` INT NOT NULL UNIQUE
);

CREATE TABLE movies_actors(
`movie_id` INT NOT NULL,
`actor_id` INT NOT NULL 
);

CREATE TABLE genres_movies(
`genre_id` INT NOT NULL,
`movie_id` INT NOT NULL
);

ALTER TABLE actors 
ADD CONSTRAINT fk_actors_country
FOREIGN KEY (country_id)
REFERENCES countries(id);

ALTER TABLE movies
ADD CONSTRAINT fk_movies_country
FOREIGN KEY (country_id)
REFERENCES countries(id),
ADD CONSTRAINT fk_movie_movieInfo
FOREIGN KEY (movie_info_id)
REFERENCES movies_additional_info(id);

ALTER TABLE movies_actors
ADD CONSTRAINT fk_movie_
FOREIGN KEY (movie_id)
REFERENCES movies(id),
ADD CONSTRAINT fk_actor
FOREIGN KEY (actor_id)
REFERENCES actors(id);

ALTER TABLE genres_movies
ADD CONSTRAINT fk_genre
FOREIGN KEY (genre_id)
REFERENCES genres(id),
ADD CONSTRAINT fk_movie
FOREIGN KEY (movie_id)
REFERENCES movies(id);


<!--2.
INSERT INTO actors(first_name, last_name, birthdate, height, awards, country_id)
(SELECT REVERSE(first_name), 
REVERSE(last_name), 
DATE_SUB(`birthdate`, INTERVAL 2 DAY),
(height + 10),
`country_id`,
(SELECT id FROM countries WHERE `name` = 'Armenia')
FROM actors WHERE id <= 10);



<!--3.
UPDATE `movies_additional_info` AS i
SET i.runtime = i.runtime - 10
WHERE i.id >= 15 AND i.id <= 25


<!--4.
DELETE c
FROM countries AS c
LEFT JOIN movies AS m ON c.id = m.country_id
WHERE m.id IS NULL;


<!--5.
SELECT * FROM countries AS c
ORDER BY c.currency DESC, c.`id`


<!--6.
SELECT i.`id`, m.`title`, i.`runtime`, i.`budget`, i.`release_date` 
FROM movies_additional_info AS i 
JOIN movies AS m ON i.id = m.movie_info_id
WHERE YEAR(i.release_date) BETWEEN 1996 AND 1999
ORDER BY i.`runtime`, i.`id`
LIMIT 20;


<!--7.
SELECT concat_ws(' ', a.first_name, a.last_name) AS full_name,
concat_ws('', REVERSE(a.last_name), CHAR_LENGTH(a.last_name), '@cast.com' )  AS email,
(YEAR(NOW() ) - 1) - YEAR(a.birthdate) AS `age`,
a.height FROM actors AS a
LEFT JOIN movies_actors AS ma ON a.id = ma.actor_id
LEFT JOIN movies AS m ON ma.movie_id = m.id
WHERE m.id is null
ORDER BY a.height


<!--8.
SELECT c.`name`, COUNT(m.id) AS movies_count FROM countries AS c
JOIN movies AS m ON c.id = m.country_id
GROUP BY c.`name`
HAVING movies_count >= 7
ORDER BY c.`name` DESC


<!--9.
SELECT m.title, 
(CASE WHEN i.rating <= 4 THEN 'poor'
WHEN i.rating <= 7 THEN 'good'
ELSE 'excellent' END) AS rating,
(CASE WHEN i.has_subtitles = 1 THEN 'english'
ELSE '-' END) AS subtitles
, i.budget
FROM movies AS m JOIN movies_additional_info AS i ON
m.movie_info_id = i.id
ORDER BY i.budget DESC


<!--10.
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (SELECT COUNT(m.id) FROM movies AS m
JOIN movies_actors AS ma ON m.id = ma.movie_id
JOIN actors AS a ON ma.actor_id = a.id
JOIN genres_movies AS gm ON m.id = gm.movie_id
JOIN genres AS g ON gm.genre_id = g.id
WHERE  concat_ws(' ', a.first_name, a.last_name) = full_name AND g.`name` ='history');
END


<!--11.
CREATE PROCEDURE udp_award_movie (movie_title VARCHAR(50))
BEGIN
UPDATE actors AS a
JOIN movies_actors AS ma ON a.id = ma.actor_id
JOIN movies AS m ON ma.movie_id = m.id
SET a.`awards` = a.`awards` + 1
WHERE m.title = movie_title;
END
