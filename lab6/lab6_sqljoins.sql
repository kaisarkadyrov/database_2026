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