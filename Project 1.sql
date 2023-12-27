select * from SALES_DATASET_RFM_PRJ

--1.Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN orderdate TYPE timestamp USING orderdate::timestamp
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric)
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN ordernumber TYPE integer USING ordernumber::integer
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN orderlinenumber TYPE integer USING orderlinenumber::integer
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN sales TYPE numeric(10,2) USING sales::numeric(10,2)
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN city TYPE text USING city::text
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN state TYPE text USING state::text
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN country TYPE text USING country::text
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN contactfullname TYPE text USING contactfullname::text
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN dealsize TYPE text USING dealsize::text
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN status TYPE text USING status::text
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN productline TYPE text USING productline::text
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN msrp TYPE integer USING msrp::integer
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN productcode TYPE text USING productcode::text
ALTER TABLE SALES_DATASET_RFM_PRJ 
ALTER COLUMN customername TYPE text USING customername::text

/* 2.Check NULL/BLANK (‘’)  ở các trường: 
ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE*/
select ordernumber, quantityordered,  priceeach, 
orderlinenumber, sales, orderdate
from SALES_DATASET_RFM_PRJ
where orderdate is null or priceeach is null 
or ordernumber is null or orderlinenumber is null or sales is null 
or quantityordered is null

--3.Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME 
alter table SALES_DATASET_RFM_PRJ
add column contactlastname text
alter table SALES_DATASET_RFM_PRJ
add column contactfirstname text

--3.Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
update SALES_DATASET_RFM_PRJ
set contactfirstname= substring(contactfullname from 1 for position('-'in contactfullname)-1)
update SALES_DATASET_RFM_PRJ
set contactfirstname= upper(left(contactfirstname,1)) || substring(contactfirstname from 2)

update SALES_DATASET_RFM_PRJ
set contactlastname= substring(contactfullname from position('-'in contactfullname)+1)
update SALES_DATASET_RFM_PRJ
set contactlastname= upper(left(contactlastname,1)) || substring(contactlastname from 2)

--4.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
alter table SALES_DATASET_RFM_PRJ
add column year_id integer
update SALES_DATASET_RFM_PRJ
set year_id=(extract(year from orderdate))

alter table SALES_DATASET_RFM_PRJ
add column month_id integer
update SALES_DATASET_RFM_PRJ
set month_id=(extract(month from orderdate))

alter table SALES_DATASET_RFM_PRJ
add column qtr_id integer
update SALES_DATASET_RFM_PRJ
set qtr_id = (extract(quarter from orderdate))

--5.Tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách)
--Cach 1
with min_max as(
select 
q1-1.5*iqr as min_value,
q3+1.5*iqr as max_value
from(
SELECT 
percentile_cont(0.25) within group (order by quantityordered) as q1,
percentile_cont(0.75) within group (order by quantityordered) as q3,
percentile_cont(0.75) within group (order by quantityordered)-
percentile_cont(0.25) within group (order by quantityordered) as iqr
from SALES_DATASET_RFM_PRJ) as a)
select quantityordered from SALES_DATASET_RFM_PRJ
where 
quantityordered<(select min_value from min_max) 
or
quantityordered>(select max_value from min_max) 
delete from SALES_DATASET_RFM_PRJ
where quantityordered in (select quantityordered from outliers)
  
--Cach 2
with z_scoretable as(
select quantityordered,
(select avg(quantityordered) from SALES_DATASET_RFM_PRJ) as avg,
(select stddev(quantityordered) from SALES_DATASET_RFM_PRJ) as stddev
from SALES_DATASET_RFM_PRJ),
outliers as(
select *, (quantityordered-avg)/stddev as z_score
from z_scoretable
where abs((quantityordered-avg)/stddev)>2)
update SALES_DATASET_RFM_PRJ
set quantityordered=(select avg(quantityordered)
from SALES_DATASET_RFM_PRJ)
where quantityordered in(select quantityordered from outliers)

--6.Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới tên là SALES_DATASET_RFM_PRJ_CLEAN

create table SALES_DATASET_RFM_PRJ_CLEAN AS
(select * from SALES_DATASET_RFM_PRJ)








































