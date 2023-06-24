AGREGATE DATA
9.1  
SELECT department_id, 
COUNT(*) AS 'Number of employees'
FROM employees 
GROUP BY department_id;
9.2 
 SELECT `department_id`, ROUND(AVG(salary), 2)
FROM employees
GROUP BY `department_id`;
9.3 
SELECT `department_id`, ROUND(MIN(salary), 2) AS 'Min Salary'
FROM employees
GROUP BY `department_id`
HAVING `Min Salary` > 800;
9.4
SELECT COUNT(*) AS 'appetizers' FROM `products`
WHERE `category_id` = 2 AND `price` > 8;
9.5
SELECT `category_id`, 
ROUND(AVG(`price`), 2) AS 'Average Price',
ROUND(MIN(`price`), 2) AS 'Cheapest Product',
ROUND(MAX(`price`), 2) AS 'Most Expensive Product'
FROM products
GROUP BY `category_id`
