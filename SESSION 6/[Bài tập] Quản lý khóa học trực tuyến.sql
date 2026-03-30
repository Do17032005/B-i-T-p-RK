-- Active: 1773844200417@@127.0.0.1@5432@btss6
CREATE DATABASE btss6;

CREATE TABLE courses (
    cs_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    instructor VARCHAR(50) NOT NULL,
    duration INT
);

-- 1) Them it nhat 6 khoa hoc vao bang
INSERT INTO courses (title, price, instructor, duration) VALUES
('SQL Co Ban', 650000, 'Nguyen Van A', 24),
('SQL Nang Cao', 1450000, 'Tran Thi B', 36),
('Python for Data Analysis', 1800000, 'Le Minh C', 40),
('Java Backend Fundamentals', 2100000, 'Pham Duc D', 45),
('Web Development Bootcamp', 950000, 'Hoang Thi E', 32),
('Demo Course - Testing', 500000, 'Admin Demo', 10);

-- 2) Cap nhat gia tang 15% cho cac khoa hoc co thoi luong tren 30 gio
UPDATE courses
SET price = price * 1.15
WHERE duration > 30;

-- 3) Xoa khoa hoc co ten chua tu khoa "Demo"
DELETE FROM courses
WHERE title ILIKE '%Demo%';

-- 4) Hien thi cac khoa hoc co ten chua tu "SQL" (khong phan biet hoa thuong)
SELECT *
FROM courses
WHERE title ILIKE '%SQL%';

-- 5) Lay 3 khoa hoc co gia trong khoang 500,000 den 2,000,000, sap xep giam dan theo gia
SELECT *
FROM courses
WHERE price BETWEEN 500000 AND 2000000
ORDER BY price DESC
LIMIT 3;

