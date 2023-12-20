--EX1
with new_table as 
(select company_id, title, count(job_id) as job_count
from job_listings
group by company_id, title)
select count(company_id)  
from new_table
where job_count > 1
--EX2
with app as
(SELECT category,product, sum(spend) as total_spend
FROM product_spend
where category = 'appliance'  and extract(year from transaction_date) = 2022
group by category, product 
order by max(spend) DESC
limit 2), elc as
(SELECT category,product, sum(spend) as total_spend
FROM product_spend
where category = 'electronics' and extract(year from transaction_date) = 2022
group by category, product
order by max(spend) DESC
limit 2) 
select  category,product, total_spend from app
union 
select  category,product, total_spend from elc
--EX3
with new_table as
(SELECT policy_holder_id, count(case_id)
FROM callers
group by policy_holder_id
having count (case_id) >=3)
select count (policy_holder_id)
from new_table
--EX4
SELECT p.page_id
FROM pages p    
left join page_likes pl 
on p.page_id=pl.page_id
where pl.page_id is null
order by p.page_id
--EX5
with new_table as 
(SELECT user_id, event_type, extract (month from event_date) as month
FROM user_actions
where event_type in ('sign-in','like','comment')
and extract (month from event_date) = 6)
select count(distinct u.user_id), extract (month from event_date)
from user_actions u
join new_table n on u.user_id=n.user_id
where extract (month from event_date) = 7
group by extract (month from event_date)
--EX6
select extract(month from trans_date ) as month, country, count(state) as trans_count,
sum(case when state = 'approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state = 'approved' then amount end) as approved_total_amount 
from Transactions
group by extract(month from trans_date ), country
--EX7
with new_table as
(select product_id, min(year) as year from sales group by product_id)
select s.product_id, s.year as first_year, s.quantity, s.price
from sales s
join new_table n on s.year=n.year
--EX8
select customer_id
from Customer
group by customer_id
having  count(distinct product_key) =2
--EX9
select e1.employee_id
from Employees e1
join Employees e2 on e1.employee_id =e2.manager_id 
where e1.salary < 30000 and e2.manager_id is not null
--EX10 trung EX1
--EX11
(select u.name
from MovieRating r
join Users u on r.user_id=u.user_id
group by u.name
order by count(rating) desc , u.name 
limit 1)
union
(select m.title
from Movies m
join MovieRating r on m.movie_id=r.movie_id
where extract(month from r.created_at) = 2 and extract(year from r.created_at) = 2020
group by m.title
order by avg(rating) desc, m.title 
limit 1)
--EX12
with new_table as ((select requester_id
from RequestAccepted )
union all
(select accepter_id 
from RequestAccepted))
select requester_id, count(*) as num  from new_table 
group by requester_id order by num desc limit 1



