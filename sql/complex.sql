/*
Consider an employees table with the following columns:

employee_id
name
manager_id (this is NULL for top-level managers)
Task: Write a SQL query using a recursive Common Table Expression (CTE) to retrieve the full reporting hierarchy (i.e., all managers above) for a given employee (for example, where employee_id = 5). Please explain your query and its logic.
*/
-- Create the employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager_id INT,
    -- Optional: enforce a self-referential foreign key
    CONSTRAINT fk_manager
       FOREIGN KEY (manager_id)
       REFERENCES employees(employee_id)
);


-- Insert sample data
-- Hierarchy:
-- Alice (CEO) -> Bob (VP) -> Diana (Manager) -> Eve (Employee)
-- Also adding one more branch for demonstration.
INSERT INTO employees (employee_id, name, manager_id) VALUES (1, 'Alice', NULL);
INSERT INTO employees (employee_id, name, manager_id) VALUES (2, 'Bob', 1);
INSERT INTO employees (employee_id, name, manager_id) VALUES (3, 'Charlie', 1);
INSERT INTO employees (employee_id, name, manager_id) VALUES (4, 'Diana', 2);
INSERT INTO employees (employee_id, name, manager_id) VALUES (5, 'Eve', 4);

SELECT * FROM employees;
/*
+-------------+---------+------------+
| employee_id | name    | manager_id |
+-------------+---------+------------+
|           1 | Alice   |       NULL |
|           2 | Bob     |          1 |
|           3 | Charlie |          1 |
|           4 | Diana   |          2 |
|           5 | Eve     |          4 |
+-------------+---------+------------+
*/
WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor: Start with employee_id = 5.
    SELECT 
        employee_id, 
        name, 
        manager_id,
        1 AS level
    FROM employees
    WHERE employee_id = 5

    UNION ALL

    -- Recursive: Get the manager for the current employee.
    SELECT 
        e.employee_id, 
        e.name, 
        e.manager_id,
        eh.level + 1 AS level
    FROM employees e
    INNER JOIN EmployeeHierarchy eh 
        ON e.employee_id = eh.manager_id
)
SELECT *
FROM EmployeeHierarchy;
/*
+-------------+-------+------------+-------+
| employee_id | name  | manager_id | level |
+-------------+-------+------------+-------+
|           5 | Eve   |          4 |     1 |
|           4 | Diana |          2 |     2 |
|           2 | Bob   |          1 |     3 |
|           1 | Alice |       NULL |     4 |
+-------------+-------+------------+-------+
*/


