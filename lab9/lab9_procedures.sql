DROP TABLE IF EXISTS rentals, bikes, members, stations CASCADE;
-- Create table: stations
CREATE TABLE stations (
station_id INT PRIMARY KEY,
station_name VARCHAR(50) NOT NULL,
city VARCHAR(40) NOT NULL,
capacity INT NOT NULL
);
-- Create table: bikes
CREATE TABLE bikes (
bike_id INT PRIMARY KEY,
model VARCHAR(50) NOT NULL,
station_id INT REFERENCES stations(station_id),
daily_rate NUMERIC(8,2) NOT NULL
);

CREATE TABLE members (
member_id INT PRIMARY KEY,
full_name VARCHAR(60) NOT NULL,
city VARCHAR(40) NOT NULL,
joined_on DATE NOT NULL
);
-- Create table: rentals
CREATE TABLE rentals (
rental_id INT PRIMARY KEY,
member_id INT REFERENCES members(member_id),
bike_id INT REFERENCES bikes(bike_id),
start_date DATE NOT NULL,
end_date DATE,
fee NUMERIC(8,2)
);

INSERT INTO stations VALUES
(10, 'Central Park', 'Almaty', 4),
(20, 'Riverside', 'Almaty', 3),
(30, 'Expo Gate', 'Astana', 5),
(40, 'Old Town', 'Shymkent', 2),
(50, 'Depot', 'Astana', 0);
INSERT INTO bikes VALUES
(101, 'City Cruiser', 10, 4.50),
(102, 'City Cruiser', 10, 4.50),
(103, 'Mountain X', 20, 7.00),
(104, 'Mountain X', 30, 7.00),
(105, 'Road Sprint', 30, 9.25),
(106, 'Folding Mini', 40, 3.75),
(107, 'Cargo Hauler', 20, 12.00),
(108, 'Road Sprint', 10, 9.25);
INSERT INTO members VALUES
(1, 'Aisha Nurlanova', 'Almaty', DATE '2023-03-14'),
(2, 'Daniyar Serik', 'Almaty', DATE '2023-07-02'),
(3, 'Marta Kowalski', 'Astana', DATE '2024-01-20'),
(4, 'Chen Wei', 'Astana', DATE '2024-05-11'),
(5, 'Omar Haddad', 'Shymkent', DATE '2024-09-30'),
(6, 'Elena Petrova', 'Almaty', DATE '2025-02-05');

INSERT INTO rentals VALUES
( 1, 1, 101, DATE '2024-04-05', DATE '2024-04-08', 13.50),
( 2, 1, 103, DATE '2024-06-11', DATE '2024-06-16', 35.00),
( 3, 1, 108, DATE '2025-02-02', DATE '2025-02-04', 18.50),
( 4, 1, 102, DATE '2025-05-20', DATE '2025-05-27', 31.50),
( 5, 2, 101, DATE '2024-05-01', DATE '2024-05-02', 4.50),
( 6, 2, 107, DATE '2024-11-15', DATE '2024-11-19', 48.00),
( 7, 2, 107, DATE '2025-03-08', DATE '2025-03-14', 72.00),
( 8, 3, 104, DATE '2024-02-14', DATE '2024-02-18', 28.00),
( 9, 3, 105, DATE '2024-08-03', DATE '2024-08-06', 27.75),
(10, 3, 104, DATE '2025-01-09', DATE '2025-01-10', 7.00),
(11, 3, 105, DATE '2025-06-01', DATE '2025-06-09', 74.00),
(12, 4, 104, DATE '2024-07-19', DATE '2024-07-21', 14.00),
(13, 4, 105, DATE '2025-04-12', DATE '2025-04-15', 27.75),
(14, 4, 103, DATE '2025-07-23', DATE '2025-07-29', 42.00),
(15, 5, 106, DATE '2024-10-05', DATE '2024-10-12', 26.25),
(16, 5, 106, DATE '2025-01-18', DATE '2025-01-20', 7.50),
(17, 5, 106, DATE '2025-08-14', DATE '2025-08-21', 26.25),
(18, 2, 102, DATE '2025-09-02', DATE '2025-09-05', 13.50),
(19, 1, 101, DATE '2025-10-10', NULL, NULL),
(20, 4, 108, DATE '2024-12-28', DATE '2025-01-03', 55.50),
(21, 3, 103, DATE '2025-02-26', DATE '2025-03-02', 28.00),
(22, 5, 104, DATE '2025-05-05', DATE '2025-05-08', 21.00);


