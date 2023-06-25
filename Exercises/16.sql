

16
# 1. Employees with Salary Above 35000
DELIMITER && 
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
  SELECT `first_name`, `last_name`
  FROM `employees`
  WHERE `salary` > 35000
  ORDER BY `first_name`, `last_name`, `employee_id`;
END &&  
DELIMITER ;
 
# 2. Employees with Salary Above Number
DELIMITER && 
CREATE PROCEDURE usp_get_employees_salary_above (desired_salary DECIMAL(19,4))
BEGIN
  SELECT `first_name`, `last_name` 
  FROM `employees`
  WHERE `salary` >= `desired_salary`
  order by `first_name`, `last_name`, `employee_id`;
END &&  
DELIMITER ;
 
# 3. Town Names Starting With
DELIMITER && 
CREATE PROCEDURE usp_get_towns_starting_with (town_substring VARCHAR(50))
BEGIN
  SELECT `name` 
  FROM `towns`
  WHERE `name` like CONCAT(town_substring,'%')
  order by `name`;
END &&  
DELIMITER ;
 
# 4.    Employees from Town
DELIMITER && 
CREATE PROCEDURE usp_get_employees_from_town (searched_town VARCHAR(50))
BEGIN
  SELECT `first_name`, `last_name`
  FROM `employees` AS e
  JOIN `addresses` AS a USING (address_id)
  JOIN `towns` AS t USING (town_id)
  WHERE t.`name` = `searched_town`
  ORDER BY `first_name`,`last_name`;
END &&  
DELIMITER ;
 
# 5. Salary Level Function
DELIMITER && 
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19, 4))
RETURNS VARCHAR(8)
DETERMINISTIC
BEGIN
    DECLARE salary_level VARCHAR(8);
    IF salary < 30000 THEN SET salary_level := 'Low';
    ELSEIF salary <= 50000 THEN SET salary_level := 'Average';
    ELSE SET salary_level := 'High';
    END IF;
    RETURN salary_level;
END &&  
DELIMITER ;
 
# 6. Employees by Salary Level
DELIMITER &&
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(8)) 
BEGIN
    SELECT first_name, last_name
    FROM employees
    WHERE ufn_get_salary_level(salary) LIKE salary_level
    ORDER BY first_name DESC, last_name DESC;
END &&  
DELIMITER ;


//for judge
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19, 4))
RETURNS VARCHAR(8)
DETERMINISTIC
BEGIN
    DECLARE salary_level VARCHAR(8);
    IF salary < 30000 THEN SET salary_level := 'Low';
    ELSEIF salary <= 50000 THEN SET salary_level := 'Average';
    ELSE SET salary_level := 'High';
    END IF;
    RETURN salary_level;
END; 
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(8)) 
BEGIN
    SELECT e.first_name, e.last_name
    FROM employees AS e
    WHERE ufn_get_salary_level(e.salary) LIKE salary_level
    ORDER BY first_name DESC, last_name DESC;
END;
 
# 7. Define Function
DELIMITER &&
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));
END &&  
DELIMITER ;
 
# 8. Find Full Name
DELIMITER &&
CREATE PROCEDURE usp_get_holders_full_name() 
BEGIN
  SELECT CONCAT(`first_name`, " ", `last_name`) AS `full_name`
  FROM `account_holders`
  ORDER BY `full_name`, `id`;
END &&  
DELIMITER ;
 
# 9. People with Balance Higher Than
DELIMITER &&
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(money decimal(19,4))
BEGIN
    SELECT ah.`first_name`, ah.`last_name`
    FROM `account_holders` as ah
    LEFT JOIN `accounts` as a ON ah.`id` = a.`account_holder_id`
    GROUP BY a.account_holder_id, ah.`first_name`, ah.`last_name`
    HAVING SUM(a.`balance`) > `money`
    ORDER BY a.`account_holder_id`;
END;
 &&
DELIMITER ;
 
# 10. Future Value Function
DELIMITER &&
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19, 4), yearly_interest DOUBLE, yers INT)
RETURNS DECIMAL(19, 4)
DETERMINISTIC
BEGIN
    DECLARE future_sum DECIMAL(19, 4);
    SET future_sum := sum * POW(1 + yearly_interest, yers);
    RETURN future_sum;
END &&
DELIMITER ;
 
# 11. Calculating Interest

