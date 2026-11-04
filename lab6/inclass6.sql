--Part A
--1 a)
SELECT * FROM students s
CROSS JOIN courses c;
--Will print count of rows from students * count of rows from courses
--Predicted: 20
--Printed: 20

--b)
SELECT s.full_name, e.grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;
--Predicted 5 rows.
--Prints 7 rows.

--c)
SELECT s.full_name, e.grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id;
--Predicted 5 rows.
--Prints 8 rows.

--d)
SELECT c.title, e.grade
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id;
--Predicted 8 rows.
--Prints 8 rows.

--e)
SELECT d.dept_name, c.title
FROM departments d
FULL JOIN courses c ON d.dept_code = c.dept_code;
--Predicted 6 rows
--Prints 6 rows.

--2
--a,d,e are correct.

--3
SELECT * from students, courses; --same amount of rows.
SELECT * from students
INNER JOIN courses ON TRUE; --same amount of rows.

--Part B
--1
SELECT s.full_name, c.title
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id;

--2
SELECT s.full_name
FROM students s
INNER JOIN enrollments e ON e.student_id = s.student_id
INNER JOIN courses c ON c.course_id = e.course_id;

--3
SELECT c.title
FROM courses c
INNER JOIN enrollments e ON c.course_id = e.course_id
WHERE c.course_id = NULL;

--4


--Part C
SELECT d.dept_name
FROM departments d
FULL JOIN courses c on d.dept_code = c.dept_code;

--2
