-- Basic GROUP BY with COUNT function
-- Count number of employees in each department
SELECT 
    department_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;

-- GROUP BY with multiple aggregate functions
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary,
    SUM(salary) AS total_salary_budget
FROM employees
GROUP BY department_id;

-- GROUP BY with multiple columns
SELECT 
    department_id,
    job_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id, job_id;



-- HAVING with SUM function
-- Find departments where total salary exceeds 50000
SELECT 
    department_id,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
HAVING SUM(salary) > 50000;

-- HAVING with AVG function
-- Find departments with average salary greater than 6000
SELECT 
    department_id,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 6000;

-- HAVING with COUNT function
-- Find departments with more than 5 employees
SELECT 
    department_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;

-- HAVING with multiple conditions
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 3 AND AVG(salary) > 5000;



-- Find employee with highest salary
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- Find employees earning more than average salary
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Find employees in the same department as employee with ID 101
SELECT 
    employee_id,
    first_name,
    last_name,
    department_id
FROM employees
WHERE department_id = (
    SELECT department_id 
    FROM employees 
    WHERE employee_id = 101
);

-- Find manager details for a specific employee
SELECT 
    employee_id,
    first_name,
    last_name,
    job_id
FROM employees
WHERE employee_id = (
    SELECT manager_id 
    FROM employees 
    WHERE employee_id = 105
);



-- Find employees working in specific departments
SELECT 
    employee_id,
    first_name,
    last_name,
    department_id
FROM employees
WHERE department_id IN (
    SELECT department_id 
    FROM departments 
    WHERE location_id = 1700
);

-- Find employees with specific job titles
SELECT 
    employee_id,
    first_name,
    last_name,
    job_id
FROM employees
WHERE job_id IN (
    SELECT job_id 
    FROM jobs 
    WHERE min_salary > 4000
);




-- Find employees earning more than any IT Programmer
SELECT 
    employee_id,
    first_name,
    last_name,
    salary,
    job_id
FROM employees
WHERE salary > ANY (
    SELECT salary 
    FROM employees 
    WHERE job_id = 'IT_PROG'
);

-- Find employees earning less than any manager
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary < ANY (
    SELECT salary 
    FROM employees 
    WHERE job_id LIKE '%MAN%'
);




-- Find employees earning more than all IT Programmers
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary > ALL (
    SELECT salary 
    FROM employees 
    WHERE job_id = 'IT_PROG'
);

-- Find employees earning less than all managers
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary < ALL (
    SELECT salary 
    FROM employees 
    WHERE job_id LIKE '%MAN%'
)
AND job_id NOT LIKE '%MAN%';




-- Find employees earning more than their department average
SELECT 
    e1.employee_id,
    e1.first_name,
    e1.last_name,
    e1.salary,
    e1.department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

-- Find departments that have employees
SELECT 
    department_id,
    department_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);

-- Find employees without any subordinates
SELECT 
    employee_id,
    first_name,
    last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employees m
    WHERE m.manager_id = e.employee_id
);



-- Find departments with average salary higher than company average
SELECT 
    department_id,
    AVG(salary) AS department_avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

-- Find job titles with maximum salary higher than department 50's maximum
SELECT 
    job_id,
    MAX(salary) AS job_max_salary
FROM employees
GROUP BY job_id
HAVING MAX(salary) > (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = 50
);




-- Create backup table structure
CREATE TABLE employee_bkp AS 
SELECT * FROM employees WHERE 1=0;

-- Insert employees with specific job titles into backup table
INSERT INTO employee_bkp
SELECT * FROM employees
WHERE job_id IN (
    SELECT job_id 
    FROM jobs 
    WHERE job_title LIKE '%Manager%'
);

-- Insert high-salary employees into special bonus table
CREATE TABLE high_earners AS 
SELECT * FROM employees WHERE 1=0;

INSERT INTO high_earners
SELECT * FROM employees
WHERE salary > (
    SELECT AVG(salary) * 1.5 
    FROM employees
);





-- Give 10% raise to employees in high-revenue departments
UPDATE employees
SET salary = salary * 1.10
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE department_name IN ('Sales', 'Marketing')
);

-- Update commission for employees earning less than department average
UPDATE employees e1
SET commission_pct = 0.15
WHERE salary < (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
)
AND commission_pct IS NULL;




-- Delete employees from terminated departments
DELETE FROM employee_bkp
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE department_name = 'Temp Department'
);

