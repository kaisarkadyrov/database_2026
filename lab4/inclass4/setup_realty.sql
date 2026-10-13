-- Setup for In-Class Task: Real Estate (run before the task)
DROP TABLE IF EXISTS apartments;
DROP TABLE IF EXISTS agents;

CREATE TABLE agents (
    agent_id  SERIAL PRIMARY KEY,
    full_name VARCHAR(50)
);

CREATE TABLE apartments (
    apt_id    SERIAL PRIMARY KEY,
    district  VARCHAR(20),
    address   VARCHAR(40),
    rooms     INTEGER,
    area_m2   NUMERIC(5,1),
    price_mln NUMERIC(6,1),          -- price in million tenge, NULL = "price on request"
    status    VARCHAR(10),
    agent_id  INTEGER REFERENCES agents(agent_id)
);

INSERT INTO agents (full_name) VALUES
    ('Aidana Serikova'),
    ('Bolat Tursynov'),
    ('Gulmira Akhmet'),
    ('Ruslan Kim');

INSERT INTO apartments (district, address, rooms, area_m2, price_mln, status, agent_id) VALUES
    ('Medeu',     'Dostyk Ave 97',     3,  95.0,  78.0, 'Sold',     1),
    ('Medeu',     'Kabanbay St 12',    2,  60.0,  NULL, 'For sale', 1),
    ('Almaly',    'Abay Ave 10',       2,  58.0,  42.0, 'For sale', 2),
    ('Almaly',    'Tole Bi St 45',     1,  38.0,  27.5, 'Sold',     2),
    ('Almaly',    'Abay Ave 52',       3,  82.0,  61.0, 'For sale', 3),
    ('Bostandyk', 'Al-Farabi Ave 21',  4, 130.0, 120.0, 'For sale', 3),
    ('Bostandyk', 'Timiryazev St 8',   2,  55.0,  45.0, 'Sold',     2),
    ('Bostandyk', 'Rozybakiev St 30',  3,  76.0,  NULL, 'For sale', 1),
    ('Auezov',    'Zhandosov St 60',   1,  35.0,  22.0, 'Sold',     3),
    ('Auezov',    'Abay Ave 150',      2,  50.0,  30.0, 'Sold',     1);
