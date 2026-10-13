--Task1
SELECT address,
       price_mln,
       ROUND((price_mln * 1000 / area_m2), 0) AS price_per_m2
FROM apartments
ORDER BY price_mln DESC NULLS LAST;
--Task2
SELECT DISTINCT district
FROM apartments
WHERE address LIKE '%Ave%' AND status = 'For sale'
GROUP BY district
ORDER BY district;
--Task3
SELECT district,
       COUNT(*) AS listings,
       CASE
           WHEN COUNT(area_m2) > 0 THEN COUNT(area_m2)
           ELSE 0
       END AS with_price,
       ROUND(AVG(price_mln), 1) AS avg_price
FROM apartments
GROUP BY district;

--Task4
SELECT district
FROM apartments
WHERE status = 'For sale'
INTERSECT
SELECT district
FROM apartments
WHERE status = 'Sold'
GROUP BY district;
--Task5
SELECT full_name
FROM agents
WHERE agent_id IN (
    SELECT a.agent_id
    FROM apartments a
    JOIN agents ag
    ON a.agent_id = ag.agent_id
    WHERE a.status = 'Sold'
);