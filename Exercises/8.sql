
8
# 1. Find Names of All Employees by First Name
SELECT `first_name`, `last_name` from `employees`
WHERE `first_name` LIKE 'Sa%'
ORDER BY `employee_id`;
 
# 2. Find Names of All Employees by Last Name
SELECT `first_name`, `last_name` from `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`;
 
# 3. Find First Names of All Employees
SELECT `first_name` from `employees`
WHERE `department_id` IN (3,10)
AND 
year(`hire_date`) BETWEEN 1995 and 2005
ORDER BY `employee_id`;
 
# 4. Find All Employees Except Engineers
SELECT `first_name`, `last_name` from `employees`
WHERE `job_title` NOT LIKE '%engineer%'
ORDER BY `employee_id`;
 
# 5. Find Towns with Name Length
SELECT `name` from `towns`
WHERE char_length(`name`) = 5 OR char_length(`name`) = 6
ORDER BY `name`;
 
# 6. Find Towns Starting With
SELECT * FROM `towns`
WHERE `name` LIKE ('m%') OR `name` LIKE ('k%') OR `name` LIKE ('b%') OR `name` LIKE ('e%')
ORDER BY `name`;

### 
SELECT `town_id` ,`name` FROM `towns`
WHERE `name`  REGEXP '^[mkbe].*'
ORDER BY `name`; 
###
# 7. Find Towns Not Starting With
SELECT * FROM `towns`
WHERE `name` NOT LIKE ('r%') AND `name` NOT LIKE ('b%') AND `name` NOT LIKE ('d%')
ORDER BY `name`;
 
# 8. Create View Employees Hired After
CREATE VIEW v_employees_hired_after_2000 as 
SELECT `first_name`, `last_name` FROM `employees`
WHERE  year(hire_date) > 2000;
SELECT * FROM v_employees_hired_after_2000;
 
# 9. Length of Last Name
SELECT `first_name`, `last_name` FROM `employees`
WHERE char_length(`last_name`) = 5;
 
# 10.   Countries Holding 'A' 3 or More Times
SELECT `country_name`, `iso_code` FROM `countries`
WHERE `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code`;
 
# 11. Mix of Peak and River Names
SELECT 
    `peak_name`,
    `river_name`,
    CONCAT(LOWER(`peak_name`), SUBSTRING(LOWER(`river_name`),2)) AS mix
FROM
    peaks,
    rivers
WHERE
    RIGHT(`peak_name`, 1) = LEFT(LOWER(`river_name`), 1)
ORDER BY mix;
 
# 12. Games From 2011 and 2012 Year
SELECT `name`, date_format(`start`, '%Y-%m-%d') AS `start` FROM `games`
WHERE year(`start`) >= 2011 AND year(`start`) <= 2012  
ORDER BY `start`, `name`
LIMIT 50;
 
# 13. User Email Providers
SELECT `user_name`, substring(`email`, locate('@', email) + 1) AS 'Email Provider' FROM `users` 
ORDER BY `Email Provider`, `user_name`;
 
# 14. Get Users with IP Address Like Pattern
SELECT `user_name`, `ip_address` FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;
 
# 15. Show All Games with Duration
SELECT `name` as 'game',
CASE
WHEN hour(`start`) < 12 THEN 'Morning'
WHEN hour(`start`) < 18 THEN 'Afternoon'
ELSE 'Evening'
END 
AS 'Part of the Day',
CASE
WHEN `duration` <= 3 THEN 'Extra Short'
WHEN `duration` <= 6 THEN 'Short'
WHEN `duration` <= 10 THEN 'Long'
ELSE 'Extra Long'
END 
AS 'Duration'
FROM `games`;
 
# 16. Orders Table
SELECT `product_name`, `order_date`,
adddate(`order_date`, interval 3 day) as pay_due, 
adddate(`order_date`, interval 1 month) as deliver_due
FROM `orders`;
