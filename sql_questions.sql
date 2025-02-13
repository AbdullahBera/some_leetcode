
SELECT * 
FROM famous 

-- Question 1 (Meta)

"""
A table named “famous” has two columns called user id and follower id. It represents each user ID has a particular follower ID. These follower IDs are also users of 
hashtag#Facebook / hashtag#Meta. Then, find the famous percentage of each user. 
Famous Percentage = number of followers a user has / total number of users on the platform.

🔍 At first glance, this might seem tedious, but it's straightforward once you break it down. Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE famous (user_id INT, follower_id INT);

INSERT INTO famous VALUES
(1, 2), (1, 3), (2, 4), (5, 1), (5, 3), 
(11, 7), (12, 8), (13, 5), (13, 10), 
(14, 12), (14, 3), (15, 14), (15, 13);

"""

WITH total_followers AS ( 
	SELECT CAST(COUNT(follower_id)AS FLOAT) AS total
	FROM famous
),
total_user_followers AS(
	SELECT user_id, 
		CAST(COUNT(follower_id) AS FLOAT) AS total_user_follower
	FROM famous
	GROUP BY user_id
)
SELECT u.user_id, 
		u.total_user_follower / f.total * 100 AS percentage
FROM total_user_followers AS u
CROSS JOIN total_followers AS f
ORDER BY user_id; 

--Question 2 (Amazon)

"""
Given a table 'sf_transactions' of purchases by date, calculate the month-over-month percentage change in revenue. The output should include the year-month date (YYYY-MM) 
and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year. The percentage change column will be populated 
from the 2nd month forward and calculated as ((this month’s revenue — last month’s revenue) / last month’s revenue)*100.


𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE sf_transactions(id INT, created_at datetime, value INT, purchase_id INT);

INSERT INTO sf_transactions VALUES
(1, '2019-01-01 00:00:00',  172692, 43), (2,'2019-01-05 00:00:00',  177194, 36),(3, '2019-01-09 00:00:00',  109513, 30),(4, '2019-01-13 00:00:00',  164911, 30),
(5, '2019-01-17 00:00:00',  198872, 39), (6, '2019-01-21 00:00:00',  184853, 31),(7, '2019-01-25 00:00:00',  186817, 26), (8, '2019-01-29 00:00:00',  137784, 22),
(9, '2019-02-02 00:00:00',  140032, 25), (10, '2019-02-06 00:00:00', 116948, 43), (11, '2019-02-10 00:00:00', 162515, 25), (12, '2019-02-14 00:00:00', 114256, 12), 
(13, '2019-02-18 00:00:00', 197465, 48), (14, '2019-02-22 00:00:00', 120741, 20), (15, '2019-02-26 00:00:00', 100074, 49), (16, '2019-03-02 00:00:00', 157548, 19), 
(17, '2019-03-06 00:00:00', 105506, 16), (18, '2019-03-10 00:00:00', 189351, 46), (19, '2019-03-14 00:00:00', 191231, 29), (20, '2019-03-18 00:00:00', 120575, 44), 
(21, '2019-03-22 00:00:00', 151688, 47), (22, '2019-03-26 00:00:00', 102327, 18), (23, '2019-03-30 00:00:00', 156147, 25);
"""
WITH total_revenue AS(
	SELECT TO_CHAR(created_at, 'YYYY-MM') AS year_month,
			SUM(value) AS total_value
	FROM sf_transactions
	GROUP BY TO_CHAR(created_at, 'YYYY-MM')
	ORDER BY year_month
)
SELECT year_month,
		total_value, 
		ROUND((CAST(total_value - LAG(total_value) OVER (ORDER BY year_month) AS numeric) / 
			  LAG(total_value) OVER (ORDER BY year_month)) * 100, 2) AS percentage_change
FROM total_revenue;

-- Question 3 (Google)

"""
You are analyzing a social network dataset at Google. Your task is to find mutual friends between two users, Karl and Hans. There is only one user named Karl and one named Hans in the dataset.

The output should contain 'user_id' and 'user_name' columns.

🔗 Understanding how to join tables in SQL is essential for effective data analysis; mastering this concept allows you to combine related data seamlessly. Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE users(user_id INT, user_name varchar(30));
INSERT INTO users VALUES (1, 'Karl'), (2, 'Hans'), (3, 'Emma'), (4, 'Emma'), (5, 'Mike'), (6, 'Lucas'), (7, 'Sarah'), (8, 'Lucas'), (9, 'Anna'), (10, 'John');

CREATE TABLE friends(user_id INT, friend_id INT);
INSERT INTO friends VALUES (1,3),(1,5),(2,3),(2,4),(3,1),(3,2),(3,6),(4,7),(5,8),(6,9),(7,10),(8,6),(9,10),(10,7),(10,9);
-------------
"""

WITH karl_mutual AS (
	SELECT friend_id 
	FROM friends
	WHERE user_id = (SELECT user_id FROM useres WHERE user_name = 'Karl')
), hans_mutual AS (
	SELECT friend_id
	FROM friends
	WHERE user_id = (SELECT user_id FROM useres WHERE user_name = 'Hans')
)
SELECT u.user_id, u.user_name
FROM useres AS u
JOIN karl_mutual AS km ON km.friend_id = u.user_id
JOIN hans_mutual AS hm ON hm.friend_id = u.user_id


