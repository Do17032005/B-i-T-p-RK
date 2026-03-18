create schema shop;
create table shop.user(
user_id serial primary key ,
user_name varchar(50) unique not null ,
email varchar(100) unique not null ,
password varchar(100) not null ,
 role varchar(20) check ( role in ('customer','admin'))
);
create table shop.categories(
category_id serial primary key ,
category_name varchar(100) not null unique
);
create table shop.products(
product_id serial primary key ,
product_name varchar(100) not null ,
price numeric(10,2) check ( price>0 ),
stock int check ( stock>0 ),
category_id int,
foreign key (category_id) references shop.categories(category_id)
);
-- create type shop.status as enum ('pending','ship','delivered','cancelled');
create table shop.Order(
order_id serial primary key ,
user_id int,
foreign key (user_id) references shop.user(user_id),
order_date date not null ,
status varchar(20) check ( status in ('pending','ship','delivered','cancelled'))
);

create table shop.orderdetail(
    order_detail_id serial primary key,
    order_id int,
    foreign key (order_id) references shop.Order (order_id),
    product_id  int,
    foreign key (product_id) references shop.products (product_id),
    quantity int check ( quantity > 0 ),
    price_each numeric(10, 2) check ( price_each > 0 )
);

create table shop.payments(
    payment_id serial primary key ,
    order_id int,
    foreign key (order_id) references shop.Order(order_id),
    amount numeric(10,2) check ( amount>=0 ),
    pament_date date not null ,
    method varchar(30) check ( method in ('credit','card','momo','bank transfer','cash') )
);