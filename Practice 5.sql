--EX1 
select t1.Continent, floor(avg(t2.Population))
from COUNTRY as t1
inner join CITY as t2
on t1.code = t2.CountryCode
group by t1.Continent
--EX2
SELECT round(sum(case when t.signup_action = 'Confirmed' then 1 end)*1.0
/count(distinct e.email_id),2)
FROM  emails as e
left join texts as t 
on e.email_id = t.email_id 
--EX3
SELECT age.age_bucket, 
ROUND(100*sum(CASE WHEN act.activity_type = 'send' THEN act.time_spent END) :: DECIMAL 
/sum(CASE WHEN act.activity_type in ('open','send') THEN act.time_spent END),2) as send_perc,
ROUND(100*sum(CASE WHEN act.activity_type = 'open' THEN act.time_spent END) :: DECIMAL 
/sum(CASE WHEN act.activity_type in ('open','send') THEN act.time_spent END),2) as open_perc
FROM activities as act
inner join age_breakdown as age 
on act.user_id = age.user_id
group by age.age_bucket
--EX4
SELECT c.customer_id
FROM customer_contracts c
left join products p
on c.product_id = p.product_id
group by c.customer_id
having count (distinct p.product_category) = 3
--EX5
select a.employee_id , a.name, count(b.reports_to) as reports_count,
ceiling(avg(b.age)) as avg_age
from Employees a
inner join Employees b
on a.employee_id = b.reports_to
group by a.employee_id, a.name
order by a.employee_id
--EX6
select p.product_name, sum(o.unit) as unit    
from Products p
inner join Orders o
on p.product_id = o.product_id
where order_date between '2020-02-01' and '2020-02-28' 
group by p.product_name
having sum(o.unit) >= 100
--EX7
SELECT p.page_id
FROM pages p    
left join page_likes pl 
on p.page_id=pl.page_id
where pl.page_id is null
order by p.page_id