--- Question 4 (Uber)
"""
Some forecasting methods are extremely simple and surprisingly effective. Naïve forecast is one of them. To create a naïve forecast for "distance per dollar" 
(defined as distance_to_travel/monetary_cost), first sum the "distance to travel" and "monetary cost" values monthly. This gives the actual value for the current month. 
For the forecasted value, use the previous month's value. After obtaining both actual and forecasted values, calculate the root mean squared error (RMSE) using the formula 
RMSE = sqrt(mean(square(actual - forecast))). Report the RMSE rounded to two decimal places.

🔍 At first glance, this might seem tedious, but it's straightforward once you break it down. Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE uber_request_logs(request_id int, request_date datetime, request_status varchar(10), distance_to_travel float, monetary_cost float, driver_to_client_distance 
float);

INSERT INTO uber_request_logs VALUES (1,'2020-01-09','success', 70.59, 6.56,14.36), (2,'2020-01-24','success', 93.36, 22.68,19.9), (3,'2020-02-08','fail', 
51.24, 11.39,21.32), (4,'2020-02-23','success', 61.58,8.04,44.26), (5,'2020-03-09','success', 25.04,7.19,1.74), (6,'2020-03-24','fail', 45.57, 4.68,24.19), 
(7,'2020-04-08','success', 24.45,12.69,15.91), (8,'2020-04-23','success', 48.22,11.2,48.82), (9,'2020-05-08','success', 56.63,4.04,16.08), (10,'2020-05-23','fail', 
19.03,16.65,11.22), (11,'2020-06-07','fail', 81,6.56,26.6), (12,'2020-06-22','fail', 21.32,8.86,28.57), (13,'2020-07-07','fail', 14.74,17.76,19.33), (14,'2020-07-22',
'success',66.73,13.68,14.07), (15,'2020-08-06','success',32.98,16.17,25.34), (16,'2020-08-21','success',46.49,1.84,41.9), (17,'2020-09-05','fail', 45.98,12.2,2.46), 
(18,'2020-09-20','success',3.14,24.8,36.6), (19,'2020-10-05','success',75.33,23.04,29.99), (20,'2020-10-20','success', 53.76,22.94,18.74);

"""


WITH monthly_distance_cost AS(
	SELECT TO_CHAR(request_date, 'YYYY-MM') as year_month,
			SUM(distance_to_travel) AS total_monthly_distance,
			SUM(monetary_cost) AS cost_monthly
	FROM uber_request_logs
	GROUP BY TO_CHAR(request_date, 'YYYY-MM')
	ORDER BY 1	
), actual_value AS(
	SELECT year_month, 
			ROUND((CAST(total_monthly_distance AS NUMERIC)/ CAST(cost_monthly AS NUMERIC)),2) AS distance_per_dolar
	FROM monthly_distance_cost 
), actual_forecasted AS(
	SELECT year_month, 
			distance_per_dolar, 
			LAG(distance_per_dolar) OVER (ORDER BY year_month) AS forecasted
	FROM actual_value
)
SELECT 
	ROUND(SQRT(AVG(POWER((distance_per_dolar - forecasted),2))),2) AS rmse
FROM actual_forecasted
WHERE forecasted IS NOT NULL 


--- Question 5 (Microsoft)

"""
Given a list of projects and employees mapped to each project, calculate by the amount of project budget allocated to each employee. The output should include the project 
title and the project budget rounded to the closest integer. Order your list by projects with the highest budget per employee first.


𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE ms_projects(id int, title varchar(15), budget int);
INSERT INTO ms_projects VALUES (1, 'Project1',  29498),(2, 'Project2',  32487),(3, 'Project3',  43909),(4, 'Project4',  15776),(5, 'Project5',  36268),(6, 'Project6',  
41611),(7, 'Project7',  34003),(8, 'Project8',  49284),(9, 'Project9',  32341),(10, 'Project10',    47587),(11, 'Project11',    11705),(12, 'Project12',    10468),(13, 
'Project13',    43238),(14, 'Project14',    30014),(15, 'Project15',    48116),(16, 'Project16',    19922),(17, 'Project17',    19061),(18, 'Project18',    10302),(19, 
'Project19',    44986),(20, 'Project20',    19497);

CREATE TABLE ms_emp_projects(emp_id int, project_id int);
INSERT INTO ms_emp_projects VALUES (10592,  1),(10593,  2),(10594,  3),(10595,  4),(10596,  5),(10597,  6),(10598,  7),(10599,  8),(10600,  9),(10601,  10),(10602, 11),
(10603, 12),(10604, 13),(10605, 14),(10606, 15),(10607, 16),(10608, 17),(10609, 18),(10610, 19),(10611, 20);

"""

SELECT p.title AS project_title,
		(p.budget / COUNT(e.emp_id)) AS budget_per_employee
FROM ms_projects AS p 
LEFT JOIN ms_emp_projects AS e ON p.id = e.project_id 
GROUP BY p.title, p.budget
ORDER BY 2 DESC


--- Question 6 (Airbnb)

"""
Find the total number of available beds per hosts' nationality.
Output the nationality along with the corresponding total number of available beds. Sort records by the total available beds in descending order.

🔍 It's straightforward, read the question carefully and give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE airbnb_apartments(host_id int,apartment_id varchar(5),apartment_type varchar(10),n_beds int,n_bedrooms int,country varchar(20),city varchar(20));
INSERT INTO airbnb_apartments VALUES(0,'A1','Room',1,1,'USA','NewYork'),(0,'A2','Room',1,1,'USA','NewJersey'),(0,'A3','Room',1,1,'USA','NewJersey'),(1,'A4','Apartment',
2,1,'USA','Houston'),(1,'A5','Apartment',2,1,'USA','LasVegas'),(3,'A7','Penthouse',3,3,'China','Tianjin'),(3,'A8','Penthouse',5,5,'China','Beijing'),(4,'A9','Apartment',
2,1,'Mali','Bamako'),(5,'A10','Room',3,1,'Mali','Segou')

CREATE TABLE airbnb_hosts(host_id int,nationality  varchar(15),gender varchar(5),age int);
INSERT INTO airbnb_hosts  VALUES(0,'USA','M',28),(1,'USA','F',29),(2,'China','F',31),(3,'China','M',24),(4,'Mali','M',30),(5,'Mali','F',30);

"""


SELECT h.nationality,
		SUM(a.n_beds)
FROM airbnb_apartments AS a
LEFT JOIN airbnb_hosts AS h ON a.host_id = h.host_id
GROUP BY h.nationality
ORDER BY 2 DESC

SELECT h.nationality,
		SUM(a.n_beds)
FROM  airbnb_hosts AS h
LEFT JOIN airbnb_apartments AS a ON a.host_id = h.host_id
GROUP BY h.nationality
ORDER BY 2 DESC

-- Question 7 (IBM)


