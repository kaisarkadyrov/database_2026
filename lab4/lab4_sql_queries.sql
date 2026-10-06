-- PART 1

--Task1.1
SELECT first_name || ' ' || last_name AS full_name,
       department,
       salary
FROM employees;
--Task1.2
SELECT DISTINCT department FROM employees;
--Task1.3
SELECT project_name,
       budget,
       CASE
           WHEN budget > 150000 THEN 'Large'
           WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium'
           ELSE 'Small'
       END AS budget_category
FROM projects;
--Task1.4
SELECT first_name || ' ' || last_name AS full_name,
       coalesce(email, 'No email provided') AS email
FROM employees;

--Part2
--Task2.1
SELECT * FROM employees WHERE hire_date > '2020-01-01';
--Task2.2
SELECT * FROM employees
    WHERE salary BETWEEN 60000 AND 70000;
--Task2.3
SELECT * from employees
    WHERE last_name LIKE 'S%' OR last_name LIKE 'J%';
--Task2.4
SELECT * FROM employees
    WHERE manager_id IS NOT NULL AND department = 'IT';