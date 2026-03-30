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
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS "tong doanh thu",
    COUNT(o.order_id) AS "tong don"
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > 2000
ORDER BY "tong doanh thu" DESC;

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(oi.quantity) AS "tong san pham mua",
    SUM(oi.quantity * oi.price) AS "tong chi tieu"
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY "tong chi tieu" DESC;

