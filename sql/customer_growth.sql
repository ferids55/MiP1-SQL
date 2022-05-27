--Create CTE for new geolocation
WITH geolocation AS (
	SELECT DISTINCT loc.*, geolocation_city, geolocation_state
    FROM (
		SELECT
			geolocation_zip_code_prefix,
         	MAX(geolocation_lat) AS latitude,
			MAX(geolocation_lng) AS longitude
        FROM geolocation_dataset
		GROUP BY 1
		ORDER BY 1) loc
	JOIN geolocation_dataset AS geo
	ON loc.geolocation_zip_code_prefix = geo.geolocation_zip_code_prefix
	ORDER BY 1
)
		
SELECT * FROM geolocation;

--TASK 2
--Create Monthly Active User Data
WITH
	monthly_active_user_data AS (
		SELECT
			tahun,
			ROUND(AVG(active_user), 3) AS rata_rata_mau
		FROM(
			SELECT
				DATE_PART('year', orders.order_purchase_timestamp) AS tahun,
				DATE_PART('month', orders.order_purchase_timestamp) AS bulan,
				COUNT(DISTINCT customers.customer_unique_id) AS active_user
			FROM
				orders_dataset AS orders 
			JOIN customers_dataset AS customers
				ON orders.customer_id = customers.customer_id
			GROUP BY 1,2 
		) monthly_active_user
		GROUP BY 1
		ORDER BY 1
	),
	--Create New Customer Data
	new_customer_data AS (
		SELECT
			DATE_PART('year', first_transaction) AS tahun,
			COUNT(DISTINCT customer) AS new_customer
		FROM (
			SELECT
				customers.customer_unique_id AS customer,
				MIN(orders.order_purchase_timestamp) AS first_transaction
			FROM
				orders_dataset AS orders 
			JOIN customers_dataset AS customers
				ON orders.customer_id = customers.customer_id
			GROUP BY 1
		) transactions
		GROUP BY 1
		ORDER BY 1
	),
	--Create Repeat Order Data
	repeat_order_data AS (
		SELECT
			tahun,
			COUNT(DISTINCT customer) AS repeat_customer
		FROM (
			SELECT
				DATE_PART('year', orders.order_purchase_timestamp) AS tahun,
				customers.customer_unique_id AS customer,
				COUNT(order_id) as total_transaction
			FROM
				orders_dataset AS orders 
			JOIN customers_dataset AS customers
				ON orders.customer_id = customers.customer_id
			GROUP BY 1,2
			HAVING COUNT(order_id) > 1
		) repeat_order
		GROUP BY 1
		ORDER BY 1
	),
	--Create Average of Transactions Data
	avg_transaction_data AS (
		SELECT
			tahun,
			ROUND(AVG(total_transaction), 3) AS rata_rata_transaksi
		FROM (
			SELECT
				DATE_PART('year', orders.order_purchase_timestamp) AS tahun,
				customers.customer_unique_id AS customer,
				COUNT(order_id) as total_transaction
			FROM
				orders_dataset AS orders 
			JOIN customers_dataset AS customers
				ON orders.customer_id = customers.customer_id
			GROUP BY 1,2
		) transactions
		GROUP BY 1
		ORDER BY 1
	)

--Join All CTE tables
SELECT
	mau.tahun as tahun,
	rata_rata_mau,
	new_customer,
	repeat_customer,
	rata_rata_transaksi
FROM monthly_active_user_data AS mau
JOIN new_customer_data AS nc
ON mau.tahun = nc.tahun
JOIN repeat_order_data AS ro
ON mau.tahun = ro.tahun
JOIN avg_transaction_data AS trx
ON mau.tahun = trx.tahun;