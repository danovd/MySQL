<!--Database Basics MySQL Exam - 15 October 2022

<!--1.
 CREATE TABLE products(
`id` INT PRIMARY KEY auto_increment,
`name` VARCHAR(30) unique NOT NULL,
`type` VARCHAR(30) NOT NULL,
`price` DECIMAL (10, 2) NOT NULL
);


CREATE TABLE orders_products(
`order_id` INT NOT NULL,
`product_id` INT NOT NULL);


CREATE TABLE orders(
`id` INT PRIMARY KEY auto_increment,
`table_id` INT NOT NULL,
`waiter_id` INT NOT NULL,
`order_time` TIME NOT NULL,
`payed_status` BOOLEAN 
);

CREATE TABLE waiters(
`id` INT PRIMARY KEY auto_increment,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL,
`email` VARCHAR(50) NOT NULL,
`phone` VARCHAR(50),
`salary` DECIMAL(10, 2)
);

CREATE TABLE `tables`(
`id` INT PRIMARY KEY auto_increment,
`floor` INT NOT NULL,
`reserved` BOOL,
`capacity` INT NOT NULL
);

CREATE TABLE orders_clients(
`order_id` INT NOT NULL,
`client_id` INT NOT NULL
);

CREATE TABLE clients(
`id` INT PRIMARY KEY auto_increment,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50)NOT NULL,
`birthdate` DATE NOT NULL,
`card` VARCHAR(50),
`review` TEXT 
);

ALTER TABLE orders_products 
ADD constraint fk_order
foreign key (order_id)
REFERENCES orders(id),
ADD constraint fk_product
foreign key (product_id)
references products(id);

ALTER TABLE orders_clients
ADD CONSTRAINT fk_order2
foreign key (order_id)
REFERENCES orders(id),
ADD CONSTRAINT fk_client
FOREIGN KEY (client_id)
REFERENCES clients(id);


ALTER TABLE orders
ADD CONSTRAINT fk_orders_tables
FOREIGN KEY (table_id)
REFERENCES tables(id),
ADD CONSTRAINT fk_orders_waiters
FOREIGN KEY (waiter_id)
REFERENCES waiters(id);



<!--2. 
INSERT INTO products (`name`, `type`, `price`)
(SELECT concat(w.last_name, ' ', "specialty"), "Cocktail", ceiling(w.salary * 0.01) 
FROM waiters AS w WHERE w.id > 6)


<!--3.
UPDATE orders AS o SET o.table_id = o.table_id - 1
WHERE o.id >= 12 AND o.id <= 23;


<!--4.
DELETE FROM waiters
WHERE id NOT IN (
    SELECT waiter_id
    FROM orders);


<!--5.
SELECT * from clients
ORDER BY birthdate DESC, id DESC;


<!--6.
SELECT first_name, last_name, birthdate, review FROM clients
WHERE card IS NULL AND YEAR(birthdate) BETWEEN 1978 AND 1993
ORDER By last_name DESC, id 
LIMIT 5


<!--7.
SELECT concat(last_name, first_name, CHARACTER_LENGTH(first_name), "Restaurant") AS `username`, 
reverse(SUBSTRING(`email`, 2, 12)) AS `password`
FROM waiters
WHERE salary is not NULL
ORDER BY `password` DESC;


<!--8.
SELECT p.id, p.`name`, count(op.product_id) AS c 
FROM products AS p
JOIN orders_products AS op ON p.id = product_id
JOIN orders AS o ON op.order_id = o.id
GROUP BY op.product_id
HAVING c >= 5
ORDER BY c DESC, p.`name` ASC;


<!--9.
SELECT t.id AS table_id, t.capacity AS capacity, count(oc.order_id) AS count_clients,
IF(capacity > count(oc.order_id), "Free seats", 
IF(capacity = count(oc.order_id), "Full", IF(capacity < count(oc.order_id), "Extra", "")))
AS availability
FROM tables AS t 
JOIN orders AS o ON t.id = o.table_id
JOIN orders_clients AS oc ON o.id = oc.order_id
JOIN clients AS c ON oc.client_id = c.id
WHERE t.floor = 1
GROUP BY t.id
ORDER BY t.id DESC


<!--9. ВТОРИ НАЧИН
SELECT t.id AS table_id, t.capacity AS capacity, COUNT(oc.order_id) AS count_clients,
    CASE
        WHEN t.capacity > COUNT(oc.order_id) THEN 'Free seats'
        WHEN t.capacity = COUNT(oc.order_id) THEN 'Full'
        WHEN t.capacity < COUNT(oc.order_id) THEN 'Extra seats'
    END AS availability
FROM tables AS t
JOIN orders AS o ON t.id = o.table_id
JOIN orders_clients AS oc ON o.id = oc.order_id
JOIN clients AS c ON oc.client_id = c.id
WHERE t.floor = 1
GROUP BY t.id
ORDER BY t.id DESC;


<!--10.
CREATE FUNCTION udf_client_bill(_fN VARCHAR(50))
RETURNS DECIMAL(19,2)
DETERMINISTIC
BEGIN
    DECLARE result DECIMAL(19,2);
    SET result := (
        SELECT SUM(price) AS total_price 
        FROM products AS p
        JOIN orders_products AS op ON p.id = op.product_id
        JOIN orders AS o ON op.order_id = o.id
        JOIN orders_clients AS oc ON o.id = oc.order_id
        JOIN clients AS c ON oc.client_id = c.id
        WHERE CONCAT(c.first_name, " ", c.last_name) = _fN
    );
    RETURN result;
END


<!--11.
DELIMITER $$
CREATE PROCEDURE udp_happy_hour(`_type` VARCHAR(50))
BEGIN
UPDATE products SET price = price * 0.8 WHERE price >= 10 AND `type` = `_type`;
END $$

