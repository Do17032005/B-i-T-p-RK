CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    dept_id int,
    FOREIGN KEY (dept_id) REFERENCES departments (dept_id),
    salary NUMERIC(10, 2) NOT NULL
);

INSERT INTO
    departments (dept_name)
VALUES ('HR'),
    ('IT'),
    ('Nhan su'),
    ('Truyen thong');

INSERT INTO
    employees (emp_name, dept_id, salary)
VALUES ('A', 1, 70000.00),
    ('B', 2, 80000.00),
    ('C', 3, 90000.00),
    ('D', 4, 75000.00);

-- 1) Liet ke danh sach nhan vien cung ten phong ban (INNER JOIN)
SELECT e.emp_id, e.emp_name, d.dept_name AS department_name
FROM employees e
    INNER JOIN departments d ON d.dept_id = e.dept_id
ORDER BY e.emp_id;

-- 2) Tinh luong trung binh cua tung phong ban
SELECT d.dept_name AS department_name, AVG(e.salary) AS avg_salary
FROM departments d
    INNER JOIN employees e ON e.dept_id = d.dept_id
GROUP BY
    d.dept_name
ORDER BY d.dept_name;

-- 3) Hien thi phong ban co luong trung binh > 10 trieu
SELECT d.dept_name AS department_name, AVG(e.salary) AS avg_salary
FROM departments d
    INNER JOIN employees e ON e.dept_id = d.dept_id
GROUP BY
    d.dept_name
HAVING
    AVG(e.salary) > 10000
ORDER BY avg_salary DESC;

-- 4) Liet ke phong ban khong co nhan vien nao
SELECT d.dept_id, d.dept_name AS department_name
FROM departments d
    LEFT JOIN employees e ON e.dept_id = d.dept_id
WHERE
    e.emp_id IS NULL
ORDER BY d.dept_id;