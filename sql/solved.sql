-- https://leetcode.com/problems/recyclable-and-low-fat-products/
-- Write a solution to find the ids of products that are both low fat and recyclable.
SELECT product_id FROM Products WHERE LOWER(low_fats) = 'y' AND LOWER(recyclable) = 'y'

-- https://leetcode.com/problems/find-customer-referee/
-- Find the names of the customer that are not referred by the customer with id = 2.
SELECT name FROM Customer WHERE COALESCE(referee_id, 1) <> 2

-- https://leetcode.com/problems/big-countries/
-- A country is big if:
-- it has an area of at least three million (i.e., 3000000 km2), or
-- it has a population of at least twenty-five million (i.e., 25000000).
-- Write a solution to find the name, population, and area of the big countries.
SELECT name, population, area FROM world WHERE area >= 3000000 OR population >= 25000000

-- https://leetcode.com/problems/article-views-i/
-- Write a solution to find all the authors that viewed at least one of their own articles.
-- Return the result table sorted by id in ascending order.
SELECT DISTINCT author_id AS id FROM views WHERE author_id = viewer_id ORDER BY 1

-- https://leetcode.com/problems/invalid-tweets/
-- Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.
-- Return the result table in any order.
SELECT tweet_id FROM tweets WHERE LENGTH(content) > 15

-- https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/
-- Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
-- Return the result table in any order.
SELECT eu.unique_id, e.name FROM EmployeeUNI eu RIGHT JOIN Employees e ON eu.id = e.id

-- https://leetcode.com/problems/product-sales-analysis-i/
-- Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
-- Return the resulting table in any order.
SELECT p.product_name, s.year, s.price FROM sales s JOIN product p ON s.product_id = p.product_id

-- https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/
-- Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
-- Return the result table sorted in any order.
SELECT v.customer_id, COUNT(1) AS count_no_trans FROM visits v LEFT JOIN transactions t ON v.visit_id = t.visit_id WHERE t.transaction_id IS NULL GROUP BY 1

-- https://leetcode.com/problems/rising-temperature/
-- Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).
-- Return the result table in any order.
SELECT w1.id FROM Weather w1, Weather w2 WHERE DATEDIFF(w1.recordDate, w2.recordDate) = 1 AND w1.temperature > w2.temperature

-- https://leetcode.com/problems/average-time-of-process-per-machine/
-- There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.
-- The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.
-- The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.
-- Return the result table in any order.
WITH CTE AS (
SELECT q.machine_id, q.process_id, SUM(q.end_time - q.start_time) AS processing_time FROM (SELECT machine_id, process_id, CASE WHEN activity_type = 'start' THEN timestamp ELSE 0 END AS start_time, CASE WHEN activity_type = 'end' THEN timestamp ELSE 0 END AS end_time FROM activity) q GROUP BY 1, 2
)
SELECT cte.machine_id, ROUND(AVG(cte.processing_time),3) AS processing_time FROM cte GROUP BY 1

-- https://leetcode.com/problems/employee-bonus/
-- Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.
-- Return the result table in any order.
SELECT name, bonus FROM employee e LEFT JOIN bonus b ON e.empid = b.empid WHERE COALESCE(bonus, 0) < 1000

-- https://leetcode.com/problems/students-and-examinations/
-- Write a solution to find the number of times each student attended each exam.
-- Return the result table ordered by student_id and subject_name.
SELECT s.student_id, s.student_name, su.subject_name, COUNT(e.subject_name) attended_exams FROM students s JOIN subjects su LEFT JOIN examinations e ON e.student_id = s.student_id AND su.subject_name = e.subject_name GROUP BY 1, 3 ORDER BY 1, 3

-- https://leetcode.com/problems/managers-with-at-least-5-direct-reports/
-- Write a solution to find managers with at least five direct reports.
-- Return the result table in any order.
SELECT name FROM employee WHERE id IN (SELECT managerid FROM employee GROUP BY 1 HAVING COUNT(managerid) >= 5)

