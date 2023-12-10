--EX1
SELECT NAME FROM CITY 
WHERE COUNTRYCODE = 'USA' AND POPULATION > 120000
--EX2
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN'
--EX3
SELECT CITY, STATE FROM STATION
--EX4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'a%' or CITY LIKE'e%' or CITY LIKE 'i%' or CITY LIKE'o%' or CITY LIKE 'u%'
--EX5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%a' or CITY LIKE'%e' or CITY LIKE '%i' or CITY LIKE'%o' or CITY LIKE '%u'
--EX6
SELECT DISTINCT CITY FROM STATION
WHERE CITY NOT LIKE 'a%' or CITY LIKE'e%' or CITY LIKE 'i%' or CITY LIKE'o%' or CITY LIKE 'u%'
--EX7
SELECT name FROM Employee
ORDER BY name ASC
--EX8
SELECT name FROM Employee
WHERE salary > 2000 and months < 10
ORDER BY employee_id
--EX9
SELECT product_id FROM Products
WHERE low_fats = 'Y' and recyclable = 'Y'
--EX10
SELECT name FROM Customer
WHERE referee_id != 2 
--EX11
SELECT name, population, area  FROM World
WHERE area >=3000000 or population >= 25000000 
--EX12
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id = viewer_id
ORDER BY id 
--EX13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL
--EX14






