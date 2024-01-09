# Website Analysis 

## Case Description

The company launched a website platform for buying and selling goods on April 19, 2012.
To build market awareness, they advertised on several social media platforms. 
Over the next few days, they will conduct an analysis to see the traffic and performance of the company's website.

## Objectives

The objective of this project is exploring the data with SQL from given cases

**Tools Used:**
- SQL for data exploration


## Product Analysis

At the beginning of 2013, the company plans to add a new product. But before that, they wanted to see the monthly trend of sales, revenue, and margin/profit.
Therefore, on January 5, 2013, they asked to find this information.


```sql
-- SQL query for sales trend analysis

SELECT 
		YEAR(created_at) as years
        , MONTH(created_at) as months
        , COUNT(user_id) as number_of_sales
        , SUM(price_usd) as total_revenue
        , SUM(price_usd - cogs_usd) as total_margin
FROM orders
WHERE created_at < DATE('2013-01-05')
GROUP BY 1, 2
ORDER BY 1,2;
```

Insights: Seen sales, revenue, and margin increase every month


### New Product Analysis

The company has launched a new product since January 6, 2013.

On April 5, 2013, we were asked to analyze, the order volume, conversion rate, and the number of each product (old and new products) sold on a monthly basis. Analyze the data starting from April 1, 2012.

Notes: 
old product: value 1 in promary_product_id column
new product: value 2 in promary_product_id column


```sql
-- SQL query for new product analysis

SELECT 
		YEAR(WS.created_at) as years
        , MONTH(WS.created_at) as months
        , COUNT(WS.website_session_id) as sessions
        , (SUM(O.items_purchased) / COUNT(WS.website_session_id) * 100) as conv_rate
        , SUM(O.items_purchased) as orders
        , SUM(CASE WHEN O.primary_product_id = 1 THEN O.items_purchased ELSE 0 END) as product_one_orders
        , SUM(CASE WHEN O.primary_product_id = 2 THEN O.items_purchased ELSE 0 END) as product_two_orders
FROM orders O
RIGHT JOIN website_sessions WS
	ON O.website_session_id = WS.website_session_id
WHERE WS.created_at BETWEEN DATE('2012-04-01') AND DATE('2013-04-05')
GROUP BY 1, 2
;
```

Insights: New products are starting to increase sales


### Cross-Selling Analysis
Since September 25, 2013, the company has been using a cross-sell strategy to increase sales. Until the end of 2013, they also added 1 new product, so there were 3 products sold on the website.

On January 2, 2014, they were asked to analyze the performance of cross-sell since it was first implemented until the end of 2013.
The company wanted to know how many cross-sell products were sold per purchase of the main product.



```sql
-- SQL query for Cross selling analysis

CREATE OR REPLACE VIEW crossSell_View AS
SELECT order_id
		, order_item_id
        , is_primary_item
        , primary_product_Id
        , product_id
FROM order_items OI
JOIN orders
	USING(order_id)
WHERE is_primary_item != 1
	AND OI.created_at  BETWEEN DATE('2013-09-25') AND DATE('2013-12-31');

SELECT * FROM crossSell_View;

WITH primary_product_cte as (
		SELECT primary_product_id
				, COUNT(primary_product_id) as orders
		FROM orders
		WHERE created_at  BETWEEN DATE('2013-09-25') AND DATE('2013-12-31')
		GROUP BY 1
        )
        
SELECT primary_product_id
		, orders
		, SUM(CASE WHEN product_id = 1 THEN 1 ELSE 0 END) AS x_sell_prod1
		, SUM(CASE WHEN product_id = 2 THEN 1 ELSE 0 END) AS x_sell_prod2
		, SUM(CASE WHEN product_id = 3 THEN 1 ELSE 0 END) AS x_sell_prod3
FROM crosssell_view
JOIN primary_product_cte
	USING(primary_product_id)
GROUP BY 1;
```

Insights: Cross-sell happened most on the first product


## User Analysis
The website manager is interested in knowing whether users who have visited the website will visit again at a later time.

On June 1, 2014, the manager wanted to find out how many users had visited the website.


```sql
-- SQL query for Repeat sessions

WITH repeat_user_cte as (		
        SELECT user_id,
			   COUNT(user_id) OVER () AS total_users,
			   COUNT(user_id) OVER (PARTITION BY user_id) - 1 AS repeat_count
		FROM website_sessions
        WHERE created_at  BETWEEN DATE('2014-01-01') AND DATE('2014-06-01')
		ORDER BY user_id
        )
SELECT repeat_count
		, COUNT(user_id) AS users
FROM repeat_user_cte
GROUP BY 1;
```

Insights: There are many users who come back to the website after their first visit.

