

CREATE TABLE Products (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE  INDEX CX_Products_CategoryId
ON Products (category_id);


CREATE INDEX IX_Products_Price
ON Products (price);

INSERT INTO
    Products (
        product_id,
        category_id,
        price,
        stock_quantity
    )
VALUES (1, 10, 199.99, 50),
    (2, 10, 129.99, 40),
    (3, 10, 249.99, 25),
    (4, 20, 89.99, 80),
    (5, 20, 159.99, 60),
    (6, 30, 299.99, 15),
    (7, 30, 179.99, 30),
    (8, 10, 99.99, 90);




