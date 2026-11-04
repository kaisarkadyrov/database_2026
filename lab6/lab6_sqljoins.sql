--Part1
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2)
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    budget DECIMAL(10, 2)
);

INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');

INSERT INTO projects (project_id, project_name, dept_id,
budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);

--Part2
--Task2.1
SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;

--Task2.2
--a
SELECT employees.emp_name, departments.dept_name
FROM employees, departments;
--b
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON TRUE;

--Task2.3
SELECT e.emp_name, p.project_name
FROM employees e
CROSS JOIN projects p
ORDER BY e.emp_name, p.project_name;

--Part3
--Task3.1
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
--4 rows are returned. Tom Brown is not included because he does not have a department id

--Task3.2
SELECT emp_name, dept_name
FROM employees
INNER JOIN departments USING (dept_id);
--dept_id shows only once in the table

--Task3.3
SELECT emp_name, dept_name
FROM employees
NATURAL INNER JOIN departments;

--Task3.4
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d on e.dept_id = d.dept_id
INNER JOIN projects p on d.dept_id = p.dept_id;
-- 6 rows: John and Mike (IT) each appear twice (2 IT projects),
-- Jane (HR) and Sarah (Finance) once each.
-- Tom Brown (no dept) and AI Research (no dept) are excluded.

--Part4
--Task4.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
-- Answer: 5 rows. Tom Brown appears with NULL in emp_dept, dept_dept
-- and dept_name, because no department matched his row.

--Task4.2
SELECT emp_name, dept_id, dept_name
FROM employees
LEFT JOIN departments USING (dept_id);


--Task4.3
SELECT e.emp_name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;
-- Result: Tom Brown.

--Task4.4
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;
-- IT 2, HR 1, Finance 1, Marketing 0.
-- COUNT(e.emp_id) (not COUNT(*)) is used so Marketing gets 0, not 1.

--Part5
--Task5.1
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
-- 5 rows; Marketing appears with emp_name = NULL.

--Task5.2
SELECT e.emp_name, d.dept_name
FROM departments d
LEFT JOIN employees e ON e.dept_id = d.dept_id;

--Task5.3
SELECT d.dept_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;
-- Result: Marketing, Building D.