"""
IBM is working on a new feature to analyze user purchasing behavior for all Fridays in the first quarter of the year. For each Friday separately, calculate the average 
amount users have spent per order. The output should contain the week number of that Friday and average amount spent.

🔍 By solving this, you'll learn how to handle date and time by the end of the day. Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE user_purchases(user_id int, date date, amount_spent float, day_name varchar(15));

INSERT INTO user_purchases VALUES(1047,'2023-01-01',288,'Sunday'),(1099,'2023-01-04',803,'Wednesday'),(1055,'2023-01-07',546,'Saturday'),(1040,'2023-01-10',680,'Tuesday'),
(1052,'2023-01-13',889,'Friday'),(1052,'2023-01-13',596,'Friday'),(1016,'2023-01-16',960,'Monday'),(1023,'2023-01-17',861,'Tuesday'),(1010,'2023-01-19',758,'Thursday'),
(1013,'2023-01-19',346,'Thursday'),(1069,'2023-01-21',541,'Saturday'),(1030,'2023-01-22',175,'Sunday'),(1034,'2023-01-23',707,'Monday'),(1019,'2023-01-25',253,'Wednesday'),
(1052,'2023-01-25',868,'Wednesday'),(1095,'2023-01-27',424,'Friday'),(1017,'2023-01-28',755,'Saturday'),(1010,'2023-01-29',615,'Sunday'),(1063,'2023-01-31',534,'Tuesday'),
(1019,'2023-02-03',185,'Friday'),(1019,'2023-02-03',995,'Friday'),(1092,'2023-02-06',796,'Monday'),(1058,'2023-02-09',384,'Thursday'),(1055,'2023-02-12',319,'Sunday'),(1090,
'2023-02-15',168,'Wednesday'),(1090,'2023-02-18',146,'Saturday'),(1062,'2023-02-21',193,'Tuesday'),(1023,'2023-02-24',259,'Friday');
-------------
"""

WITH total_amount_spent AS(
SELECT user_id,
		date,
		amount_spent,
		DATE_PART('week', date) as week_number,
		day_name
FROM user_purchases
WHERE day_name = 'Friday' AND 
		DATE_PART('month', date) IN (1,2,3)
)
SELECT week_number,
		AVG(amount_spent)
FROM total_amount_spent
GROUP BY 1;

-- Question 8 (Tesla)

"""

You are given a table of product launches by company by year. Write a query to count the net difference between the number of products companies launched in 2020 with the 
number of products companies launched in the previous year. Output the name of the companies and a net difference of net products released for 2020 compared to the previous 
year.

🔍 By solving this, you'll learn how to handle aggregation function. Give it a try! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE car_launches(year int, company_name varchar(15), product_name varchar(30));

INSERT INTO car_launches VALUES(2019,'Toyota','Avalon'),(2019,'Toyota','Camry'),(2020,'Toyota','Corolla'),(2019,'Honda','Accord'),(2019,'Honda','Passport'),(2019,'Honda',
'CR-V'),(2020,'Honda','Pilot'),(2019,'Honda','Civic'),(2020,'Chevrolet','Trailblazer'),(2020,'Chevrolet','Trax'),(2019,'Chevrolet','Traverse'),(2020,'Chevrolet','Blazer'),
(2019,'Ford','Figo'),(2020,'Ford','Aspire'),(2019,'Ford','Endeavour'),(2020,'Jeep','Wrangler')
"""

WITH total_launches AS(
	SELECT company_name,
			SUM(CASE WHEN year = 2019 THEN 1 ELSE 0 END) AS product_2019,
			SUM(CASE WHEN year = 2020 THEN 1 ELSE 0 END) AS product_2020 
	FROM car_launches
	WHERE year IN (2019, 2020)
	GROUP BY company_name
)
SELECT company_name,
		(product_2020 - product_2019) AS net_difference
FROM total_launches
ORDER BY net_difference DESC;


--- Question 9 (Netflix)

"""

Find the genre of the person with the most number of oscar winnings.
If there are more than one person with the same number of oscar wins, return the first one in alphabetic order based on their name. Use the names as keys when joining 
the tables.

🔍 By solving this, you'll learn how to use join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE nominee_information(name varchar(20), amg_person_id varchar(10), top_genre varchar(10), birthday datetime, id int);

INSERT INTO nominee_information VALUES('Jennifer Lawrence','P562566','Drama','1990-08-15',755),('Jonah Hill','P418718','Comedy','1983-12-20',747),('Anne Hathaway', 
'P292630','Drama', '1982-11-12',744),('Jennifer Hudson','P454405','Drama', '1981-09-12',742),('Rinko Kikuchi', 'P475244','Drama', '1981-01-06', 739);

CREATE TABLE oscar_nominees(year int, category varchar(30), nominee varchar(20), movie varchar(30), winner int, id int);

INSERT INTO oscar_nominees VALUES(2008,'actress in a leading role','Anne Hathaway','Rachel Getting Married',0,77),(2012,'actress in a supporting role','Anne HathawayLes',
'Mis_rables',1,78),(2006,'actress in a supporting role','Jennifer Hudson','Dreamgirls',1,711),(2010,'actress in a leading role','Jennifer Lawrence','Winters Bone',1,717),
(2012,'actress in a leading role','Jennifer Lawrence','Silver Linings Playbook',1,718),(2011,'actor in a supporting role','Jonah Hill','Moneyball',0,799),(2006,'actress in 
a supporting role','Rinko Kikuchi','Babel',0,1253);
------------

"""
WITH top_winner AS(
SELECT i.name,
		i.top_genre,
		SUM(o.winner) AS most_winnings 
FROM nominee_information AS i
LEFT JOIN oscar_nominees AS o ON o.nominee = i.name
GROUP BY i.name, i.top_genre, o.winner
ORDER BY 3 DESC
)
SELECT 
		top_genre
FROM top_winner 
LIMIT 1


-- Question 10 (Amazon)

