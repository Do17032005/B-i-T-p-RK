



CREATE TABLE Sales (
    sale_id INT IDENTITY (1, 1) PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    sale_date DATE NOT NULL,
    amount DECIMAL(12, 2) NOT NULL
);

INSERT INTO
    Sales (
        customer_id,
        product_id,
        sale_date,
        amount
    )
VALUES (1, 101, '2026-04-01', 450.00),
    (1, 102, '2026-04-02', 700.00),
    (2, 103, '2026-04-01', 300.00),
    (2, 104, '2026-04-03', 250.00),
    (3, 105, '2026-04-02', 1200.00),
    (4, 106, '2026-04-03', 150.00),
    (4, 107, '2026-04-04', 200.00),
    (4, 108, '2026-04-05', 100.00);
GO

CREATE VIEW dbo.CustomerSales AS
SELECT customer_id, SUM(amount) AS total_amount
FROM Sales
GROUP BY
    customer_id;


SELECT * FROM dbo.CustomerSales WHERE total_amount > 1000;

UPDATE dbo.Sales SET amount = amount + 100 WHERE customer_id = 1;

SELECT * FROM dbo.CustomerSales;