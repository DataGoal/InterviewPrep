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

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Departments
INSERT INTO departments (department_id, dept_name) VALUES
(1, 'Engineering'),
(2, 'HR'),
(3, 'Marketing'),
(4, 'Sales');

-- Employees
INSERT INTO employees (emp_id, name, department_id, salary) VALUES
(101, 'Alice', 1, 90000),
(102, 'Bob', 1, 95000),
(103, 'Charlie', 1, 91000),
(104, 'David', 1, 92000),
(105, 'Eva', 2, 60000),
(106, 'Frank', 2, 62000),
(107, 'Grace', 3, 70000),
(108, 'Heidi', 3, 71000),
(109, 'Ivan', 3, 72000),
(110, 'Judy', 3, 73000),
(111, 'Kevin', 4, 85000);

-- Find the names of employees whose salary is higher than the
-- average salary of departments with more than 3 employees.

SELECT e.name, a.department_id, a.dept_name, a.dept_avg_salary, e.salary FROM (
SELECT d.department_id, d.dept_name, AVG(e.salary) dept_avg_salary
FROM departments d 
JOIN employees e ON d.department_id = e.department_id
GROUP BY 1, 2 
HAVING COUNT(DISTINCT e.emp_id) > 3) a 
JOIN employees e
ON a.department_id = e.department_id
WHERE e.salary > a.dept_avg_salary
;

----------------------------------

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount INT
);
INSERT INTO orders (order_id, customer_id, order_date, amount) VALUES
(1, 101, '2024-01-01', 500),
(2, 101, '2024-01-05', 300),
(3, 101, '2024-01-10', 700),
(4, 102, '2024-02-01', 1000),
(5, 102, '2024-02-05', 150),
(6, 102, '2024-02-10', 200),
(7, 103, '2024-03-01', 800),
(8, 103, '2024-03-05', 900),
(9, 103, '2024-03-10', 100),
(10, 104, '2024-03-15', 400);
-- Write a query to find the top 2 most valuable orders (by amount) 
-- for each customer, along with the customer's total order amount.

WITH customer_order_counts AS (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
),
ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        amount,
        DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY amount DESC) AS rnk
    FROM orders
    WHERE customer_id IN (SELECT customer_id FROM customer_order_counts)
)
SELECT 
    r.customer_id, 
    r.order_id, 
    r.amount, 
    SUM(o.amount) AS total_amount
FROM ranked_orders r
JOIN orders o 
    ON r.customer_id = o.customer_id
WHERE r.rnk <= 2
GROUP BY r.customer_id, r.order_id, r.amount
ORDER BY r.customer_id, r.amount DESC;

--------------------------------------------
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David');
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

INSERT INTO products (product_id, product_name, category, price) VALUES
(101, 'Laptop', 'Electronics', 1000.00),
(102, 'Phone', 'Electronics', 500.00),
(103, 'Chair', 'Furniture', 150.00),
(104, 'Table', 'Furniture', 300.00),
(105, 'Shoes', 'Fashion', 120.00);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO orders (order_id, customer_id, product_id, quantity, order_date) VALUES
(1001, 1, 101, 1, '2024-03-01'),
(1002, 2, 101, 2, '2024-03-02'),
(1003, 3, 103, 3, '2024-03-03'),
(1004, 1, 104, 1, '2024-03-04'),
(1005, 4, 105, 2, '2024-03-04'),
(1006, 2, 102, 1, '2024-03-05'),
(1007, 3, 104, 2, '2024-03-06'),
(1008, 2, 105, 3, '2024-03-07');

--  For each product category, find the customer(s)
-- who spent the most total amount in that category.
WITH ranked AS (
SELECT o.customer_id, c.customer_name, p.category, SUM(p.price*o.quantity) total_amount,
DENSE_RANK() OVER(PARTITION BY p.category ORDER BY SUM(p.price*o.quantity) DESC) AS rnk
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 1, 2, 3
)
SELECT customer_name, category, total_amount
FROM ranked
WHERE rnk = 1

-- Find customers who have made at least one purchase from
-- every product category available in the products table.

SELECT o.customer_id, c.customer_name, COUNT(DISTINCT p.category) AS category_count
FROM orders o 
JOIN products p ON o.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.category) = (
    SELECT COUNT(DISTINCT category)
    FROM products
);

