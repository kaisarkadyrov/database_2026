-- 1.
CREATE DATABASE advanced_lab;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary INTEGER,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INTEGER,
    manager_id INTEGER
);

create table projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

-- Part B
--Task 2
--2
INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (1, 'Azamat', 'Nurlan', 'IT');

--3
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Aigul', 'Sarsen', 'HR', DEFAULT, '2023-01-12', DEFAULT);

--4
INSERT INTO departments (dept_name, budget, manager_id)
VALUES ('IT', 100000, 1),
       ('HR', 200000, 2),
       ('Sales', 150000, NULL);

--5
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Dulat', 'Kaliev', 'Sales', 50000*1.1, CURRENT_DATE);

--6
CREATE TEMPORARY TABLE temp_employees (LIKE employees);

INSERT INTO temp_employees
SELECT * FROM employees WHERE department = 'IT';

--Part C
--7
UPDATE employees
set salary = salary * 1.1;

--8
UPDATE employees
SET status = 'Senior'
WHERE salary > 60000
And hire_date < '2020-01-01';

--9
UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

--10
UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Kanat', 'Ibraev',  'IT',    70000, '2020-04-01'),
       ('Madina','Serik',   'IT',    55000, '2021-07-19'),
       ('Nurlan','Abenov',  'IT',    62000, '2022-10-03'),
       ('Zhanna','Kasym',   'Sales', 48000, '2021-11-11'),
       ('Rustem','Tolegen', 'Sales', 52000, '2020-12-01');

--11
UPDATE departments d
SET budget = (SELECT AVG(e.salary) * 1.2
                FROM employees e
                WHERE e.department = d.dept_name)
WHERE EXISTS (SELECT 1
                FROM employees e
                WHERE e.department = d.dept_name
                    AND e.salary IS NOT NULL);

--12
UPDATE employees
SET salary = salary * 1.5, status = 'Promoted'
WHERE department = 'Sales';

--Part D
--13
delete from employees
WHERE status = 'Terminated';

--14
DELETE from employees
WHERE salary < 40000
AND hire_date > '2023-01-01'
AND department IS NULL;

--15
delete from departments
WHERE dept_name NOT IN (SELECT DISTINCT department
                        FROM employees
                        WHERE department IS NOT NULL);

--16
DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

--Part E
--17
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Nobody', 'Yet', NULL, NULL, CURRENT_DATE);

--18
UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

--19
DELETE FROM employees
WHERE salary IS NULL
OR department is NULL;

-- Part F
--20
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Asel', 'Mukhamed', 'IT', 60000, CURRENT_DATE)
RETURNING emp_id, first_name || ' ' || last_name AS full_name;

--21
UPDATE employees e
SET salary = e.salary + 5000
FROM (select emp_id, salary as old_salary
      FROM employees
      WHERE department = 'IT') as old_data
WHERE e.emp_id = old_data.emp_id
RETURNING e.emp_id, old_data.old_salary, e.salary AS new_salary;

--22
DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

