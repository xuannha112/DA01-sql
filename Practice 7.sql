--EX1
SELECT extract(year from transaction_date), product_id, spend as curr_year_spend,
lag(spend) over(partition by product_id order by extract(year from transaction_date)) as prev_year_spend,
round((spend-lag(spend) over(partition by product_id order by extract(year from transaction_date)))
  /lag(spend) over(partition by product_id order by extract(year from transaction_date))*100,2) as yoy_rate
FROM user_transactions
--EX2
with new_table as
(SELECT card_name, issued_amount, issue_month,	issue_year,
rank() over(partition by card_name order by issue_year, issue_month) as rank
FROM monthly_cards_issued)
select card_name, issued_amount
from new_table
where new_table.rank=1
order by issued_amount desc 
--EX3
with new_table as(
SELECT user_id, spend, transaction_date,
rank() over(partition by user_id order by transaction_date) as rank
FROM transactions)
select user_id,	spend, transaction_date
from new_table
where new_table.rank = 3
--EX4
with new_table as (SELECT transaction_date, user_id,
count(*) over(partition by user_id order by transaction_date desc) as purchase_count,
rank() over(partition by user_id order by transaction_date desc)
FROM user_transactions)
select distinct transaction_date, user_id, purchase_count
from new_table
where rank =1
--EX5
with new_table as (
SELECT user_id, tweet_date,tweet_count,
lag(tweet_count,1) over(partition by user_id order by tweet_date) as lag1,
lag(tweet_count,2) over(partition by user_id order by tweet_date) as lag2
FROM tweets)
select user_id, tweet_date,
case 
when row_number() over(partition by user_id order by tweet_date) =1 then round(tweet_count :: DECIMAL,2)
when row_number() over(partition by user_id order by tweet_date) =2 then round((tweet_count :: DECIMAL +lag1)/2,2) 
else round((tweet_count :: DECIMAL +lag1+lag2)/3,2) end
from new_table
--EX6
with new_table as(
SELECT transaction_id,merchant_id,credit_card_id, transaction_timestamp,
lag(transaction_timestamp) over(partition by credit_card_id),
extract(hour from(transaction_timestamp-
lag(transaction_timestamp) over(partition by credit_card_id)))*60 +
(extract(minute from transaction_timestamp) - extract(minute FROM
lag(transaction_timestamp) over(partition by credit_card_id))) as hihi
FROM transactions)
select count(*) from new_table where hihi <10
--EX7
with new_table as(
select category, product, sum(spend) as total_spend,
rank() over(partition by category order by sum(spend) desc) as rank
from product_spend
where extract(year from transaction_date)=2022
group by category, product)
select category, product, total_spend
from new_table
where rank in(1,2)
--EX8
with new_table as(
select a.artist_name, count(*) as so_luong,
dense_rank() over( order by count(*) desc) as rank
from artists a
join songs s on a.artist_id=s.artist_id
join global_song_rank g on g.song_id=s.song_id
where g.rank <=10
group by a.artist_name)
select artist_name, rank
from new_table
where rank<=5