----------------------------------------------------------------------
CREATE TABLE fct_customer_sale (cust_id VARCHAR(50), 
prod_sku_id VARCHAR(50), order_date DATETIME, 
order_value BIGINT, order_id VARCHAR(50));

CREATE TABLE map_customer_territories (cust_id VARCHAR(50), 
territory_id VARCHAR(50));

INSERT INTO fct_customer_sale (cust_id, prod_sku_id, order_date, order_value, order_id)
VALUES ('C001', 'P100', '2021-07-15', 100, 'O1001'), 
('C002', 'P101', '2021-07-20', 200, 'O1002'), 
('C001', 'P100', '2021-10-05', 150, 'O1003'), 
('C002', 'P101', '2021-10-10', 250, 'O1004'), 
('C003', 'P102', '2021-08-22', 180, 'O1005'), 
('C003', 'P102', '2021-11-30', 210, 'O1006');

INSERT INTO map_customer_territories (cust_id, territory_id) 
VALUES  ('C001', 'T001'),
('C002', 'T002'), 
('C003', 'T003');

-- Write a query to return Territory and corresponding Sales Growth.
-- Compare growth between periods Q4-2021 vs Q3-2021. If Territory 
-- (say T123) has Sales worth $100 in Q3-2021 and 
-- Sales worth $110 in Q4-2021, then the Sales Growth 
-- will be 10% [ i.e. = ((110 - 100)/100) * 100 ]

-- Output the ID of the Territory and the Sales Growth. 
-- Only output these territories that had any sales in both quarters.
WITH CTE AS (
SELECT m.territory_id,
SUM(CASE WHEN QUARTER(f.order_date) = 3 THEN f.order_value END) AS q3_sale,
SUM(CASE WHEN QUARTER(f.order_date) = 4 THEN f.order_value END) AS q4_sale
FROM fct_customer_sale f
JOIN map_customer_territories m ON f.cust_id = m.cust_id
GROUP BY m.territory_id
)
SELECT territory_id, ((q4_sale-q3_sale)/q3_sale) * 100 AS sale_growth
FROM cte

---------------------------------------------------------------
-- From users who had their first session as a viewer, how many 
-- streamer sessions have they had? 
-- Return the user id and number of sessions in descending order. 
-- In case there are users with the same number of 
-- sessions, order them by ascending user id.

CREATE TABLE twitch_sessions 
(user_id BIGINT, session_start DATETIME, session_end DATETIME, 
session_id BIGINT PRIMARY KEY, session_type VARCHAR(20) 
CHECK (session_type IN ('viewer', 'streamer')));

INSERT INTO twitch_sessions (user_id, session_start, session_end, session_id, session_type)
VALUES (101, '2024-02-01 10:00:00', '2024-02-01 11:00:00', 1, 'viewer'), 
(101, '2024-02-02 14:00:00', '2024-02-02 15:30:00', 2, 'streamer'), 
(102, '2024-02-01 09:30:00', '2024-02-01 10:30:00', 3, 'viewer'), 
(102, '2024-02-03 16:00:00', '2024-02-03 17:00:00', 4, 'streamer'), 
(102, '2024-02-05 18:00:00', '2024-02-05 19:30:00', 5, 'streamer'), 
(103, '2024-02-02 11:00:00', '2024-02-02 12:00:00', 6, 'viewer'), 
(104, '2024-02-01 08:30:00', '2024-02-01 09:00:00', 7, 'viewer'), 
(104, '2024-02-04 20:00:00', '2024-02-04 21:00:00', 8, 'streamer'), 
(104, '2024-02-06 22:00:00', '2024-02-06 23:00:00', 9, 'streamer'), 
(104, '2024-02-07 15:00:00', '2024-02-07 16:30:00', 10, 'streamer');

WITH first_viewer AS (
SELECT user_id , MIN(session_start)
FROM twitch_sessions
WHERE session_type = 'viewer'
GROUP BY 1
)
SELECT f.user_id, COUNT(*)
FROM twitch_sessions t 
JOIN first_viewer f ON t.user_id = f.user_id
WHERE t.session_type = 'streamer'
GROUP BY 1
ORDER BY 2 DESC, 1 ASC;

-----------------------------------------------------


