

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
    last_modified TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


CREATE OR REPLACE FUNCTION update_last_modified()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	NEW.last_modified := NOW();
	RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_update_last_modified ON products;

CREATE TRIGGER trg_update_last_modified
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_last_modified();



INSERT INTO
    products (name, price)
VALUES ('Ban phim co', 550000),
    ('Chuot khong day', 320000),
    ('Man hinh 24 inch', 3200000);


SELECT id, name, price, last_modified FROM products ORDER BY id;


UPDATE products SET price = 600000 WHERE name = 'Ban phim co';

UPDATE products
SET
    price = price + 100000
WHERE
    name IN (
        'Chuot khong day',
        'Man hinh 24 inch'
    );


SELECT id, name, price, last_modified FROM products ORDER BY id;