-- Delete employees with no activity in last year from backup
DELETE FROM employee_bkp
WHERE employee_id NOT IN (
    SELECT employee_id
    FROM job_history
    WHERE end_date > ADD_MONTHS(SYSDATE, -12)
);




-- Display employee details with department and job information
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    -- Scalar subquery for department name
    (SELECT department_name 
     FROM departments d 
     WHERE d.department_id = e.department_id) AS department_name,
    -- Scalar subquery for job title
    (SELECT job_title 
     FROM jobs j 
     WHERE j.job_id = e.job_id) AS job_title,
    -- Scalar subquery for manager name
    (SELECT first_name || ' ' || last_name 
     FROM employees m 
     WHERE m.employee_id = e.manager_id) AS manager_name
FROM employees e
WHERE e.department_id IS NOT NULL;




-- Top 5 highest paid employees (Oracle ROWNUM)
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM (
    SELECT 
        employee_id,
        first_name,
        last_name,
        salary
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM <= 5;

-- Top 3 departments by total salary budget
SELECT 
    department_id,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
ORDER BY total_salary DESC
FETCH FIRST 3 ROWS ONLY;

-- Employees ranked 6th to 10th by salary
SELECT *
FROM (
    SELECT 
        employee_id,
        first_name,
        last_name,
        salary,
        ROW_NUMBER() OVER (ORDER BY salary DESC) as salary_rank
    FROM employees
)
WHERE salary_rank BETWEEN 6 AND 10;




-- Comprehensive example combining multiple concepts
-- Find departments where average salary is above company average
-- and have more than 2 employees, showing top 3 results

SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    (SELECT ROUND(AVG(salary), 2) FROM employees) AS company_avg_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
WHERE d.department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING COUNT(*) > 2
)
GROUP BY d.department_id, d.department_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees)
ORDER BY avg_salary DESC
FETCH FIRST 3 ROWS ONLY;

-- Correlated subquery to find employees earning more than their department average
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    (SELECT ROUND(AVG(salary), 2) 
     FROM employees dept_emp 
     WHERE dept_emp.department_id = e.department_id) AS dept_avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees dept_avg
    WHERE dept_avg.department_id = e.department_id
)
ORDER BY e.department_id, e.salary DESC;



-- Find employees with the same job and department as specific employee
SELECT 
    employee_id,
    first_name,
    last_name,
    job_id,
    department_id
FROM employees
WHERE (job_id, department_id) = (
    SELECT job_id, department_id
    FROM employees
    WHERE employee_id = 101
)
AND employee_id != 101;

-- Update multiple columns using subquery
UPDATE employees
SET (salary, job_id) = (
    SELECT 
        AVG(salary) * 1.1,
        'SA_REP'
    FROM employees
    WHERE department_id = 80
)
WHERE employee_id = 195;



-- IN – LAB TASKS

-- Q1. List each department and the number of students in it.
-- Q2. Find departments where the average GPA of students is greater than 3.0.
-- Q3. Display the average fee paid by students grouped by course.
-- Q4.Count how many faculty members are assigned to each department.
-- Q5.Find faculty members whose salary is higher than the average salary.
-- Q6. Show students whose GPA is higher than at least one student in the CS
-- department.
-- Q7. Display the top 3 students with the highest GPA.
-- Q8. Find students enrolled in all the courses that student Ali is enrolled in.
-- Q9. Show the total fees collected per department.
-- Q10. Display courses taken by students who have GPA above 3.5.

-- Post– LAB TASKS

-- Q11. Show departments where the total fees collected exceed 1 million.
-- Q12. Display faculty departments where more than 5 faculty members earn above
-- 100,000 salary.
-- Q13. Delete all students whose GPA is below the overall average GPA.
-- Q14. Delete courses that have no students enrolled.
-- Q15. Copy all students who paid more than the average fee into a new table
-- HighFee_Students.
-- Q16. Insert faculty into Retired_Faculty if their joining date is earlier than the minimum
-- joining date in the university.
-- Q17. Find the department having the maximum total fee collected.
-- Q18. Show the top 3 courses with the highest enrollments using ROWNUM or LIMIT.
-- Q19 Display students who have enrolled in more than 3 courses and have GPA greater
-- than the overall average .
-- Q20. Find faculty who do not teach any course and insert them into Unassigned_Faculty.
