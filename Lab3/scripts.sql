-- Q1
CREATE TABLE Employees (
    emp_id     NUMBER PRIMARY KEY,
    emp_name   VARCHAR2(50),
    salary     NUMBER CHECK (salary > 20000),
    dept_id    NUMBER
);

-- Q2
ALTER TABLE Employees RENAME COLUMN emp_name TO full_name;

-- Q3. Drop the check constraint on salary and insert employee with salary = 5000
ALTER TABLE Employees DROP CONSTRAINT SYS_C001; -- replace SYS_C001 with actual constraint name
INSERT INTO Employees (emp_id, full_name, salary, dept_id) VALUES (1, 'Ali Khan', 5000, NULL);

-- Q4
CREATE TABLE departments (
    dept_id   NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50) UNIQUE
);

INSERT INTO departments VALUES (10, 'HR');
INSERT INTO departments VALUES (20, 'IT');
INSERT INTO departments VALUES (30, 'Finance');

-- Q5
ALTER TABLE Employees
ADD CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
REFERENCES departments (dept_id);

-- Q6
ALTER TABLE Employees
ADD bonus NUMBER(6,2) DEFAULT 1000;

-- Q7
ALTER TABLE Employees
ADD city VARCHAR2(20) DEFAULT 'Karachi';

ALTER TABLE Employees
ADD age NUMBER CHECK (age > 18);

-- Q8
DELETE FROM Employees WHERE emp_id IN (1, 3);

-- Q9
ALTER TABLE Employees MODIFY (full_name VARCHAR2(20));
ALTER TABLE Employees MODIFY (city VARCHAR2(20));

-- Q10
ALTER TABLE Employees
ADD email VARCHAR2(100) UNIQUE;

-- ? POST–LAB TASKS

-- Q11
ALTER TABLE Employees
ADD CONSTRAINT unique_bonus UNIQUE (bonus);

-- Q12
ALTER TABLE Employees
ADD dob DATE;

ALTER TABLE Employees
ADD CONSTRAINT chk_age_18 CHECK (MONTHS_BETWEEN(SYSDATE, dob)/12 >= 18);

-- Q13
INSERT INTO Employees (emp_id, full_name, salary, dept_id, dob, age)
VALUES (2, 'Test Invalid', 25000, 10, DATE '2015-01-01', 10);

-- Q14
ALTER TABLE Employees DROP CONSTRAINT fk_emp_dept;

INSERT INTO Employees (emp_id, full_name, salary, dept_id)
VALUES (3, 'Wrong Dept', 30000, 999); 

ALTER TABLE Employees
ADD CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
REFERENCES departments (dept_id);

-- Q15
ALTER TABLE Employees DROP COLUMN age;
ALTER TABLE Employees DROP COLUMN city;

-- Q16
SELECT d.dept_id, d.dept_name, e.emp_id, e.full_name
FROM departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id;

-- Q17
ALTER TABLE Employees RENAME COLUMN salary TO monthly_salary;

-- Q18
SELECT d.dept_id, d.dept_name
FROM departments d
WHERE d.dept_id NOT IN (SELECT dept_id FROM employees WHERE dept_id IS NOT NULL);

-- Q19
TRUNCATE TABLE students;

-- Q20
SELECT dept_id, COUNT(*) AS emp_count
FROM Employees
GROUP BY dept_id
ORDER BY emp_count DESC
FETCH FIRST 1 ROW ONLY;


