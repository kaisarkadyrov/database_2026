Task1

CREATE DATABASE airport_db
    TEMPLATE template0
    ENCODING 'UTF8'
    CONNECTION LIMIT 30;

Task2 
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_code CHAR(6),
    origin CHAR(3),
    destination CHAR(3),
    departure TIMESTAMP WITH TIME ZONE,
    flight_time INTERVAL,
    ticket_price NUMERIC(6, 2),
    is_international BOOLEAN DEFAULT true;
);

Task3
CREATE TABLE passengers(
    passenger_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    birth_date DATE,
    loyalty_points INTEGER,
    notes TEXT,
    registered_at TIMESTAMP WITHOUT TIME ZONE;
);

Task 4
1. ALTER TABLE flights ALTER COLUMN flight_code TYPE VARCHAR(8);
2. ALTER TABLE flights 
3. ALTER TABLE flights ADD COLUMN gate VARCHAR(5);
4. ALTER TABLE passengers ALTER COLUMN loyalty_points TYPE INTEGER
    ALTER TABLE passengers DROP COLUMN notes;
5. ALTER TABLE passengers ADD COLUMN seat_class CHAR(1) DEFAULT 'E';

Task 5
1.DROP TABLE passenger IF EXISTS;
2.ALTER DATABASE airport_db CONNECTION LIMIT 100;