-- Creating a table with NOT NULL constraints
CREATE TABLE Employees (
    EmployeeID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100)  -- This column can contain NULL values
);

-- Adding NOT NULL constraint to existing column
ALTER TABLE Employees MODIFY Email VARCHAR(100) NOT NULL;

-- Creating table with UNIQUE constraint on single column
CREATE TABLE Students (
    StudentID INT NOT NULL UNIQUE,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

-- Creating table with composite UNIQUE constraint
CREATE TABLE CourseEnrollment (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATE,
    CONSTRAINT UC_Enrollment UNIQUE (StudentID, CourseID)
);

-- Adding UNIQUE constraint to existing table
ALTER TABLE Students ADD UNIQUE (Email);



-- Single column primary key
CREATE TABLE Customers (
    CustomerID INT NOT NULL PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Contact VARCHAR(50)
);

-- Composite primary key
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

-- Adding primary key to existing table
ALTER TABLE Employees ADD PRIMARY KEY (EmployeeID);



-- Creating tables with foreign key relationship
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100) NOT NULL,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

-- Adding foreign key to existing table
ALTER TABLE Employees ADD CONSTRAINT FK_Dept 
FOREIGN KEY (DeptID) REFERENCES Departments(DeptID);


-- Creating table with CHECK constraint
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2) CHECK (Price > 0),
    Quantity INT CHECK (Quantity >= 0)
);

-- CHECK constraint with multiple conditions
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    CONSTRAINT CHK_Age CHECK (Age >= 18 AND Age <= 65)
);

-- Adding CHECK constraint to existing table
ALTER TABLE Products ADD CONSTRAINT CHK_Price 
CHECK (Price > 0);


-- Creating table with DEFAULT values
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE DEFAULT CURRENT_DATE,
    Status VARCHAR(20) DEFAULT 'Pending',
    TotalAmount DECIMAL(10,2)
);

-- Adding DEFAULT constraint to existing column
ALTER TABLE Orders MODIFY Status VARCHAR(20) DEFAULT 'Pending';


-- Creating index on single column
CREATE INDEX idx_customer_name ON Customers(CustomerName);

-- Creating unique composite index
CREATE UNIQUE INDEX idx_customer_email ON Customers(CustomerID, Email);

-- Dropping an index
DROP INDEX idx_customer_name;




-- INSERT with only values (must match column order)
INSERT INTO Customers VALUES (1, 'John Doe', 'john@email.com');

-- INSERT with specified columns
INSERT INTO Customers (CustomerID, CustomerName, Contact) 
VALUES (2, 'Jane Smith', 'jane@email.com');

-- INSERT multiple rows
INSERT INTO Customers (CustomerID, CustomerName) 
VALUES 
(3, 'Bob Wilson'),
(4, 'Alice Brown'),
(5, 'Charlie Davis');




-- Update single column for specific records
UPDATE Customers 
SET Contact = 'newemail@email.com' 
WHERE CustomerID = 1;

-- Update multiple columns
UPDATE Products 
SET Price = Price * 1.1, 
    Quantity = Quantity - 1 
WHERE ProductID = 101;

-- Update all records (use with caution!)
UPDATE Orders 
SET Status = 'Processed' 
WHERE Status = 'Pending';



-- Delete specific records
DELETE FROM Customers 
WHERE CustomerID = 5;

-- Delete records based on condition
DELETE FROM Orders 
WHERE OrderDate < '2024-01-01';

-- Delete all records from table (use with caution!)
DELETE FROM TemporaryTable;





-- Create database
CREATE DATABASE CompanyDB;

-- Use the database
USE CompanyDB;

-- Create table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    HireDate DATE DEFAULT CURRENT_DATE,
    Salary DECIMAL(10,2) CHECK (Salary > 0)
);




-- Create database
CREATE DATABASE CompanyDB;

-- Use the database
USE CompanyDB;

