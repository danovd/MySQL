15
15.1
DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE id_for_town INT;
    DECLARE count_by_town INT;
    
    SET id_for_town := (SELECT `town_id` FROM `towns` WHERE `name` = town_name);
    SET count_by_town := (SELECT COUNT(*) FROM `employees` AS `e` 
    WHERE `e`.`address_id` IN (SELECT `address_id` FROM `addresses`
    WHERE `town_id` = id_for_town)
    );
	
  RETURN count_by_town;
  END$$
2
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN

UPDATE `employees` SET `salary` = `salary` * 1.05
WHERE `department_id` = (
SELECT `department_id` FROM `departments` WHERE `name` = department_name
);
END
3
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	START TRANSACTION;
	IF((SELECT count(employee_id) FROM employees WHERE employee_id like id)<>1) THEN
	ROLLBACK;
	ELSE
		UPDATE employees AS e SET salary = salary + salary*0.05 
		WHERE e.employee_id = id;
	END IF; 
END




4
CREATE TABLE deleted_employees(
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	middle_name VARCHAR(20),
	job_title VARCHAR(50),
	department_id INT,
	salary DOUBLE 
);
CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
INSERT INTO deleted_employees (first_name,last_name,                   middle_name,job_title,department_id,salary)
	VALUES(OLD.first_name,OLD.last_name,OLD.middle_name,		    OLD.job_title,OLD.department_id,OLD.salary);
END;

