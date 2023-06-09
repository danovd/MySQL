/* 1 */
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(30) NOT NULL UNIQUE,
  password VARCHAR(30) NOT NULL,
  email VARCHAR(50) NOT NULL,
  gender CHAR(1) NOT NULL,
  age INT NOT NULL,
  job_title VARCHAR(40) NOT NULL,
  ip VARCHAR(30) NOT NULL
);

CREATE TABLE addresses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  address VARCHAR(30) NOT NULL,
  town VARCHAR(30) NOT NULL,
  country VARCHAR(30) NOT NULL,
  user_id INT NOT NULL
);

CREATE TABLE photos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  description TEXT NOT NULL,
  date DATETIME NOT NULL,
  views INT DEFAULT 0 NOT NULL
);

CREATE TABLE comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  comment VARCHAR(255) NOT NULL,
  date DATETIME NOT NULL,
  photo_id INT NOT NULL
);

CREATE TABLE users_photos (
  user_id INT NOT NULL,
  photo_id INT NOT NULL
);

CREATE TABLE likes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  photo_id INT NOT NULL,
  user_id INT NOT NULL
);

ALTER TABLE addresses
ADD CONSTRAINT fk_addresses_users
FOREIGN KEY (user_id)
REFERENCES users (id);

ALTER TABLE comments
ADD CONSTRAINT fk_comments_photos
FOREIGN KEY (photo_id)
REFERENCES photos (id);

ALTER TABLE users_photos
ADD CONSTRAINT fk_users_photos_users
FOREIGN KEY (user_id)
REFERENCES users (id),
ADD CONSTRAINT fk_users_photos_photos
FOREIGN KEY (photo_id)
REFERENCES photos (id);

ALTER TABLE likes
ADD CONSTRAINT fk_likes_photos
FOREIGN KEY (photo_id)
REFERENCES photos (id),
ADD CONSTRAINT fk_likes_users
FOREIGN KEY (user_id)
REFERENCES users (id);

/* 2 */

INSERT INTO addresses(address, town, country, user_id)
(SELECT username, `password`, ip, age  FROM users
WHERE gender = 'M')


/* 3 */
UPDATE addresses AS a
SET a.country = (
CASE 
WHEN a.country LIKE 'B%' THEN 'blocked'
WHEN a.country LIKE 'T%' THEN 'Test'
WHEN a.country LIKE 'P%' THEN 'In Progress'
ELSE a.country
END);


/* 4 */
DELETE a FROM addresses AS a
WHERE a.id % 3 = 0; 


/* 5 */
SELECT username, gender, age FROM users
ORDER BY age DESC, username ASC 


/* 6 */
SELECT p.id, p.`date` AS date_and_time, p.`description`, count(c.id) AS commentsCount FROM photos AS p
JOIN comments AS c ON p.id = c.photo_id
GROUP BY p.id
ORDER BY count(c.id) DESC, p.id ASC
LIMIT 5


/* 7 */
SELECT concat(u.id, ' ', u.username) AS id_username, u.email 
FROM users AS u JOIN users_photos AS up ON u.id = up.user_id
WHERE u.id = up.photo_id
ORDER BY u.id


/* 8 */
SELECT p.id AS photo_id, COUNT(DISTINCT l.id) AS likes_count, COUNT(DISTINCT c.id) AS comments_count FROM photos AS p
LEFT JOIN likes AS l ON p.id = l.photo_id
LEFT JOIN comments AS c ON p.id = c.photo_id
GROUP BY p.id
ORDER BY count(distinct l.id) DESC, count(distinct c.id) DESC, p.id ASC 


/* 9 */
SELECT (concat(LEFT(p.`description`, 30), '...') )AS summary, p.`date` AS `date` FROM photos AS p
WHERE DAY(p.`date`) = 10
ORDER BY p.`date` DESC;


/* 10 */
CREATE FUNCTION udf_users_photos_count(_username VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN 
DECLARE result INT;
SET result = (SELECT count(up.user_id) FROM users AS u
JOIN users_photos AS up ON u.id = up.user_id
WHERE u.username = _username);
RETURN result;
END


/* 11 */
CREATE PROCEDURE udp_modify_user(_address VARCHAR(30), _town VARCHAR(30))
BEGIN
UPDATE users AS u
JOIN addresses AS a ON u.id = a.user_id
SET u.age = u.age + 10
WHERE a.address = _address AND a.town = _town;
END

