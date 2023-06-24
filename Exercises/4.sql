4.1 Create tables
CREATE TABLE `minions`(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(255),
age INT 
);

CREATE TABLE `towns`(
town_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(255) NOT NULL
)
4.2 Alter Minions Table
ALTER TABLE `minions`
ADD COLUMN `town_id` INT NOT NULL,
ADD CONSTRAINT `fk_minions_towns`
FOREIGN KEY (`town_id`)
REFERENCES `towns`(`id`)
4.3 Insert Records in Both Tables
INSERT INTO `towns` (id, `name`) VALUES(1 , 'Sofia'), (2, 'Plovdiv'), (3, 'Varna');

INSERT INTO `minions` (`id`, `name`, `age`, `town_id`)
VALUES(1, 'Kevin', 22, 1), (2, 'Bob', 15, 3), (3, 'Steward', NULL, 2);
4.4 Truncate Table Minions
TRUNCATE TABLE `minions`;
4.5 Drop All Tables
DROP TABLE `minions`;
DROP TABLE `towns`;
4.6 Create Table People
CREATE TABLE `people`(
`id` INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(200) NOT NULL,
`picture` BLOB, 
`height` DOUBLE(10,2),
`weight`DOUBLE(10, 2),
`gender` CHAR(1) NOT NULL,
`birthdate` DATE NOT NULL,
`biography` TEXT 

);
INSERT INTO `people`(`name`, `gender`, `birthdate`)
VALUES
("Boris",'m',DATE(NOW())),
("Aleksandar",'m',DATE(NOW())),
("Dancho",'m',DATE(NOW())),
("Peter",'m',DATE(NOW())),
("Desi",'f',DATE(NOW()));
4.7 Create Table Users
CREATE TABLE `users`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`username` VARCHAR(30) NOT NULL,
`password` VARCHAR(26) NOT NULL,
`profile_picture` BLOB,
`last_login_time` TIME,
`is_deleted` BOOLEAN
);

INSERT INTO `users`(`username`, `password`)
VALUES ("pesho1", "dfdfwe"),
("ivan2", "esfae"),
("test", "af"),
("asda", "daf"),
("dwfw", "wefgrs");
4.8 Change Primary Key
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD PRIMARY KEY pk_users(`id`, `username`);
4.9 Set Default Value of a Field
ALTER TABLE `users`
MODIFY COLUMN `last_login_time` DATETIME DEFAULT NOW();
4.10 Set Unique Field
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY `users`(`id`),
MODIFY COLUMN `username` VARCHAR(30) UNIQUE;
4.11 Movies Database
Skip
4.12 Car Rental Database
Skip
4.13 Basic Insert
CREATE DATABASE `soft_uni`;
USE `soft_uni`;
CREATE TABLE `towns`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(255) NOT NULL
);
CREATE TABLE `addresses`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`address_text` VARCHAR(255) NOT NULL,
`town_id` INT NOT NULL
);

CREATE TABLE `departments`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(255)
);
CREATE TABLE `employees`(
`id` INT PRIMARY KEY AUTO_INCREMENT, 
`first_name` VARCHAR(255) NOT NULL,
`middle_name` VARCHAR(255) NOT NULL,
`last_name` VARCHAR(255) NOT NULL,
`job_title` VARCHAR(255) NOT NULL,
`department_id` INT NOT NULL,
`hire_date` DATE,
`salary` DECIMAL,
`address_id` VARCHAR(255) NOT NULL
);
INSERT INTO `towns`(`name`)
VALUES ("Sofia"), ("Plovdiv"), ("Varna"), ("Burgas");
INSERT INTO `departments` (`name`)
VALUES ("Engineering"), ("Sales"), ("Marketing"),
("Software Development"), ("Quality Assurance");
INSERT INTO `employees` (`first_name`, `middle_name`, `last_name`, 
`job_title`, `department_id`, `hire_date`, `salary`)
VALUES
("Ivan", "Ivanov", "Ivanov", ".NET Developer", 4, "2013-02-01", 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);
4.14 Basic Select All Fields
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;
4.15 Basic Select All Fields and Order Them

SELECT * FROM `towns`
ORDER BY `name`;

SELECT * FROM `departments`
ORDER BY `name`;


SELECT * FROM `employees`
ORDER BY `salary` DESC;
4.16 Basic Select Some Fields
SELECT `name` FROM `towns`
ORDER BY `name`;
SELECT `name` FROM `departments`
ORDER BY `name`;
SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;
4.17 Increase Employees Salary
UPDATE `employees`
SET `salary` =  `salary` * 1.1;

SELECT `salary` FROM `employees`;