"""

Write a query that'll identify returning active users. A returning active user is a user that has made a second purchase within 7 days of any other of their purchases.
 Output a list of user_ids of these returning active users.

🔍 By solving this, you'll learn how to use self join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE amazon_transactions(id int, user_id int, item varchar(15), created_at datetime, revenue int);

INSERT INTO amazon_transactions VALUES (1,109,'milk','2020-03-03 00:00:00',123),(2,139,'biscuit','2020-03-18 00:00:00', 421), (3,120,'milk','2020-03-18 00:00:00',176),
(4,108,'banana','2020-03-18 00:00:00',862), (5,130,'milk','2020-03-28 00:00:00',333), (6,103,'bread','2020-03-29 00:00:00',862), (7,122,'banana','2020-03-07 00:00:00',952),
 (8,125,'bread','2020-03-13 00:00:00',317), (9,139,'bread','2020-03-30 00:00:00',929), (10,141,'banana','2020-03-17 00:00:00',812), (11,116,'bread','2020-03-31 00:00:00',
 226), (12,128,'bread','2020-03-04 00:00:00',112), (13,146,'biscuit','2020-03-04 00:00:00',362), (14,119,'banana','2020-03-28 00:00:00',127), (15,142,'bread','2020-03-09 
 00:00:00',503), (16,122,'bread','2020-03-06 00:00:00',593), (17,128,'biscuit','2020-03-24 00:00:00',160), (18,112,'banana','2020-03-24 00:00:00',262), (19,149,'banana',
 '2020-03-29 00:00:00',382), (20,100,'banana','2020-03-18 00:00:00',599);
------------

""" 

SELECT DISTINCT t1.user_id
FROM amazon_transactions t1 
JOIN amazon_transactions t2 
	ON t1.user_id = t2.user_id
	AND t1.created_at < t2.created_at
	AND t2.created_at <= t1.created_at + INTERVAL '7 Days';


-- Question 11 (Nvidia)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Nvidia, Microsoft (Medium Level) hashtag#SQL Interview Question — Solution

Find the number of transactions that occurred for each product. Output the product name along with the corresponding number of transactions and order records by the 
product id in ascending order. You can ignore products without transactions.

🔍 By solving this, you'll learn how to use join with grouping. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE excel_sql_inventory_data (product_id INT,product_name VARCHAR(50),product_type VARCHAR(50),unit VARCHAR(20),price_unit FLOAT,wholesale 
FLOAT,current_inventory INT);

INSERT INTO excel_sql_inventory_data (product_id, product_name, product_type, unit, price_unit, wholesale, current_inventory) 
VALUES(1, 'strawberry', 'produce', 'lb', 3.28, 1.77, 13),(2, 'apple_fuji', 'produce', 'lb', 1.44, 0.43, 2),(3, 'orange', 'produce', 'lb', 
1.02, 0.37, 2),(4, 'clementines', 'produce', 'lb', 1.19, 0.44, 44),(5, 'blood_orange', 'produce', 'lb', 3.86, 1.66, 19);

CREATE TABLE excel_sql_transaction_data (transaction_id INT PRIMARY KEY,time DATETIME,product_id INT);

INSERT INTO excel_sql_transaction_data (transaction_id, time, product_id) 
VALUES(153, '2016-01-06 08:57:52', 1),(91, '2016-01-07 12:17:27', 1),(31, '2016-01-05 13:19:25', 1),(24, '2016-01-03 10:47:44', 3),(4, '2016-01-06 17:57:42',
3),(163, '2016-01-03 10:11:22', 3),(92, '2016-01-08 12:03:20', 2),(32, '2016-01-04 19:37:14', 4),(253, '2016-01-06 14:15:20', 5),(118, '2016-01-06 14:27:33', 5);

"""


SELECT i.product_name, 
		COUNT(t.transaction_id) AS count_products
FROM excel_sql_inventory_data AS i 
JOIN excel_sql_transaction_data AS t
	ON t.product_id = i.product_id
GROUP BY i.product_name, i.product_id
ORDER BY i.product_id 


-- Question 12 (Dropbox)

"""
Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. Output just the absolute difference in 
salaries.

🔍 By solving this, you'll learn how to use case and join. Give it a try later and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE db_employee (id INT,first_name VARCHAR(50),last_name VARCHAR(50),salary INT,department_id INT);

INSERT INTO db_employee (id, first_name, last_name, salary, department_id) VALUES(10306, 'Ashley', 'Li', 28516, 4),(10307, 'Joseph', 'Solomon', 19945, 1),(10311, 
'Melissa', 'Holmes', 33575, 1),(10316, 'Beth', 'Torres', 34902, 1),(10317, 'Pamela', 'Rodriguez', 48187, 4),(10320, 'Gregory', 'Cook', 22681, 4),(10324, 'William', 
'Brewer', 15947, 1),(10329, 'Christopher', 'Ramos', 37710, 4),(10333, 'Jennifer', 'Blankenship', 13433, 4),(10339, 'Robert', 'Mills', 13188, 1);

CREATE TABLE db_dept (id INT,department VARCHAR(50));

"""


SELECT  ABS(
		MAX(CASE WHEN d.id = 1 THEN e.salary END) -
		MAX(CASE WHEN d.id = 4 THEN e.salary END)
		) AS difference 
FROM db_employee AS e
LEFT JOIN db_dept AS d 
	ON d.id = e.department_id


-- Question 13 (Expedia)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Expedia, Airbnb (Basic Level) hashtag#SQL Interview Question — Solution

Find the number of rows for each review score earned by 'Hotel Arena'. Output the hotel name (which should be 'Hotel Arena'), review score along with the corresponding 
number of rows with that score for the specified hotel.

🔍 By solving this, you'll learn how to use join with grouping. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE hotel_reviews (hotel_address VARCHAR(255),additional_number_of_scoring INT,review_date DATETIME,average_score FLOAT,hotel_name VARCHAR(100),reviewer_nationality
 VARCHAR(100),negative_review TEXT,review_total_negative_word_counts INT,total_number_of_reviews INT,positive_review TEXT,review_total_positive_word_counts INT,
 total_number_of_reviews_reviewer_has_given INT,reviewer_score FLOAT,tags VARCHAR(255),days_since_review VARCHAR(50),lat FLOAT,lng FLOAT);

INSERT INTO hotel_reviews (hotel_address, additional_number_of_scoring,review_date, average_score, hotel_name, reviewer_nationality,negative_review,
review_total_negative_word_counts, total_number_of_reviews,positive_review,review_total_positive_word_counts, total_number_of_reviews_reviewer_has_given, reviewer_score, 
tags, days_since_review, lat, lng) VALUES('123 Main St', 5, '2024-01-01', 8.5, 'Hotel Arena', 'American', 'Noisy room', 3, 200, 'Great staff', 5, 10, 8.0, 'Family stay', 
'100 days', 40.7128, -74.0060),('123 Main St', 2, '2024-01-02', 8.5, 'Hotel Arena', 'British', 'Small bathroom', 2, 200, 'Clean room', 6, 5, 9.0, 'Solo traveler', '95 days',
 40.7128, -74.0060),('123 Main St', 3, '2024-01-03', 8.5, 'Hotel Arena', 'Canadian', 'Slow service', 4, 200, 'Nice view', 7, 3, 6.0, 'Couple stay', '90 days', 
 40.7128, -74.0060);

------------
"""

