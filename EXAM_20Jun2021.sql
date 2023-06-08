/* Database Basics MySQL Exam - 20 June 2021 */



/* 1 */
CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(100) NOT NULL
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
);

CREATE TABLE clients(
id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(50) NOT NULL,
phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
age INT NOT NULL,
rating FLOAT DEFAULT 5.5
);

CREATE TABLE cars(
id INT PRIMARY KEY AUTO_INCREMENT,
make VARCHAR(20) NOT NULL,
model VARCHAR(20),
`year` INT DEFAULT 0 NOT NULL,
mileage INT DEFAULT 0,
`condition` CHAR(1) NOT NULL,
category_id INT NOT NULL
);


CREATE TABLE courses(
id INT PRIMARY KEY AUTO_INCREMENT,
from_address_id INT NOT NULL,
`start` DATETIME NOT NULL,
bill DECIMAL(10,2) DEFAULT 10,
car_id INT NOT NULL,
client_id INT NOT NULL
);

CREATE TABLE cars_drivers(
car_id INT NOT NULL,
driver_id INT NOT NULL
);

ALTER TABLE courses 
ADD CONSTRAINT fk_address
FOREIGN KEY (from_address_id)
REFERENCES addresses(id),
ADD CONSTRAINT fk_cars
FOREIGN KEY (car_id)
REFERENCES cars(id),
ADD CONSTRAINT fk_client
FOREIGN KEY (client_id)
REFERENCES clients(id);

ALTER TABLE cars
ADD CONSTRAINT fk_category
FOREIGN KEY (category_id)
REFERENCES categories(id);

ALTER TABLE cars_drivers
ADD CONSTRAINT fk_car_
FOREIGN KEY (car_id)
REFERENCES cars(id),
ADD CONSTRAINT fk_driver
FOREIGN KEY (driver_id)
REFERENCES drivers(id),
ADD PRIMARY KEY (car_id, driver_id);


/* 2 */
INSERT INTO clients (full_name, phone_number)
SELECT concat(d.first_name, ' ', d.last_name),  concat('(088) 9999', d.id * 2)  FROM drivers AS d
WHERE d.id BETWEEN 10 AND 20


/* 3 */
UPDATE cars AS c
SET c.`condition` = 'C'
WHERE (c.mileage > 800000 OR c.mileage IS NULL) AND c.`year` <= 2010 AND c.make != 'Mercedes-Benz'


/* 4 */
DELETE FROM clients
WHERE id NOT IN (
  SELECT DISTINCT client_id
  FROM courses
) AND CHAR_LENGTH(full_name) > 3;


/* 5 */
SELECT make, model, `condition` FROM cars
ORDER BY id