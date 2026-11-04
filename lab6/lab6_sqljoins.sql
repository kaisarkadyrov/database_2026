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

--Part6

--Task6.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id;
-- Answer: 6 rows.
-- NULLs on the LEFT side (employee columns): Marketing - a department
--   with no employees.
-- NULLs on the RIGHT side (department columns): Tom Brown - an employee
--   with no department.

--Task6.2
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p ON d.dept_id = p.dept_id;
-- 6 rows: Marketing has no project (project columns NULL),
-- AI Research has no department (dept_name NULL).

--Task6.3
SELECT
    CASE
        WHEN e.emp_id  IS NULL THEN 'Department without employees'
        WHEN d.dept_id IS NULL THEN 'Employee without department'
        ELSE 'Matched'
    END AS record_status,
    e.emp_name,
    d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;
-- Result: Tom Brown (employee without department),
--         Marketing (department without employees).

--Part7
--Task7.1
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d
       ON e.dept_id = d.dept_id
      AND d.location = 'Building A';
-- 5 rows: John and Mike get 'IT'; Jane, Sarah, Tom get dept_name NULL.

--Task7.2
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
-- 2 rows: John Smith and Mike Johnson only.
--
-- Difference: in Query 1 the condition is part of the matching rule,
-- so it only decides WHICH department is attached; the LEFT JOIN still
-- keeps every employee (non-matching ones get NULLs).
-- In Query 2 the join is done first and WHERE filters the result
-- afterwards; rows with location NULL or not 'Building A' are removed,
-- so the LEFT JOIN effectively becomes an INNER JOIN.

--Task7.3
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d
        ON e.dept_id = d.dept_id
       AND d.location = 'Building A';

-- Filter in WHERE:
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
-- Answer: no difference, both return John Smith and Mike Johnson.
-- An INNER JOIN keeps only rows where the whole ON condition is TRUE,
-- and WHERE also keeps only rows where its condition is TRUE, so it
-- does not matter at which stage the filter is applied - no rows are
-- preserved with NULLs as in outer joins.

--Part8
--Task8.1
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    p.project_name,
    p.budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects  p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;
-- All 4 departments appear; Marketing with NULL employee and project.

--Task8.2
ALTER TABLE employees ADD COLUMN manager_id INT;

UPDATE employees SET manager_id = 3    WHERE emp_id = 1;
UPDATE employees SET manager_id = 3    WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3    WHERE emp_id = 4;
UPDATE employees SET manager_id = 3    WHERE emp_id = 5;

SELECT
    e.emp_name AS employee,
    m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;
-- Everyone's manager is Mike Johnson; Mike himself has manager NULL
-- (LEFT JOIN keeps him in the result).

--Task8.3
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;
-- IT 52500, HR 60000, Finance 65000.

-- Same task written with a subquery:
SELECT d.dept_name, s.avg_salary
FROM departments d
INNER JOIN (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
) s ON d.dept_id = s.dept_id
WHERE s.avg_salary > 50000;

-- =====================================================================
-- Lab Questions
-- =====================================================================

-- 1. Difference between INNER JOIN and LEFT JOIN?
--    INNER JOIN returns only rows that have a match in both tables.
--    LEFT JOIN returns all rows from the left table; where there is no
--    match in the right table, the right-side columns are NULL.
--
-- 2. When to use CROSS JOIN in practice?
--    When every combination is needed: availability/schedule matrices
--    (employees x projects), all size x color product variants,
--    calendar of dates x stores for reports, generating test data.
--
-- 3. Why does the position of a filter (ON vs WHERE) matter for outer
--    joins but not for inner joins?
--    In an outer join, ON only decides which rows match; unmatched rows
--    of the preserved table are still returned with NULLs. WHERE runs
--    after the join and removes rows, including those NULL-filled rows.
--    In an inner join unmatched rows are discarded anyway, so filtering
--    during the join (ON) or after it (WHERE) gives the same result.
--
-- 4. SELECT COUNT(*) FROM table1 CROSS JOIN table2 (5 and 10 rows)?
--    5 x 10 = 50.
--
-- 5. How does NATURAL JOIN choose join columns?
--    It automatically joins on ALL columns that have the same name in
--    both tables (equality on each), and outputs each such column once.
--
-- 6. Risks of NATURAL JOIN?
--    - Columns are chosen implicitly: an unrelated column with the same
--      name (e.g. "name", "created_at", "id") silently becomes part of
--      the join condition and gives wrong or empty results.
--    - Adding/renaming a column later can change the query's behavior
--      without any error.
--    - If there are no common columns it becomes a CROSS JOIN.
--    - The query is harder to read because the condition is not visible.
--
-- 7. Convert SELECT * FROM A LEFT JOIN B ON A.id = B.id to RIGHT JOIN:
--    SELECT * FROM B RIGHT JOIN A ON A.id = B.id;
--    (Same rows; with SELECT * the column order changes - B's columns
--    come first.)
--
-- 8. When to use FULL OUTER JOIN?
--    When unmatched rows from BOTH tables are needed: reconciling two
--    data sources, finding orphaned records on either side (as in 6.3),
--    comparing two lists to see what is only in A, only in B, or in both.