-- Kadyrov Kaisar
-- Group Wednesday 1pm

--Task1
CREATE TABLE coaches (
    coach_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE
);
ALTER TABLE coaches ADD CONSTRAINT unique_email UNIQUE(email);
--Task2
CREATE TABLE players (
    player_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    rating INTEGER NOT NULL CHECK ( rating BETWEEN 100 AND 3000 ) DEFAULT 1200,
    coach_id INTEGER REFERENCES coaches ON DELETE CASCADE
);
--Task3
CREATE TABLE matches (
    match_id INTEGER PRIMARY KEY,
    white_id INTEGER NOT NULL REFERENCES players,
    black_id INTEGER NOT NULL REFERENCES players,
    match_date DATE NOT NULL,
    CONSTRAINT different_players CHECK ( white_id <> black_id ),
    UNIQUE (white_id, black_id, match_date)
);

--Task4
-- A
INSERT INTO matches (match_id, white_id, black_id,
match_date) VALUES (3, 2, 1, '2026-10-10');
--OK

--B
INSERT INTO matches (match_id, white_id, black_id,
match_date) VALUES (4, 3, 3, '2026-10-11');
--Does not work because white_id and black_id must be different from
--each other. A player cannot play against themselves

--C
ALTER TABLE players ADD COLUMN email TEXT CONSTRAINT unique_email UNIQUE;
--OK

--D
DELETE FROM coaches WHERE coach_id = 1;
-- Here it cannot be deleted because table players references to table coaches
-- while matches references to table players

--E
DELETE FROM players WHERE player_id = 4;
--Same case, table matches references to table players

--F
UPDATE players SET rating = rating + 1000 WHERE coach_id IS NULL;
-- Does not work because if a player has rating at least 2000,
--the check constraint breaks (CHECK ( rating BETWEEN 100 AND 3000))
-- It can not be more than 3000