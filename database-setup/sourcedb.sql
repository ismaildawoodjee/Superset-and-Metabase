CREATE SCHEMA IF NOT EXISTS ecommerce;

DROP TABLE IF EXISTS ecommerce.customers;
DROP TABLE IF EXISTS ecommerce.orders;
DROP TABLE IF EXISTS ecommerce.order_reviews;
DROP TABLE IF EXISTS ecommerce.geolocation;
DROP TABLE IF EXISTS ecommerce.order_items;
DROP TABLE IF EXISTS ecommerce.order_payments;
DROP TABLE IF EXISTS ecommerce.products;
DROP TABLE IF EXISTS ecommerce.sellers;
DROP TABLE IF EXISTS ecommerce.product_category_name_translation;

CREATE TABLE ecommerce.customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix CHAR(5),
    customer_city TEXT,
    customer_state CHAR(2)
);
CREATE TABLE ecommerce.orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);
CREATE TABLE ecommerce.order_reviews(
    review_id TEXT,
    order_id TEXT,
    review_score SMALLINT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);
CREATE TABLE ecommerce.geolocation (
    geolocation_zip_code_prefix CHAR(5),
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city TEXT,
    geolocation_state CHAR(2)
);
CREATE TABLE order_items (
  order_id TEXT,
  order_item_id INT,
  product_id TEXT,
  seller_id TEXT,
  shipping_limit_date TIMESTAMP,
  price NUMERIC,
  freight_value NUMERIC
);
CREATE TABLE order_payments (
  order_id TEXT,
  payment_sequential INT,
  payment_type TEXT,
  payment_installments INT,
  payment_value NUMERIC
);
CREATE TABLE products (
  product_id TEXT,
  product_category_name TEXT,
  product_name_length INT,
  product_description_length INT,
  product_photos_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT
);
CREATE TABLE sellers (
  seller_id TEXT,
  seller_zip_code_prefix CHAR(5),
  seller_city TEXT,
  seller_state CHAR(2)
);
CREATE TABLE product_category_name_translation (
  product_category_name TEXT,
  product_category_name_english TEXT
);

COPY ecommerce.customers
FROM
  '/source-data/olist_customers_dataset.csv' CSV DELIMITER ',' HEADER;
COPY ecommerce.orders
FROM
  '/source-data/olist_orders_dataset.csv' CSV DELIMITER ',' HEADER;
COPY ecommerce.order_reviews
FROM
  '/source-data/olist_order_reviews_dataset.csv' CSV DELIMITER ',' HEADER;
COPY ecommerce.geolocation
FROM
  '/source-data/olist_geolocation_dataset.csv' CSV DELIMITER ',' HEADER;
COPY ecommerce.order_items
FROM
  '/source-data/olist_order_items_dataset.csv' CSV DELIMITER ',' HEADER;
COPY ecommerce.order_payments
FROM
  '/source-data/olist_order_payments_dataset.csv' CSV DELIMITER ',' HEADER;
COPY products
FROM
  '/source-data/olist_products_dataset.csv' CSV DELIMITER ',' HEADER;
COPY sellers
FROM
  '/source-data/olist_sellers_dataset.csv' CSV DELIMITER ',' HEADER;
COPY product_category_name_translation
FROM
  '/source-data/product_category_name_translation.csv' CSV DELIMITER ',' HEADER;