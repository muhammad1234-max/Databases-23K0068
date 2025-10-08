-- Create sample tables for demonstration
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    job_title VARCHAR(50),
    salary DECIMAL(10,2),
    dept_id INT,
    manager_id INT
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT
);

-- Insert sample data
INSERT INTO departments VALUES 
(10, 'IT', 'New York'),
(20, 'Sales', 'Chicago'),
(30, 'Marketing', 'Boston'),
(40, 'HR', 'Seattle'),
(50, 'Finance', 'Austin');

INSERT INTO employees VALUES 
(101, 'John Smith', 'Manager', 75000, 10, NULL),
(102, 'Jane Doe', 'Developer', 60000, 10, 101),
(103, 'Bob Johnson', 'Sales Rep', 55000, 20, 101),
(104, 'Alice Brown', 'Developer', 62000, 10, 101),
(105, 'Charlie Wilson', 'Analyst', 58000, 30, 101),
(106, 'Diana Lee', 'HR Manager', 65000, 40, NULL),
(107, 'Mike Davis', 'Accountant', 52000, 50, 106);

INSERT INTO projects VALUES 
(1, 'Website Redesign', 10),
(2, 'Sales Portal', 20),
(3, 'Mobile App', 10),
(4, 'Market Research', 30);



-- Cross Join: Every employee combined with every department
-- Results in: (# employees) * (# departments) rows
SELECT 
    e.emp_name,
    d.dept_name
FROM employees e
CROSS JOIN departments d;

-- Traditional Oracle syntax for Cartesian product
SELECT 
    e.emp_name,
    d.dept_name
FROM employees e, departments d;

-- Practical example: Generate all possible employee-department assignments
SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_id,
    d.dept_name
FROM employees e
CROSS JOIN departments d
ORDER BY e.emp_id, d.dept_id;





-- Basic Inner Join: Employees with their departments
SELECT 
    e.emp_id,
    e.emp_name,
    e.job_title,
    d.dept_name,
    d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- Traditional Oracle syntax (WHERE clause join)
SELECT 
    e.emp_id,
    e.emp_name,
    e.job_title,
    d.dept_name
FROM employees e, departments d
WHERE e.dept_id = d.dept_id;

-- Multiple table Inner Join
SELECT 
    e.emp_name,
    d.dept_name,
    p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id;





-- Natural Join (automatically joins on common column names)
-- Note: Both tables must have columns with same name
SELECT 
    emp_id,
    emp_name,
    dept_id,
    dept_name
FROM employees
NATURAL JOIN departments;

-- Using clause to specify join columns explicitly
SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM employees e
JOIN departments d USING (dept_id);

-- Multiple columns in USING clause
-- Assuming both tables have dept_id and location columns
SELECT 
    e.emp_name,
    d.dept_name
FROM employees e
JOIN departments d USING (dept_id, location);






-- Self Join: Find employees and their managers
SELECT 
    worker.emp_id AS employee_id,
    worker.emp_name AS employee_name,
    worker.job_title AS employee_job,
    manager.emp_id AS manager_id,
    manager.emp_name AS manager_name,
    manager.job_title AS manager_job
FROM employees worker
LEFT JOIN employees manager ON worker.manager_id = manager.emp_id;

-- Self Join: Find employees in the same department
SELECT 
    e1.emp_name AS employee1,
    e2.emp_name AS employee2,
    d.dept_name
FROM employees e1
JOIN employees e2 ON e1.dept_id = e2.dept_id AND e1.emp_id < e2.emp_id
JOIN departments d ON e1.dept_id = d.dept_id
ORDER BY d.dept_name, e1.emp_name;




-- Left Outer Join: All employees with their department info
-- Includes employees even if they don't have a department
SELECT 
    e.emp_id,
    e.emp_name,
    e.job_title,
    d.dept_name,
    d.location
FROM employees e
LEFT OUTER JOIN departments d ON e.dept_id = d.dept_id;

-- Traditional Oracle syntax (+ operator)
SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM employees e, departments d
WHERE e.dept_id = d.dept_id(+);

-- Practical example: Find employees without departments
SELECT 
    e.emp_id,
    e.emp_name,
    e.job_title
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

-- Left Join with multiple tables
SELECT 
    e.emp_name,
    d.dept_name,
    p.project_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id;




-- Right Outer Join: All departments with their employees
-- Includes departments even if they have no employees
SELECT 
    d.dept_id,
    d.dept_name,
    e.emp_name,
    e.job_title
FROM employees e
RIGHT OUTER JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name;

-- Traditional Oracle syntax (+ operator)
SELECT 
    d.dept_name,
    e.emp_name
FROM employees e, departments d
WHERE e.dept_id(+) = d.dept_id;

-- Practical example: Find departments without employees
SELECT 
    d.dept_id,
    d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;





-- Full Outer Join: All employees AND all departments
-- Combines results of both Left and Right joins
SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_id,
    d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id
ORDER BY COALESCE(e.dept_id, d.dept_id);

-- Practical example: Complete organizational overview
SELECT 
    COALESCE(e.emp_name, 'No Employee') AS employee_name,
    COALESCE(d.dept_name, 'No Department') AS department_name,
    CASE 
        WHEN e.emp_id IS NULL THEN 'Department without employees'
        WHEN d.dept_id IS NULL THEN 'Employee without department'
        ELSE 'Employee in department'
    END AS status
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;




-- Create additional tables for set operations
CREATE TABLE current_employees AS
SELECT * FROM employees;

CREATE TABLE former_employees AS
SELECT * FROM employees WHERE emp_id IN (102, 105);

CREATE TABLE contractors (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    job_title VARCHAR(50),
    salary DECIMAL(10,2),
    dept_id INT
);

INSERT INTO contractors VALUES 
(201, 'Sarah Chen', 'Developer', 70000, 10),
(202, 'Tom Wilson', 'Designer', 55000, 30),
(203, 'Lisa Garcia', 'Analyst', 60000, 30);





-- UNION: Combine current and former employees, remove duplicates
SELECT 
    emp_id,
    emp_name,
    job_title,
    dept_id
FROM current_employees
UNION
SELECT 
    emp_id,
    emp_name,
    job_title,
    dept_id
FROM former_employees
ORDER BY emp_id;

-- UNION with different tables but same structure
SELECT 
    emp_id,
    emp_name,
    job_title,
    'Employee' AS type
FROM current_employees
UNION
SELECT 
    emp_id,
    emp_name,
    job_title,
    'Contractor' AS type
FROM contractors
ORDER BY type, emp_name;





-- UNION ALL: Combine all records including duplicates
SELECT 
    emp_id,
    emp_name,
    job_title
FROM current_employees
WHERE dept_id = 10
UNION ALL
SELECT 
    emp_id,
    emp_name,
    job_title
FROM contractors
WHERE dept_id = 10
ORDER BY emp_name;

-- Practical example: Combined payroll calculation
SELECT 
    emp_name,
    salary,
    'Employee' AS employment_type
FROM current_employees
UNION ALL
SELECT 
    emp_name,
    salary,
    'Contractor' AS employment_type
FROM contractors
ORDER BY salary DESC;




-- INTERSECT: Find common job titles between employees and contractors
SELECT job_title FROM current_employees
INTERSECT
SELECT job_title FROM contractors;

-- INTERSECT: Employees who work in departments that also have contractors
SELECT dept_id FROM current_employees
INTERSECT
SELECT dept_id FROM contractors;

-- More complex INTERSECT example
SELECT 
    e.emp_name,
    e.job_title
FROM current_employees e
WHERE e.salary > 55000
INTERSECT
SELECT 
    c.emp_name,
    c.job_title
FROM contractors c
WHERE c.salary > 55000;





-- MINUS: Job titles that only employees have (not contractors)
SELECT job_title FROM current_employees
MINUS
SELECT job_title FROM contractors;

-- MINUS: Departments with employees but no contractors
SELECT dept_id FROM current_employees
MINUS
SELECT dept_id FROM contractors;

-- MINUS: High-paid employees who are not contractors
SELECT 
    emp_name,
    salary
FROM current_employees
WHERE salary > 60000
MINUS
SELECT 
    emp_name,
    salary
FROM contractors
WHERE salary > 60000;





-- Multiple JOIN types in single query
SELECT 
    e.emp_name AS employee,
    m.emp_name AS manager,
    d.dept_name,
    p.project_name,
    CASE 
        WHEN p.project_id IS NULL THEN 'No Project'
        ELSE 'Assigned to Project'
    END AS project_status
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
INNER JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

-- Using JOINs to solve business problems
-- Find departments with their employee count and average salary
SELECT 
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    COUNT(p.project_id) AS project_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_salary DESC NULLS LAST;




-- Comprehensive set operations example
-- Analyze workforce composition
SELECT 'Only Employees' AS category, COUNT(*) AS count
FROM (
    SELECT dept_id FROM current_employees
    MINUS
    SELECT dept_id FROM contractors
)
UNION ALL
SELECT 'Only Contractors', COUNT(*)
FROM (
    SELECT dept_id FROM contractors
    MINUS
    SELECT dept_id FROM current_employees
)
UNION ALL
SELECT 'Both Employees and Contractors', COUNT(*)
FROM (
    SELECT dept_id FROM current_employees
    INTERSECT
    SELECT dept_id FROM contractors
);

-- Workforce analysis by department type
SELECT 
    d.dept_name,
    CASE 
        WHEN EXISTS (SELECT 1 FROM contractors c WHERE c.dept_id = d.dept_id)
        AND EXISTS (SELECT 1 FROM current_employees e WHERE e.dept_id = d.dept_id)
        THEN 'Mixed'
        WHEN EXISTS (SELECT 1 FROM contractors c WHERE c.dept_id = d.dept_id)
        THEN 'Contractors Only'
        WHEN EXISTS (SELECT 1 FROM current_employees e WHERE e.dept_id = d.dept_id)
        THEN 'Employees Only'
        ELSE 'No Workforce'
    END AS workforce_type
FROM departments d
ORDER BY d.dept_name;



-- Efficient JOIN with selective columns
SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 50000;

-- Using EXISTS instead of JOIN for existence checks
SELECT 
    d.dept_id,
    d.dept_name
FROM departments d
WHERE EXISTS (
    SELECT 1 
    FROM employees e 
    WHERE e.dept_id = d.dept_id AND e.salary > 60000
);

-- Set operations with ordering and filtering
SELECT * FROM (
    SELECT emp_id, emp_name, salary FROM current_employees
    UNION
    SELECT emp_id, emp_name, salary FROM contractors
)
WHERE salary BETWEEN 50000 AND 70000
ORDER BY salary DESC;




-- IN – LAB TASKS

-- Q1. Write a query to display all possible pairs of employees and departments
-- Q2. Show all departments and employees, even if no employees are assigned to a
-- department
-- Q3. Display employee names along with their manager names.
-- Q4. Find employees who have not been assigned any project.
-- Q5. Display student names with their enrolled course names using.
-- Q6. Display all customers with their orders, even if some customers have not
-- placed any order.
-- Q7. Show all departments and employees, even if a department has no employee.
-- Q8. Display all pairs of teachers and subjects (whether taught or not).
-- Q9. Show all departments along with total employees.
-- Q10.Show each student, their course, and their teacher.
-- POST-LAB TASKS

-- Q11. Show all students and teachers where student city = teacher city.
-- Q12. List all employees and their manager names; also include employees without
-- managers.
-- 13. Find employees who don’t belong to any department.
-- 14. Show average salary of employees in each department; only display departments
-- where average salary &gt; 50,000.
-- 15. Show employees who earn more than the average salary in their department
-- 16. Find departments where no employee earns less than 30,000.
-- 17. Display students and their courses where the student’s city = ‘Lahore’.
-- 18. Display all employees along with their manager and department where employee hire
-- date BETWEEN ‘2020-01-01’ AND ‘2023-01-01’.
-- 19. List all students enrolled in courses taught by ‘Sir Ali’.
-- 20. Find employees whose manager is from the same department

