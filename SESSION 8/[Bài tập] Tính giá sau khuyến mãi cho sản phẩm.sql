CREATE TABLE products
(
    id               serial PRIMARY KEY,
    name             VARCHAR(255)   NOT NULL,
    price            DECIMAL(10, 2) NOT NULL,
    discount_percent int
);

CREATE OR REPLACE PROCEDURE calculate_discount(
    p_id INT,
    OUT p_final_price NUMERIC
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_price            DECIMAL(10, 2);
    v_discount_percent INT;
    v_limited_discount INT;
BEGIN

    SELECT price, discount_percent
    INTO v_price, v_discount_percent
    FROM products
    WHERE id = p_id;


    IF NOT FOUND THEN
        RAISE EXCEPTION 'Không tìm thấy sản phẩm với ID: %', p_id;
    END IF;


    IF v_discount_percent > 50 THEN
        v_limited_discount := 50;
    ELSE
        v_limited_discount := v_discount_percent;
    END IF;


    p_final_price := v_price - (v_price * v_limited_discount / 100);

    UPDATE products
    SET price = p_final_price
    WHERE id = p_id;

END;
$$;

-- ===== DỮ LIỆU TEST =====
INSERT INTO products (name, price, discount_percent)
VALUES ('Laptop Dell', 1500.00, 35),
       ('Monitor Samsung', 400.00, 45),
       ('Chuột Logitech', 60.00, 60),
       ('Bàn phím Razer', 150.00, 25),
       ('Tai nghe Sony', 250.00, 80);

SELECT id, name, price, discount_percent
FROM products;


DO
$$
    DECLARE
        v_result NUMERIC;
    BEGIN

        -- Monitor Samsung - discount 45%
        CALL calculate_discount(2, v_result);
        RAISE NOTICE 'Giá mới: %', v_result;


-- Chuột Logitech - discount 60% → GIỚI HẠN 50%';
        CALL calculate_discount(3, v_result);
        RAISE NOTICE 'Giá mới: %', v_result;



    END
$$;

SELECT id, name, price, discount_percent
FROM products;