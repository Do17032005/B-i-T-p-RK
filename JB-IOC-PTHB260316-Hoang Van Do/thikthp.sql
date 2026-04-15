create table if not exists Customer
(
    customer_id        varchar(5) primary key,
    customer_full_name varchar(100),
    customer_email     varchar(100) unique,
    customer_phone     varchar(15),
    customer_address   varchar(255)
);

create table if not exists Room
(
    room_id     varchar(5) primary key,
    room_type   varchar(50),
    room_price  decimal(10, 2),
    room_status varchar(20),
    room_area   int
);

create table if not exists Booking
(
    booking_id     int primary key,
    customer_id    varchar(5) references customer (customer_id),
    room_id        varchar(5) references room (room_id),
    check_in_date  date,
    check_out_date date,
    total_amount   decimal(10, 2)
);

create table if not exists Payment
(
    payment_id     int primary key,
    booking_id     int references booking (booking_id),
    payment_method varchar(50),
    pament_date    date,
    payment_amount decimal(10, 2)
);

insert into customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address)
VALUES ('C001', 'Nguyen Anh Tu',
        'tu.nguyen@example.com', '0912345678',
        'Hanoi, Vietnam'),
       ('C002', 'Tran Thi Mai', 'mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
       ('C003', 'Le Minh Hoang', 'hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
       ('C004', 'Pham Hoang Nam', 'nam.pham@example.com', '0945678901', 'Hue, Vietnam'),
       ('C005', 'NVu Minh Thu', 'thu.vu@example.com', '0956789012', 'Hai Phong, Vietnam'),
       ('C006', 'Nguyen Thi Lan', 'lan.nguyen@example.com', '0967890123', 'Quang Ninh, Vietnam'),
       ('C007', 'Bui Minh Tuan  ', 'tuan.bui@example.com', '0978901234', 'Bac Giang, Vietnam'),
       ('C008', 'Pham Quang Hieu', 'hieu.pham@example.com', '0989012345', 'Bac Giang, Vietnam'),
       ('C009', 'Le Thi Lan', 'lan.le@example.com', '0990123456', 'Da Lat, Vietnam'),
       ('C010', 'Nguyen Thi Mai', 'mai.nguyen@example.com', '0901234567', 'Can Tho, Vietnam');


select r.room_price
from booking b
         join room r on r.room_id = b.room_id;

delete
from payment p
where payment_method = 'Cash'
  and p.payment_amount < 500;

--phần 2

--5.Lấy thông tin khách hàng gồm mã khách hàng,
-- họ tên, email, số điện thoại và
-- địa chỉ được sắp xếp theo họ tên khách hàng tăng dần.

select c.customer_id,
       c.customer_full_name,
       c.customer_email,
       c.customer_phone,
       c.customer_address
from customer c
order by c.customer_address;

--6 Lấy thông tin các phòng khách sạn gồm mã phòng,
-- loại phòng, giá phòng và diện tích phòng,
-- sắp xếp theo giá phòng giảm dần.

select r.room_id, r.room_type, r.room_price, r.room_area
from room r
order by r.room_price desc;

--7 Lấy thông tin khách hàng và phòng khách sạn đã đặt,
-- gồm mã khách hàng, họ tên khách hàng, mã phòng,
-- ngày nhận phòng và ngày trả phòng.

select c.customer_id, c.customer_full_name, r.room_id, b.check_in_date, b.check_out_date
from booking b
         join public.customer c on b.customer_id = c.customer_id
         join public.room r on b.room_id = r.room_id;

--8Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng,
-- gồm mã khách hàng, họ tên khách hàng,
-- phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán giảm dần.

select c.customer_id,
       c.customer_full_name,
       p.payment_method,
       r.room_price * (b.check_out_date - b.check_in_date)
from booking b
         join public.customer c on b.customer_id = c.customer_id
         join public.room r on b.room_id = r.room_id
         join Payment P on b.booking_id = P.booking_id
order by r.room_price * (b.check_out_date - b.check_in_date) desc;

--9  Lấy thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer
-- được sắp xếp theo tên khách hàng.

select c.customer_id, c.customer_full_name, c.customer_address, c.customer_phone, c.customer_email
from customer c
limit 3 offset 1;

--10 Lấy danh sách khách hàng đã đặt ít nhất 2 phòng và có tổng số tiền thanh toán trên 1000,
-- gồm mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.

select c.customer_id, c.customer_full_name, count(b.room_id)
from booking b
         join public.customer c on b.customer_id = c.customer_id
    and total_amount > 1000
group by c.customer_id, c.customer_full_name;

--11 Lấy danh sách các phòng có tổng số tiền thanh toán dưới 1000 và có ít nhất 3 khách hàng đặt,
-- gồm mã phòng, loại phòng, giá phòng và tổng số tiền thanh toán.
select r.room_id, r.room_type, r.room_price * (b.check_out_date - b.check_in_date), b.total_amount
from booking b
         join public.room r on b.room_id = r.room_id
where b.total_amount < '1000';

--12x Lấy danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 1000,
-- gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền thanh toán.
select c.customer_id, c.customer_full_name, r.room_id, r.room_price * (b.check_out_date - b.check_in_date)
from booking b
         join public.room r on b.room_id = r.room_id
         join public.customer c on b.customer_id = c.customer_id
where r.room_price * (b.check_out_date - b.check_in_date) > 1000;

--13 Lấy danh sách các khách hàng Mmã KH, Họ tên, Email, SĐT) có họ tên chứa chữ "Minh" hoặc địa chỉ (address) ở "Hanoi". Sắp xếp kết quả theo họ tên tăng dần.

select c.customer_id, c.customer_full_name, c.customer_email, c.customer_phone
from customer c
where c.customer_full_name like '%Minh%'
   or c.customer_address like 'Hanoi';

-- 14  Lấy danh sách tất cả các phòng (Mã phòng, Loại phòng, Giá), sắp xếp theo giá phòng giảm dần.
-- Hiển thị 5 phòng tiếp theo sau 5 phòng đầu tiên (tức là lấy kết quả của trang thứ 2,
-- biết mỗi trang có 5 phòng).

select r.room_id, r.room_type, r.room_price
from room r
order by r.room_price desc
limit 5 offset 1;

-- Phần 3
--15  Hãy tạo một view để lấy thông tin các phòng và khách hàng đã đặt,
-- với điều kiện ngày nhận phòng nhỏ hơn ngày 2025-03-10.
-- Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng

create or replace view v_room_Available
as
select b.room_id, r.room_type, c.customer_id, c.customer_full_name
from booking b
         join public.customer c on b.customer_id = c.customer_id
         join public.room r on b.room_id = r.room_id
where b.check_in_date between '2025-03-1' and '2025-03-10';

-- 16  Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt,
-- với điều kiện diện tích phòng lớn hơn 30 m².
-- Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng
create or replace view v_room_area
as
select c.customer_id, c.customer_full_name, r.room_id, r.room_area
from booking
         join public.customer c on booking.customer_id = c.customer_id
         join public.room r on booking.room_id = r.room_id
where r.room_area > 30;
--phần 4
--17Hãy tạo một trigger check_insert_booking để kiểm tra
-- dữ liệu mối khi chèn vào bảng Booking. Kiểm tra nếu ngày đặt phòng mà sau ngày trả
-- phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được
-- !” và hủy thao tác chèn dữ liệu vào bảng.
create or replace function insert_booking()
    returns trigger
as
$$
declare
    v_ngaynha date;
    v_ngaytra date;

begin
    select check_in_date into v_ngaynha from booking;
    select check_out_date into v_ngaytra from booking;

    if v_ngaytra > v_ngaynha then
        raise exception 'Ngày đặt phòng không thể sau ngày trả phòng được !';
    end if;

    insert into booking(booking_id, customer_id, room_id, check_in_date, check_out_date, total_amount)
    values (new.booking_id, new.customer_id, new.room_id, current_timestamp, current_timestamp, new.total_amount);
end;
$$ language plpgsql;

create or replace trigger check_insert_booking
    before insert
    on booking
    for each row
execute function insert_booking();

--18 Hãy tạo một trigger có tên là update_room_status_on_booking
-- để tự động cập nhật trạng thái phòng thành "Booked" khi một phòng được đặt
-- (khi có bản ghi được INSERT vào bảng Booking).

create or replace function update_room()
    returns trigger
as
$$
declare
    v_trangthai varchar;
begin
    select room_id, room_status into v_trangthai from room where room_status = 'Available';


    if v_trangthai = 'Available' then
        insert into booking(booking_id, customer_id, room_id, check_in_date, check_out_date, total_amount)
        VALUES (new.booking_id, new.customer_id, new.room_id, current_timestamp, current_timestamp, new.total_amount);
    end if;

    update room set room_status = 'Booked' where room_id = new.room_id;
end;
$$ language plpgsql;

create or replace trigger update_room_status_on_booking
    before update
    on Room
    for each row
execute function update_room();

--phần 5
--19. (5 điểm) Viết store procedure có tên add_customer
-- để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
create or replace procedure add_customer(
    in ma_kh int,
    in ten_kh varchar(50),
    in emai_kh varchar(50),
    in sdt_kh varchar(15),
    in diachi_kh varchar(255)
)
    language plpgsql
as
$$
begin
    insert into customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address)
    VALUES (ma_kh, ten_kh, emai_kh, sdt_kh, diachi_kh);

end;
$$;

--20 20. (5 điểm) Hãy tạo một Stored Procedure
-- có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
create or replace procedure add_payment(
    in p_booking_id int,
    in p_payment_method varchar(50),
    in p_payment_date date,
    in p_payment_amount decimal(10, 2)
)
    language plpgsql
as
$$
begin
    insert into payment(payment_id, booking_id, payment_method, pament_date, payment_amount)
    values (payment_id, p_booking_id, p_payment_method, p_payment_date, p_payment_amount);
end;
$$;