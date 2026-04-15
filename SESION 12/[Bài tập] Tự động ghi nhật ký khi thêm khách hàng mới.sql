DROP TABLE IF EXISTS customer_log;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers
(
    c_id  SERIAL PRIMARY KEY,
    name  VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE customer_log
(
    log_id      SERIAL PRIMARY KEY,
    c_id        INT REFERENCES customers (c_id),
    c_name      VARCHAR(50),
    action_time TIMESTAMP
);

CREATE OR REPLACE FUNCTION insert_c()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO customer_log(c_id, c_name, action_time)
    VALUES (NEW.c_id, NEW.name, CURRENT_TIMESTAMP);

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_c_insert
    AFTER INSERT
    ON customers
    FOR EACH ROW
EXECUTE FUNCTION insert_c();

INSERT INTO customers(name, email)
VALUES ('an', 'an@gmail.com'),
       ('bach', 'bach@gmail.com'),
       ('long', 'long@gmail.com'),
       ('linh', 'linh@gmail.com');

SELECT *
FROM customer_log;

select *
from customers;

select *
from customer_log;
