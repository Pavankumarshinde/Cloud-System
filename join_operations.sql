select * from employees;
select * from employees order by first_name ASC;  -- order by .
select * from employees limit 4; -- will not print after limit .
select * from employees offset 4; -- will skipps first 4 rows,
select distinct * from employees;
-- Create student table
CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50),
    teacher_id INT
);












-- Create student table
CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50),
    teacher_id INT
);

-- Create teacher table
CREATE TABLE teacher (
    teacher_id SERIAL PRIMARY KEY,
    teacher_name VARCHAR(50)
);


-- Insert data into teacher table
INSERT INTO teacher (teacher_name) VALUES
('Mr. Smith'),
('Ms. Johnson'),
('Dr. Brown');
INSERT INTO teacher (teacher_name) VALUES ('MR. sharma');
INSERT INTO teacher (teacher_name) VALUES (NULL);


-- Insert data into student table
INSERT INTO student (student_name, teacher_id) VALUES
('Alice', 1),
('Bob', 2),
('Charlie', 3),
('Daisy', NULL);
insert into student(student_name, teacher_id) values('Charm', 3);

select * from teacher;
select * from student


-- INNER JOIN Returns rows with matching teacher_id in both tables
SELECT s.student_name, t.teacher_name
FROM student s
INNER JOIN teacher t
ON s.teacher_id = t.teacher_id;

-- LEFT JOIN
SELECT s.student_name, t.teacher_name
FROM student s
LEFT JOIN teacher t
ON s.teacher_id = t.teacher_id;

-- RIGHT JOIN
SELECT s.student_name, t.teacher_name
FROM student s
RIGHT JOIN teacher t
ON s.teacher_id = t.teacher_id;

-- FULL OUTER JOIN
SELECT s.student_name, t.teacher_name
FROM student s
FULL OUTER JOIN teacher t
ON s.teacher_id = t.teacher_id;

-- CROSS JOIN
SELECT s.student_name, t.teacher_name
FROM student s
CROSS JOIN teacher t;

-- SELF JOIN
SELECT s1.student_name AS Student1, s2.student_name AS Student2
FROM student s1
JOIN student s2
ON s1.teacher_id = s2.teacher_id
WHERE s1.student_id != s2.student_id;




 -- 7. Aggregate Functions

 select count(*) from student;
 select * from student;
 select sum(teacher_id) from student;
 select avg(teacher_id) from student;
select min(teacher_id) from student;
select max(teacher_id) from student;

select length(student_name) from student;
select lower(student_name) from student;
select upper(student_name) from student;
UPDATE public.student
	SET student_name=upper(student_name);
select * from student;

select concat(student_name ,' ', teacher_id) from student;

ALTER TABLE teacher
ADD COLUMN joining_date DATE;
select * from teacher;

update teacher set joining_date=(now());4
update teacher set joining_date=(current_date);
update teacher set joining_date=(current_time);



ALTER TABLE teacher
ADD COLUMN teacher_salary NUMERIC(10, 2);

select * from teacher;
UPDATE teacher
SET teacher_salary = CASE 
    WHEN teacher_id = 1 THEN 1200
    WHEN teacher_id = 2 THEN 800
    WHEN teacher_id = 3 THEN 450
    ELSE 0
END;

SELECT teacher_id, teacher_name, teacher_salary,
CASE 
    WHEN teacher_salary > 1000 THEN 'High Salary'
    WHEN teacher_salary > 500 THEN 'Medium Salary'
    ELSE 'Low Salary'
END AS salary_status
FROM teacher;




-- UNION, Intersection, except.
-- Add department column to student table
ALTER TABLE student ADD COLUMN department VARCHAR(50);

-- Add department column to teacher table
ALTER TABLE teacher ADD COLUMN department VARCHAR(50);


-- Update department column in student table
UPDATE student
SET department = CASE
    WHEN student_id = 1 THEN 'Physics'
    WHEN student_id = 2 THEN 'Math'
    WHEN student_id = 3 THEN 'Computer Science'
    ELSE 'Biology'
END;

-- Update department column in teacher table
UPDATE teacher
SET department = CASE
    WHEN teacher_id = 1 THEN 'Physics'
    WHEN teacher_id = 2 THEN 'Math'
    WHEN teacher_id = 3 THEN 'History'
END;


SELECT department FROM student
UNION
SELECT department FROM teacher;

SELECT department FROM student
INTERSECT
SELECT department FROM teacher;

SELECT department FROM student
EXCEPT
SELECT department FROM teacher;


-- commit & rollback
-- COMMIT: Saves all changes made during the transaction to the database.
-- ROLLBACK: Reverts all changes made during the transaction, restoring the table to its state before the transaction began.

BEGIN TRANSACTION;

-- Insert a new teacher
INSERT INTO teacher (teacher_name, department, teacher_salary, joining_date)
VALUES ('Dr. Adams', 'Biology', 1500.00, NOW());

-- Update teacher salary for 'Ms. Johnson'
UPDATE teacher
SET teacher_salary = 900.00
WHERE teacher_name = 'Ms. Johnson';

-- Commit the transaction
COMMIT;


select * from teacher;
BEGIN TRANSACTION;

-- Insert another teacher
INSERT INTO teacher (teacher_name, department, teacher_salary, joining_date)
VALUES ('Prof. Carter', 'Computer Science', 2000.00, NOW());

