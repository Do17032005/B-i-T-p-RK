create table customer
(
    c_id      serial primary key,
    full_name varchar(100),
    email     varchar(100),
    phone     varchar(100)
);

create table orderss
(
    o_id         serial primary key,
    c_id         int references customer (c_id),
    total_amount decimal(10, 2),
    o_date       date
);

-- 5 dòng dữ liệu cho bảng customer
insert into customer (full_name, email, phone)
values ('Nguyen Van A', 'a@gmail.com', '0901111111'),
       ('Tran Thi B', 'b@gmail.com', '0902222222'),
       ('Le Van C', 'c@gmail.com', '0903333333'),
       ('Pham Thi D', 'd@gmail.com', '0904444444'),
       ('Hoang Van E', 'e@gmail.com', '0905555555');

-- 5 dòng dữ liệu cho bảng orderss
insert into orderss (c_id, total_amount, o_date)
values (1, 250.50, '2026-04-01'),
       (2, 500.00, '2026-04-02'),
       (3, 150.75, '2026-04-03'),
       (4, 320.40, '2026-04-04'),
       (5, 999.99, '2026-04-05');

create or replace view v_order_summary as
select c.full_name, o.total_amount, o.o_date
from customer c
         join orderss o on c.c_id = o.c_id
where total_amount >= 300;

select *
from v_order_summary;

insert into v_order_summary (full_name, total_amount, o_date)
VALUES ('Honag Van Do', '700.99', '2026-04-04');

update v_order_summary
set total_amount = 700.99
where full_name = 'Tran Thi B';

create or replace view v_monthly_sales
as
select o.o_date as sale_date, sum(total_amount) as total
from orderss o
group by sale_date
order by sale_date;

select *
from v_monthly_sales;