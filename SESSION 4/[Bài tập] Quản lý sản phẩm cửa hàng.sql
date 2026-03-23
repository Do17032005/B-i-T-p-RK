create table products(
    product_id serial primary key ,
    name varchar(50),
    categoty varchar(50),
    price decimal(10,2),
    stock int
);

insert into products values ('7','Điều hòa Panasonics','Home Appliances','400.00','10');

update products set stock = '7' where name = 'Laptop Dell';

delete
from products
where stock = '0';

select * from products order by price asc ;

select distinct categoty from products ;

select * from products where price between '100' and '1000';

select * from products order by price desc limit 2;

select *
from products
order by price desc
limit 2 offset 1;


-- Thêm sản phẩm mới: 'Điều hòa Panasonic', category 'Home Appliances', giá 400.00, stock 10
-- Cập nhật stock của 'Laptop Dell' thành 7
-- Xóa các sản phẩm có stock bằng 0 (nếu có)
-- Liệt kê tất cả sản phẩm theo giá tăng dần
-- Liệt kê danh mục duy nhất của các sản phẩm (DISTINCT)
-- Liệt kê sản phẩm có giá từ 100 đến 1000
-- Liệt kê các sản phẩm có tên chứa từ 'LG' hoặc 'Samsung' (sử dụng LIKE/ILIKE)
-- Hiển thị 2 sản phẩm đầu tiên theo giá giảm dần, hoặc lấy sản phẩm thứ 2 đến thứ 3 bằng LIMIT và OFFSET