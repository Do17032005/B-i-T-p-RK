-- =============================================================

CREATE TABLE IF NOT EXISTS customers_log (
    log_id BIGSERIAL PRIMARY KEY,
    customer_id INT,
    operation VARCHAR(10) NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_by TEXT NOT NULL DEFAULT CURRENT_USER,
    change_time TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION fn_log_customers_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	IF TG_OP = 'INSERT' THEN
		INSERT INTO customers_log (
			customer_id,
			operation,
			old_data,
			new_data,
			changed_by,
			change_time
		)
		VALUES (
			NEW.id,
			'INSERT',
			NULL,
			to_jsonb(NEW),
			CURRENT_USER,
			NOW()
		);

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		INSERT INTO customers_log (
			customer_id,
			operation,
			old_data,
			new_data,
			changed_by,
			change_time
		)
		VALUES (
			NEW.id,
			'UPDATE',
			to_jsonb(OLD),
			to_jsonb(NEW),
			CURRENT_USER,
			NOW()
		);

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN
		INSERT INTO customers_log (
			customer_id,
			operation,
			old_data,
			new_data,
			changed_by,
			change_time
		)
		VALUES (
			OLD.id,
			'DELETE',
			to_jsonb(OLD),
			NULL,
			CURRENT_USER,
			NOW()
		);

		RETURN OLD;
	END IF;

	RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_log_customers_changes ON customers;

CREATE TRIGGER trg_log_customers_changes
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW
EXECUTE FUNCTION fn_log_customers_changes();


INSERT INTO
    customers (name, email, phone, address)
VALUES (
        'Nguyen Van A',
        'vana@example.com',
        '0901234567',
        'Ha Noi'
    );

UPDATE customers
SET
    phone = '0988888888',
    address = 'Da Nang'
WHERE
    email = 'vana@example.com';

DELETE FROM customers WHERE email = 'vana@example.com';


SELECT
    log_id,
    customer_id,
    operation,
    old_data,
    new_data,
    changed_by,
    change_time
FROM customers_log
ORDER BY log_id;