-- Active: 1773844200417@@127.0.0.1@5432@btss7
create table books
(
    book_id     serial primary key,
    title       varchar(500),
    author      varchar(50),
    genre       varchar(50),
    price       decimal(10, 2),
    description text,
    creat_at    timestamp default current_timestamp
);

INSERT INTO books (title, author, genre, price, description)
VALUES ('Dạo Phố Sài Gòn', 'Nhất Linh', 'Văn học', 89000.00,
        'Một bộ truyện ngắn về cuộc sống thường ngày ở Sài Gòn xưa'),
       ('Cha Tôi', 'Kim Dung', 'Tiểu thuyết', 120000.00, 'Câu chuyện cảm động về mối quan hệ cha con'),
       ('Không Gia Đình', 'Hector Malot', 'Tiểu thuyết', 95000.00,
        'Câu chuyện về một cậu bé bất hạnh và hành trình tìm kiếm gia đình'),
       ('Trí Tuệ Nhân Tạo Cơ Bản', 'Andrew Ng', 'Công nghệ', 250000.00,
        'Hướng dẫn toàn diện về machine learning và AI'),
       ('Clean Code', 'Robert C. Martin', 'Lập trình', 200000.00, 'Hướng dẫn viết mã sạch và dễ bảo trì'),
       ('Lược Sử Nhân Loại', 'Yuval Noah Harari', 'Lịch sử', 180000.00,
        'Một cái nhìn toàn cảnh về lịch sử phát triển của loài người'),
       ('Những Người Thay Đổi Thế Giới', 'Malcolm Gladwell', 'Tâm lý học', 160000.00,
        'Phân tích những yếu tố giúp con người thành công'),
       ('Harry Potter và Phòng Chứa Bí Mật', 'J.K. Rowling', 'Fantasy', 140000.00,
        'Phần thứ hai của series Harry Potter'),
       ('Đắc Nhân Tâm', 'Dale Carnegie', 'Kỹ năng sống', 125000.00,
        'Sách hướng dẫn về cách giao tiếp và xây dựng mối quan hệ'),
       ('Chân Dung Dorian Gray', 'Oscar Wilde', 'Văn học cổ điển', 110000.00,
        'Tiểu thuyết gốc nói về sắc đẹp, tham vọng và kết cục của nó');

create index ind_seach_book on books (title, author, genre);

create extension if not exists btree_gin;

create index ind_book_author on books using gin (author);

sELECT title
FROM books;

select *
from books;

CLUSTER books USING ind_seach_book;



explain
select title
from books

