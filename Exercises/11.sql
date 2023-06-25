11 TABLE RELATIONS
11.1
CREATE TABLE Mountains(
id INT PRIMARY KEY auto_increment,
`name` VARCHAR(255) NOT NULL
);

CREATE TABLE Peaks(
id INT PRIMARY KEY auto_increment,
`name` VARCHAR(255) NOT NULL,
mountain_id INT NOT NULL
);

ALTER TABLE Peaks
ADD CONSTRAINT fk_peaks_mountain
FOREIGN KEY (`mountain_id`)
REFERENCES Mountains(`id`);
11.2
SELECT v.driver_id, v.vehicle_type, 
concat(c.first_name, ' ', c.last_name) AS 'driver_name'
FROM vehicles AS v JOIN campers AS c ON v.driver_id = c.id;
11.3
SELECT 
r.starting_point AS route_starting_point, 
r.end_point AS route_ending_point,
r.leader_id,
concat_ws(' ', c.first_name, c.last_name) AS leader_name

 FROM routes AS r
JOIN campers AS c ON r.leader_id = c.id

11.4
CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);

CREATE TABLE `peaks`(
`id` INT PRIMARY KEY auto_increment,
`name` VARCHar(200) NOT NULL, 
`mountain_id` INT, 
CONSTRAINT `fk_peaks_mountains`
FOREIGN KeY (mountain_id)
REFERENCES mountains(`id`)
ON DELETE CASCADE
);
