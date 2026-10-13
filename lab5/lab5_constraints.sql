--Part1
--Task1.1
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK ( age BETWEEN 18 AND 65),
    salary NUMERIC CHECK(salary > 0)
);
--Task1.2
CREATE TABLE products_catalog (
    product_id     INTEGER,
    product_name   TEXT,
    regular_price  NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0
        AND discount_price > 0
        AND discount_price < regular_price
        )
);
--Task1.3
CREATE TABLE bookings (
    booking_id     INTEGER,
    check_in_date  DATE,
    check_out_date DATE,
    num_guests     INTEGER,
    CONSTRAINT num_guests CHECK ( num_guests BETWEEN 1 AND 10),
    CONSTRAINT check_out_date CHECK ( check_out_date > check_in_date )
);
--Task1.4
-- employees: valid data
INSERT INTO employees VALUES (1, 'John',  'Smith',  30, 3500.00);
INSERT INTO employees VALUES (2, 'Anna',  'Brown',  45, 5200.50);
-- employees: invalid data
-- INSERT INTO employees VALUES (3, 'Tom', 'Young', 17, 2000);
--   ERROR: new row for relation "employees" violates check constraint "employees_age_check"
--   Reason: age 17 is outside 18..65.
-- INSERT INTO employees VALUES (4, 'Bob', 'Old', 70, 2000);
--   ERROR: ... violates check constraint "employees_age_check"
--   Reason: age 70 is greater than 65.
-- INSERT INTO employees VALUES (5, 'Eve', 'Zero', 25, 0);
--   ERROR: ... violates check constraint "employees_salary_check"
--   Reason: salary must be > 0 (0 is not allowed).
-- INSERT INTO employees VALUES (6, 'Max', 'Minus', 25, -100);
--   ERROR: ... violates check constraint "employees_salary_check"
--   Reason: negative salary.

-- products_catalog: valid data
INSERT INTO products_catalog VALUES (1, 'Phone',  500.00, 450.00);
INSERT INTO products_catalog VALUES (2, 'Tablet', 300.00, 299.99);
-- products_catalog: invalid data
-- INSERT INTO products_catalog VALUES (3, 'TV', 0, 0);
--   ERROR: ... violates check constraint "valid_discount"
--   Reason: regular_price and discount_price must be > 0.
-- INSERT INTO products_catalog VALUES (4, 'Laptop', 1000, 0);
--   ERROR: ... violates check constraint "valid_discount"
--   Reason: discount_price must be > 0.
-- INSERT INTO products_catalog VALUES (5, 'Watch', 100, 150);
--   ERROR: ... violates check constraint "valid_discount"
--   Reason: discount_price (150) is not less than regular_price (100).
-- INSERT INTO products_catalog VALUES (6, 'Camera', 100, 100);
--   ERROR: ... violates check constraint "valid_discount"
--   Reason: discount_price must be strictly less than regular_price.

-- bookings: valid data
INSERT INTO bookings VALUES (1, '2026-11-01', '2026-11-05', 2);
INSERT INTO bookings VALUES (2, '2026-12-20', '2026-12-27', 10);
-- bookings: invalid data
-- INSERT INTO bookings VALUES (3, '2026-11-01', '2026-11-05', 0);
--   ERROR: ... violates check constraint "bookings_guests_check"
--   Reason: num_guests = 0, must be between 1 and 10.
-- INSERT INTO bookings VALUES (4, '2026-11-01', '2026-11-05', 11);
--   ERROR: ... violates check constraint "bookings_guests_check"
--   Reason: num_guests = 11, more than 10.
-- INSERT INTO bookings VALUES (5, '2026-11-10', '2026-11-05', 2);
--   ERROR: ... violates check constraint "bookings_dates_check"
--   Reason: check_out_date is before check_in_date.
-- INSERT INTO bookings VALUES (6, '2026-11-10', '2026-11-10', 2);
--   ERROR: ... violates check constraint "bookings_dates_check"
--   Reason: check_out_date must be strictly after check_in_date.