SELECT hotel_name,
		reviewer_score, 
		COUNT(reviewer_score) AS number_of_scores
FROM hotel_reviews
GROUP BY hotel_name, reviewer_score


-- Question 14 (Amazon)
"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon, Salesforce (Basic Level) hashtag#SQL Interview Question — Solution

What is the total sales revenue of Samantha and Lisa?

🔊 Just wanted to point out that even major companies like Amazon ask questions this basic— so it's worth giving it a try! and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE sales_performance (salesperson VARCHAR(50),widget_sales INT,sales_revenue INT,id INT PRIMARY KEY);

INSERT INTO sales_performance (salesperson, widget_sales, sales_revenue, id) VALUES('Jim', 810, 40500, 1),('Bobby', 661, 33050, 2),('Samantha', 1006, 50300, 3),
('Taylor', 984, 49200, 4),('Tom', 403, 20150, 5),('Pat', 715, 35750, 6),('Lisa', 1247, 62350, 7);
------------
"""

SELECT
		SUM(sales_revenue) AS total_revenue 
FROM sales_performance
WHERE salesperson IN ('Samantha', 'Lisa')


-- Question 15 (Google)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Google (Medium Level) hashtag#SQL Interview Question — Solution

Find all records from days when the number of distinct users receiving emails was greater than the number of distinct users sending emails.

🔍 By solving this, you'll learn how to use agg function and join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE google_gmail_emails (id INT PRIMARY KEY,from_user VARCHAR(50),to_user VARCHAR(50),day INT);

INSERT INTO google_gmail_emails (id, from_user, to_user, day) VALUES(0, '6edf0be4b2267df1fa', '75d295377a46f83236', 10),(1, '6edf0be4b2267df1fa', '32ded68d89443e808', 6),
(2, '6edf0be4b2267df1fa', '55e60cfcc9dc49c17e', 10),(3, '6edf0be4b2267df1fa', 'e0e0defbb9ec47f6f7', 6),(4, '6edf0be4b2267df1fa', '47be2887786891367e', 1),
(5, '6edf0be4b2267df1fa', '2813e59cf6c1ff698e', 6),(6, '6edf0be4b2267df1fa', 'a84065b7933ad01019', 8),(7, '6edf0be4b2267df1fa', '850badf89ed8f06854', 1),
(8, '6edf0be4b2267df1fa', '6b503743a13d778200', 1),(9, '6edf0be4b2267df1fa', 'd63386c884aeb9f71d', 3),(10, '6edf0be4b2267df1fa', '5b8754928306a18b68', 2),
(11, '6edf0be4b2267df1fa', '6edf0be4b2267df1fa', 8),(12, '6edf0be4b2267df1fa', '406539987dd9b679c0', 9),(13, '6edf0be4b2267df1fa', '114bafadff2d882864', 5),
(14, '6edf0be4b2267df1fa', '157e3e9278e32aba3e', 2),(15, '75d295377a46f83236', '75d295377a46f83236', 6),(16, '75d295377a46f83236', 'd63386c884aeb9f71d', 8),
(17, '75d295377a46f83236', '55e60cfcc9dc49c17e', 3),(18, '75d295377a46f83236', '47be2887786891367e', 10),(19, '75d295377a46f83236', '5b8754928306a18b68', 10),
(20, '75d295377a46f83236', '850badf89ed8f06854', 7);

"""
WITH emails AS(
	SELECT day,
		COUNT(DISTINCT(to_user)) AS receiving_emails,
		COUNT(DISTINCT(from_user)) AS sending_emails
	FROM google_gmail_emails
	GROUP BY day
)
SELECT g.id, 
		g.from_user,
		g.to_user,
		g.day
FROM google_gmail_emails AS g
JOIN emails AS e ON e.day = g.day 
WHERE e.receiving_emails > e.sending_emails
ORDER BY 4, 1

-- Question 16 (JPMorgan)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: JP Morgan, Chase, Bloomberg (Medium Level) hashtag#SQL Interview Question — Solution

Bank of Ireland has requested that you detect invalid transactions in December 2022. An invalid transaction is one that occurs outside of the bank's normal business 
hours. The following are the hours of operation for all branches:

Monday - Friday 09:00 - 16:00
Saturday & Sunday Closed
Irish Public Holidays 25th and 26th December
Determine the transaction ids of all invalid transactions.

💸 Tech-driven financial firms have asked this question in interviews. By solving this, you'll learn how to use time and date function. Give it a try and share the 
output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE boi_transactions (transaction_id INT PRIMARY KEY,time_stamp DATETIME NOT NULL);

