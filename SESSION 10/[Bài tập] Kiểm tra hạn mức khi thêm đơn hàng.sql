
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    credit_limit NUMERIC(14, 2) NOT NULL CHECK (credit_limit >= 0)
);


CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_amount NUMERIC(14, 2) NOT NULL CHECK (order_amount > 0),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
);


CREATE OR REPLACE FUNCTION check_credit_limit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	v_credit_limit NUMERIC(14, 2);
	v_total_orders NUMERIC(14, 2);
BEGIN

	SELECT c.credit_limit
	INTO v_credit_limit
	FROM customers c
	WHERE c.id = NEW.customer_id;

	IF v_credit_limit IS NULL THEN
		RAISE EXCEPTION 'Khong tim thay customer_id = %', NEW.customer_id;
	END IF;


	SELECT COALESCE(SUM(o.order_amount), 0)
	INTO v_total_orders
	FROM orders o
	WHERE o.customer_id = NEW.customer_id;

	IF v_total_orders + NEW.order_amount > v_credit_limit THEN
		RAISE EXCEPTION
			'Vuot han muc tin dung. customer_id=%, tong_hien_tai=%, don_moi=%, han_muc=%',
			NEW.customer_id,
			v_total_orders,
			NEW.order_amount,
			v_credit_limit;
	END IF;

	RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_check_credit ON orders;

CREATE TRIGGER trg_check_credit
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION check_credit_limit();



-- Du lieu khach hang mau
INSERT INTO
    customers (name, credit_limit)
VALUES ('Nguyen Van A', 1000000),
    ('Tran Thi B', 2000000);


SELECT id, name, credit_limit FROM customers ORDER BY id;

-- Truong hop hop le: tong 300000 + 400000 = 700000 <= 1000000
INSERT INTO orders (customer_id, order_amount) VALUES (1, 300000);

INSERT INTO orders (customer_id, order_amount) VALUES (1, 400000);

-- Truong hop vuot han muc: 700000 + 400000 = 1100000 > 1000000
n
INSERT INTO orders (customer_id, order_amount) VALUES (1, 400000);

-- Truong hop hop le cho khach hang 2
INSERT INTO orders (customer_id, order_amount) VALUES (2, 1500000);

-- Truong hop vuot han muc cho khach hang 2
-- 1500000 + 600000 = 2100000 > 2000000 -> bi chan
INSERT INTO orders (customer_id, order_amount) VALUES (2, 600000);


SELECT id, customer_id, order_amount FROM orders ORDER BY id;


SELECT
    c.id AS customer_id,
    c.name,
    c.credit_limit,
    COALESCE(SUM(o.order_amount), 0) AS total_orders
FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY
    c.id,
    c.name,
    c.credit_limit
ORDER BY c.id;