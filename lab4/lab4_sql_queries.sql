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

--Part3
--Task3.1
SELECT upper(first_name) || ' ' || upper(last_name) as upper_names,
       length(last_name) AS len_last_name,
       substring(email FROM 1 FOR 3) as email_prefix
FROM employees;
--Task3.2
SELECT first_name || ' ' || last_name AS full_name,
       salary * 12 AS annual_salary,
       ROUND(salary/12, 2) as montly_salary,
       salary * 0.1 as raise_amount
FROM employees;
--Task3.3
SELECT format('Project: %s - Budget: $%s - Status: %s',
        project_name, budget, status
       ) as project_info
FROM projects;
--Task3.4
SELECT first_name || ' ' || last_name AS full_name,
       hire_date,
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_with_company
FROM employees;

--Part4
--Task4.1
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
--Task4.2
SELECT p.project_name,
       SUM(a.hours_worked) AS total_hours
FROM projects p
JOIN assignments a
    ON p.project_id = a.project_id
GROUP BY p.project_name;
--Task4.3
SELECT department,
       COUNT(*) as num_of_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;
--Task4.4
SELECT MAX(salary) AS max_salary,
       MIN(salary) AS min_salary,
       SUM(salary) AS total_payroll
FROM employees;