INSERT INTO boi_transactions (transaction_id, time_stamp) VALUES(1051, '2022-12-03 10:15'),(1052, '2022-12-03 17:00'),(1053, '2022-12-04 10:00'),(1054, '2022-12-04 
14:00'),(1055, '2022-12-05 08:59'),(1056, '2022-12-05 16:01'),(1057, '2022-12-06 09:00'),(1058, '2022-12-06 15:59'),(1059, '2022-12-07 12:00'),(1060, '2022-12-08 09:00'),
(1061, '2022-12-09 10:00'),(1062, '2022-12-10 11:00'),(1063, '2022-12-10 17:30'),(1064, '2022-12-11 12:00'),(1065, '2022-12-12 08:59'),(1066, '2022-12-12 16:01'),
(1067, '2022-12-25 10:00'),(1068, '2022-12-25 15:00'),(1069, '2022-12-26 09:00'),(1070, '2022-12-26 14:00'),(1071, '2022-12-26 16:30'),(1072, '2022-12-27 09:00'),
(1073, '2022-12-28 08:30'),(1074, '2022-12-29 16:15'),(1075, '2022-12-30 14:00'),(1076, '2022-12-31 10:00');
------------
"""

SELECT transaction_id
FROM boi_transactions
WHERE EXTRACT(MONTH FROM time_stamp) = 12
	AND EXTRACT(YEAR FROM time_stamp) = 2025 
	AND (
		time_stamp::time BETWEEN '09:00:00' AND '16:00:00'
		OR EXTRACT(DOW FROM time_stamp) BETWEEN 1 AND 5 
	)
	AND time_stamp::date NOT IN ('2022-12-25', '2022-12-26');


-- Question 17 (Uber)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Uber (Medium Level) hashtag#SQL Interview Question — Solution

You’re given a table of Uber rides that contains the mileage and the purpose for the business expense. You’re asked to find business purposes that generate the
 most miles driven for passengers that use Uber for their business transportation. Find the top 3 business purpose categories by total mileage.

🔍 By solving this, you'll learn how to group by. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE my_uber_drives (start_date DATETIME,end_date DATETIME,category VARCHAR(50),start VARCHAR(50),stop VARCHAR(50),miles FLOAT,purpose VARCHAR(50));

INSERT INTO my_uber_drives (start_date, end_date, category, start, stop, miles, purpose) VALUES('2016-01-01 21:11', '2016-01-01 21:17', 'Business', 'Fort Pierce', 
'Fort Pierce', 5.1, 'Meal/Entertain'),('2016-01-02 01:25', '2016-01-02 01:37', 'Business', 'Fort Pierce', 'Fort Pierce', 5, NULL),('2016-01-02 20:25', '2016-01-02 20:38', 
'Business', 'Fort Pierce', 'Fort Pierce', 4.8, 'Errand/Supplies'),('2016-01-05 17:31', '2016-01-05 17:45', 'Business', 'Fort Pierce', 'Fort Pierce', 4.7, 'Meeting'),
('2016-01-06 14:42', '2016-01-06 15:49', 'Business', 'Fort Pierce', 'West Palm Beach', 63.7, 'Customer Visit'),('2016-01-06 17:15', '2016-01-06 17:19', 'Business', 
'West Palm Beach', 'West Palm Beach', 4.3, 'Meal/Entertain'),('2016-01-06 17:30', '2016-01-06 17:35', 'Business', 'West Palm Beach', 'Palm Beach', 7.1, 'Meeting');
------------

"""

SELECT purpose, 
		SUM(miles) AS max_miles
FROM my_uber_drives 
WHERE category = 'Business'
GROUP BY purpose 
LIMIT 3;



-- Question 18 (Amazon)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Amazon, Doordash(Medium Level)hashtag#SQL Interview Question — Solution

You have been asked to find the job titles of the highest-paid employees.
Your output should include the highest-paid title or multiple titles with the same salary.

🔍 By solving this, you'll learn how to use subquery and join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE worker(worker_id INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),salary INT,joining_date DATETIME,department VARCHAR(50));

INSERT INTO worker(worker_id, first_name, last_name, salary, joining_date, department) VALUES(1, 'John', 'Doe', 80000, '2020-01-15', 'Engineering'),(2, 'Jane', 'Smith', 
120000, '2019-03-10', 'Marketing'),(3, 'Alice', 'Brown', 120000, '2021-06-21', 'Sales'),(4, 'Bob', 'Davis', 75000, '2018-04-30', 'Engineering'),(5, 'Charlie', 'Miller',
 95000, '2021-01-15', 'Sales');

CREATE TABLE title(worker_ref_id INT,worker_title VARCHAR(50),affected_from DATETIME);

INSERT INTO title(worker_ref_id, worker_title, affected_from) VALUES(1, 'Engineer', '2020-01-15'),(2, 'Marketing Manager', '2019-03-10'),(3, 'Sales Manager', '2021-06-21'),
(4, 'Junior Engineer', '2018-04-30'),(5, 'Senior Salesperson', '2021-01-15');
-----------
"""

SELECT t.worker_title
FROM worker AS w
JOIN title AS t ON t.worker_ref_id = w.worker_id
WHERE w.salary = (
		SELECT MAX(salary) FROM worker
);


-- Question 19 (Walmart)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Walmart (HardLevel) hashtag#SQL Interview Question — Solution

Identify users who started a session and placed an order on the same day. For these users, calculate the total number of orders and the total order value for that day. 
Your output should include the user, the session date, the total number of orders, and the total order value for that day.

🔍By solving this, you'll learn how to use join, groupby and having. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE sessions(session_id INT PRIMARY KEY,user_id INT,session_date DATETIME);

INSERT INTO sessions(session_id, user_id, session_date) VALUES (1, 1, '2024-01-01 00:00:00'),(2, 2, '2024-01-02 00:00:00'),(3, 3, '2024-01-05 00:00:00'),(4, 3, 
'2024-01-05 00:00:00'),(5, 4, '2024-01-03 00:00:00'),(6, 4, '2024-01-03 00:00:00'),(7, 5, '2024-01-04 00:00:00'),(8, 5, '2024-01-04 00:00:00'),(9, 3, '2024-01-05 00:00:00'),
(10, 5, '2024-01-04 00:00:00');

CREATE TABLE order_summary (order_id INT PRIMARY KEY,user_id INT,order_value INT,order_date DATETIME);

INSERT INTO order_summary (order_id, user_id, order_value, order_date) VALUES (1, 1, 152, '2024-01-01 00:00:00'),(2, 2, 485, '2024-01-02 00:00:00'),(3, 3, 398, 
'2024-01-05 00:00:00'),(4, 3, 320, '2024-01-05 00:00:00'),(5, 4, 156, '2024-01-03 00:00:00'),(6, 4, 121, '2024-01-03 00:00:00'),(7, 5, 238, '2024-01-04 00:00:00'),
(8, 5, 70, '2024-01-04 00:00:00'),(9, 3, 152, '2024-01-05 00:00:00'),(10, 5, 171, '2024-01-04 00:00:00');

-----------
"""

SELECT s.user_id,
		s.session_date,
		COUNT(o.order_id) AS count_order,
		sum(o.order_value) AS total_value
FROM sessions AS s 
JOIN order_summary AS o 
	ON o.user_id = s.user_id
WHERE s.session_date = o.order_date 
GROUP BY s.user_id, s.session_date
ORDER BY 2



-- Question 20 (Microsoft)
"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Apple, Microsoft, Dell (Easy Level) hashtag#SQL Interview Question — Solution

Write a query that returns the number of unique users per client per month

🔍Easiest one, but it's been asked by multiple top companies. Give it a try and share your output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE fact_events (id INT PRIMARY KEY,time_id DATETIME,user_id VARCHAR(20),customer_id VARCHAR(50),client_id VARCHAR(20),event_type VARCHAR(50),event_id INT);

INSERT INTO fact_events (id, time_id, user_id, customer_id, client_id, event_type, event_id) VALUES(1, '2020-02-28', '3668-QPYBK', 'Sendit', 'desktop', 'message sent', 3),
(2, '2020-02-28', '7892-POOKP', 'Connectix', 'mobile', 'file received', 2),(3, '2020-04-03', '9763-GRSKD', 'Zoomit', 'desktop', 'video call received', 7),(4, '2020-04-02', 
'9763-GRSKD', 'Connectix', 'desktop', 'video call received', 7),(5, '2020-02-06', '9237-HQITU', 'Sendit', 'desktop', 'video call received', 7),(6, '2020-02-27', '8191-XWSZG',
 'Connectix', 'desktop', 'file received', 2),(7, '2020-04-03', '9237-HQITU', 'Connectix', 'desktop', 'video call received', 7),(8, '2020-03-01', '9237-HQITU', 'Connectix', 
 'mobile', 'message received', 4),(9, '2020-04-02', '4190-MFLUW', 'Connectix', 'mobile', 'video call received', 7),(10, '2020-04-21', '9763-GRSKD', 'Sendit', 'desktop', 
 'file received', 2);
-----------
"""

SELECT TO_CHAR(time_id, 'YYYY-MM') AS month_stamp,
		COUNT(DISTINCT user_id) AS unique_ucers,
		client_id
FROM fact_events
GROUP BY client_id, TO_CHAR(time_id, 'YYYY-MM')



-- Question 1 
'''
Return the count of employees by gender. Return the gender value and the count of employees
'''

SELECT gender,
		COUNT(gender) AS gender_count
FROM employees
GROUP BY gender;

-- Question 2 
'''
Return the first_name and last_name of the employees who have had more than 1 title. Return 
the first_name, last_name and the count of the titles they have.
'''

SELECT e.first_name,
		e.last_name,
        COUNT(t.emp_no) AS titles_count
FROM titles AS t
LEFT JOIN employees AS e
		ON e.emp_no = t.emp_no
GROUP BY t.emp_no
HAVING COUNT(t.emp_no) > 1;

-- Question 3 
'''
All-time highest earning employee. This is the employee whose salary is highest. Return the 
first_name, last_name, salary and the department in which the employee works.
'''

WITH max_salary AS (
	SELECT e.first_name,
			e.last_name,
            e.emp_no,
            s.salary
	FROM employees AS e 
    LEFT JOIN salaries AS s
			ON s.emp_no = e.emp_no
	WHERE s.salary = (SELECT MAX(salary) FROM salaries)
), 
employee_departments AS(
	SELECT de.emp_no,
			d.dept_name
	FROM dept_emp AS de 
    LEFT JOIN departments AS d 
			ON d.dept_no = de.dept_no
)
SELECT m.first_name,
		m.last_name,
        m.salary,
		em.dept_name
FROM max_salary AS m
LEFT JOIN employee_departments AS em
		ON em.emp_no = m.emp_no;

-- Question 4 
'''
Find all the employees who have never been a department manager. Return the first_name and 
the last_name.
'''

SELECT first_name,
		last_name 
FROM employees AS e 
WHERE emp_no NOT IN (SELECT emp_no FROM dept_manager);

-- Question 5 
'''
Return the sum of departmental salaries by year group by department and ascending order of 
year. Return should have department name, year and the total salary. For the year calculations, 
consider the to_date.
'''

WITH employee_department AS (
    SELECT s.emp_no, 
           s.salary,
           s.to_date,
           de.dept_no
    FROM salaries AS s
    LEFT JOIN dept_emp AS de
        ON de.emp_no = s.emp_no
), department_names_employees AS (
    SELECT de.emp_no,
           de.dept_no,
           dep.dept_name
    FROM dept_emp AS de
    LEFT JOIN departments AS dep
        ON dep.dept_no = de.dept_no
) 
SELECT 
    dne.dept_name,
    DATE_FORMAT(ed.to_date, '%Y') AS year,
    SUM(ed.salary) AS total_salary
FROM employee_department AS ed
LEFT JOIN department_names_employees AS dne
    ON dne.emp_no = ed.emp_no
    AND dne.dept_no = ed.dept_no 
GROUP BY 1, 2
ORDER BY 2 ASC;

-- Question 6 
'''
Which job title has the highest salary? Return the job title and the salary.
'''

WITH max_salaries AS(
	SELECT emp_no, 
			salary AS max_salary
	FROM salaries
	WHERE salary = (SELECT MAX(salary) FROM salaries)
)
SELECT ms.max_salary,
		t.title
FROM max_salaries AS ms
LEFT JOIN titles AS t
		ON t.emp_no = ms.emp_no
LIMIT 1; 

-- Question 21 (Microsoft)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Microsoft (Hard Level) hashtag#SQL Interview Question — Solution

Find the total number of downloads for paying and non-paying users by date. Include only records where non-paying customers have more downloads than paying customers. 
The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads. 

Note: In Oracle you should use "date" when referring to date column (reserved keyword).

🔍By solving this, you'll learn how to use join, groupby and having. Give it a try and share the output!👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE ms_user_dimension (user_id INT PRIMARY KEY,acc_id INT);
INSERT INTO ms_user_dimension (user_id, acc_id) VALUES (1, 101),(2, 102),(3, 103),(4, 104),(5, 105);

CREATE TABLE ms_acc_dimension (acc_id INT PRIMARY KEY,paying_customer VARCHAR(10));
INSERT INTO ms_acc_dimension (acc_id, paying_customer) VALUES (101, 'Yes'),(102, 'No'),(103, 'Yes'),(104, 'No'),(105, 'No');

CREATE TABLE ms_download_facts (date DATETIME,user_id INT,downloads INT);
INSERT INTO ms_download_facts (date, user_id, downloads) VALUES ('2024-10-01', 1, 10),('2024-10-01', 2, 15),('2024-10-02', 1, 8),('2024-10-02', 3, 12),('2024-10-02', 4, 20)
,('2024-10-03', 2, 25),('2024-10-03', 5, 18);
-----------
"""

WITH payment_for_customers AS(
	SELECT ud.user_id, 
			ad.paying_customer 
	FROM ms_user_dimension AS ud 
	LEFT JOIN ms_acc_dimension AS ad 
			ON ad.acc_id = ud.acc_id
)
SELECT df.date,
		SUM(CASE WHEN pc.paying_customer = 'Yes' THEN df.downloads ELSE 0 END) AS paying_customer,
		SUM(CASE WHEN pc.paying_customer = 'No' THEN df.downloads ELSE 0 END) AS not_paying_customer
FROM payment_for_customers AS pc
LEFT JOIN ms_download_facts AS df
		ON pc.user_id = df.user_id 
GROUP BY 1
HAVING SUM(CASE WHEN pc.paying_customer = 'No' THEN df.downloads ELSE 0 END) > 
 		SUM(CASE WHEN pc.paying_customer = 'Yes' THEN df.downloads ELSE 0 END)
ORDER BY 1 ASC

-- Question 22 (Walmart)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: Walmart, Paypal (Medium Level) hashtag#SQL Interview Question — Solution

Find managers with at least 3 direct reporting employees. In situations where user is reporting to himself/herself, count that also.
Output first names of managers.

🔍By solving this, you'll learn how to use self join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE employees (id INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),age INT,sex VARCHAR(10),employee_title VARCHAR(50),department VARCHAR(50),salary 
INT,target INT,bonus INT,email VARCHAR(100),city VARCHAR(50),address VARCHAR(255),manager_id INT);

