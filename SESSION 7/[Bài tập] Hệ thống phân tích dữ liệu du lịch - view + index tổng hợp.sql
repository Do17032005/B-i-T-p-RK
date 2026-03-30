-- Active: 1773844200417@@127.0.0.1@5432@btss7
create table patients
(
    patient_id serial primary key,
    full_name  varchar(50),
    phonr      varchar(50),
    city       varchar(50),
    symptoms   text[]
);

create table doctors
(
    doctor_id  serial primary key,
    full_name  varchar(50),
    department varchar(50)
);

create table appointments
(
    appointment_id   serial primary key,
    patient_id       int references patients (patient_id),
    doctor_id        int references doctors (doctor_id),
    appointment_date date,
    diagnosis        varchar(200),
    fee              numeric(10, 2)
);

-- Chèn dữ liệu bệnh nhân (5 bệnh nhân)
insert into patients (full_name, phonr, city, symptoms)
VALUES ('Nguyễn Văn An', '0912345678', 'Hà Nội', ARRAY ['sốt', 'đau đầu', 'ho']),
       ('Trần Thị Bình', '0923456789', 'Hồ Chí Minh', ARRAY ['đau bụng', 'buồn nôn']),
       ('Lê Văn Cường', '0934567890', 'Đà Nẵng', ARRAY ['đau lưng', 'mệt mỏi']),
       ('Phạm Thị Dung', '0945678901', 'Hải Phòng', ARRAY ['đau khớp', 'sưng viêm']),
       ('Hoàng Văn Em', '0956789012', 'Cần Thơ', ARRAY ['ho', 'khó thở', 'đau ngực']),
       ('Vũ Thị Hoa', '0967890123', 'Huế', ARRAY ['mất ngủ', 'căng thẳng']),
       ('Đỗ Văn Kiên', '0978901234', 'Nha Trang', ARRAY ['đau răng', 'sốt nhẹ']);

-- Chèn dữ liệu bác sĩ (5 bác sĩ)
insert into doctors (full_name, department)
VALUES ('BS. Nguyễn Minh Tuấn', 'Nội khoa'),
       ('BS. Trần Thị Lan', 'Ngoại khoa'),
       ('BS. Lê Văn Hùng', 'Tim mạch'),
       ('BS. Phạm Thị Mai', 'Nhi khoa'),
       ('BS. Hoàng Văn Nam', 'Da liễu'),
       ('BS. Vũ Thị Hương', 'Thần kinh'),
       ('BS. Đỗ Văn Long', 'Răng hàm mặt');

-- Chèn dữ liệu cuộc hẹn (10 cuộc hẹn)
insert into appointments (patient_id, doctor_id, appointment_date, diagnosis, fee)
VALUES (1, 1, '2024-03-15', 'Viêm đường hô hấp trên', 300000.00),
       (2, 2, '2024-03-16', 'Viêm dạ dày cấp', 450000.00),
       (3, 3, '2024-03-17', 'Thoát vị đĩa đệm', 550000.00),
       (4, 1, '2024-03-18', 'Viêm khớp dạng thấp', 400000.00),
       (5, 3, '2024-03-19', 'Hen phế quản', 500000.00),
       (1, 2, '2024-03-20', 'Tái khám sau điều trị', 250000.00),
       (6, 6, '2024-03-21', 'Rối loạn lo âu', 600000.00),
       (7, 7, '2024-03-22', 'Sâu răng', 350000.00),
       (2, 1, '2024-03-23', 'Tái khám viêm dạ dày', 300000.00),
       (3, 4, '2024-03-24', 'Tư vấn vật lý trị liệu', 400000.00),
       (5, 3, '2024-03-25', 'Kiểm tra tim mạch định kỳ', 450000.00),
       (4, 5, '2024-03-26', 'Viêm da cơ địa', 380000.00);


--1 B-tree: tìm bệnh nhân theo số điện thoại (phone)
create index idx_btree_phone on patients (phonr);
select *
from patients
where phonr = '0967890123';
-- Hash: tìm bệnh nhân theo city
create index idx_hash_city on patients using hash (city);
select *
from patients
where city = 'Hà Nội';
-- GIN: tìm bệnh nhân theo từ khóa trong mảng symptoms
create index ind_gin_symtoms on patients using gin (symptoms);
select *
from patients
where symptoms && array ['sốt', 'sưng viêm'];

select *
from patients
where 'sốt' = any (symptoms);


-- GiST: tìm cuộc hẹn theo khoảng phí (fee)
create extension if not exists btree_gist;
create index idx_gist_fee on appointments using gist (fee);


--3 Tạo Clustered Index trên bảng appointments theo ngày khám
create index idx_appointment_date on appointments (appointment_date);
cluster appointments using idx_appointment_date;
--4 Thực hiện các truy vấn trên View:
-- Tìm top 3 bệnh nhân có tổng phí khám cao nhất
create view v_benh_nhan_co_chi_phi_cao_nhat as
select p.full_name, p.phonr, sum(a.fee) as "tong chi phi"
from patients p
         join appointments a on p.patient_id = a.patient_id
group by p.full_name, p.phonr
order by "tong chi phi" desc
limit 3;

-- Tính tổng số lượt khám theo bác sĩ
create view v_so_luong_kham as
select d.doctor_id, d.full_name as "ten bac si", count(a.appointment_id)
from doctors d
         join appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id, d.full_name;
-- 5Tạo View có thể cập nhật để thay đổi city của bệnh nhân:

create view apdtecity as
select p.patient_id, p.full_name
from patients p
where p.city in ('ha noi');