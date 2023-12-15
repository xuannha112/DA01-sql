--EX1
SELECT 
sum(case when device_type = 'laptop' then 1 else 0 end) as laptop_reviews,
sum(case when device_type in ('tablet', 'phone') then 1 else 0 end) as mobile_reviews
FROM viewership
--EX2
select
x,y,z,
case 
when x+y>z and x+z>y and y+z>x then 'Yes'
else 'No'
end triangle
from Triangle
--EX3
SELECT 
round((sum(case when call_category = 'n/a' or call_category is null 
then 1 else 0 end )/count(*))*100,1)
FROM callers
--EX5
select survived,
sum(case when pclass = 1 then 1 else 0 end) as first_class,
sum(case when pclass = 2 then 1 else 0 end) as second_class,
sum(case when pclass = 3 then 1 else 0 end) as third_class
from titanic
group by survived
