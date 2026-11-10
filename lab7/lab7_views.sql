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

--Part3

--Task3.1
CREATE OR REPLACE VIEW employee_details AS
SELECT e.emp_id,
       e.emp_name,
       e.salary,
       d.dept_name,
       d.location,
       CASE
           WHEN e.salary > 60000 THEN 'High'
           WHEN e.salary > 50000 THEN 'Medium'
           ELSE 'Standard'
       END AS salary_grade
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

SELECT * FROM employee_details;

--Task3.2
ALTER VIEW high_earners RENAME TO top_performers;

SELECT * FROM top_performers;


--Task3.3
CREATE VIEW temp_view AS
SELECT emp_id, emp_name, salary
FROM employees
WHERE salary < 50000;

SELECT * FROM temp_view;

DROP VIEW temp_view;


--Part4

--Task4.1
CREATE VIEW employee_salaries AS
SELECT emp_id, emp_name, dept_id, salary
FROM employees;


--Task4.2
UPDATE employee_salaries
SET salary = 52000
WHERE emp_name = 'John Smith';

SELECT * FROM employees WHERE emp_name = 'John Smith';
-- Answer: yes, the underlying employees table was updated. The view stores
-- no data itself, so the UPDATE is applied to employees.


--Task4.3
INSERT INTO employee_salaries (emp_id, emp_name, dept_id, salary)
VALUES (6, 'Alice Johnson', 102, 58000);

SELECT * FROM employees;
-- Answer: the insert was successful; Alice Johnson now appears in the
-- employees table.


--Task4.4
CREATE VIEW it_employees AS
SELECT emp_id, emp_name, dept_id, salary
FROM employees
WHERE dept_id = 101
WITH LOCAL CHECK OPTION;

-- This should fail
INSERT INTO it_employees (emp_id, emp_name, dept_id, salary)
VALUES (7, 'Bob Wilson', 103, 60000);
-- Answer: ERROR: new row violates check option for view "it_employees"
-- DETAIL: Failing row contains (7, Bob Wilson, 103, 60000.00).
-- Reason: CHECK OPTION rejects inserts/updates that produce rows not
-- satisfying the view's WHERE condition (dept_id = 101), i.e. rows that
-- would not be visible through the view after the insert.



--Part 5

--Task5.1
CREATE MATERIALIZED VIEW dept_summary_mv AS
SELECT d.dept_id,
       d.dept_name,
       COALESCE(e.total_employees, 0) AS total_employees,
       COALESCE(e.total_salaries, 0)  AS total_salaries,
       COALESCE(p.total_projects, 0)  AS total_projects,
       COALESCE(p.total_budget, 0)    AS total_budget
FROM departments d
LEFT JOIN (
    SELECT dept_id,
           COUNT(*)    AS total_employees,
           SUM(salary) AS total_salaries
    FROM employees
    GROUP BY dept_id
) e ON d.dept_id = e.dept_id
LEFT JOIN (
    SELECT dept_id,
           COUNT(*)    AS total_projects,
           SUM(budget) AS total_budget
    FROM projects
    GROUP BY dept_id
) p ON d.dept_id = p.dept_id
WITH DATA;

SELECT * FROM dept_summary_mv ORDER BY total_employees DESC;


--Task5.2
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES (8, 'Charlie Brown', 101, 54000);

-- Before refresh:
SELECT * FROM dept_summary_mv ORDER BY total_employees DESC;

REFRESH MATERIALIZED VIEW dept_summary_mv;

-- After refresh:
SELECT * FROM dept_summary_mv ORDER BY total_employees DESC;
-- Answer: before REFRESH the materialized view still shows the old snapshot
-- taken at creation time, so Charlie Brown is not counted. After REFRESH,
-- IT (101) has total_employees increased by 1 and total_salaries by 54000.


--Task5.3
CREATE UNIQUE INDEX idx_dept_summary_mv_dept_id
    ON dept_summary_mv (dept_id);

REFRESH MATERIALIZED VIEW CONCURRENTLY dept_summary_mv;
-- Answer: a regular REFRESH takes an ACCESS EXCLUSIVE lock, so nobody can
-- read the materialized view while it runs. CONCURRENTLY refreshes the data
-- without blocking SELECT queries: it builds a new version and applies only
-- the differences. It requires a unique index and works only if the view
-- is already populated.


--Task5.4
CREATE MATERIALIZED VIEW project_stats_mv AS
SELECT p.project_name,
       p.budget,
       d.dept_name,
       COUNT(e.emp_id) AS assigned_employees
FROM projects p
LEFT JOIN departments d ON p.dept_id = d.dept_id
LEFT JOIN employees e   ON p.dept_id = e.dept_id
GROUP BY p.project_id, p.project_name, p.budget, d.dept_name
WITH NO DATA;

SELECT * FROM project_stats_mv;
-- Answer: ERROR: materialized view "project_stats_mv" has not been populated
-- HINT: Use the REFRESH MATERIALIZED VIEW command.
-- Fix: populate it with data:
REFRESH MATERIALIZED VIEW project_stats_mv;

SELECT * FROM project_stats_mv;