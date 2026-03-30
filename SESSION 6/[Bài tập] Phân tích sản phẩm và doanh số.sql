CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE OrdersDetails (
    orderdetail_id SERIAL PRIMARY KEY,
    product_id int,
    quantity int NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

INSERT INTO
    products (product_name, category, price)
VALUES (
        'Laptop Dell Inspiron',
        'Electronics',
        12500.00
    ),
    (
        'Smartphone Samsung Galaxy',
        'Electronics',
        8200.00
    ),
    (
        'Tablet Apple iPad',
        'Electronics',
        15750.00
    ),
    (
        'Headphones Sony WH-1000XM4',
        'Electronics',
        6400.00
    ),
    (
        'Smartwatch Fitbit Versa 3',
        'Electronics',
        10900.00
    );

INSERT INTO
    OrdersDetails (product_id, quantity)
VALUES (1, 1),
    (2, 2),
    (3, 1),
    (4, 3),
    (5, 2);

-- 1) Tong doanh thu tung san pham
SELECT p.product_name, SUM(p.price * od.quantity) AS total_sales
FROM products p
    INNER JOIN OrdersDetails od ON od.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_sales DESC;

-- 2) Doanh thu trung binh theo tung loai san pham
SELECT p.category, AVG(p.price * od.quantity) AS avg_category_revenue
FROM products p
    INNER JOIN OrdersDetails od ON od.product_id = p.product_id
GROUP BY
    p.category
ORDER BY p.category;

-- 3) Chi hien thi loai co doanh thu trung binh > 20 trieu
SELECT p.category, AVG(p.price * od.quantity) AS avg_category_revenue
FROM products p
    INNER JOIN OrdersDetails od ON od.product_id = p.product_id
GROUP BY
    p.category
HAVING
    AVG(p.price * od.quantity) > 20000000
ORDER BY avg_category_revenue DESC;

-- 4) San pham co doanh thu cao hon doanh thu trung binh toan bo san pham
SELECT s.product_name, s.total_sales
FROM (
        SELECT p.product_id, p.product_name, COALESCE(SUM(p.price * od.quantity), 0) AS total_sales
        FROM products p
            LEFT JOIN OrdersDetails od ON od.product_id = p.product_id
        GROUP BY
            p.product_id, p.product_name
    ) s
WHERE
    s.total_sales > (
        SELECT AVG(x.total_sales)
        FROM (
                SELECT p2.product_id, COALESCE(
                        SUM(p2.price * od2.quantity), 0
                    ) AS total_sales
                FROM
                    products p2
                    LEFT JOIN OrdersDetails od2 ON od2.product_id = p2.product_id
                GROUP BY
                    p2.product_id
            ) x
    )
ORDER BY s.total_sales DESC;

-- 5) Liet ke toan bo san pham va tong so luong ban duoc (ke ca chua co don hang)
SELECT p.product_id, p.product_name, COALESCE(SUM(od.quantity), 0) AS total_quantity_sold
FROM products p
    LEFT JOIN OrdersDetails od ON od.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY p.product_id;