-- https://leetcode.com/problems/confirmation-rate/
-- The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.
-- Write a solution to find the confirmation rate of each user.
-- Return the result table in any order.
SELECT s.user_id, COALESCE(ROUND(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END)/COUNT(c.user_id),2),0) confirmation_rate FROM signups s LEFT JOIN confirmations c ON s.user_id = c.user_id GROUP BY 1

-- https://leetcode.com/problems/not-boring-movies/
-- Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
-- Return the result table ordered by rating in descending order.
SELECT * FROM cinema WHERE (id % 2) = 1 AND description NOT IN ('boring') ORDER BY rating DESC

-- https://leetcode.com/problems/average-selling-price/
-- Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. If a product does not have any sold units, its average selling price is assumed to be 0.
-- Return the result table in any order.
SELECT p.product_id, ROUND(COALESCE(SUM(u.units*p.price)/SUM(u.units),0),2) AS average_price FROM prices p LEFT JOIN unitssold u ON p.product_id = u.product_id AND u.purchase_date BETWEEN p.start_date AND p.end_date GROUP BY 1

-- https://leetcode.com/problems/project-employees-i/
-- Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.
SELECT p.project_id, ROUND(AVG(e.experience_years),2) AS average_years FROM project p JOIN employee e ON p.employee_id = e.employee_id GROUP BY 1

-- https://leetcode.com/problems/percentage-of-users-attended-a-contest/
-- Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
-- Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.
SELECT contest_id, ROUND(COUNT(user_id)/(SELECT COUNT(DISTINCT user_id) FROM users)*100,2) percentage FROM register GROUP BY 1 ORDER BY 2 DESC, 1 ASC

-- https://leetcode.com/problems/queries-quality-and-percentage/
-- We define query quality as:
-- The average of the ratio between query rating and its position.
-- We also define poor query percentage as:
-- The percentage of all queries with rating less than 3.
-- Write a solution to find each query_name, the quality and poor_query_percentage.
-- Both quality and poor_query_percentage should be rounded to 2 decimal places.
-- Return the result table in any order.
SELECT query_name, ROUND(SUM(rating/position)/COUNT(query_name),2) quality, ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END)/COUNT(query_name)*100,2) poor_query_percentage FROM queries GROUP BY 1

-- https://leetcode.com/problems/monthly-transactions-i/
-- Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.
SELECT DATE_FORMAT(trans_date,'%Y-%m') AS month, country,
COUNT(*) AS trans_count,
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY 1, 2

-- https://leetcode.com/problems/immediate-food-delivery-ii/
-- If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
-- The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
-- Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.
WITH CTE AS (
    SELECT DISTINCT customer_id, MIN(order_date) AS first_order FROM delivery GROUP BY 1
)
SELECT ROUND(SUM(CASE WHEN c.first_order = d.customer_pref_delivery_date THEN 1 ELSE 0 END)/COUNT(c.customer_id)*100,2) AS immediate_percentage FROM CTE c JOIN delivery d ON c.customer_id = d.customer_id AND c.first_order = d.order_date

-- https://leetcode.com/problems/game-play-analysis-iv/
-- Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.
SELECT ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) as fraction
FROM Activity
WHERE (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
IN (SELECT player_id, MIN(event_date) AS first_login FROM ACTIVITY GROUP BY player_id)

-- https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher
-- Write a solution to calculate the number of unique subjects each teacher teaches in the university.
SELECT teacher_id, COUNT(DISTINCT subject_id) cnt FROM teacher GROUP BY 1

-- https://leetcode.com/problems/user-activity-for-the-past-30-days-i/
-- Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.
SELECT activity_date day, COUNT(DISTINCT user_id) active_users FROM activity WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 29 DAY) AND '2019-07-27' GROUP BY 1 HAVING COUNT(DISTINCT activity_type) >= 1

-- https://leetcode.com/problems/product-sales-analysis-iii/
-- Write a solution to select the product id, year, quantity, and price for the first year of every product sold.
SELECT product_id, year AS first_year, quantity, price FROM sales WHERE (product_id, year) IN (SELECT product_id, MIN(year) AS year FROM sales GROUP BY 1)

