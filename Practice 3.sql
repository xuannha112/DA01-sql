--EX1
select Name
from STUDENTS
where Marks > 75
order by  right(Name,3), ID
--EX2
select user_id, 
concat(upper(left(name,1)), lower(right(name, length(name)- 1))) 
--concat(upper(left(name,1)), lower(substring(name,2)))
from Users
--EX3
SELECT manufacturer, concat('$', round((sum(total_sales)/1000000),0), ' ', 'million') as sales
FROM pharmacy_sales
group by manufacturer
order by round((sum(total_sales)/1000000),0) desc, manufacturer
--EX4
SELECT extract(month from submit_date) as month, product_id, round(avg(stars),2)
FROM reviews
group by extract(month from submit_date), product_id
order by extract(month from submit_date), product_id
--EX5
SELECT sender_id, count(message_id)
FROM messages
where extract(month from sent_date) = 8
and extract(year from sent_date) = 2022
group by sender_id, extract(month from sent_date)
order by count(message_id) desc
limit 2
--EX6
select tweet_id
from Tweets
where length(content) > 15
group by tweet_id
--EX7
select activity_date as day, count(distinct user_id)
from Activity
where activity_date between '2019-06-27' and '2019-07-28'
group by activity_date
--EX8
select count(id)
from employees
where joining_date between '2022-02-01' and '2022-08-01'
--EX9
select position('a' in first_name)
from worker
where first_name = 'Amitah'
--EX10
select title, substring(title from length(winery)+2 for 4)
from winemag_p2
where country = 'Macedonia'










