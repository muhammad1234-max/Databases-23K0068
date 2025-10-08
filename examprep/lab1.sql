-- Create a simple table to demonstrate various SQL data types
CREATE TABLE Employee_Info (
    Employee_ID INT PRIMARY KEY,             -- Integer type
    First_Name VARCHAR(50),                  -- Variable-length character string
    Last_Name NVARCHAR(50),                  -- Unicode string
    Salary DECIMAL(10,2),                    -- Decimal type (precision 10, scale 2)
    Hire_Date DATE,                          -- Date type
    Bonus MONEY,                             -- Monetary data type
    Is_Active BIT                            -- Boolean (0 or 1)
);


-- Demonstrating arithmetic operators with numeric columns
SELECT 
    Employee_ID,
    Salary,
    Salary + 500 AS Increased_Salary,   -- Addition
    Salary - 300 AS Reduced_Salary,     -- Subtraction
    Salary * 0.1 AS TenPercent_Bonus,   -- Multiplication
    Salary / 12 AS Monthly_Salary,      -- Division
    Salary % 1000 AS Remainder_Value    -- Modulus (may differ by DBMS)
FROM Employee_Info;


-- Comparison examples on EMPLOYEES table
SELECT * FROM EMPLOYEES WHERE MANAGER_ID = 101;   -- Equal to
SELECT * FROM EMPLOYEES WHERE SALARY != 17000;    -- Not equal to
SELECT * FROM EMPLOYEES WHERE SALARY > 15000;     -- Greater than
SELECT * FROM EMPLOYEES WHERE SALARY < 10000;     -- Less than
SELECT * FROM EMPLOYEES WHERE SALARY >= 12000;    -- Greater or equal
SELECT * FROM EMPLOYEES WHERE SALARY <= 9000;     -- Less or equal
SELECT * FROM EMPLOYEES WHERE MANAGER_ID <> 114;  -- Alternate “not equal” syntax


-- Using AND, OR, and NOT
SELECT FIRST_NAME, JOB_ID, SALARY 
FROM EMPLOYEES 
WHERE JOB_ID = 'AD_VP' AND DEPARTMENT_ID = 90;  -- Both conditions must be true

SELECT FIRST_NAME, JOB_ID, SALARY 
FROM EMPLOYEES 
WHERE JOB_ID = 'AD_VP' OR DEPARTMENT_ID = 90;   -- Either condition can be true

SELECT FIRST_NAME, JOB_ID, SALARY 
FROM EMPLOYEES 
WHERE NOT JOB_ID = 'AD_VP';                     -- Negates condition



-- BETWEEN: value within a range
SELECT FIRST_NAME, SALARY 
FROM EMPLOYEES 
WHERE SALARY BETWEEN 10000 AND 12000;

-- IN: matches any value in list
SELECT FIRST_NAME, JOB_ID 
FROM EMPLOYEES 
WHERE JOB_ID IN ('AD_VP', 'IT_PROG', 'SA_REP');

-- LIKE: pattern matching with wildcards
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME LIKE 'A%';       -- Names starting with A

-- EXISTS: returns rows if subquery returns any rows
SELECT FIRST_NAME, DEPARTMENT_ID
FROM EMPLOYEES e
WHERE EXISTS (SELECT 1 FROM DEPARTMENTS d WHERE d.DEPARTMENT_ID = e.DEPARTMENT_ID);

-- ANY: compares to any value in subquery result
SELECT FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID = 60);

-- ALL: compares to all values in subquery result
SELECT FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID = 60);

-- NULL: checking for null values
SELECT FIRST_NAME, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NULL;

-- UNIQUE: ensures no duplicates (used in table constraints)
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(100) UNIQUE   -- No two departments can have the same name
);


-- Select all columns from EMPLOYEES table
SELECT * FROM EMPLOYEES;

-- Select specific columns
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY FROM EMPLOYEES;

-- Filter with WHERE clause
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY 
FROM EMPLOYEES
WHERE SALARY > 2300;

-- Using range conditions with AND
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY 
FROM EMPLOYEES
WHERE SALARY >= 10000 AND SALARY <= 12000;



-- Combine multiple operators in one query
SELECT FIRST_NAME, LAST_NAME, SALARY, JOB_ID
FROM EMPLOYEES
WHERE (SALARY BETWEEN 10000 AND 20000)
  AND (DEPARTMENT_ID IN (90, 100))
  AND (FIRST_NAME LIKE 'S%')
  OR (MANAGER_ID = 101 AND SALARY > 15000)
ORDER BY SALARY DESC;




-- IN – LAB TASKS

-- Q1. Write a SQL query to retrieve employees who are not in department 100.
-- Q2. Write a SQL query to retrieve whose salary is either 10000 , 12000 or 15000.
-- Q3. Write a SQL query to display the first name and salary of employees whose salary is
-- less than OR equal to 25000.
-- Q4. Write a SQL query to retrieve employees who are not in department 60.
-- Q5. Write a SQL query retrieve employees who are in between department 60 to 80.
-- Q6. Display all details of departments.
-- Q7. Retrieve employees whose first name is &#39;Steven&#39;.
-- Q8. Display employees who earn between 15000 and 25000 and work in department 80.
-- Q9. Display employees who earn less than the salary of any employee in department 100.
-- Q10. Display employees whose department ID is unique in the employees table.

-- POST – LAB TASKS

-- Q11. Retrieve employees hired between 01-JAN-05 and 31-DEC-06.
-- Q12. Retrieve employees who do not have a manager.
-- Q13. Retrieve employees whose salary is less than all employees earning more than
-- 8000.
-- Q14. Retrieve employees whose salary is greater than any salary in department 90.
-- Q15. Retrieve departments that have at least one employee.
-- Q16. Retrieve departments that do not have any employee.
-- Q17. Retrieve employees whose salary is not between 5000 and 15000.
-- Q18. Retrieve employees who are in departments 10, 20, or 30, but not 40.
-- Q19. Display employees whose salary is less than the minimum salary of department 50.
-- Q20. Display employees whose salary is greater than the maximum salary of department
-- 90.

