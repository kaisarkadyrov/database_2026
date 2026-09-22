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

#Part 2
#Task 2.1.

1.
CREATE TABLE students (
    student_id       SERIAL PRIMARY KEY,
    first_name       VARCHAR(50),
    last_name        VARCHAR(50),
    email            VARCHAR(100),
    phone            CHAR(15),
    date_of_birth    DATE,
    enrollment_date  DATE,
    gpa              NUMERIC(3,2),
    is_active        BOOLEAN,
    graduation_year  SMALLINT
);

2.
CREATE TABLE professors (
    professor_id     SERIAL PRIMARY KEY,
    first_name       VARCHAR(50),
    last_name        VARCHAR(50),
    email            VARCHAR(100),
    office_number    VARCHAR(20),
    hire_date        DATE,
    salary           NUMERIC(12,2),
    is_tenured       BOOLEAN,
    years_experience INTEGER
);

3.
CREATE TABLE courses (
    course_id        SERIAL PRIMARY KEY,
    course_code      CHAR(8),
    course_title     VARCHAR(100),
    description      TEXT,
    credits          SMALLINT,
    max_enrollment   INTEGER,
    course_fee       NUMERIC(8,2),
    is_online        BOOLEAN,
    created_at       TIMESTAMP WITHOUT TIME ZONE
);