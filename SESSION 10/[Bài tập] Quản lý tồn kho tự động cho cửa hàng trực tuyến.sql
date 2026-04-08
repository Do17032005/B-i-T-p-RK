create table products
(
    product_id serial primary key,
    name       varchar(50),
    stock      int
);

create table orders
(
    order_id     serial primary key,
    product_id   int references products (product_id),
    quantity     numeric,
    order_status varchar(50)
);


insert into products (name, stock)
values ('Laptop Dell XPS 13', 50),
       ('iPhone 15 Pro Max', 100),
       ('Samsung Galaxy S24', 75),
       ('Airpods Pro 2', 200),
       ('MacBook Air M2', 30),
       ('iPad Pro 11 inch', 60),
       ('Sony WH-1000XM5', 80),
       ('Logitech MX Master 3', 150);


insert into orders (product_id, quantity, order_status)
values (1, 2, 'pending'),
       (2, 1, 'completed'),
       (3, 3, 'pending'),
       (4, 5, 'completed'),
       (1, 1, 'completed'),
       (5, 2, 'pending'),
       (6, 1, 'cancelled'),
       (7, 4, 'completed'),
       (2, 2, 'pending'),
       (8, 10, 'completed');


-- Function để giảm tồn kho khi tạo đơn hàng mới


create or replace function decrease_stock_on_order()
    returns trigger as
$$
declare
    current_stock int;
begin
    -- Lấy tồn kho hiện tại
    select stock
    into current_stock
    from products
    where product_id = NEW.product_id;

    -- Kiểm tra tồn kho có đủ không
    if current_stock < NEW.quantity then
        raise exception 'Không đủ hàng trong kho! Tồn kho hiện tại: %, Số lượng đặt: %',
            current_stock, NEW.quantity;
    end if;

    -- Giảm tồn kho
    update products
    set stock = stock - NEW.quantity
    where product_id = NEW.product_id;

    return NEW;
end;
$$ language plpgsql;

-- Tạo trigger
create trigger trg_decrease_stock
    after insert
    on orders
    for each row
execute function decrease_stock_on_order();


-- Xem tồn kho trước khi đặt hàng
select *
from products
where product_id = 1;

-- Tạo đơn hàng mới (sẽ tự động giảm tồn kho)
insert into orders (product_id, quantity, order_status)
values (1, 5, 'pending');

-- Xem tồn kho sau khi đặt hàng
select *
from products
where product_id = 1;





