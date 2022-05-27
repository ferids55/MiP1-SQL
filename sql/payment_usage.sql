WITH all_time_usage AS (
	SELECT
		payment_type,
		COUNT(1) AS total_usage
	FROM orders_dataset AS orders
	JOIN order_payments_dataset AS payments
	ON orders.order_id = payments.order_id
	GROUP BY 1
	ORDER BY 2 DESC
)

SELECT
	year_usage.*,
	total_usage
FROM all_time_usage
JOIN (
	SELECT
		payment_type,
		SUM(CASE year_transaction WHEN 2016 THEN 1 ELSE 0 END) AS usage_2016,
		SUM(CASE year_transaction WHEN 2017 THEN 1 ELSE 0 END) AS usage_2017,
		SUM(CASE year_transaction WHEN 2018 THEN 1 ELSE 0 END) AS usage_2018
	FROM (
		SELECT
			DATE_PART('year', order_purchase_timestamp) AS year_transaction,
			payment_type
		FROM orders_dataset AS orders
		JOIN order_payments_dataset AS payments
		ON orders.order_id = payments.order_id
	) AS payment_by_year
	GROUP BY 1
) AS year_usage
ON all_time_usage.payment_type = year_usage.payment_type
ORDER BY total_usage DESC

SELECT
	DATE_PART('year', order_purchase_timestamp) AS year_transaction,
	SUM(CASE payment_type WHEN 'credit_card' THEN 1 ELSE 0 END) AS credit_usage,
	SUM(CASE payment_type WHEN 'boleto' THEN 1 ELSE 0 END) AS boleto_usage,
	SUM(CASE payment_type WHEN 'voucher' THEN 1 ELSE 0 END) AS voucher_usage,
	SUM(CASE payment_type WHEN 'debit_card' THEN 1 ELSE 0 END) AS debit_usage,
	SUM(CASE payment_type WHEN 'not_defined' THEN 1 ELSE 0 END) AS undefined_usage
FROM orders_dataset AS orders
JOIN order_payments_dataset AS payments
ON orders.order_id = payments.order_id
GROUP BY 1
ORDER BY 1