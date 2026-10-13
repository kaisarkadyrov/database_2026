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
-- test