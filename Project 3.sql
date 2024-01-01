/* 1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE*/
select productline, year_id, dealsize,
sum(sales)
from sales_dataset_rfm_prj_clean
group by productline, year_id, dealsize
order by productline, year_id, dealsize

/*2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER*/
select year_id, month_id, revenue,order_number 
from (
select year_id, month_id, sum(sales) as revenue, count(quantityordered) as order_number,
rank()over(partition by year_id order by sum(sales)desc) as rank
from sales_dataset_rfm_prj_clean
group by year_id, month_id
order by year_id, month_id) as a
where rank=1

/*3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER*/
with cte as (
select year_id, month_id,productline,
count(productline)as order_number, sum(sales) as revenue,
rank() over(partition by year_id order by count(productline)desc) as rank
from sales_dataset_rfm_prj_clean
where month_id = 11
group by year_id, month_id,productline
order by year_id)
select year_id, month_id,productline,order_number,revenue
from cte
where rank=1

/*4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK*/
select year_id, productline, sum(sales) as revenue,
rank() over(partition by year_id order by sum(sales)desc)
from sales_dataset_rfm_prj_clean
where country = 'UK'
group by year_id, productline

/*5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23)*/
with customer_rfm as (
select customername,
current_date - max(orderdate) as R,
count(distinct ordernumber)as F,
sum(sales) as M
from sales_dataset_rfm_prj_clean
group by customername)
,rfm_score as (
select customername,
ntile(5)over(order by r desc) as r_score,
ntile(5)over(order by f ) as f_score,
ntile(5)over(order by m ) as m_score
from customer_rfm)
, rfm_final as (
select customername,
cast(r_score as varchar)||cast(f_score as varchar)||cast(m_score as varchar) as rfm_score
from rfm_score)
select customername,rfm_score,segment
from rfm_final f
join segment_score s on s.scores=f.rfm_score
