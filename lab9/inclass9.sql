--1
CREATE OR REPLACE FUNCTION fee_band(p_fee NUMERIC) RETURNS TEXT AS $$
BEGIN
IF p_fee IS NULL THEN RETURN 'not billed';
ELSIF p_fee < 15 THEN RETURN 'small';
ELSIF p_fee < 40 THEN RETURN 'medium';
ELSE RETURN 'large';
END IF;
END; $$ LANGUAGE plpgsql;

SELECT rental_id, fee, fee_band(fee) FROM rentals ORDER BY rental_id;

DROP FUNCTION fee_band;

CREATE OR REPLACE FUNCTION fee_band(p_fee NUMERIC) RETURNS TEXT AS $$
BEGIN
    CASE
        WHEN p_fee IS NULL THEN RETURN 'not billed';
        WHEN p_fee < 15 THEN RETURN 'small';
        WHEN p_fee < 40 THEN RETURN 'medium';
    ELSE RETURN 'large';
    END CASE;

END; $$ language plpgsql;

SELECT rental_id, fee, fee_band(fee) FROM rentals ORDER BY rental_id;

--language sql does not work, only plpgsql
--rental 9 gets band not billed, because of first if condition
--if we remove first if condition, we would get large every time,
--because it gets to the last condition;

--2
CREATE OR REPLACE FUNCTION fee_per_day(p_rental_id INT) RETURNS NUMERIC AS $$
DECLARE d INT; f NUMERIC;
BEGIN
SELECT days, fee INTO d, f FROM rentals WHERE rental_id = p_rental_id;
IF f IS NULL THEN
RAISE EXCEPTION 'rental % has not been billed yet', p_rental_id
USING HINT = 'set its days and fee first', ERRCODE = '22023';
END IF;
RETURN ROUND(f / d, 2);
END; $$ LANGUAGE plpgsql;

SELECT fee_per_day(2);
SELECT fee_per_day(9);
UPDATE rentals SET days = 0, fee = 12.00 WHERE rental_id = 9;
SELECT fee_per_day(9);

--first call came from USING
CREATE OR REPLACE FUNCTION fee_per_day(p_rental_id INT) RETURNS NUMERIC AS $$
DECLARE d INT; f NUMERIC;
BEGIN
SELECT days, fee INTO d, f FROM rentals WHERE rental_id = p_rental_id;
IF f IS NULL THEN
RAISE EXCEPTION 'rental % has not been billed yet', p_rental_id
USING HINT = 'set its days and fee first', ERRCODE = '22023';
END IF;
IF d <> 0 THEN
    RETURN ROUND(f / d, 2);
end if;
IF d = 0 THEN
    RAISE EXCEPTION 'you can not divide by 0';
end if;
END; $$ LANGUAGE plpgsql;

--3
CREATE OR REPLACE PROCEDURE close_rental(p_rental_id INT, p_days INT)
LANGUAGE plpgsql AS $$
DECLARE rate NUMERIC;
BEGIN
SELECT b.daily_rate INTO rate FROM rentals r JOIN bikes b ON b.bike_id = r.bike_id
WHERE r.rental_id = p_rental_id;
UPDATE rentals SET days = p_days, fee = ROUND(p_days * rate, 2)
WHERE rental_id = p_rental_id;
COMMIT;
RAISE NOTICE 'rental % closed at %', p_rental_id, ROUND(p_days * rate, 2);
END; $$;

CALL close_rental(9, 4);

SELECT rental_id, days, fee FROM rentals WHERE rental_id = 9;

--rental 9 ended up with columns: days become 4 and fee become 28
--CALL is used just to update the results, but not to print it in the console.
--We print it when we type SELECT

CREATE OR REPLACE function close_rental_function(p_rental_id INT, p_days INT)
    RETURNS VOID AS $$
DECLARE rate NUMERIC;
BEGIN
SELECT b.daily_rate INTO rate FROM rentals r JOIN bikes b ON b.bike_id = r.bike_id
WHERE r.rental_id = p_rental_id;
UPDATE rentals SET days = p_days, fee = ROUND(p_days * rate, 2)
WHERE rental_id = p_rental_id;
COMMIT;
RAISE NOTICE 'rental % closed at %', p_rental_id, ROUND(p_days * rate, 2);
END; $$
LANGUAGE plpgsql;

SELECT rental_id, days, fee FROM rentals WHERE rental_id = 9;

--it printed the same results even when it became a function