INSERT INTO employees (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id) VALUES(1, 'Alice', 'Smith', 
40, 'F', 'Manager', 'Sales', 90000, 100000, 15000, 'alice.smith@example.com', 'New York', '123 Main St', 1),(2, 'Bob', 'Johnson', 35, 'M', 'Team Lead', 'Sales', 80000, 95000,
 12000, 'bob.johnson@example.com', 'Chicago', '456 Oak St', 1),(3, 'Carol', 'Williams', 30, 'F', 'Sales Executive', 'Sales', 70000, 85000, 10000, 'carol.williams@example.com', 
 'New York', '789 Pine St', 1),(4, 'David', 'Brown', 28, 'M', 'Sales Executive', 'Sales', 68000, 80000, 9000, 'david.brown@example.com', 'Chicago', '101 Maple St', 1),(5, 'Emma',
  'Jones', 32, 'F', 'Sales Executive', 'Sales', 71000, 86000, 9500, 'emma.jones@example.com', 'New York', '202 Cedar St', 1),(6, 'Frank', 'Miller', 45, 'M', 'Manager', 'Engineering', 95000, 105000,
   16000, 'frank.miller@example.com', 'San Francisco', '303 Spruce St', 6),(7, 'Grace', 'Davis', 29, 'F', 'Engineer', 'Engineering', 73000, 87000, 11000, 'grace.davis@example.com', 'San Francisco', 
   '404 Willow St', 6);
