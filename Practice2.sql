--EX1
SELECT DISTINCT CITY FROM STATION 
WHERE ID%2=0
--EX2
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION
--EX4
SELECT round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1)
FROM items_per_order
--EX5
