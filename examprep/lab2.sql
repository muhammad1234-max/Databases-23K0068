-- Display all columns from the Employees table
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, 
       job_id, salary, commission_pct, manager_id, department_id
FROM employees;

-- Task: Display any two columns from employees table
SELECT first_name, salary 
FROM employees;

-- Use AS to rename a column in the result
SELECT employee_id, phone_number AS "Contact Number" 
FROM employees;

-- Task: Rename hire_date as Joining Date
SELECT hire_date AS "Joining Date"
FROM employees;


-- Combine (concatenate) columns together using ||
SELECT first_name || salary AS "Employees and Salaries"
FROM employees;

-- Task: Display full name of employees in one column
SELECT first_name || ' ' || last_name AS "Full Name"
FROM employees;


-- Display unique department IDs from employees
SELECT DISTINCT department_id
FROM employees;


-- Show all salary values, including duplicates
SELECT ALL salary
FROM employees;


-- Display all columns of a table using *
SELECT * 
FROM departments;


-- Basic row selection
SELECT first_name, salary 
FROM employees
WHERE employee_id = 100;

-- Comparison Search Condition (with AND)
SELECT * 
FROM employees
WHERE salary > 20000 AND department_id = 100;


-- Employees earning between 20,000 and 30,000
SELECT * 
FROM employees
WHERE salary BETWEEN 20000 AND 30000;

-- Employees earning outside that range
SELECT * 
FROM employees
WHERE salary NOT BETWEEN 20000 AND 30000;


-- List jobs for specific titles
SELECT * 
FROM jobs
WHERE job_title IN ('Sales Manager', 'Purchasing Manager');

-- Exclude certain job titles
SELECT * 
FROM jobs
WHERE job_title NOT IN ('Sales Manager', 'Purchasing Manager');


-- Employees whose first names contain 'a'
SELECT * 
FROM employees
WHERE first_name LIKE '%a%';

-- Employees with 'a' as the second letter
SELECT * 
FROM employees
WHERE first_name LIKE '_a%';


-- Employees with a commission percentage
SELECT * 
FROM employees
WHERE commission_pct IS NOT NULL;

-- Employees without a commission percentage
SELECT * 
FROM employees
WHERE commission_pct IS NULL;


-- Sort employees by increasing salary
SELECT * 
FROM employees
ORDER BY salary ASC;

-- Sort employees by decreasing salary
SELECT * 
FROM employees
ORDER BY salary DESC;


-- Perform a simple calculation without using a table
SELECT 2 + 3 AS "Result" 
FROM DUAL;

-- Display system date
SELECT SYSDATE AS "Current Date" 
FROM DUAL;


-- ROUND: Rounds a number to specified decimal places
SELECT ROUND(45.923, 2) AS Rounded FROM DUAL;     -- 45.92

-- TRUNC: Truncates number to given decimal places
SELECT TRUNC(45.923, 1) AS Truncated FROM DUAL;   -- 45.9

-- MOD: Returns remainder of division
SELECT MOD(10, 3) AS Remainder FROM DUAL;         -- 1


-- UPPER: Converts to uppercase
SELECT UPPER(first_name) AS "Uppercase Name" 
FROM employees;

-- LOWER: Converts to lowercase
SELECT LOWER(first_name) AS "Lowercase Name" 
FROM employees;

-- INITCAP: Capitalizes first letter of each word
SELECT INITCAP(first_name) AS "Proper Name" 
FROM employees;

-- LENGTH: Returns number of characters
SELECT first_name, LENGTH(first_name) AS "Name Length"
FROM employees;

-- SUBSTR: Extracts substring
SELECT SUBSTR(first_name, 1, 3) AS "Short Name"
FROM employees;

-- CONCAT: Alternative to ||
SELECT CONCAT(first_name, last_name) AS "Full Name"
FROM employees;


-- Add months to a date
SELECT ADD_MONTHS('16-SEP-81', 3) AS "New Date" FROM DUAL;

-- Find months between two dates
SELECT MONTHS_BETWEEN('16-DEC-81', '16-SEP-81') AS "Months Diff" FROM DUAL;

-- Find next Wednesday after a date
SELECT NEXT_DAY('01-JUN-08', 'Wednesday') AS "Next Wednesday" FROM DUAL;

-- Find last day of month
SELECT LAST_DAY('01-JUN-08') AS "Last Day" FROM DUAL;

-- Convert time zones
SELECT NEW_TIME('01-JUN-08', 'ISL', 'EST') AS "EST Time" FROM DUAL;

-- Get current date and time
SELECT SYSDATE AS "System Date" FROM DUAL;


-- Convert NULL to actual value
SELECT NVL(commission_pct, 0) AS "Commission" 
FROM employees;

-- Convert number to string
SELECT TO_CHAR(salary, '$99,999.00') AS "Formatted Salary" 
FROM employees;

-- Convert string to number
SELECT TO_NUMBER('1500') + 500 AS "Converted Number"
FROM DUAL;

-- Convert string to date
SELECT TO_DATE('2025-10-08', 'YYYY-MM-DD') AS "Converted Date"
FROM DUAL;


-- Average, minimum, maximum, and count of employees
SELECT AVG(salary) AS "Average Salary",
       MIN(salary) AS "Minimum Salary",
       MAX(salary) AS "Maximum Salary",
       COUNT(employee_id) AS "Total Employees"
FROM employees;

-- Earliest and latest hire dates
SELECT MIN(hire_date) AS "Earliest Hire",
       MAX(hire_date) AS "Latest Hire"
FROM employees;

-- Salary difference between highest and lowest paid employee
SELECT MAX(salary) - MIN(salary) AS "Salary Difference"
FROM employees;

-- Total number of rows in the table
SELECT COUNT(*) AS "Row Count"
FROM employees;



-- IN – LAB TASKS
-- Q1. Find the total salary of all employees.
-- Q2. Find the average salary of employees.
-- Q3. Count the number of employees reporting to each manager.
-- Q4. Select * employees who has lowest salary.
-- Q5. Display the current system date in the format DD-MM-YYYY.
-- Q6. Display the current system date with full day, month, and year (e.g.,
-- MONDAY AUGUST 2025).
-- Q7. Find all employees hired on a Wednesday.
-- Q8. Calculate months between 01-JAN-2025 and 01-OCT-2024.
-- Q9. Find how many months each employee has worked in the company (using
-- hire_date).
-- Q10.Extract the first 5 characters from each employee’s last name.

-- Post– LAB TASKS

-- Q11. Pad employee first names with * on the left side to make them 15 characters wide.
-- Q12. Remove leading spaces from &#39; Oracle&#39;.
-- Q13. Display each employee’s name with the first letter capitalized.
-- Q14. Find the next Monday after 20-AUG-2022.
-- Q15. Convert &#39;25-DEC-2023&#39; (string) to a date and display it in MM-YYYY format.
-- Q16. Display all distinct salaries in ascending order.
-- Q17. Display the salary of each employee rounded to the nearest hundred.
-- Q18. Find the department that has the maximum number of employees.
-- Q19. Find the top 3 highest-paid departments by total salary expense.
-- Q20. Find the department that has the maximum number of employees.

