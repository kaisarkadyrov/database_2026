--Part 1
CREATE TABLE departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location  VARCHAR(50)
);

CREATE TABLE employees (
    emp_id   INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id  INT,
    salary   DECIMAL(10, 2)
);

CREATE TABLE projects (
    project_id   INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id      INT,
    budget       DECIMAL(10, 2)
);

INSERT INTO departments VALUES
    (101, 'IT', 'Building A'),
    (102, 'HR', 'Building B'),
    (103, 'Finance', 'Building C'),
    (104, 'Marketing', 'Building D');

INSERT INTO employees VALUES
    (1, 'John Smith', 101, 50000),
    (2, 'Jane Doe', 102, 60000),
    (3, 'Mike Johnson', 101, 55000),
    (4, 'Sarah Williams', 103, 65000),
    (5, 'Tom Brown', NULL, 45000);

INSERT INTO projects VALUES
    (1, 'Website Redesign', 101, 100000),
    (2, 'Employee Training', 102, 50000),
    (3, 'Budget Analysis', 103, 75000),
    (4, 'Cloud Migration', 101, 150000),
    (5, 'AI Research', NULL, 200000);


--Part 2
--Task2.1
CREATE VIEW employee_details AS
SELECT e.emp_id,
       e.emp_name,
       e.salary,
       d.dept_name,
       d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

SELECT * FROM employee_details;
-- Answer: 4 rows are returned. Tom Brown does not appear because his
-- dept_id is NULL, and INNER JOIN keeps only rows that have a match in
-- both tables (NULL never matches anything).

--Task2.2
CREATE VIEW dept_statistics AS
SELECT d.dept_id,
       d.dept_name,
       COUNT(e.emp_id)          AS employee_count,
       ROUND(AVG(e.salary), 2)  AS avg_salary,
       MAX(e.salary)            AS max_salary,
       MIN(e.salary)            AS min_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT * FROM dept_statistics
ORDER BY employee_count DESC;
-- LEFT JOIN is used so that departments with no employees (Marketing)
-- still appear, with employee_count = 0.

--Task2.3
CREATE VIEW project_overview AS
SELECT p.project_id,
       p.project_name,
       p.budget,
       d.dept_name,
       d.location,
       (SELECT COUNT(*)
        FROM employees e
        WHERE e.dept_id = p.dept_id) AS team_size
FROM projects p
LEFT JOIN departments d ON p.dept_id = d.dept_id;

SELECT * FROM project_overview;

--Task2.4
CREATE VIEW high_earners AS
SELECT e.emp_name,
       e.salary,
       d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 55000;

SELECT * FROM high_earners;
-- Answer: only employees with salary strictly greater than 55000 are shown
-- (Jane Doe 60000, Sarah Williams 65000). Mike Johnson (exactly 55000)
-- is excluded because the condition is "> 55000", not ">=".
-- LEFT JOIN is used so a high earner without a department is not lost
-- (with INNER JOIN such an employee would disappear from the view).