-----------

"""

SELECT m.first_name
FROM employees AS e
JOIN employees AS m 
	ON e.manager_id = m.id
GROUP BY m.first_name
HAVING COUNT(e.id) > 3


-- Question 25 (American Express)

"""
𝐌𝐮𝐬𝐭 𝐓𝐫𝐲: American Express (Medium Level) hashtag#SQL Interview Question — Solution

American Express is reviewing their customers' transactions, and you have been tasked with locating the customer who has the third highest total transaction amount. 
The output should include the customer's id, as well as their first name and last name. For ranking the customers, use type of ranking with no gaps between subsequent ranks.

🔍By solving this, you'll learn how to use mutiple join. Give it a try and share the output! 👇

𝐒𝐜𝐡𝐞𝐦𝐚 𝐚𝐧𝐝 𝐃𝐚𝐭𝐚𝐬𝐞𝐭:
CREATE TABLE customers (id INT,first_name VARCHAR(50),last_name VARCHAR(50),city VARCHAR(100),address VARCHAR(200),phone_number VARCHAR(20));

INSERT INTO customers (id, first_name, last_name, city, address, phone_number) VALUES(1, 'Jill', 'Doe', 'New York', '123 Main St', '555-1234'),(2, 'Henry', 'Smith', 
'Los Angeles', '456 Oak Ave', '555-5678'),(3, 'William', 'Johnson', 'Chicago', '789 Pine Rd', '555-8765'),(4, 'Emma', 'Daniel', 'Houston', '321 Maple Dr', '555-4321'),
(5, 'Charlie', 'Davis', 'Phoenix', '654 Elm St', '555-6789');

CREATE TABLE card_orders (order_id INT,cust_id INT,order_date DATETIME,order_details VARCHAR(255),total_order_cost INT);

INSERT INTO card_orders (order_id, cust_id, order_date, order_details, total_order_cost) VALUES(1, 1, '2024-11-01 10:00:00', 'Electronics', 200),(2, 2, '2024-11-02 11:30:00',
 'Groceries', 150),(3, 1, '2024-11-03 15:45:00', 'Clothing', 120),(4, 3, '2024-11-04 09:10:00', 'Books', 90),(8, 3, '2024-11-08 10:20:00', 'Groceries', 130),(9, 1, 
 '2024-11-09 12:00:00', 'Books', 180),(10, 4, '2024-11-10 11:15:00', 'Electronics', 200),(11, 5, '2024-11-11 14:45:00', 'Furniture', 150),(12, 2, '2024-11-12 09:30:00', 
 'Furniture', 180);
-----------
"""

WITH transactions AS( 
	SELECT cust_id, 
			SUM(total_order_cost) AS total_spent 
	FROM card_orders
	GROUP BY cust_id
	ORDER BY 2 DESC
), rank_transactions AS(
	SELECT cust_id, 
			RANK () OVER (ORDER BY total_spent DESC) AS rank
	FROM transactions
)
	SELECT c.first_name,
			c.last_name, 
			r.cust_id
	FROM customers AS c
	JOIN rank_transactions as r 
		ON c.id = r.cust_id 
	WHERE r.rank=3