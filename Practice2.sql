--EX1
SELECT DISTINCT CITY FROM STATION 
WHERE ID%2=0
--EX2
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION
--EX4
SELECT round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1)
FROM items_per_order
--EX5
SELECT candidate_id FROM candidates
WHERE skill in ( 'Python', 'Tableau', 'PostgreSQL')
group by candidate_id
HAVING count(skill) = 3
--EX6
SELECT user_id, max(date(post_date)) - min(date(post_date)) as day_between
FROM posts
where post_date between '2021-01-01' and '2022-01-01'
group by user_id
having max(date(post_date)) - min(date(post_date)) > 0 
--EX7
SELECT card_name, max(issued_amount) - min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by max(issued_amount) - min(issued_amount) desc
--EX8
SELECT manufacturer, count(drug) as drug_count, sum(cogs - total_sales) as total_lose
FROM pharmacy_sales
where total_sales < cogs
group by manufacturer 
order by total_lose desc
--EX9
select id, movie, description, rating
from Cinema
where id%2=1 and description not like 'boring'
order by rating desc
--EX10
select teacher_id, count(distinct subject_id)
from Teacher
group by teacher_id
--EX11
select user_id, count(follower_id)
from Followers
group by user_id
order by user_id 
--EX12
select class
from Courses
group by class
having count(student) >=5



