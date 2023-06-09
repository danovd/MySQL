/* 1 */
CREATE TABLE pictures (
    id INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(100) NOT NULL,
    added_on DATETIME NOT NULL
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    best_before DATE,
    price DECIMAL(10, 2),
    description TEXT,
    category_id INT NOT NULL,
    picture_id INT NOT NULL
);


ALTER TABLE products
ADD CONSTRAINT fk_products_categories FOREIGN KEY (category_id)
    REFERENCES categories (id),
ADD CONSTRAINT fk_products_pictures FOREIGN KEY (picture_id)
    REFERENCES pictures (id);


CREATE TABLE towns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    town_id INT NOT NULL
);


ALTER TABLE addresses
ADD CONSTRAINT fk_addresses_towns FOREIGN KEY (town_id)
    REFERENCES towns (id);

CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE,
    rating FLOAT,
    has_parking BOOLEAN,
    address_id INT NOT NULL
);


ALTER TABLE stores
ADD CONSTRAINT fk_stores_addresses FOREIGN KEY (address_id)
    REFERENCES addresses (id);


CREATE TABLE products_stores (
    product_id INT,
    store_id INT,
    PRIMARY KEY (product_id, store_id)
);


ALTER TABLE products_stores
ADD CONSTRAINT fk_products_stores_products FOREIGN KEY (product_id)
    REFERENCES products (id),
ADD CONSTRAINT fk_products_stores_stores FOREIGN KEY (store_id)
    REFERENCES stores (id);


CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(15) NOT NULL,
    middle_name CHAR(1),
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(19, 2) DEFAULT 0,
    hire_date DATE NOT NULL,
    manager_id INT,
    store_id INT NOT NULL
);


ALTER TABLE employees
ADD CONSTRAINT fk_employees_stores FOREIGN KEY (store_id)
    REFERENCES stores (id),
ADD CONSTRAINT fk_employees_employees FOREIGN KEY (manager_id)
    REFERENCES employees (id);


/* 2 */
INSERT INTO products_stores (product_id, store_id)
SELECT id, 1
FROM products AS p
WHERE id NOT IN (SELECT DISTINCT product_id FROM products_stores);


/* 2 Втори начин */
 INSERT INTO products_stores (product_id, store_id)
SELECT p.id, 1
FROM products AS p
LEFT JOIN products_stores AS ps ON p.id = ps.product_id
WHERE ps.product_id IS NULL;


/* 3 */
UPDATE employees AS e
JOIN stores AS s ON e.store_id = s.id
SET e.manager_id = 3, e.salary = e.salary - 500
WHERE YEAR(e.hire_date) >= 2003 AND s.`name` NOT IN ('Cardguard', 'Veribet')  


/* 3 Втори начин */
UPDATE employees
SET manager_id = 3, salary = salary - 500
WHERE hire_date > '2003-01-01' AND store_id NOT IN (
    SELECT id FROM stores WHERE name IN ('Cardguard', 'Veribet')
);


/* 4 */
DELETE FROM employees AS e
WHERE e.id != e.manager_id AND e.salary > 6000;


/* 5 */
SELECT  first_name, middle_name, last_name, salary, hire_date FROM employees
ORDER BY hire_date DESC


/* 6 */
SELECT p.`name` AS product_name, p.price, p.best_before, 
concat(LEFT(p.`description`, 10), '...') AS short_description, pic.url AS url
FROM products AS p 
JOIN pictures AS pic ON p.picture_id = pic.id
WHERE CHAR_LENGTH(p.`description`) > 100 AND YEAR(pic.added_on) < 2019 AND p.price > 20
ORDER BY p.price DESC  


/* 7 */
SELECT s.`name`, count( p.id) AS product_count, ROUND(AVG(p.price), 2) AS `avg` FROM stores As s
left JOIN products_stores As ps ON s.id = ps.store_id
left JOIN products AS p ON ps.product_id = p.id
GROUP BY s.id  
ORDER BY product_count DESC, `avg` DESC, s.id


/* 8 */
SELECT concat(e.first_name, ' ', e.last_name)AS Full_name,
s.`name` AS `Store_name`, a.`name` AS `address`, e.salary FROM employees AS e
JOIN stores AS s ON e.store_id = s.id
JOIN addresses AS a ON s.address_id = a.id 
WHERE e.salary < 4000 AND a.`name` LIKE '%5%' AND CHAR_LENGTH(s.`name`) > 8
AND e.last_name LIKE '%n'


/* 9 */
SELECT  REVERSE(s.`name`) AS reversed_name, concat( UPPER(t.`name`) , '-', a.`name`) AS full_address, 
count(e.id) AS employees_count FROM stores AS s
JOIN employees AS e ON e.store_id = s.id
JOIN addresses AS a ON s.address_id = a.id
JOIN towns AS t ON a.town_id = t.id
GROUP BY s.id
HAVING employees_count >=1
ORDER BY full_address ASC


/* 10 */
CREATE FUNCTION udf_top_paid_employee_by_store(_store_name VARCHAR(50))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE result VARCHAR(255);
SET result = (SELECT concat(e.first_name, ' ', e.middle_name, '. ', e.last_name , ' works in store for ', (2020 - YEAR(e.hire_date)), ' years') AS ww
FROM employees AS e 
JOIN stores AS s ON e.store_id = s.id
WHERE s.`name` = _store_name 
ORDER BY e.salary DESC
LIMIT 1 );
RETURN result;
END


/* 11 */
CREATE PROCEDURE udp_update_product_price (_address_name VARCHAR (50)) 
BEGIN
UPDATE products AS p
JOIN products_stores AS ps ON p.id = ps.product_id
JOIN stores AS s ON s.id = ps.store_id
JOIN addresses AS a ON a.id = s.address_id
SET p.price = p.price + (CASE 
WHEN a.`name` LIKE '0%' THEN 100 
ELSE 200 
END)
WHERE a.`name` = _address_name;
END
