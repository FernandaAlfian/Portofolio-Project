USE mavenfuzzyfactory;

SELECT *
FROM order_item_refunds;

SELECT *
FROM order_items;

SELECT *
FROM orders;

SELECT *
FROM products;

SELECT *
FROM website_pageviews;

SELECT *
FROM website_sessions;

/* 
Case Description:
Perusahaan launching platform website jual-beli barang pada 19 April 2012.
Untuk membangun awareness pasar, mereka memasang iklan pada beberapa latform di social media. 
Selama beberapa waktu kedepan mereka akan melakukan analisis untuk melihat traffic dan performa perusahaan website yang dimiliki.

*/


/* 
Product Analysis

Di awal tahun 2013 perusahaan berencana untuk menambah produk baru. Namun sebelum itu, mereka ingin melihat trend bulanan dari penjualan, revenue, dan margin/profit.
Karena itu, pada tanggal 5 Januari 2013, mereka meminta untuk mencari informasi tersebut.

Objective: To find the strategy if selles run unexpected or make new strategies for increasing the sales
1. Trend Analysis
- Sales trand in daily/weekly/monthly
- What products that has good sales?

Cross Selling Analysis
Compare November and December sales


User Analysis
Analysis repeat sessions



 */
 
 
SELECT *
-- , count(order_item_id)
FROM order_items;

SELECT *
-- 		, count(order_id)
FROM orders;



-- Sales trand in daily/weekly/monthly

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

/*
Terlihat sales, revenue, dan margin meningkat setiap bulannya
*/


/*
Perusahaan telah melaunching produk baru sejak 6 Januari 2013.

Pada tanggal 5 April 2013, diminta untuk menganalisis, volume order, conversion rate, dan jumlah masing-masing produk (produk lama dan baru)
yang terjual secara bulanan. Lakukan analisis data mulai tanggal 1 April 2012.

Note: 
produk lama: bernilai 1 pada kolom promary_product_id
produk baru: bernilai 2 pada kolom promary_product_id
*/

-- new product analysis
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
/*
Terlihat adanya produk baru yang mulai menambah penjualan
*/




/*
Sejak tanggal 25 September 2013 perusahaan melakukan strategi cross-sell untuk meningkatkan penjualan.
Hingga akhir tahun 2013 mereka juga menambah 1 produk baru, sehingga terdapat 3 produk yang dijual di website.

Pada tanggal 2 Januari 2014, diminta untuk menganalisa performa cross-sell sejak pertama kali diadakan hingga akhir tahun 2013.
Perusahaan ingin mengetahui berapa banyak produk cross-sell yang terjual tiap pembelian produk utama.
*/
-- Cross selling analysis
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

/*
Cross-sell terjadi paling banyak pada produk pertama
*/



/*
Terjadi penurunan volume session sejak budget marketing dikurangi

Hasil ini menjadi acuan bagi perusahaan untuk membuat strategi baru dalam memaksimalkan volume traffic namun tidak ingin
mengeluarkan banyak biaya iklan
*/


/*
Website manager tertarik untuk mengetahui apakah user yang telah berkunjung ke website akan berkunjung kembali di waktu yang lain

Pada tanggal 1 Juni 2014 manager ingin untuk mencari tahu ada berapa banyak user yang repat/berkunjung ke website
*/

/* 

User Analysis
Analysis repeat sessions

*/

-- repet sessions
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

/*
Terlihat cukup banyak user yang datang kembali ke website setelah kunjungan pertama mereka
*/





/*
Hasil analisis sebelumnya menarik perhatian marketing manager, dia tertarik melihat lebih dalam tentang repeat customer.
Dua menghubungi anda pada tanggal 8 Juni 2014.

Marketing manager ingin utuk mengetahui channel/source mana yang digunakan oleh user saat berkunjung kembali. Dia ingin melihat apakah mereka datang lewat direct type-in
atau lewat paid campaign yang diadakan oleh perusahaan.

Anda diminta untuk membandingkan jumlah new and repeat session berdasarkan channel/source



utm_source   | utm_campaign  | http_referer											| channel_group
NULL  		 |   			 | 'https://www.gsearch.com', 'https://www.bsearch.com' | organic serach
			 | nonbrand  	 |  													| paid_nonbrand
			 | brand  		 |  													| paid_brand
NULL   		 |   			 | NULL 												| direct_type_in
socialbook   |   			 |  													| paid_social
*/
-- repeat channel behaviour analysis
SELECT 
	CASE
		WHEN utm_source IS NULL AND http_referer IN('https://www.gsearch.com', 'https://www.bsearch.com') THEN 'organic_search'
        WHEN utm_source IS NOT NULL AND utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_source IS NOT NULL AND utm_campaign = 'brand' THEN 'paid_brand'
        WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
        WHEN utm_source	= 'socialbook' THEN 'paid_social'
		ELSE ""
    END as channel_group
    , COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) as new_sessinos
    , COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) as repeat_sessions
    
FROM website_sessions
WHERE created_at  BETWEEN DATE('2014-01-01') AND DATE('2014-06-08')
GROUP BY 1
ORDER BY 3 DESC;


/*
Dapat dilihat ketika user melakukan kunjungan kembali, mereka datang dari organic search, direct type-in dan paid brand
*/


























