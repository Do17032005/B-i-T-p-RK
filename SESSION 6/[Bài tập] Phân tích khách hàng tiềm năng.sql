-- Active: 1773844200417@@127.0.0.1@5432@btss6@ss6b7
CREATE SCHEMA ss6b7;
CREATE TABLE ss6b7.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);

CREATE TABLE ss6b7.orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id int,
    FOREIGN KEY (customer_id) REFERENCES ss6b7.customers (customer_id),
    total_amount NUMERIC(10, 2) NOT NULL
);

INSERT INTO
    ss6b7.customers (customer_name)
VALUES ('Customer A'),
    ('Customer B'),
    ('Customer C');

INSERT INTO
    ss6b7.orders (
        order_date,
        customer_id,
        total_amount
    )
VALUES ('2023-01-01', 1, 1000.00),
    ('2023-01-02', 2, 1500.00),
    ('2023-01-03', 3, 2000.00);

-- 1) Hien thi ten khach hang va tong tien da mua, sap xep giam dan
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM ss6b7.customers c
    INNER JOIN ss6b7.orders o ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_spent DESC;

-- 2) Tim khach hang co tong chi tieu cao nhat (Subquery + MAX)
SELECT t.customer_name, t.total_spent
FROM (
        SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
        FROM ss6b7.customers c
            INNER JOIN ss6b7.orders o ON o.customer_id = c.customer_id
        GROUP BY
            c.customer_id, c.customer_name
    ) t
WHERE
    t.total_spent = (
        SELECT MAX(x.total_spent)
        FROM (
                SELECT SUM(o2.total_amount) AS total_spent
                FROM ss6b7.orders o2
                GROUP BY
                    o2.customer_id
            ) x
    );

-- 3) Liet ke khach hang chua tung mua hang (LEFT JOIN + IS NULL)
SELECT c.customer_id, c.customer_name
FROM ss6b7.customers c
    LEFT JOIN ss6b7.orders o ON o.customer_id = c.customer_id
WHERE
    o.order_id IS NULL;

-- 4) Khach hang co tong chi tieu > trung binh toan bo khach hang
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
FROM ss6b7.customers c
    INNER JOIN ss6b7.orders o ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING
    SUM(o.total_amount) > (
        SELECT AVG(y.customer_total)
        FROM (
                SELECT SUM(o3.total_amount) AS customer_total
                FROM ss6b7.customers c3
                    INNER JOIN ss6b7.orders o3 ON o3.customer_id = c3.customer_id
                GROUP BY
                    c3.customer_id
            ) y
    )
ORDER BY total_spent DESC;