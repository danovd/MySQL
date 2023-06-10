/* 1 */
CREATE TABLE countries(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cities(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE,
population INT,
country_id INT NOT NULL 
);
CREATE TABLE universities(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(60) NOT NULL UNIQUE,
address VARCHAR(80) NOT NULL UNIQUE,
tuition_fee DECIMAL(19, 2) NOT NULL,
number_of_staff INT,
city_id INT 
);
CREATE TABLE students(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(40) NOT NULL,
last_name VARCHAR(40) NOT NULL,
age INT,
phone VARCHAR(20) NOT NULL UNIQUE,
email VARCHAR(255) NOT NULL UNIQUE, 
is_graduated TINYINT(1) NOT NULL,
city_id INT 
);
CREATE TABLE courses(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE,
duration_hours DECIMAL(19, 2),
start_date DATE,
teacher_name VARCHAR(60) NOT NULL UNIQUE,
`description` TEXT,
university_id INT 
);

CREATE TABLE students_courses(
grade DECIMAL(19,2) NOT NULL,
student_id INT NOT NULL,
course_id INT NOT NULL
);


ALTER TABLE cities
ADD CONSTRAINT fk_countries
FOREIGN KEY (country_id)
REFERENCES countries(id);


ALTER TABLE universities
ADD CONSTRAINT fk_cities
FOREIGN KEY (city_id)
REFERENCES cities(id);

ALTER TABLE courses
ADD CONSTRAINT fk_universities
FOREIGN KEY (university_id)
REFERENCES universities(id);

ALTER TABLE students 
ADD CONSTRAINT fk_cities2
FOREIGN KEY (city_id)
REFERENCES cities(id);


ALTER TABLE students_courses
ADD CONSTRAINT fk_students
FOREIGN KEY (student_id)
REFERENCES students(id),
ADD CONSTRAINT fk_courses
FOREIGN KEY (course_id)
REFERENCES courses(id);

ALTER TABLE students_courses
ADD CONSTRAINT fk_st_student FOREIGN KEY (student_id) REFERENCES students (id),
ADD CONSTRAINT fk_st_course FOREIGN KEY (course_id) REFERENCES courses (id)


/* 2 */
INSERT INTO courses (name, duration_hours, start_date, teacher_name, description, university_id)
SELECT
  CONCAT(teacher_name, ' course'),
  CHAR_LENGTH(name) / 10,
  DATE_ADD(start_date, INTERVAL 5 DAY),
  REVERSE(teacher_name),
  CONCAT('Course ', teacher_name, REVERSE(description)),
  DAY(start_date)
FROM courses
WHERE id <= 5;


/* 3 */
UPDATE universities AS u
SET u.tuition_fee = u.tuition_fee + 300
WHERE u.id >= 5 AND u.id <= 12;

