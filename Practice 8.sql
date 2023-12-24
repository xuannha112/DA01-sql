--EX1
with new_table as (
select delivery_id, customer_id, order_date, customer_pref_delivery_date,
rank() over(partition by customer_id order by order_date) as rank
from Delivery)
select 
round((sum(case when order_date=customer_pref_delivery_date then 1 else 0 end)::DECIMAL / count(distinct customer_id))*100,2)
from new_table--
where rank=1
--EX2
with new_table as(select player_id, event_date,
lead(event_date) over(partition by player_id order by event_date) as lead
from Activity)
select round(sum(case when lead-event_date =1 then 1 else 0 end)::decimal/count(distinct player_id),2)
from new_table
--EX3
select  id, 
case 
when id%2=1 then coalesce(lead(student) over(order by id), student)
else lag(student) over(order by id) end 
from Seat
--EX4
with new_table as(
select visited_on, sum(amount) as amount from Customer group by visited_on)
select visited_on,
(amount
+lag(amount,6) over(order by visited_on)
+lag(amount,5) over(order by visited_on) 
+lag(amount,4) over(order by visited_on) 
+lag(amount,3) over(order by visited_on)
+lag(amount,2) over(order by visited_on)
+lag(amount,1) over(order by visited_on)) as total_amount,
round((amount 
+lag(amount,6) over(order by visited_on)
+lag(amount,5) over(order by visited_on) 
+lag(amount,4) over(order by visited_on) 
+lag(amount,3) over(order by visited_on)
+lag(amount,2) over(order by visited_on)
+lag(amount,1) over(order by visited_on))/7::decimal,2) as avg_amount
from new_table
--EX5
with new_table as (
select *, 
count(lat)over(partition by lat order by lat) a,
count(tiv_2015)over(partition by tiv_2015 order by tiv_2015) b
from Insurance)
select sum(tiv_2016)
from new_table
where a=1 and b<>1
--EX6
with new_table as (
select e.id,e.name, e.salary,departmentid, d.name as department_name,
dense_rank() over(partition by departmentId order by salary desc) rank
from Employee e
join Department d on d.id=e.departmentId)
select department_name, name, salary
from new_table
where rank in (1,2,3)
--EX7
with new_table as(
select person_id, person_name, weight, turn, 
sum(weight) over(order by turn) total_weight
from Queue)
select person_name
from new_table
where total_weight =1000
--EX8
with new_table as(
select product_id,change_date,new_price,
rank() over(partition by product_id order by change_date desc) rank
from Products
where change_date<='2019-08-16')
select product_id,new_price
from new_table
where rank=1
union
select product_id, 10
from Products
where product_id not in (select product_id from new_table)
