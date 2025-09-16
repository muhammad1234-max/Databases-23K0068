
-- Q1. List each department and the number of students in it.
SELECT d.dept_name, COUNT(s.student_id) AS num_students
FROM departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- Q2. Find departments where the average GPA of students is greater than 3.0.
SELECT d.dept_name, AVG(s.gpa) AS avg_gpa
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING AVG(s.gpa) > 3.0;

-- Q3. Display the average fee paid by students grouped by course.
SELECT c.course_name, AVG(s.fee) AS avg_fee
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON e.student_id = s.student_id
GROUP BY c.course_name;

-- Q4. Count how many faculty members are assigned to each department.
SELECT d.dept_name, COUNT(f.faculty_id) AS num_faculty
FROM departments d
LEFT JOIN faculty f ON d.dept_id = f.dept_id
GROUP BY d.dept_name;

-- Q5. Find faculty members whose salary is higher than the average salary.
SELECT *
FROM faculty
WHERE salary > (SELECT AVG(salary) FROM faculty);

-- Q6. Show students whose GPA is higher than at least one student in the CS department.
SELECT *
FROM students
WHERE gpa > ANY (SELECT gpa
                 FROM students s
                 JOIN departments d ON s.dept_id = d.dept_id
                 WHERE d.dept_name = 'CS');

-- Q7. Display the top 3 students with the highest GPA.
SELECT *
FROM students
ORDER BY gpa DESC
FETCH FIRST 3 ROWS ONLY;

-- Q8. Find students enrolled in all the courses that student Ali is enrolled in.
SELECT s.student_id, s.student_name
FROM students s
WHERE NOT EXISTS (
    SELECT c.course_id
    FROM enrollments e
    JOIN students s2 ON e.student_id = s2.student_id
    JOIN courses c ON e.course_id = c.course_id
    WHERE s2.student_name = 'Ali'
    MINUS
    SELECT e2.course_id
    FROM enrollments e2
    WHERE e2.student_id = s.student_id
);

-- Q9. Show the total fees collected per department.
SELECT d.dept_name, SUM(s.fee) AS total_fees
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- Q10. Display courses taken by students who have GPA above 3.5.
SELECT DISTINCT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON e.student_id = s.student_id
WHERE s.gpa > 3.5;


-- Q11. Show departments where the total fees collected exceed 1 million.
SELECT d.dept_name, SUM(s.fee) AS total_fees
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING SUM(s.fee) > 1000000;

-- Q12. Display faculty departments where more than 5 faculty members earn above 100,000 salary.
SELECT d.dept_name, COUNT(*) AS high_salary_faculty
FROM departments d
JOIN faculty f ON d.dept_id = f.dept_id
WHERE f.salary > 100000
GROUP BY d.dept_name
HAVING COUNT(*) > 5;

-- Q13. Delete all students whose GPA is below the overall average GPA.
DELETE FROM students
WHERE gpa < (SELECT AVG(gpa) FROM students);

-- Q14. Delete courses that have no students enrolled.
DELETE FROM courses
WHERE course_id NOT IN (SELECT DISTINCT course_id FROM enrollments);

-- Q15. Copy all students who paid more than the average fee into HighFee_Students.
CREATE TABLE HighFee_Students AS
SELECT *
FROM students
WHERE fee > (SELECT AVG(fee) FROM students);

-- Q16. Insert faculty into Retired_Faculty if their joining date is earlier than the minimum joining date in the university.
INSERT INTO Retired_Faculty
SELECT *
FROM faculty
WHERE joining_date < (SELECT MIN(joining_date) FROM faculty);

-- Q17. Find the department having the maximum total fee collected.
SELECT dept_id, SUM(fee) AS total_fee
FROM students
GROUP BY dept_id
ORDER BY total_fee DESC
FETCH FIRST 1 ROW ONLY;

-- Q18. Show the top 3 courses with the highest enrollments.
SELECT c.course_name, COUNT(e.student_id) AS num_enrollments
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY num_enrollments DESC
FETCH FIRST 3 ROWS ONLY;

-- Q19. Display students who have enrolled in more than 3 courses and have GPA greater than the overall average.
SELECT s.student_id, s.student_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.student_name, s.gpa
HAVING COUNT(e.course_id) > 3 AND s.gpa > (SELECT AVG(gpa) FROM students);

-- Q20. Find faculty who do not teach any course and insert them into Unassigned_Faculty.
INSERT INTO Unassigned_Faculty
SELECT *
FROM faculty f
WHERE NOT EXISTS (SELECT 1 FROM teaches t WHERE t.faculty_i_
