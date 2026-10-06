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
