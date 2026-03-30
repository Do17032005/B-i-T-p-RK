-- Active: 1773844200417@@127.0.0.1@5432@btss6
CREATE TABLE orderinfo(
    orderif_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id int,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    total_amount NUMERIC(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL
);

-- 1) Them 5 don hang mau voi tong tien khac nhau
INSERT INTO orderinfo (order_date, customer_id, total_amount, status) VALUES
('2024-10-02', 1, 450000.00, 'Pending'),
('2024-10-05', 2, 750000.00, 'Completed'),
('2024-10-14', 3, 1200000.00, 'Processing'),
('2024-11-01', 1, 990000.00, 'Cancelled'),
('2024-09-28', 2, 300000.00, 'Completed');

-- 2) Truy van don hang co tong tien lon hon 500,000
SELECT *
FROM orderinfo
WHERE total_amount > 500000;

-- 3) Truy van don hang co ngay dat trong thang 10 nam 2024
SELECT *
FROM orderinfo
WHERE order_date >= '2024-10-01'
    AND order_date < '2024-11-01';

-- 4) Liet ke don hang co trang thai khac "Completed"
SELECT *
FROM orderinfo
WHERE status <> 'Completed';

-- 5) Lay 2 don hang moi nhat
SELECT *
FROM orderinfo
ORDER BY order_date DESC
LIMIT 2;

