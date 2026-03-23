create table books (
    id serial primary key ,
    title text,
    author varchar(50),
    category varchar(50),
    publish_year char(5),
    price decimal(10,2),
    stock int
);



-- Cập nhật giá:
-- Tăng giá 10% cho những sách xuất bản từ năm 2021 trở đi và có price < 200000
update books set price =( price + 0.1) where publish_year >= '2021' and price < 2000;
-- Xử lý lỗi nhập:
-- Với những sách có stock IS NULL, cập nhật stock = 0
update books set stock = '0' where stock isnull;
-- Truy vấn nâng cao:
-- Liệt kê danh sách sách thuộc chủ đề CNTT hoặc AI có giá trong khoảng 100000 - 250000
select * from books where category in ( 'CNTT', 'AI');

select * from books where (category in ('CNTT', 'AI') and price between 100000 and 250000);
-- Sắp xếp giảm dần theo price, rồi tăng dần theo title
select *
from books order by price desc, title asc ;
-- Tìm kiếm tự
-- do :
-- Tìm các sách có tiêu đề chứa từ “học” (không phân biệt hoa thường)
    select * from books where title ilike 'học%';
-- Gợi ý: dùng ILIKE '%học%'
-- Thống kê chuyên mục:

-- Liệt kê các thể loại duy nhất (DISTINCT) có ít nhất một cuốn sách xuất bản sau năm 2020
select distinct category
from books
where publish_year > '2020';
-- Phân trang kết quả:
-- Chỉ hiển thị 2 kết quả đầu tiên, bỏ qua 1 kết quả đầu tiên (dùng LIMIT + OFFSET)
select * from books order by stock limit 2 offset 1;