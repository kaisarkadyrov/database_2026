#Laboratory Work #2

#Part 1
Task 1.1.
1.
CREATE DATABASE university_main
    OWNER CURRENT_USER
    TEMPLATE template0
    ENCODING 'UTF8';

2.
CREATE DATABASE university_archive
    TEMPLATE template0
    CONNECTION LIMIT 50;


3.
CREATE DATABASE university_test
    CONNECTION LIMIT 10;
 
ALTER DATABASE university_test WITH IS_TEMPLATE = true;

Task 1.2.
1.
CREATE TABLESPACE student_data
    LOCATION 'C:\data\students';

2.
CREATE TABLESPACE course_data
    OWNER postgres
    LOCATION '/data/courses';

3.
CREATE DATABASE university_distributed
    TABLESPACE student_data
    TEMPLATE template0
    ENCODING 'LATIN9';