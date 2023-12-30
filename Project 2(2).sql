-- EX1
with cte as(
select format_datetime('%Y-%m',o.created_at)as month, format_datetime('%Y',o.created_at) as year,
p.category as product_category,sum(sale_price) as TPV, count(i.order_id) as TPO,sum(p.cost) as total_cost, 
sum(sale_price)-sum(p.cost) as total_ptofit,(sum(sale_price)-sum(p.cost))/sum(p.cost) as Profit_to_cost_ratio
from bigquery-public-data.thelook_ecommerce.order_items as i
join bigquery-public-data.thelook_ecommerce.orders as o on i.user_id=o.user_id
join bigquery-public-data.thelook_ecommerce.products as p on p.id=i.product_id
where i.returned_at is null
group by 1,2,3
order by 1,2,3)
select *,
round(((lead(TPV)over(partition by product_category order by month)-TPV)/TPV)*100.00,2)||'%' as Revenue_growth,
round(((lead(TPO)over(partition by product_category order by month)-TPO)/TPO)*100.00,2)||'%' as Order_growth
from cte
--EX2
with ctee as (
with cte as (
select user_id, format_datetime('%Y-%m',first_purchase_date) as cohort_date,first_purchase_date,count,
(extract(year from created_at)-extract(year from first_purchase_date))*12+
(extract(month from created_at)-extract(month from first_purchase_date))+1 as index
from (
select distinct user_id,created_at,
min(created_at) over(partition by user_id) as first_purchase_date,
count(order_id) over(partition by user_id) as count
from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete' order by format_datetime('%Y-%m',first_purchase_date)))
select cohort_date,
sum(case when index =1 then count else 0 end) as m1,
sum(case when index =2 then count else 0 end) as m2,
sum(case when index =3 then count else 0 end) as m3,
sum(case when index =4 then count else 0 end) as m4
from cte
group by cohort_date)
select cohort_date,
100 * m1/m1 ||'%' as m1,
round(100.00 *m2/m1,2) ||'%' as m2,
round(100.00 *m3/m1,2) ||'%' as m3,
round(100.00 *m4/m1,2) ||'%' as m4
from ctee
order by cohort_date
