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