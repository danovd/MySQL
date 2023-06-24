<!--Database Basics MySQL Exam - 13 February 2022
<!--1.

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) UNIQUE NOT NULL
);


CREATE TABLE brands(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) UNIQUE NOT NULL 
);  
  
  
CREATE TABLE reviews(
id INT PRIMARY KEY AUTO_INCREMENT,
content TEXT,
rating DECIMAL(10, 2) NOT NULL,
picture_url VARCHAR(80) NOT NULL,
published_at DATETIME NOT NULL
);

CREATE TABLE products(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL,
price DECIMAL(19,2) NOT NULL,
quantity_in_stock INT,
`description` TEXT,
brand_id INT NOT NULL, 
category_id INT NOT NULL,
review_id INT NOT NULL  
);

CREATE TABLE customers(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
phone VARCHAR(30) UNIQUE NOT NULL,
address VARCHAR(60) NOT NULL,
discount_card BIT(1) DEFAULT FALSE NOT NULL
);

CREATE TABLE orders(
id INT PRIMARY KEY AUTO_INCREMENT,
order_datetime DATETIME NOT NULL,
customer_id INT NOT NULL
);

CREATE TABLE orders_products(
order_id INT NOT NULL,
product_id INT NOT NULL
);

ALTER TABLE orders
ADD CONSTRAINT fk_customer_id
foreign key (customer_id)
REFERENCES customers(id);

ALTER TABLE orders_products
ADD CONSTRAINT fk_order_id
FOREIGN KEY (order_id)
REFERENCES orders(id),
ADD CONSTRAINT fk_product_id
FOREIGN KEY (product_id)
REFERENCES products(id);

ALTER TABLE products
ADD CONSTRAINT fk_reviews
FOREIGN KEY (review_id)
REFERENCES reviews(id),
ADD CONSTRAINT fk_brand
FOREIGN KEY (brand_id)
REFERENCES brands(id),
ADD CONSTRAINT fk_category
FOREIGN KEY (category_id)
REFERENCES categories(id);
<!--2.
INSERT INTO reviews (`content`, `picture_url`, `published_at`, `rating`)
SELECT LEFT(p.description, 15),  REVERSE(p.`name`), DATE('2010/10/10'), p.price / 8
FROM products AS p WHERE p.id >= 5;
<!--3.
UPDATE products AS p
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock BETWEEN 60 AND 70;
<!--4.
DELETE c FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.customer_id IS NULL;
<!--5.
SELECT * from categories c
ORDER BY c.name desc;
<!--6.
SELECT p.id AS product_id, b.id AS brand_id, p.`name` AS `name`, p.`quantity_in_stock` AS quantity from products AS p
JOIN brands AS b ON p.brand_id = b.id
WHERE p.price > 1000 AND p.quantity_in_stock < 30
ORDER BY p.quantity_in_stock, p.id;
<!--7.
SELECT id, content, rating, picture_url, published_at FROM reviews
WHERE LEFT(content, 2) = 'My' AND CHAR_LENGTH(content) > 61  
ORDER BY rating DESC;
<!--8.
SELECT concat(c.`first_name`, ' ', c.`last_name`) AS full_name, c.address, o.order_datetime AS order_date FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id
WHERE YEAR(o.order_datetime) <= 2018
ORDER BY full_name DESC
<!--9.
SELECT count(c.id) AS items_count, c.`name`, sum(p.quantity_in_stock) AS total_quantity FROM categories AS c
JOIN products AS p ON c.id = p.category_id
GROUP BY c.id
ORDER BY count(c.id) desc, sum(p.quantity_in_stock)
limit 5
<!--10.
CREATE FUNCTION udf_customer_products_count(_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE result INT; 
SET result = (SELECT count(3) FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id
JOIN orders_products AS op ON o.id = op.order_id
Join products AS p ON op.product_id = p.id
WHERE c.first_name = _name);
RETURN result;
END
<!--11.
CREATE PROCEDURE udp_reduce_price (category_name VARCHAR(50))
BEGIN
UPDATE products AS p
JOIN categories AS c ON p.category_id = c.id
JOIN reviews AS r ON r.id = p.review_id
SET p.price = price * 0.70
WHERE c.name = category_name
AND r.rating < 4; 
END
