DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    sale_date DATE NOT NULL
);

INSERT INTO
    sales (
        customer_id,
        amount,
        sale_date
    )
VALUES (1, 250.00, '2026-04-01'),
    (2, 400.00, '2026-04-03'),
    (1, 150.00, '2026-04-05'),
    (3, 900.00, '2026-04-10'),
    (2, 300.00, '2026-04-15'),
    (4, 500.00, '2026-05-01');

CREATE OR REPLACE PROCEDURE calculate_total_sales(
	IN start_date DATE,
	IN end_date DATE,
	OUT total NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT COALESCE(SUM(amount), 0)
	INTO total
	FROM sales
	WHERE sale_date BETWEEN start_date AND end_date;
END;
$$;

CALL calculate_total_sales ('2026-04-01', '2026-04-30');

CALL calculate_total_sales ('2026-05-01', '2026-05-31');