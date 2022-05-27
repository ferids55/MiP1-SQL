--Add Primary Key Using Alter Statement
ALTER TABLE customers_dataset ADD CONSTRAINT PK_customer_id PRIMARY KEY (customer_id);
ALTER TABLE products_dataset ADD CONSTRAINT PK_product_id PRIMARY KEY (product_id);
ALTER TABLE sellers_dataset ADD CONSTRAINT PK_seller_id PRIMARY KEY (seller_id);
ALTER TABLE orders_dataset ADD CONSTRAINT PK_order_id PRIMARY KEY (order_id);

--Add not null constraint
ALTER TABLE geolocation_dataset ALTER COLUMN geolocation_zip_code_prefix SET NOT NULL;
ALTER TABLE order_items_dataset ALTER COLUMN order_item_id SET NOT NULL;
ALTER TABLE order_reviews_dataset ALTER COLUMN review_id SET NOT NULL;

-- Add Foreign Key Using Alter Statement
ALTER TABLE orders_dataset ADD CONSTRAINT FK_customer_id
FOREIGN KEY (customer_id) REFERENCES customers_dataset(customer_id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE order_items_dataset
ADD CONSTRAINT FK_seller_id FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_product_id FOREIGN KEY (product_id) REFERENCES products_dataset(product_id)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_order_id FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE order_reviews_dataset ADD CONSTRAINT FK_order_id
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE order_payments_dataset ADD CONSTRAINT FK_order_id
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id)
ON DELETE CASCADE ON UPDATE CASCADE;