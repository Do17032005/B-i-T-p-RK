CREATE TABLE products
(
    product_id serial primary key,
    name       varchar(50),
    stock      int
);

create table sale
(
    sale_id    serial primary key,
    product_id int references products (product_id),
    quantity   int
);

create or replace function check_stock_p()
    returns trigger
as
$$
declare
    v_curent_stock int;
begin
    select p.stock into v_curent_stock from products p where p.product_id = new.product_id;

    if v_curent_stock is null then
        raise exception 'không có hàng';
    end if;

    if new.quantity > v_curent_stock then
        raise exception 'không đủ số lượng tồn kho,'
            ' số lượng còn lại là % .số lượng khách hàng cần là %'
            , v_curent_stock, new.quantity;
    end if;

    --nếu đủ số lượng upadte lại kho
    update products
    set stock = stock - new.quantity
    where product_id = new.product_id;
    return new;

exception

end;
$$ language plpgsql;

create or replace trigger bf_ins_stock
    before insert
    on sale
    for each row
execute function check_stock_p();

insert into products(name, stock)
VALUES ('linhtinh', '10'),
       ('acer', '50'),
       ('dell', '100'),
       ('tram', '5'),
       ('gaming laptop', '8');

select *
from products p;

select *
from sale;

insert into sale (product_id, quantity)
VALUES ('2', '10');

