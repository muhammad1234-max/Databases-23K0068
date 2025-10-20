-- Q1
SELECT e.emp_id, e.first_name, d.department_id, d.department_name
FROM employees e
CROSS JOIN departments d;

-- Q2
SELECT d.department_id, d.department_name,
       e.emp_id, e.first_name, e.last_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;

-- Q3
SELECT e.emp_id,
       e.first_name || ' ' || e.last_name AS employee_name,
       m.emp_id   AS manager_id,
       m.first_name || ' ' || m.last_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY e.emp_id;

-- Q4
SELECT e.emp_id, e.first_name, e.last_name
FROM employees e
LEFT JOIN emp_projects ep ON e.emp_id = ep.emp_id
WHERE ep.project_id IS NULL;

-- Q5
SELECT s.student_id, s.student_name, c.course_id, c.course_name
FROM students s
JOIN enrollments en ON s.student_id = en.student_id
JOIN courses c ON en.course_id = c.course_id
ORDER BY s.student_id;

-- Q6
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;

-- Q7
SELECT d.department_id, d.department_name,
       e.emp_id, e.first_name, e.last_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_id;

-- Q8
SELECT t.teacher_id, t.teacher_name, s.subject_id, s.subject_name
FROM teachers t
CROSS JOIN subjects s
ORDER BY t.teacher_id, s.subject_id;

-- Q9
SELECT d.department_id, d.department_name,
       COUNT(e.emp_id) AS total_employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_employees DESC;

--Q10
SELECT s.student_id, s.student_name,
       c.course_id, c.course_name,
       t.teacher_id, t.teacher_name
FROM students s
JOIN enrollments en ON s.student_id = en.student_id
JOIN courses c ON en.course_id = c.course_id
LEFT JOIN teachers t ON c.teacher_id = t.teacher_id
ORDER BY s.student_id, c.course_id;
