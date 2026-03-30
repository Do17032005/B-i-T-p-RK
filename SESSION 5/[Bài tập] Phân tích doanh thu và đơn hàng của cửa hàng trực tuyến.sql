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
    total_amount NUMERIC(10, 2)
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id int,
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    product_name VARCHAR(100) NOT NULL,
    quantity int NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

INSERT INTO
    customers (customer_name, city)
VALUES ('Nguyen Van An', 'Ha Noi'),
    ('Tran Thi Binh', 'Hai Phong'),
    ('Le Quang Huy', 'Da Nang'),
    ('Pham Thu Lan', 'Can Tho'),
    (
        'Hoang Minh Khoa',
        'Nha Trang'
    );

INSERT INTO
    orders (
        order_date,
        customer_id,
        total_amount
    )
VALUES ('2026-03-01', 1, 12500.00),
    ('2026-03-03', 2, 8200.00),
    ('2026-03-05', 3, 15750.00),
    ('2026-03-08', 4, 6400.00),
    ('2026-03-10', 5, 10900.00);

INSERT INTO
    order_items (
        order_id,
        product_name,
        quantity,
        price
    )
VALUES (
        1,
        'Laptop Dell Inspiron',
        1,
        12500.00
    ),
    (
        2,
        'Tai nghe Sony WH-CH520',
        2,
        4100.00
    ),
    (3, 'iPad Gen 10', 1, 15750.00),
    (
        4,
        'Ban phim co Logitech',
        2,
        3200.00
    ),
    (
        5,
        'Man hinh LG 27 inch',
        1,
        10900.00
    );

--1.
SELECT
    c.customer_name AS "ten khach hang",
    o.order_date AS "ngay dat hang",
    o.total_amount AS "tong so tien"
FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date, o.order_id;

--2Aggregate Functions: Thống kê tổng hợp đơn hàng

SELECT
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    MAX(o.total_amount) AS max_order_value,
    MIN(o.total_amount) AS min_order_value,
    COUNT(o.order_id) AS total_orders
FROM orders o;

--3.GROUP BY / HAVING: Tổng doanh thu theo từng thành phố, chỉ lấy > 10000

SELECT c.city AS city, SUM(o.total_amount) AS total_revenue
FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
GROUP BY
    c.city
HAVING
    SUM(o.total_amount) > 10000
ORDER BY total_revenue DESC;

--4.JOIN 3 bảng: Danh sách sản phẩm đã bán kèm thông tin khách

SELECT c.customer_name, o.order_date, oi.product_name, oi.quantity, oi.price
FROM
    order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date, c.customer_name, oi.product_name;