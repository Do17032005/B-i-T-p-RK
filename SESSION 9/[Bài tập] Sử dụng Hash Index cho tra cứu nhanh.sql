

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    username VARCHAR(100) NOT NULL
);

INSERT INTO
    users (email, username)
VALUES (
        'example@example.com',
        'example_user'
    ),
    ('alice@example.com', 'alice'),
    ('bob@example.com', 'bob'),
    (
        'charlie@example.com',
        'charlie'
    ),
    ('david@example.com', 'david');


CREATE INDEX idx_users_email_hash ON users USING HASH (email);
EXPLAIN SELECT * FROM users WHERE email = 'example@example.com';