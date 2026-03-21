create schema library;

create table library.Books (
    book_id int primary key ,
    title text,
    author text,
    published_year int,
    available boolean default true
);


create table library.Members (
    member_id int primary key ,
    name varchar(50),
    email varchar(100) unique ,
    join_date date
);