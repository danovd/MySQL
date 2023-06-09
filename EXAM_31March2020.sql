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




