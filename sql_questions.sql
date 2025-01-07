
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