--Part2
--Task2.1
CREATE TABLE customers (
    customer_id       INTEGER NOT NULL,
    email             TEXT    NOT NULL,
    phone             TEXT,                -- nullable
    registration_date DATE    NOT NULL
);
--Task2.2
CREATE TABLE inventory (
    item_id      INTEGER   NOT NULL,
    item_name    TEXT      NOT NULL,
    quantity     INTEGER   NOT NULL CHECK (quantity >= 0),
    unit_price   NUMERIC   NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);
--Task2.3
INSERT INTO customers VALUES (1, 'a@mail.com', '+7-700-111-2233', '2026-01-10');
INSERT INTO customers VALUES (2, 'b@mail.com', '+7-700-444-5566', '2026-02-15');
INSERT INTO inventory VALUES (1, 'Notebook', 100, 2.50,  '2026-10-01 10:00:00');
INSERT INTO inventory VALUES (2, 'Pen',      500, 0.75,  '2026-10-02 11:30:00');

-- 2. NULL in NOT NULL columns
-- INSERT INTO customers VALUES (NULL, 'c@mail.com', NULL, '2026-03-01');
--   ERROR: null value in column "customer_id" of relation "customers" violates not-null constraint
-- INSERT INTO customers VALUES (3, NULL, NULL, '2026-03-01');
--   ERROR: null value in column "email" of relation "customers" violates not-null constraint
-- INSERT INTO customers VALUES (3, 'c@mail.com', NULL, NULL);
--   ERROR: null value in column "registration_date" of relation "customers" violates not-null constraint
-- INSERT INTO inventory VALUES (3, NULL, 10, 1.00, now());
--   ERROR: null value in column "item_name" of relation "inventory" violates not-null constraint
-- INSERT INTO inventory VALUES (4, 'Eraser', NULL, 1.00, now());
--   ERROR: null value in column "quantity" of relation "inventory" violates not-null constraint
-- INSERT INTO inventory VALUES (5, 'Ruler', -5, 1.00, now());
--   ERROR: ... violates check constraint "inventory_quantity_check"  (quantity must be >= 0)
-- INSERT INTO inventory VALUES (6, 'Glue', 5, 0, now());
--   ERROR: ... violates check constraint "inventory_unit_price_check" (unit_price must be > 0)

-- 3. NULL in nullable column (phone) - succeeds
INSERT INTO customers VALUES (3, 'c@mail.com', NULL, '2026-03-01');
INSERT INTO customers VALUES (4, 'd@mail.com', NULL, '2026-03-05');

--Part3
--Task3.1
CREATE TABLE users (
    user_id    INTEGER,
    username   TEXT UNIQUE,
    email      TEXT UNIQUE,
    created_at TIMESTAMP
);
--Task3.2
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id    INTEGER,
    course_code   TEXT,
    semester      TEXT,
    UNIQUE (student_id, course_code, semester)
);
--Task3.3
ALTER TABLE users DROP CONSTRAINT users_username_key;
ALTER TABLE users DROP CONSTRAINT users_email_key;
ALTER TABLE users ADD CONSTRAINT unique_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT unique_email    UNIQUE (email);

INSERT INTO users VALUES (1, 'alice', 'alice@mail.com', now());
INSERT INTO users VALUES (2, 'bob',   'bob@mail.com',   now());
-- INSERT INTO users VALUES (3, 'alice', 'other@mail.com', now());
--   ERROR: duplicate key value violates unique constraint "unique_username"
-- INSERT INTO users VALUES (4, 'carol', 'bob@mail.com', now());
--   ERROR: duplicate key value violates unique constraint "unique_email"
-- NULLs do not conflict with UNIQUE (NULL <> NULL), so this works twice:
INSERT INTO users VALUES (5, NULL, NULL, now());
INSERT INTO users VALUES (6, NULL, NULL, now());

