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

--Part5
--Task5.1
SELECT first_name || ' ' || last_name AS full_name,
       employee_id,
       salary
FROM employees
WHERE salary > 65000
UNION
SELECT first_name || ' ' || last_name AS full_name,
       employee_id,
       salary
FROM employees
WHERE hire_date > '2020-01-01';
--Task5.2
SELECT first_name || ' ' || last_name AS full_name,
       salary
FROM employees
WHERE department = 'IT'
INTERSECT
SELECT first_name || ' ' || last_name AS full_name,
       salary
FROM employees
WHERE salary > 65000;
--Task5.3
SELECT employee_id, e.first_name || ' ' || e.last_name AS full_name
FROM employees e
EXCEPT
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name
FROM employees e
JOIN assignments a
ON e.employee_id = a.employee_id;

--Part6
--Task6.1
SELECT e.first_name || ' ' || e.last_name AS full_name
FROM employees e
WHERE EXISTS(
    SELECT 1
    FROM assignments a
    WHERE a.employee_id = e.employee_id
);
--Task6.2
SELECT first_name || ' ' || last_name AS full_name
FROM employees
WHERE employee_id IN (
    SELECT a.employee_id
    FROM assignments a
    JOIN projects p ON a.project_id = p.project_id
    WHERE p.status = 'Active'
);
--Task6.3
SELECT first_name || ' ' || last_name AS full_name
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
    );

--Part7
--Task7.1
-- Task 7.1
SELECT e.first_name || ' ' || e.last_name AS full_name,
       e.department,
       e.salary,
       AVG(a.hours_worked) AS avg_hours_worked,
       RANK() OVER (PARTITION BY e.department ORDER BY e.salary ) AS salary_rank_in_dept
FROM employees e
LEFT JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department, e.salary
ORDER BY e.department, e.salary DESC;
--Task7.2
SELECT p.project_name,
       SUM(a.hours_worked) AS total_hours,
       COUNT(DISTINCT a.employee_id) as assigned_emp
FROM projects p
JOIN assignments a
ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name
HAVING SUM(a.hours_worked) > 150;
--Task7.3
SELECT e.department,
       COUNT(*) as total_employees,
       AVG(e.salary) AS average_salary,
       (SELECT e2.first_name || ' ' || e2.last_name as full_name
        FROM employees e2
        WHERE e2.department = e.department
        ORDER BY e2.salary DESC
        LIMIT 1) as highest_paid_employee,
        GREATEST(MAX(e.salary) - AVG(e.salary), 0) AS max_above_avg,
        LEAST(MIN(e.salary), AVG(e.salary)) AS lowest_value
FROM employees e
GROUP BY e.department;