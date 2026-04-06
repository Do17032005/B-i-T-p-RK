-- Active: 1773844200417@@127.0.0.1@5432@btss9@public
CREATE DATABASE btss9;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount NUMERIC(12, 2) NOT NULL
);


INSERT INTO
    orders (
        customer_id,
        order_date,
        total_amount
    )
SELECT (1000 + (g % 200)), CURRENT_DATE - (g % 365), (random() * 1000 + 100)::NUMERIC(12, 2)
FROM generate_series(1, 50000) AS g;

ANALYZE orders;

EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 1001;


CREATE INDEX idx_orders_customer_id ON orders USING BTREE (customer_id);

ANALYZE orders;

EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 1001;

