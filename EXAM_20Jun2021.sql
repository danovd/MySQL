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


/* 6 */
SELECT d.first_name, d.last_name, c.make, c.model, c.mileage FROM drivers AS d
JOIN cars_drivers AS cd ON d.id = cd.driver_id
JOIN cars AS c ON cd.car_id = c.id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name 


/* 7 */
SELECT c.id AS car_id, c.make, c.mileage,
 COUNT(co.id) AS count_of_courses,
 ROUND(AVG(co.bill), 2) AS avg_bill
FROM cars AS c
left JOIN courses AS co ON c.id = co.car_id
GROUP BY c.id
HAVING count_of_courses != 2
ORDER BY count_of_courses DESC, c.id;


/* 8 */
SELECT cl.full_name, count(c.id) AS count_of_cars, SUM(co.bill) AS total_sum FROM clients AS cl
JOIN courses AS co ON cl.id = co.client_id
JOIN cars AS c ON c.id = co.car_id
WHERE cl.full_name LIKE '_a%'
GROUP BY cl.id
HAVING count(c.id) > 1
ORDER BY cl.full_name


/* 9 */
SELECT a.`name`, 

(CASE 
WHEN HOUR(co.`start`) >=6 AND  HOUR(co.`start`) <= 20 THEN 'Day'
WHEN HOUR(co.`start`) <= 5 OR HOUR(co.`start`) >= 21 THEN 'Night'
END
)AS day_time, 
co.bill AS bill, cl.full_name AS full_name, c.make, c.model, cat.`name` 
FROM courses AS co
left JOIN addresses AS a ON co.from_address_id = a.id
left JOIN cars AS c ON co.car_id = c.id
left JOIN categories AS cat ON c.category_id = cat.id
left JOIN clients AS cl ON co.client_id = cl.id
ORDER BY co.id


/* 10 */
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE result INT;
SET result = (SELECT count(co.id) FROM clients AS cl 
JOIN courses AS co ON cl.id = co.client_id
WHERE cl.phone_number = phone_num);
RETURN result;
END


/* 11 */
DELIMITER $$
CREATE PROCEDURE udp_courses_by_address(_address_name VARCHAR(100))

BEGIN
SELECT a.`name`, cl.full_name AS full_names, 
(CASE 
WHEN co.bill < 20 THEN 'Low'
WHEN co.bill < 30 THEN 'Medium'
ELSE 'High'
END
) AS level_of_bill, 
c.make, c.`condition`, cat.`name` AS cat_name
 FROM courses AS co
JOIN addresses AS a ON co.from_address_id = a.id
JOIN clients AS cl ON co.client_id =cl.id
JOIN cars AS c ON c.id = co.car_id
JOIN categories AS cat ON cat.id = c.category_id
WHERE a.`name` = _address_name
ORDER BY c.make, full_names;
 
END $$