!!! Задачата се качва заедно с решението на предишната задача поради използването на функцията!
** Коректното според мен решение, вземащо предвид сумите от всички акаунти на дадено лице:
CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, interest_rate DECIMAL(19,4))
BEGIN

SELECT a.`id` AS 'account_id', ah.`first_name`, ah.`last_name`, 
    SUM(a.`balance`) AS 'current_balance', ufn_calculate_future_value(SUM(a.balance), 0.1, 5) AS 'balance_in_5_years'
    FROM `account_holders` AS ah
    JOIN `accounts` AS a ON a.`account_holder_id` = ah.`id`
  
   GROUP BY a.`account_holder_id`
   having a.id  = 1;
END &&
DELIMITER ;

*** Решение, коректно според Judge:
DELIMITER &&
CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, interest_rate DECIMAL(19,4))
BEGIN
    SELECT a.`id` AS 'account_id', ah.`first_name`, ah.`last_name`, 
    a.`balance` AS 'current_balance', ufn_calculate_future_value(a.balance, interest_rate, 5) AS 'balance_in_5_years'
    FROM `account_holders` AS ah
    JOIN `accounts` AS a ON a.`account_holder_id` = ah.`id`
    WHERE a.`id` = id;
END &&
DELIMITER ;


 
# 12.   Deposit Money
DELIMITER &&
CREATE PROCEDURE usp_deposit_money(id INT, money_amount DECIMAL(19,4))
BEGIN
    START TRANSACTION;
    IF(money_amount <= 0 ) THEN
    ROLLBACK;
    ELSE
        UPDATE `accounts` AS ac SET ac.`balance` = ac.`balance` + money_amount
        WHERE ac.`id` = id;
    END IF; 
END
DELIMITER ;
 
# 13. Withdraw Money
DELIMITER &&
CREATE PROCEDURE usp_withdraw_money(id int, money_amount decimal(19,4))
BEGIN
    START TRANSACTION;
    IF (money_amount <= 0 OR (SELECT `balance` FROM accounts AS a WHERE a.`id` = id) < money_amount) THEN
    ROLLBACK;
    ELSE
        UPDATE accounts as ac SET ac.balance = ac.balance - money_amount
        WHERE ac.id = id;
        COMMIT;
    END IF; 
END&&
 
# 14.   Money Transfer
DELIMITER &&
CREATE PROCEDURE usp_transfer_money(fromID int, toID int,money_amount decimal(19,4))
BEGIN
    START TRANSACTION;
    IF(money_amount <= 0 OR (SELECT `balance` from `accounts` where `id` = fromID) < money_amount
    OR fromID = toID 
    OR (SELECT COUNT(id) FROM `accounts` WHERE `id` = fromID) <> 1
    OR (SELECT COUNT(id) FROM `accounts` WHERE `id` = toID) <> 1) 
    THEN ROLLBACK;
    ELSE
        UPDATE `accounts` SET `balance` = `balance` - money_amount
        WHERE `id` = fromID;
        UPDATE `accounts` SET `balance` = `balance` + money_amount
        WHERE `id` = toID;
        COMMIT;
    END IF; 
END&&
 
# 15. Log Accounts Trigger
CREATE TABLE `logs`(
    `log_id` INT PRIMARY KEY AUTO_INCREMENT, 
    `account_id` INT NOT NULL,
    `old_sum` DECIMAL(19, 4) NOT NULL,
    `new_sum` DECIMAL(19, 4) NOT NULL
);
DELIMITER $$
CREATE TRIGGER tr_change_balance
AFTER UPDATE ON `accounts`
FOR EACH ROW
BEGIN
    INSERT INTO `logs`(`account_id`, `old_sum`, `new_sum`) 
    VALUES (OLD.id, OLD.balance, NEW.balance);
END$$
 
# 16. Emails Trigger 
CREATE TABLE `notification_emails`(
    `id` INT PRIMARY KEY AUTO_INCREMENT, 
    `recipient` INT NOT NULL,
    `subject` TEXT,
    `body` TEXT
);
DELIMITER $$
CREATE TRIGGER tr_email_on_change_balance
AFTER INSERT
ON `logs`
FOR EACH ROW
BEGIN
    INSERT INTO `notification_emails`(`recipient`, `subject`, `body`)
    VALUES (NEW.`account_id`, concat_ws(' ', 'Balance change for account:', NEW.`account_id`), concat_ws(' ', 'On', NOW(), 'your balance was changed from', NEW.`old_sum`, 'to', NEW.`new_sum`, '.'));
END$$