SELECT (SELECT COUNT(*) FROM stations) AS stations,
(SELECT COUNT(*) FROM bikes) AS bikes,
(SELECT COUNT(*) FROM members) AS members,
(SELECT COUNT(*) FROM rentals) AS rentals;


--Part 2
--2.1
CREATE OR REPLACE FUNCTION rental_days(p_rental_id INTEGER) RETURNS INTEGER AS $$
DECLARE
    result INTEGER;
BEGIN
    SELECT end_date - start_date
    INTO result
    FROM rentals
    WHERE rental_id = p_rental_id;
    RETURN result;
END; $$
LANGUAGE plpgsql;

SELECT rental_days(2);
SELECT rental_days(11);
SELECT rental_days(19);    -- open rental: end_date IS NULL
SELECT rental_days(999);

--2.2
CREATE OR REPLACE FUNCTION member_rental_count(p_member_id INT) RETURNS INT AS $$
declare v_cnt INT;
BEGIN
    SELECT COUNT(*) into v_cnt
    FROM rentals
    WHERE member_id = p_member_id;
    RETURN v_cnt;
END; $$
LANGUAGE plpgsql;

SELECT member_rental_count(1) AS m1,
       member_rental_count(5) AS m5,
       member_rental_count(6) AS m6,
       member_rental_count(99) AS m99;

--2.3
CREATE OR REPLACE FUNCTION station_city(p_station_id INT) RETURNS VARCHAR AS $$
DECLARE
    v_city VARCHAR;
BEGIN
    SELECT city INTO v_city
      FROM stations
     WHERE station_id = p_station_id;
    RETURN v_city;
END; $$
LANGUAGE plpgsql;

SELECT station_city(30);
SELECT station_city(77);

--2.4
SELECT rental_id, member_id, rental_days(rental_id) AS duration
  FROM rentals
 WHERE rental_days(rental_id) > 4
 ORDER BY duration DESC, rental_id;

--Part 3
--3.1
CREATE OR REPLACE FUNCTION fee_with_discount(p_fee NUMERIC, p_percent NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN ROUND(p_fee * (100 - p_percent) / 100, 2);
END; $$
LANGUAGE plpgsql;

SELECT fee_with_discount(74.00, 15);

--3.2
CREATE OR REPLACE FUNCTION member_stats(
    p_member_id    INT,
    OUT rental_cnt INT,
    OUT total_fee  NUMERIC,
    OUT last_start DATE)
AS $$
BEGIN
    SELECT COUNT(*), COALESCE(SUM(fee), 0), MAX(start_date)
      INTO rental_cnt, total_fee, last_start
      FROM rentals
     WHERE member_id = p_member_id;
END; $$
LANGUAGE plpgsql;

SELECT member_stats(3);
SELECT * FROM member_stats(3);

--3.3
CREATE OR REPLACE FUNCTION apply_late_fee(INOUT p_fee NUMERIC) AS $$
BEGIN
    p_fee := p_fee + 5.00;
END; $$
LANGUAGE plpgsql;

SELECT rental_id, fee, apply_late_fee(fee) AS fee_with_late_charge
  FROM rentals
 WHERE rental_id = 1;

--3.4
CREATE OR REPLACE FUNCTION fee_summary(
    VARIADIC p_fees NUMERIC[],
    OUT total   NUMERIC,
    OUT average NUMERIC,
    OUT largest NUMERIC)
AS $$
BEGIN
    SELECT SUM(p_fees[i]), ROUND(AVG(p_fees[i]), 2), MAX(p_fees[i])
      INTO total, average, largest
      FROM generate_subscripts(p_fees, 1) g(i);
END; $$
LANGUAGE plpgsql;

SELECT * FROM fee_summary(13.50, 35.00, 18.50, 31.50);

-- EXPECTED ERROR: no arguments at all
SELECT * FROM fee_summary();

--3.5