-- Create table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    HireDate DATE DEFAULT CURRENT_DATE,
    Salary DECIMAL(10,2) CHECK (Salary > 0)
);




-- Add new column
ALTER TABLE Employees ADD Department VARCHAR(50);

-- Drop column
ALTER TABLE Employees DROP COLUMN Department;

-- Modify column data type
ALTER TABLE Employees MODIFY Salary DECIMAL(12,2);

-- Rename table
ALTER TABLE Employees RENAME TO Staff;

-- Rename column
ALTER TABLE Staff RENAME COLUMN Salary TO AnnualSalary;



-- Truncate table (remove all data, keep structure)
TRUNCATE TABLE TemporaryData;

-- Drop table (remove table and its structure)
DROP TABLE TemporaryData;

-- Drop database
DROP DATABASE OldDatabase;




-- Create database
CREATE DATABASE SchoolDB;

USE SchoolDB;

-- Create tables with constraints
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Age INT CHECK (Age >= 16 AND Age <= 25),
    EnrollmentDate DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT CHECK (Credits BETWEEN 1 AND 5)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE DEFAULT CURRENT_DATE,
    Grade CHAR(1) CHECK (Grade IN ('A', 'B', 'C', 'D', 'F')),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    CONSTRAINT UC_StudentCourse UNIQUE (StudentID, CourseID)
);

-- Create indexes for better performance
CREATE INDEX idx_student_name ON Students(FirstName, LastName);
CREATE INDEX idx_enrollment_date ON Enrollments(EnrollmentDate);

-- Insert sample data
INSERT INTO Students (StudentID, FirstName, LastName, Email, Age) 
VALUES 
(1, 'John', 'Doe', 'john.doe@email.com', 20),
(2, 'Jane', 'Smith', 'jane.smith@email.com', 22);

INSERT INTO Courses (CourseID, CourseName, Credits) 
VALUES 
(101, 'Database Systems', 3),
(102, 'Web Development', 4);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) 
VALUES 
(1001, 1, 101, 'A'),
(1002, 2, 102, 'B');

-- Update data
UPDATE Students 
SET Age = 21 
WHERE StudentID = 1;

-- Delete data
DELETE FROM Enrollments 
WHERE Grade = 'F';




-- IN – LAB TASKS

-- Q1. create a table named employees with the following columns, emp_id ,
-- emp_name , salary(should be greater than 20000) , dept_id(reference) from
-- departments table.
-- Q2. Change column name from emp_name to full_name.
-- Q3. Drop the check constraint on salary and try inserting an employee
-- with salary = 5000.
-- Q4. Create a table departments with columns dept_id (PK), dept_name
-- (UNIQUE). Insert 3 records.
-- Q5. Add a foreign key from employees.dept_id to departments.dept_id.
-- Q6. Add a new column bonus NUMBER(6,2) in employees with a default value of
-- 1000.
-- Q7. Forgot to add city have default value Karachi and age column(should be greater
-- than 18).
-- Q8. Delete records have id 1 and id 3.
-- Q9. Change the length of full_name and city column length must be 20 characters.
-- Q10.Add email column and set unique constraint.

-- Post– LAB TASKS

-- Q11. A company policy says no employee can have the same bonus amount. Add a
-- UNIQUE constraint on bonus and test it with two records.
-- Q12. Add a dob DATE column in staff and add a constraint that ensures employees
-- must be at least 18 years old.
-- Q13. Insert an employee with invalid date of birth (less than 18 years old) and check the
-- error
-- Q14. Drop the dept_id foreign key and insert an employee with a non-existing
-- department. Then re-add the constraint and check again.
-- Q15. Drop age and city columns.
-- Q16. Display departments and employees of that departments.
-- Q17. Rename the column salary to monthly_salary and ensure constraints remain intact
-- Q18. Write a query to display all departments that have no employees.
-- Q19.Write a query to empty the table of students .
-- Q20. Find the department that has the maximum number of employees.
