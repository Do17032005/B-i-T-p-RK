-- Dùng bảng products và sales từ bài tập 2
-- Viết TRIGGER AFTER
-- INSERT để giảm số lượng stock trong products

create or replace function fn_giam_stock()
    returns trigger
as
$$
declare

begin
    update products set stock = stock - new.quantity where product_id = new.product_id;

    return new;

    --     exception
--         when others then
--         rollback ;
--         raise ;
end;
$$ language plpgsql;

create or replace trigger af_giam_stock
    after insert
    on sale
    for each row
execute function fn_giam_stock();
--     Thêm đơn hàng và kiểm tra products để thấy số lượng tồn kho giảm đúng

insert into sale(product_id, quantity)
VALUES ('3', '5');

select *
from products;

select *
from sale;