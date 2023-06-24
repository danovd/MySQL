•	3_1
CREATE TABLE `employees`(
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL
);

CREATE TABLE `categories`(
id INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(100) NOT NULL
);

CREATE TABLE `products`(
id INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(100) NOT NULL,
`category_id` INT NOT NULL
)

•	3_2
INSERT INTO `employees`(`first_name`, `last_name`) VALUES ("Donald", "Trump");
INSERT INTO `employees`(`first_name`, `last_name`) VALUES ("Nikola", "Tesla");
INSERT INTO `employees`(`first_name`, `last_name`) VALUES ("Mao", "Dzedun");

Може и INSERT INTO `employees`(`first_name`, `last_name`) VALUES ("Donald", "Trump"),	 ("Nikola", "Tesla"), ("Mao", "Dzedun");


•	3_3
ALTER TABLE employees
ADD COLUMN `middle_name` VARCHAR(100);
•	3.4
ALTER TABLE products
ADD CONSTRAINT fk_products_categories
FOREIGN KEY products(category_id)
REFERENCES categories(id);
•	3.5
ALTER TABLE employees
MODIFY COLUMN `middle_name` VARCHAR(100);

