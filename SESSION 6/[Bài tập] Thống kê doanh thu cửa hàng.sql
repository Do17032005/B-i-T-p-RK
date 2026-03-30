CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    city VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id int,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    total_amount NUMERIC(10, 2) NOT NULL
);

-- 1) Tong doanh thu, so don hang, gia tri trung binh moi don
SELECT
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS total_orders,
    AVG(total_amount) AS average_order_value
FROM orders;

-- 2) Nhom theo nam dat hang va hien thi doanh thu tung nam
SELECT EXTRACT(
        YEAR
        FROM order_date
    ) AS order_year, SUM(total_amount) AS yearly_revenue
FROM orders
GROUP BY
    EXTRACT(
        YEAR
        FROM order_date
    )
ORDER BY order_year;

-- 3) Chi hien thi cac nam co doanh thu tren 50 trieu
SELECT EXTRACT(
        YEAR
        FROM order_date
    ) AS order_year, SUM(total_amount) AS yearly_revenue
FROM orders
GROUP BY
    EXTRACT(
        YEAR
        FROM order_date
    )
HAVING
    SUM(total_amount) > 50000000
ORDER BY order_year;

-- 4) Hien thi 5 don hang co gia tri cao nhat
SELECT
    order_id,
    order_date,
    customer_id,
    total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 5;