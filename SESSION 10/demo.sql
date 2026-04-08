create database btss10;

-- 1. Bảng accounts
create table accounts
(
    id     serial primary key,
    name   varchar(100)        not null,
    email  varchar(100) unique not null,
    pass   varchar(255)        not null,
    phone  varchar(20),
    status varchar(20) default 'active' check (status in ('active', 'inactive', 'blocked'))
);

-- 2. Bảng log_user
create table log_user
(
    id         serial primary key,
    action     varchar(10) not null check (action in ('INSERT', 'UPDATE', 'DELETE')),
    data_old   text,
    data_new   text,
    change_by  varchar(100),
    created_at timestamp default current_timestamp
);

-- Thêm dữ liệu mẫu vào bảng accounts
insert into accounts (name, email, pass, phone, status)
values ('Nguyễn Văn An', 'nguyenvanan@gmail.com', 'password123', '0901234567', 'active'),
       ('Trần Thị Bình', 'tranthibinh@gmail.com', 'password456', '0912345678', 'active'),
       ('Lê Văn Cường', 'levancuong@gmail.com', 'password789', '0923456789', 'inactive'),
       ('Phạm Thị Dung', 'phamthidung@gmail.com', 'password321', '0934567890', 'active'),
       ('Hoàng Văn Em', 'hoangvanem@gmail.com', 'password654', '0945678901', 'blocked');



create or replace function log_account_insert()
    returns trigger as
$$
begin
    insert into log_user (action, data_old, data_new, change_by, created_at)
    values ('INSERT',
            null,
            json_build_object(
                    'id', NEW.id,
                    'name', NEW.name,
                    'email', NEW.email,
                    'phone', NEW.phone,
                    'status', NEW.status
            )::text,
            current_user,
            current_timestamp);
    return NEW;
end;
$$ language plpgsql;

create trigger trg_account_insert
    after insert
    on accounts
    for each row
execute function log_account_insert();


create or replace function log_account_update()
    returns trigger as
$$
begin
    insert into log_user (action, data_old, data_new, change_by, created_at)
    values ('UPDATE',
            json_build_object(
                    'id', OLD.id,
                    'name', OLD.name,
                    'email', OLD.email,
                    'phone', OLD.phone,
                    'status', OLD.status
            )::text,
            json_build_object(
                    'id', NEW.id,
                    'name', NEW.name,
                    'email', NEW.email,
                    'phone', NEW.phone,
                    'status', NEW.status
            )::text,
            current_user,
            current_timestamp);
    return NEW;
end;
$$ language plpgsql;

create trigger trg_account_update
    after update
    on accounts
    for each row
execute function log_account_update();


create or replace function log_account_delete()
    returns trigger as
$$
begin
    insert into log_user (action, data_old, data_new, change_by, created_at)
    values ('DELETE',
            json_build_object(
                    'id', OLD.id,
                    'name', OLD.name,
                    'email', OLD.email,
                    'phone', OLD.phone,
                    'status', OLD.status
            )::text,
            null,
            current_user,
            current_timestamp);
    return OLD;
end;
$$ language plpgsql;

create trigger trg_account_delete
    after delete
    on accounts
    for each row
execute function log_account_delete();



update accounts
set status = 'inactive'
where email = 'nguyenvanan@gmail.com';


delete
from accounts
where email = 'hoangvanem@gmail.com';


select *
from log_user
order by created_at;

