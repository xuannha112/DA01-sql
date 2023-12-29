-- 1.Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select format_datetime('%Y-%m',created_at) as month_year , 
count(distinct user_id) as total_user, count(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.order_items
where returned_at is null
and format_datetime('%Y-%m',created_at) between '2019-01' and '2022-04'
group by 1
order by 1
  
--2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select format_datetime('%Y-%m',created_at) as month_year, 
count( distinct user_id) as distinct_user, sum(sale_price)/count(order_id) as avg_ord_value
from bigquery-public-data.thelook_ecommerce.order_items
where returned_at is null
and format_datetime('%Y-%m',created_at) between '2019-01' and '2022-04'
group by 1
order by 1
  
-- 3. Nhóm khách hàng theo độ tuổi
with youngest as(
select distinct first_name, last_name, gender,age
from bigquery-public-data.thelook_ecommerce.users as u
join bigquery-public-data.thelook_ecommerce.order_items as i on u.id = i.user_id
where age in ( select min(age)
from bigquery-public-data.thelook_ecommerce.users)
and format_datetime('%Y-%m',i.created_at) between '2019-01' and '2022-04'
order by gender)
select gender, count(gender) 
from youngest
group by gender
  
with oldest as(
select distinct first_name, last_name, gender,age
from bigquery-public-data.thelook_ecommerce.users as u
join bigquery-public-data.thelook_ecommerce.order_items as i on u.id = i.user_id
where age in ( select max(age)
from bigquery-public-data.thelook_ecommerce.users)
and format_datetime('%Y-%m',i.created_at) between '2019-01' and '2022-04'
order by gender)
select gender,count(gender) 
from oldest
group by gender

-- 4.Top 5 sản phẩm mỗi tháng
select * from (
select format_datetime('%Y-%m',created_at) as month_year,
product_id, product_name, product_retail_price as sales, cost, product_retail_price-cost as profit, 
dense_rank() over(partition by format_datetime('%Y-%m',created_at) order by product_retail_price-cost) as rank_per_month
from bigquery-public-data.thelook_ecommerce.inventory_items
where format_datetime('%Y-%m',created_at) between '2019-01' and '2022-04') as a
where rank_per_month <=5 order by month_year
  
-- 5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
select format_datetime('%d',created_at) as day, product_category, 
sum(product_retail_price)as revenue
from bigquery-public-data.thelook_ecommerce.inventory_items
where format_datetime('%Y-%m-%d',created_at) between '2022-01-15'and'2022-04-15'
group by 1,2
order by 1




