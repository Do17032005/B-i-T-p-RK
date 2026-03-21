create schema sales ;

create table sales.Products(
    product_id serial primary key ,
    product_name varchar(50),
    price numeric(10,2),
    stock_quantity int
);

create table sales.Orders(
    order_id serial primary key ,
    order_date date,
    member_id int,
    foreign key (member_id) references library.members(member_id)
);

create table sales.OrderDetails(
    order_detail_id serial primary key ,
    order_id int,
    foreign key (order_id) references sales.Orders(order_id),
    product_id int,
    foreign key (product_id) references sales.Products(product_id)
);