create table customers
(
    customer_id serial primary key,
    full_name   varchar(50),
    email       varchar(50),
    city        varchar(50)
);

create table products
(
    product_id   serial primary key,
    product_name varchar(50),
    category     text,
    price        numeric(5, 2)
);

create table orders
(
    order_id    serial primary key,
    customer_id int references customers (customer_id),
    product_id  int references products (product_id),
    order_date  date,
    quantity    int
);

-- Thêm dữ liệu mẫu cho bảng customers (5 khách hàng)
INSERT INTO customers (full_name, email, city)
VALUES ('Nguyễn Văn An', 'nguyenvanan@gmail.com', 'Hà Nội'),
       ('Trần Thị Bình', 'tranbinhhcm@gmail.com', 'Hồ Chí Minh'),
       ('Lê Văn Cường', 'lecuongdn@gmail.com', 'Đà Nẵng'),
       ('Phạm Thị Dung', 'phamdung@gmail.com', 'Hải Phòng'),
       ('Hoàng Văn Em', 'hoangemct@gmail.com', 'Cần Thơ'),
       ('Vũ Thị Hoa', 'vuhoa@gmail.com', 'Huế'),
       ('Đỗ Văn Kiên', 'dokiennt@gmail.com', 'Nha Trang');

-- Thêm dữ liệu mẫu cho bảng products (5 sản phẩm)
INSERT INTO products (product_name, category, price)
VALUES ('Laptop Dell XPS 13', 'Electronics', 999.99),
       ('iPhone 15 Pro', 'Electronics', 899.99),
       ('Samsung Galaxy S24', 'Electronics', 799.99),
       ('iPad Pro 12.9', 'Electronics', 699.99),
       ('AirPods Pro', 'Electronics', 249.99),
       ('MacBook Air M2', 'Electronics', 999.99),
       ('Sony WH-1000XM5', 'Electronics', 399.99);

-- Thêm dữ liệu mẫu cho bảng orders (10 đơn hàng)
INSERT INTO orders (customer_id, product_id, order_date, quantity)
VALUES (1, 1, '2024-03-01', 1),
       (2, 2, '2024-03-02', 2),
       (3, 3, '2024-03-03', 1),
       (4, 4, '2024-03-04', 1),
       (5, 5, '2024-03-05', 3),
       (1, 6, '2024-03-06', 1),
       (2, 7, '2024-03-07', 2),
       (3, 1, '2024-03-08', 1),
       (6, 2, '2024-03-09', 1),
       (7, 3, '2024-03-10', 2),
       (4, 5, '2024-03-11', 4),
       (5, 4, '2024-03-12', 1);


-- 1 Tối ưu truy vấn tìm kiếm khách hàng và sản phẩm:
-- Tạo chỉ mục B-tree trên cột email để tối ưu tìm khách hàng theo email
create index ind_btree_email on customers (email);
-- Tạo chỉ mục Hash trên cột city để lọc theo thành phố
create index ind_hash_city on customers using hash (city);
-- Tạo chỉ mục GIN trên cột category của products để hỗ trợ tìm theo danh mục (mảng)
create index ind_gin_category on products using hash (category);

-- Tạo chỉ mục GiST trên cột price để hỗ trợ tìm sản phẩm trong khoảng giá
create extension if not exists btree_gist;
create index ind_gist_price on products using gist (price);

--3 Thực hiện một số truy vấn trước và sau khi có Index:
-- Tìm khách hàng có email cụ thể
select *
from customers
where email = 'tranbinhhcm@gmail.com';
-- Tìm sản phẩm có category chứa 'Electronics'
select *
from products
where category = 'Electronics';
-- Tìm sản phẩm trong khoảng giá từ 500 đến 1000
select *
from products
where price between 500 and 1000;
-- Dùng
-- EXPLAIN ANALYZE để so sánh hiệu suất truy vấn trước và sau khi tạo Index
explain analyse
select *
from products
where category = 'Electronics';

--4 Thực hiện Clustered Index trên bảng orders theo cột order_date

create index ind_orders_date on orders (order_date);
cluster orders using ind_orders_date;
--5 Sử dụng View để:
-- Xem top 3 khách hàng mua nhiều nhất
create view v_3khach_mua_nh_nhat as
select c.full_name, count(o.order_id)
from customers c
         join orders o on c.customer_id = o.customer_id
group by c.full_name
order by count(o.order_id) desc
limit 3;
-- Xem tổng doanh thu theo từng sản phẩm
create view v_tongdoanhthu as
select p.product_id,
       p.product_name,
       p.category,
       p.price                   AS unit_price,
       sum(o.quantity)           AS "tong san pham",
       sum(o.quantity * p.price) AS "tong daonh thu"
from products p
         join orders o on p.product_id = o.product_id
group by p.product_id, p.product_name, p.category, p.price
order by "tong daonh thu" desc;