-- https://leetcode.com/problems/classes-more-than-5-students/
-- Write a solution to find all the classes that have at least five students.
SELECT class FROM courses GROUP BY class HAVING COUNT(student) >= 5

-- https://leetcode.com/problems/find-followers-count/
-- Write a solution that will, for each user, return the number of followers.
SELECT user_id, COUNT(follower_id) followers_count FROM followers GROUP BY 1 ORDER BY 1 ASC

-- https://leetcode.com/problems/biggest-single-number/
-- A single number is a number that appeared only once in the MyNumbers table.
-- Find the largest single number. If there is no single number, report null.
SELECT MAX(num) num FROM mynumbers WHERE num NOT IN (SELECT num FROM mynumbers GROUP BY 1 HAVING COUNT(num) > 1)

-- https://leetcode.com/problems/customers-who-bought-all-products
-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
SELECT customer_id FROM customer GROUP BY 1 HAVING COUNT(DISTINCT product_key) IN (SELECT COUNT(1) FROM product)

-- https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/
-- For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
-- Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
-- Return the result table ordered by employee_id.
WITH CTE AS (
SELECT reports_to, COUNT(*) cnt, ROUND(AVG(age)) avg_age FROM employees WHERE reports_to IS NOT NULL GROUP BY 1 
)
SELECT e.employee_id, e.name, c.cnt reports_count, c.avg_age average_age FROM cte c JOIN employees e ON c.reports_to = e.employee_id ORDER BY 1

-- https://leetcode.com/problems/primary-department-for-each-employee/
-- Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.
-- Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.
-- Return the result table in any order.
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag='Y' OR 
    employee_id in
    (SELECT employee_id
    FROM Employee
    Group by employee_id
    having count(employee_id)=1)

-- https://leetcode.com/problems/triangle-judgement/
-- Report for every three line segments whether they can form a triangle.
SELECT *, IF(x+y>z and y+z>x and z+x>y, "Yes", "No") as triangle FROM Triangle

-- https://leetcode.com/problems/consecutive-numbers/
-- Find all numbers that appear at least three times consecutively.
WITH CTE AS(
SELECT id, num, LAG(num) OVER(ORDER BY id) lid FROM logs
), cte2 AS(
SELECT id, num, lid, LAG(lid) OVER(ORDER BY id) lid2 FROM cte
)
SELECT DISTINCT num ConsecutiveNums FROM cte2 WHERE num = lid AND num = lid2

-- https://leetcode.com/problems/product-price-at-a-given-date/
-- Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.
WITH CTE AS (
SELECT product_id, new_price price FROM products WHERE (product_id, change_date) IN (SELECT product_id, MAX(change_date) FROM products WHERE change_date <= '2019-08-16' GROUP BY 1)
)
SELECT DISTINCT p.product_id, COALESCE(c.price,10) price FROM products p LEFT JOIN cte c ON p.product_id = c.product_id

-- https://leetcode.com/problems/last-person-to-fit-in-the-bus/description/
-- There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.
-- Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit.
-- Note that only one person can board the bus at any given turn.
WITH CTE AS (
SELECT *, SUM(weight) OVER(ORDER BY turn) s_sum FROM queue
), cte2 AS (
SELECT person_name, RANK() OVER(ORDER BY s_sum DESC) rnk FROM cte WHERE s_sum <= 1000
)

SELECT person_name FROM cte2 WHERE rnk =1 

-- https://leetcode.com/problems/count-salary-categories/
-- Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:
-- "Low Salary": All the salaries strictly less than $20000.
-- "Average Salary": All the salaries in the inclusive range [$20000, $50000].
-- "High Salary": All the salaries strictly greater than $50000.
-- The result table must contain all three categories. If there are no accounts in a category, return 0.
SELECT "Low Salary" as category, COUNT(*) as accounts_count 
FROM accounts
WHERE income < 20000
UNION
SELECT "Average Salary" as category, COUNT(*) as accounts_count 
FROM accounts
WHERE income BETWEEN 20000 AND 50000
UNION
SELECT "High Salary" as category, COUNT(*) as accounts_count 
FROM accounts
WHERE income > 50000 

