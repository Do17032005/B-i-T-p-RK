create table orders
(
    order_id     serial primary key,
    product_id   int references products (product_id),
    quantity     int,
    total_amount decimal
);

create or replace function sum_total_amount()
    returns trigger
as
$$
begin
    select
end;
$$ language plpgsql;