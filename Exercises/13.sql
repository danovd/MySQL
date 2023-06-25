13

13.1
SELECT e.employee_id, concat_ws(" ", e.first_name, e.last_name) AS full_name, 
d.department_id, d.`name` 
FROM employees AS e  JOIN departments AS d ON 
e.employee_id = d.manager_id
ORDER BY e.employee_id
LIMIT 5;

13.2
SELECT t.town_id, t.`name`, a.address_text 
FROM towns as t
JOIN addresses AS a ON a.town_id = t.town_id 
WHERE t.`name` LIKE '%San Francisco%'  OR t.`name` LIKE '%Sofia%' OR 
t.`name` LIKE '%Carnation%'
ORDER BY t.town_id, a.address_id;
13.3
SELECT e.employee_id, e.first_name, e.last_name, e.department_id, e.salary
FROM employees AS e
WHERE e.manager_id IS null
13.4
SELECT COUNT(*) FROM employees
WHERE salary > (
SELECT AVG(salary) FROM employees
);