-- https://leetcode.com/problems/employees-whose-manager-left-the-company/
-- Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.
-- Return the result table ordered by employee_id.
SELECT employee_id FROM employees WHERE salary < 30000 AND manager_id NOT IN (SELECT DISTINCT employee_id FROM employees) ORDER BY 1

-- https://leetcode.com/problems/exchange-seats
-- Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
-- Return the result table ordered by id in ascending order.
SELECT id, COALESCE(CASE WHEN id%2=1 THEN LEAD(student) OVER(ORDER BY id) ELSE LAG(student) OVER (ORDER BY id) END,student) AS student FROM seat

-- https://leetcode.com/problems/movie-rating/
-- Write a solution to:
-- Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
-- Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.
WITH CTE AS(
SELECT u.name, RANK() OVER(ORDER BY COUNT(r.movie_id) DESC, u.name ASC) rnk FROM users u JOIN movierating r ON u.user_id = r.user_id GROUP BY 1 ORDER BY 2 DESC
), CTE2 AS (
SELECT m.title, RANK() OVER(ORDER BY AVG(r.rating) DESC, m.title ASC) rnk FROM movies m JOIN movierating r ON m.movie_id = r.movie_id WHERE DATE_FORMAT(created_at, '%Y-%m') = '2020-02' GROUP BY r.movie_id ORDER BY 1
)

SELECT c.name results FROM cte c WHERE rnk = 1
UNION ALL
SELECT c2.title results FROM cte2 c2 WHERE rnk = 1

-- https://leetcode.com/problems/restaurant-growth/
-- You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
-- Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
-- Return the result table ordered by visited_on in ascending order.
with perdayamount
as
(
    select visited_on, sum(amount) amount
    from Customer
    group by visited_on
)

select c1.visited_on, sum(c2.amount) as amount, round( avg(c2.amount), 2) as average_amount
from perdayamount c1
join perdayamount c2 on 
    datediff(c1.visited_on, c2.visited_on) between 0 and 6
group by c1.visited_on    
having count(1) = 7 

-- https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/
-- Write a solution to find the people who have the most friends and the most friends number.
-- The test cases are generated so that only one person has the most friends.
WITH CTE AS (
SELECT requester_id AS id FROM requestaccepted
UNION ALL
SELECT accepter_id AS id FROM requestaccepted
)

SELECT id, COUNT(id) num FROM cte GROUP BY 1 ORDER BY 2 DESC LIMIT 1

-- https://leetcode.com/problems/investments-in-2016/
-- Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
-- have the same tiv_2015 value as one or more other policyholders, and
-- are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
-- Round tiv_2016 to two decimal places.
SELECT ROUND(SUM(tiv_2016),2) tiv_2016 FROM insurance WHERE tiv_2015 IN (SELECT tiv_2015 FROM insurance GROUP BY 1 HAVING COUNT(tiv_2015) > 1) AND (lat, lon) NOT IN (SELECT lat, lon FROM insurance GROUP BY 1, 2 HAVING COUNT(lat) > 1 AND COUNT(lon) > 1)


-- https://leetcode.com/problems/department-top-three-salaries/
-- A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
-- Write a solution to find the employees who are high earners in each of the departments.
SELECT q.Department, q.Employee, q.Salary FROM 
(SELECT d.name AS Department, e.name AS Employee, e.salary AS Salary, DENSE_RANK() OVER(PARTITION BY d.id ORDER BY e.salary DESC) AS rnk FROM employee e JOIN department d ON e.departmentId = d.id) q WHERE q.rnk <= 3 ORDER BY 3 DESC

