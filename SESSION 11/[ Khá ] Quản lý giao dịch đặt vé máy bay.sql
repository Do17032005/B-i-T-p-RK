create table flights
(
    fl_id           serial primary key,
    fl_name         varchar(50),
    available_seats int
);

create table bookings
(
    booking_id     serial primary key,
    fl_id          int references flights (fl_id),
    customers_name varchar(50)
);

insert into flights(fl_name, available_seats)
values ('Vn123', 3),
       ('Vn143', 2),
       ('Vn183', 4);

create or replace procedure create_flight(
    p_fl_id_in int,
    p_available_seats_in int
)

    language plpgsql
as
$$
declare
    v_ghe_trong int;
    v_fl_name   varchar(50);
begin
    begin
        -- Kiểm tra số ghế hiện tại
        select f.fl_name, f.available_seats
        into v_fl_name, v_ghe_trong
        from flights f
        where f.fl_id = p_fl_id_in;

        insert into bookings(fl_id, customers_name)
        VALUES (p_fl_id_in, 'nguyen van A');

        if v_ghe_trong < p_available_seats_in then
            raise exception 'không đủ ghế. còn % ghế ',v_ghe_trong;
        end if;

        update flights
        set available_seats = available_seats - p_available_seats_in
        where fl_id = p_fl_id_in;
        raise notice 'đặt ghế thành công';

        commit;

    exception
        when others then
            rollback;
            raise;
    end;
end;
$$;

call create_flight(1, 5);

select *
from flights;
select *
from bookings;
