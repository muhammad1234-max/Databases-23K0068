-- Q11
SELECT s.student_id, s.student_name, s.city AS student_city,
       t.teacher_id, t.teacher_name, t.city AS teacher_city
FROM students s
JOIN teachers t ON s.city = t.city
ORDER BY s.student_id;

-- Q12
SELECT e.emp_id, e.first_name || ' ' || e.last_name AS employee_name,
       m.emp_id AS manager_id, NVL(m.first_name || ' ' || m.last_name,'(No Manager)') AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY e.emp_id;

-- Q13
SELECT e.emp_id, e.first_name, e.last_name, e.department_id
FROM employees e
WHERE e.department_id IS NULL
   OR e.department_id NOT IN (SELECT department_id FROM departments);

-- Q14
SELECT d.department_id, d.department_name,
       AVG(e.salary) AS avg_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING AVG(e.salary) > 50000
ORDER BY avg_salary DESC;

-- Q15
SELECT e.emp_id, e.first_name || ' ' || e.last_name AS employee_name,
       e.department_id, e.salary
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS dept_avg
    FROM employees
    GROUP BY department_id
) das ON e.department_id = das.department_id
WHERE e.salary > das.dept_avg
ORDER BY e.department_id, e.salary DESC;

-- Q16
SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING NVL(MIN(e.salary), 99999999) >= 30000;

-- Q17
SELECT s.student_id, s.student_name, s.city,
       c.course_id, c.course_name
FROM students s
JOIN enrollments en ON s.student_id = en.student_id
JOIN courses c ON en.course_id = c.course_id
WHERE UPPER(s.city) = 'LAHORE'
ORDER BY s.student_id;

-- Q18
SELECT e.emp_id, e.first_name || ' ' || e.last_name AS employee_name,
       m.emp_id AS manager_id, NVL(m.first_name || ' ' || m.last_name,'(No Manager)') AS manager_name,
       d.department_id, d.department_name,
       e.hire_date
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE e.hire_date BETWEEN DATE '2020-01-01' AND DATE '2023-01-01'
ORDER BY e.hire_date;

-- Q19
SELECT s.student_id, s.student_name,
       c.course_id, c.course_name, t.teacher_id, t.teacher_name
FROM students s
JOIN enrollments en ON s.student_id = en.student_id
JOIN courses c ON en.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE t.teacher_name = 'Sir Ali'
ORDER BY s.student_id;

-- Q20
SELECT e.emp_id, e.first_name || ' ' || e.last_name AS employee_name,
       e.department_id,
       m.emp_id AS manager_id, m.first_name || ' ' || m.last_name AS manager_name,
       m.department_id AS manager_dept_id
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE e.department_id = m.department_id
ORDER BY e.department_id, e.emp_id;
