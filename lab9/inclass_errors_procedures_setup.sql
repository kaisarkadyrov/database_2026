-- ============================================================
-- In-Class Task: Errors, Handlers and Procedures
-- Laboratory Work 9 - Stored Procedures.  PostgreSQL 11+ (tested on 16).
-- Step 3 needs PostgreSQL 11 or later: CREATE PROCEDURE and COMMIT.
-- Run this setup first, then work through steps 1-3 on the handout.
-- Step 2 is MEANT to raise two errors; those errors are the question.
-- (Same schema as the previous two in-class tasks - reuse that database if you have it.)
-- ============================================================

DROP TABLE IF EXISTS rentals, bikes;

CREATE TABLE bikes (
    bike_id    INT PRIMARY KEY,
    model      VARCHAR(30)  NOT NULL,
    daily_rate NUMERIC(6,2) NOT NULL);

CREATE TABLE rentals (
    rental_id INT PRIMARY KEY,
    bike_id   INT NOT NULL REFERENCES bikes(bike_id),
    member    VARCHAR(30) NOT NULL,
    days      INT,
    fee       NUMERIC(8,2));

INSERT INTO bikes VALUES
 (1, 'City Cruiser', 4.50), (2, 'Mountain X',  7.00),
 (3, 'Road Sprint',  9.25), (4, 'Folding Mini', 3.75);

INSERT INTO rentals VALUES
 (1, 1, 'Aisha',   3, 13.50), (2, 2, 'Aisha',   5, 35.00),
 (3, 3, 'Daniyar', 2, 18.50), (4, 1, 'Daniyar', 7, 31.50),
 (5, 2, 'Marta',   4, 28.00), (6, 3, 'Marta',   8, 74.00),
 (7, 4, 'Omar',    6, 22.50), (8, 1, 'Aisha',   1,  4.50),
 (9, 2, 'Omar',    NULL, NULL);