-- Update salary for 'Dr. Adams'
UPDATE teacher
SET teacher_salary = 1700.00
WHERE teacher_name = 'Dr. Adams';

-- Rollback the transaction
ROLLBACK;


-- USE of some Functions:

select * from teacher;

UPDATE teacher
SET teacher_salary = 1700.00, department='Biology'
WHERE teacher_name = 'MR. sharma';

UPDATE teacher
SET teacher_salary = 1700.00, department='Physics'
WHERE teacher_name = NULL;

drop table teacher;

select * from teacher;

SELECT
    department,
    teacher_name,
    teacher_salary,
    AVG(teacher_salary) OVER (PARTITION BY department) AS avg_salary_dept
FROM teacher;

-- Columns Selected:

-- department: Groups teachers by their department.
-- teacher_name: Shows the name of each teacher.
-- teacher_salary: Displays the salary of each teacher.
-- AVG(teacher_salary) OVER (PARTITION BY department): Calculates the average salary for all teachers within the same department.
-- OVER (PARTITION BY department):

-- Partitions the rows by the department column.
-- Calculates the average salary (AVG) for each department group.


-- WITH KEYWORD


WITH top_departments AS (
    SELECT 
        department, 
        SUM(teacher_salary) AS total_salary
    FROM teacher
    GROUP BY department
    ORDER BY total_salary DESC
    
)
SELECT * FROM top_departments;

select * from teacher;


select * from teacher order by teacher_salary DESC LIMIT 3;

SELECT 
        teacher_name, 
        department,
        teacher_salary
    FROM teacher
    ORDER BY teacher_salary DESC
    LIMIT 2;

WITH top_teachers AS (
    SELECT 
        teacher_name, 
        department,
        teacher_salary
    FROM teacher
    ORDER BY teacher_salary DESC
    LIMIT 2
)
SELECT * FROM top_teachers;


-- creating virtual view:

CREATE VIEW teacher_salary_summary2 AS
SELECT 
    department,
    COUNT(teacher_id) AS teacher_count,
    SUM(teacher_salary) AS total_salary,
    AVG(teacher_salary) AS avg_salary
FROM teacher
GROUP BY department;




SELECT * FROM teacher_salary_summary;


-- 
select * from teacher;
CREATE MATERIALIZED VIEW teacher_salary_summary_mv2 AS
SELECT 
	department,
    COUNT(teacher_id) AS teacher_count,
    SUM(teacher_salary) AS total_salary,
    AVG(teacher_salary) AS avg_salary
FROM teacher
GROUP BY department;

REFRESH MATERIALIZED VIEW teacher_salary_summary_mv;

SELECT * FROM teacher_salary_summary_mv;
select * from teacher_salary_summary;


-- Explanation of query : Execuate the query and provide the analysis.
-- EXPLAIN ANALYZE 
SELECT 
    department, 
    SUM(teacher_salary) AS total_salary
FROM teacher
WHERE department LIKE 'P%'
 '%khan'
GROUP BY department;

select * from teacher where lower(teacher_name) LIKE lower('MR%');



-- generating rows; entries in a table.


CREATE TABLE customers2 (
 customer_id SERIAL PRIMARY KEY,
 first_name VARCHAR(50) NOT NULL,
 last_name VARCHAR(50) NOT NULL,
 email VARCHAR(100) UNIQUE,
 city VARCHAR(50),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

 select * from customers2;



 

 INSERT INTO customers2 (first_name, last_name, email, city)
 SELECT 
'John' || i, 'Doe' || i, 
'john.doe' || i || '@gmail.com', 
'City' || (i % 100)
FROM generate_series(1, 10000) AS s(i);


select * from customers2;




CREATE TABLE orders2 (
 order_id SERIAL PRIMARY KEY,
 customer_id INT REFERENCES customers2(customer_id),
 order_date DATE DEFAULT CURRENT_DATE,
 total_amount NUMERIC(10, 2) NOT NULL,
 status VARCHAR(20) CHECK (status IN ('Pending', 'Shipped', 
'Delivered', 'Cancelled'))
 );

select * from orders2;






select random() ;
select (0.8836841497307899* 9999 +1)::int;

INSERT INTO orders2 (customer_id, order_date, total_amount, status)
SELECT 
    (random() * 9999 + 1)::int AS customer_id, -- Random customer_id between 1 and 10000

	
    CURRENT_DATE - (random() * 365)::int AS order_date, -- Random date in the last year
    ROUND((random() * 980 + 20)::numeric, 2) AS total_amount, -- Random total amount between 20 and 1000
	
    CASE 
        WHEN random() < 0.25 THEN 'Pending'
        WHEN random() < 0.5 THEN 'Shipped'
        WHEN random() < 0.75 THEN 'Delivered'
        ELSE 'Cancelled'
    END AS status
FROM generate_series(1, 10000); -- Generate 10,000 rows

 select * from orders2;


-- big order,  medium  order, or small size order. total amount=800 to 1000, 500 to 800 , else 



 
alter table orders2 
add column order_type  varchar(50);


update orders2 set order_type = case 
when total_amount >800 then 'big order'
when total_amount >500 then 'medium order'
else 'small order'
end;

select * from orders2;

