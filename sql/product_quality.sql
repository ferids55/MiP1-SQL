CREATE TABLE revenue_by_year AS
	SELECT
		year_transaction,
		SUM(price + freight_value) AS total_revenue
	FROM order_items_dataset AS details
	JOIN (
		SELECT
			order_id,
			DATE_PART('year', order_purchase_timestamp) AS year_transaction
		FROM orders_dataset
		WHERE order_status = 'delivered'
	) AS orders
	ON details.order_id = orders.order_id
	GROUP BY 1
	ORDER BY 1;

CREATE TABLE canceled_order_by_year AS
	SELECT
		DATE_PART('year', order_purchase_timestamp) AS year_transaction,
		COUNT(order_id) AS total_canceled_order
	FROM orders_dataset
	WHERE order_status = 'canceled'
	GROUP BY 1
	ORDER BY 1;

CREATE TABLE top_category_revenue_by_year AS
	SELECT
		year_transaction,
		product_category_name,
		revenue
	FROM (
		SELECT
			year_transaction,
			product_category_name,
			SUM(price+freight_value) AS revenue,
			RANK() OVER(
				PARTITION BY year_transaction
				ORDER BY SUM(price+freight_value) DESC
			) AS revenue_rank
		FROM order_items_dataset AS details
		JOIN (
			SELECT
				order_id,
				DATE_PART('year', order_purchase_timestamp) AS year_transaction
			FROM orders_dataset
			WHERE order_status = 'delivered'	
		) AS orders
		ON details.order_id = orders.order_id
		JOIN products_dataset AS products
		ON details.product_id = products.product_id
		GROUP BY 1,2
	) AS category_revenue
	WHERE revenue_rank = 1;


CREATE TABLE top_category_canceled_order_by_year AS
	SELECT
		year_transaction,
		product_category_name,
		canceled_order
	FROM (
		SELECT
			year_transaction,
			product_category_name,
			COUNT(details.order_id) AS canceled_order,
			RANK() OVER(
				PARTITION BY year_transaction 
				ORDER BY COUNT(details.order_id) DESC
			) AS cancel_rank
		FROM order_items_dataset AS details
		JOIN (
			SELECT
				order_id,
				DATE_PART('year', order_purchase_timestamp) AS year_transaction
			FROM orders_dataset
			WHERE order_status = 'canceled'	
		) AS orders
		ON details.order_id = orders.order_id
		JOIN products_dataset AS products
		ON details.product_id = products.product_id
		GROUP BY 1,2
	) AS canceled_transactions
	WHERE cancel_rank = 1;
	
--Join All new tables
SELECT
	rv.year_transaction AS year_transaction,
	rv.total_revenue AS total_revenue,
	crv.product_category_name AS highest_revenue_category,
	crv.revenue AS highest_revenue,
	co.total_canceled_order AS total_canceled_order,
	cco.product_category_name AS highest_canceled_order_category,
	cco.canceled_order AS highest_canceled_order
FROM revenue_by_year AS rv
JOIN canceled_order_by_year AS co ON rv.year_transaction = co.year_transaction
JOIN top_category_revenue_by_year AS crv ON co.year_transaction = crv.year_transaction
JOIN top_category_canceled_order_by_year AS cco ON crv.year_transaction = cco.year_transaction;
