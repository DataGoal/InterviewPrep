-- Create Departments Table
CREATE TABLE Departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);

-- Insert Sample Data into Departments Table
INSERT INTO Departments (department_name) VALUES 
('Engineering'),
('Marketing'),
('HR'),
('Finance'),
('Sales');

-- Create Employees Table
CREATE TABLE Employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10,2),
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(id),
    FOREIGN KEY (manager_id) REFERENCES Employees(id)
);

-- Insert Sample Data into Employees Table
INSERT INTO Employees (name, department_id, salary, manager_id) VALUES 
('Alice', 1, 75000.00, NULL),  -- Manager
('Bob', 1, 50000.00, 1),
('Charlie', 2, 60000.00, NULL), -- Manager
('David', 3, 55000.00, NULL), -- Manager
('Emma', 4, 62000.00, NULL), -- Manager
('Frank', NULL, 48000.00, NULL), -- No department
('Grace', 1, 53000.00, 1),
('Hank', 2, 59000.00, 3),
('Ivy', 5, 57000.00, NULL),
('Jack', 1, 52000.00, 1),
('Tom', 2, 60000.00, NULL); -- Manager


-- Create Projects Table
CREATE TABLE Projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(id)
);

-- Insert Sample Data into Projects Table
INSERT INTO Projects (name, department_id) VALUES 
('AI Research', 1),
('Website Revamp', 2),
('Employee Onboarding', 3),
('Financial Analysis', 4),
('CRM Development', 1),
('Ad Campaign', 2),
('HR Portal Upgrade', 3),
('Sales Dashboard', 5);


SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM projects;


-- Write an SQL query to fetch all employees along with their department names. If an employee doesn’t belong to any department, still include them in the result.
SELECT e.name, e.department_id, d.department_name 
FROM employees e 
LEFT JOIN departments d ON e.department_id = d.id;

-- Write an SQL query to fetch employees who are not assigned to any department.
SELECT e.name FROM 
employees e 
LEFT JOIN departments d ON e.department_id = d.id 
WHERE d.id IS NULL;

-- Write an SQL query to fetch departments that have no employees assigned.
SELECT d.id, d.department_name 
FROM departments d 
LEFT JOIN employees e ON d.id = e.department_id 
WHERE e.id IS NULL;

-- Retrieve a list of employees along with their manager’s name. If an employee has no manager, still include them in the result.
SELECT e1.id, e1.name employee_name, e2.name manager_name 
FROM employees e1 
LEFT JOIN employees e2 ON e1.manager_id = e2.id;

-- Write an SQL query to count the number of employees in each department. Show department names along with the employee count, including departments with zero employees.
SELECT d.id, d.department_name, COUNT(e.id) emp_count 
FROM departments d 
LEFT JOIN employees e ON e.department_id = d.id 
GROUP BY 1, 2;

-- Fetch employees whose salary is greater than the average salary of their respective department.
WITH dept_avg_salary AS (
SELECT d.id dept_id, d.department_name dept_name, AVG(e.salary) avg_salary 
FROM departments d 
JOIN employees e ON d.id = e.department_id 
GROUP BY 1, 2
)
SELECT e.id, e.name, e.salary, d.dept_id, d.dept_name
FROM employees e 
LEFT JOIN dept_avg_salary d ON e.department_id = d.dept_id
WHERE e.salary > d.avg_salary;

-- Fetch employees who work in either the 'Engineering' or 'Marketing' department.
SELECT e.id, e.name
FROM employees e 
LEFT JOIN departments d ON e.department_id = d.id
WHERE LOWER(d.department_name) IN ('engineering') OR LOWER(d.department_name) IN ('marketing');


-- Retrieve the highest-paid employee in each department along with their salary and department name.

WITH dept_max_salary AS (
SELECT d.id dept_id, d.department_name dept_name, MAX(e.salary) max_salary 
FROM departments d 
LEFT JOIN employees e ON d.id = e.department_id 
GROUP BY 1, 2
)
SELECT e.id, e.name, e.salary, d.dept_id, d.dept_name
FROM employees e 
LEFT JOIN dept_max_salary d ON e.department_id = d.dept_id
WHERE e.salary = d.max_salary;

SELECT e.id, e.name, e.salary, d.department_name
FROM (
    SELECT id, name, salary, department_id,
           DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) as rnk
    FROM employees
) e
INNER JOIN departments d ON e.department_id = d.id
WHERE e.rnk = 1;

-- Write a query to get employees who are not reporting to any manager.
SELECT e1.id, e1.name
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.id
WHERE e2.id IS NULL;

-- Write a query to fetch employees working on projects related to their department.
SELECT e.name, d.department_name, p.name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
LEFT JOIN projects p ON d.id = p.department_id;

-- Write an SQL query to find employees whose salary is higher than their respective manager's salary.
SELECT e1.id, e1.name employee_name, e1.salary emp_salary, e2.name manager_name, e2.salary manager_salary
FROM employees e1 
LEFT JOIN employees e2 ON e1.manager_id = e2.id
WHERE e1.salary > e2.salary;