-- https://leetcode.com/problems/fix-names-in-a-table/
-- Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.
SELECT user_id, CONCAT(SUBSTR(UPPER(name), 1, 1), SUBSTR(LOWER(name), 2, LENGTH(name))) name FROM users ORDER BY 1

-- https://leetcode.com/problems/patients-with-a-condition/
-- Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.
SELECT * FROM patients WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%'

-- https://leetcode.com/problems/delete-duplicate-emails/
-- Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
-- For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.
-- For Pandas users, please note that you are supposed to modify Person in place.
-- After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show the Person table. The final order of the Person table does not matter.
DELETE p from Person p, Person q where p.Id>q.Id AND q.Email=p.Email 

-- https://leetcode.com/problems/second-highest-salary/
-- Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).
SELECT MAX(salary) SecondHighestSalary FROM employee WHERE salary NOT IN (SELECT MAX(salary) FROM employee)

-- https://leetcode.com/problems/group-sold-products-by-the-date/
-- Write a solution to find for each date the number of different products sold and their names.
-- The sold products names for each date should be sorted lexicographically.
-- Return the result table ordered by sell_date.
SELECT 
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

-- https://leetcode.com/problems/list-the-products-ordered-in-a-period
-- Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
-- Return the result table in any order.
WITH cte AS (
SELECT product_id, SUM(unit) unit FROM orders WHERE DATE_FORMAT(order_date,'%Y-%m') = '2020-02' GROUP BY 1
)

SELECT p.product_name, c.unit FROM cte c JOIN products p ON c.product_id = p.product_id WHERE c.unit >= 100

-- https://leetcode.com/problems/find-users-with-valid-e-mails/
-- Write a solution to find the users who have valid emails.
-- A valid e-mail has a prefix name and a domain where:
-- The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
-- The domain is '@leetcode.com'.
-- Return the result table in any order.
SELECT * FROM users WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9_.-]*@leetcode[\.]com$' 

/*
Q. Give me the list of actors who have acted together most number of times.

Actor1|Actor2|Movie
-------|-------|---------
B   | A     | Movie1
B   | C     | Movie2
B   | C     | Movie3
A   | B     | Movie4
A   | B     | Movie5  

*/

create table movie(
Actor1 TEXT,
Actor2 TEXT,
Movie TEXT);
insert into movie 
values('B','A','Movie1');
insert into movie
values('B','C','Movie2');
insert into movie
values('B','C','Movie3');
insert into movie
values('A','B','Movie4');
insert into movie
values('A','B','Movie5');

SELECT LEAST(actor1, actor2) AS actor1,
       GREATEST(actor1, actor2) AS actor2,
       COUNT(*) AS movie_count
FROM movie_data
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

SELECT actor1, actor2, COUNT(*) AS movie_count
FROM (
    SELECT 
        CASE WHEN actor1 < actor2 THEN actor1 ELSE actor2 END AS actor1,
        CASE WHEN actor1 < actor2 THEN actor2 ELSE actor1 END AS actor2
    FROM movie_data
) paired_actors
GROUP BY actor1, actor2
ORDER BY movie_count DESC
LIMIT 1;


/*
Q: Find top 2 teams who won maximum matches consecutively (in consecutive years).

Team  | Year_won |
Seahawks|2007
49ers |2010
49ers |2011
49ers |2014
Cardinals |2005
Seahawks|2006
Seahawks|2008

*/

create table game(
team TEXT,
year_won YEAR);
insert into game 
values('Seahawks','2007');
insert into game
values('49ers','2010');
insert into game
values('49ers','2011');
insert into game
values('49ers','2014');
insert into game
values('Cardinals','2005');
insert into game
values('Seahawks','2006');
insert into game
values('Seahawks','2008');

WITH CTE AS (
SELECT team, year_won, 
LAG(year_won) OVER(PARTITION BY team ORDER BY year_won) yer, 
year_won - LAG(year_won) OVER(PARTITION BY team ORDER BY year_won) sk FROM game )

SELECT team, COUNT(sk) FROM cte WHERE sk = 1 GROUP BY 1 ORDER BY 2 DESC
