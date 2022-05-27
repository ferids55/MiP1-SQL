--Create Database
CREATE DATABASE ecommerce;

--Create Tables to Database
CREATE TABLE IF NOT EXISTS geolocation_dataset(
	geolocation_zip_code_prefix CHAR(5),
	geolocation_lat DOUBLE PRECISION,
	geolocation_lng DOUBLE PRECISION,
	geolocation_city VARCHAR(50),
	geolocation_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS customers_dataset(
	customer_id UUID,
	customer_unique_id UUID,
	customer_zip_code_prefix CHAR(5),
	customer_city VARCHAR(50),
	customer_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS sellers_dataset(
	seller_id UUID,
	seller_zip_code_prefix CHAR(5),
	seller_city VARCHAR(50),
	seller_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS products_dataset(
	product_no SERIAL,
	product_id UUID,
	product_category_name VARCHAR(50),
	product_name_length REAL,
	product_description_length REAL,
	product_photos_qty REAL,
	product_weight_g REAL,
	product_length_cm REAL,
	product_height_cm REAL,
	product_width_cm REAL
);

CREATE TABLE IF NOT EXISTS orders_dataset(
	order_id UUID,
	customer_id UUID,
	order_status VARCHAR(20),
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items_dataset(
	order_id UUID,
	order_item_id INTEGER,
	product_id UUID,
	seller_id UUID,
	shipping_limit_date TIMESTAMP,
	price NUMERIC(7,2),
	freight_value NUMERIC(5,2)
);

CREATE TABLE IF NOT EXISTS order_payments_dataset(
	order_id UUID,
	payment_sequential INTEGER,
	payment_type VARCHAR(20),
	payment_installments INTEGER,
	payment_value NUMERIC(7,2)
);

CREATE TABLE IF NOT EXISTS order_reviews_dataset(
	review_id UUID,
	order_id UUID,
	review_score INTEGER,
	review_comment_title VARCHAR(255),
	review_comment_message TEXT,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP
);