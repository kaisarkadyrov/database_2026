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

