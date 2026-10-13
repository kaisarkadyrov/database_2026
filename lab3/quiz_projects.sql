--Task1
INSERT INTO projects (project_name, budget, start_date, end_date)
VALUES ('Mobile App', 400000*1.25, CURRENT_DATE, CURRENT_DATE + 90)
RETURNING project_id, budget, start_date, end_date;

--Task2
UPDATE team_members
SET status = 'Unassigned'
WHERE project_id is NULL
RETURNING full_name, status;

--Task3
UPDATE projects
SET completion_pct = CASE
    WHEN total_tasks = 0 THEN 0
    ELSE round(done_tasks::numeric * 100) / total_tasks
END;

SELECT * FROM projects;

--Task4
UPDATE projects p
SET end_date = end_date + 30
WHERE budget > 500000
RETURNING project_name, end_date;
