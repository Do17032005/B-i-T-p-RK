create table customers(
    customer_id serial primary key ,
    full_name varchar(50),
    region VARCHAR(50)
);

create table products(
    product_id serial primary key ,
    product_name varchar(50),
    category VARCHAR(50),
    price numeric(5,2)
);

create table orders(
    order_id serial primary key ,
    customer_id int references customers(customer_id),
    product_id int references products(product_id),
    order_date date,
    status varchar(50),
    total_amount DECIMAL(10,2)
);

CREATE TABLE order_datail(
    order_detail_id serial primary key ,
    order_id int references orders(order_id),
    product_id int references products(product_id),
    quantity int,
    price DECIMAL(10,2)
);

INSERT INTO customers (full_name, region) VALUES
('John Doe', 'North'),
('Jane Smith', 'South'),
('Alice Johnson', 'East'),
('Bob Brown', 'West');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 999.99),
('Smartphone', 'Electronics', 499.99),
('Headphones', 'Accessories', 199.99),
('Camera', 'Electronics', 299.99);

INSERT INTO orders (customer_id, product_id, order_date, status, total_amount) VALUES
(1, 1, '2024-01-15', 'Completed', 999.99),
(2, 2, '2024-02-20', 'Completed', 499.99),
(3, 3, '2024-03-10', 'Pending', 199.99),
(4, 4, '2024-04-05', 'Completed', 299.99);

INSERT INTO order_datail (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 999.99),
(2, 2, 1, 499.99),
(3, 3, 1, 199.99),
(4, 4, 1, 299.99);

CREATE VIEW v_doanh_thu_theo_vung AS
SELECT
    c.region,
    COUNT(o.order_id) AS so_luong_don,
    SUM(o.total_amount) AS doanh_thu
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

SELECT region, so_luong_don, doanh_thu
FROM v_doanh_thu_theo_vung
ORDER BY doanh_thu DESC
LIMIT 3;

-- Từ v_revenue_by_region, tạo View mới v_revenue_above_avg chỉ hiển thị khu vực có doanh thu > trung bình toàn quốc
CREATE VIEW v_revenue_above_avg AS
SELECT region, so_luong_don, doanh_thu
from v_doanh_thu_theo_vung
WHERE doanh_thu > (SELECT AVG(doanh_thu) FROM v_doanh_thu_theo_vung);

