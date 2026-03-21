create schema hotel;

create table hotel.RoomTypes (
    room_type_id serial primary key ,
    type_name varchar(50) not null unique ,
    price_per_night numeric(10,2) check ( price_per_night>0 ),
    max_capacity int check ( max_capacity>0)
);

create table hotel.Rooms (

    room_id serial primary key ,
    room_number varchar(10) not null unique ,
    room_type_id int,
    foreign key (room_type_id) references hotel.RoomTypes(room_type_id),
    status varchar(20) check ( status in ('availble','occupied','maintenance'))
);

create table hotel.Customers (
    customer_id serial primary key ,
    full_name varchar(100) not null ,
    email varchar(100) unique not null ,
    phone varchar(15) not null
);

create table hotel.Bookings (
    booking_id serial primary key ,
    customer_id int,
    foreign key (customer_id) references hotel.customers(customer_id),
    room_id int,
    foreign key (room_id) references hotel.Rooms(room_id),
    check_in date not null ,
    check_out date not null ,
    status varchar (20) check ( status in ('pending','confirmed','cancelled') )
);

create table hotel.Payments (
    payment_id serial primary key ,
    booking_id int ,
    foreign key (booking_id) references hotel.Bookings(booking_id),
    amount numeric(10,2) check ( amount>0 ),
    payment_date date not null,
    method varchar(20) check ( method in ('creduit','card','momo','cash','bank transfer') )
);

