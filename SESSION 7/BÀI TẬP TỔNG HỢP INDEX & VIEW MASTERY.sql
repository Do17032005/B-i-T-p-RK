CREATE TABLE if not exists SinhVien
(
    id         SERIAL PRIMARY KEY,
    ma_sv      VARCHAR(20) UNIQUE,
    ho_ten     VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL,
    gioi_tinh  VARCHAR(10),
    que_quan   VARCHAR(100),
    ngay_sinh  DATE,
    lop_id     INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE if not exists LopHoc
(
    id      SERIAL PRIMARY KEY,
    ma_lop  VARCHAR(20) UNIQUE,
    ten_lop VARCHAR(100),
    khoa_id INTEGER
);
CREATE TABLE if not exists BangDiem
(
    id           SERIAL PRIMARY KEY,
    sinh_vien_id INTEGER,
    mon_hoc_id   INTEGER,
    diem_so      DECIMAL(4, 2),
    hoc_ky       VARCHAR(10),
    created_at   TIMESTAMP DEFAULT NOW()
);
CREATE TABLE if not exists MonHoc
(
    id      SERIAL PRIMARY KEY,
    ma_mon  VARCHAR(20) UNIQUE,
    ten_mon VARCHAR(100)
);

-- =========================
-- 1) Dữ liệu bảng LopHoc
-- =========================
insert into LopHoc (ma_lop, ten_lop, khoa_id)
values ('CNTT01', 'Công nghệ thông tin 1', 1),
       ('CNTT02', 'Công nghệ thông tin 2', 1),
       ('QTKD01', 'Quản trị kinh doanh 1', 2),
       ('KT01', 'Kế toán 1', 3),
       ('NNA01', 'Ngôn ngữ Anh 1', 4);

-- =========================
-- 2) Dữ liệu bảng MonHoc
-- =========================
insert into MonHoc (ma_mon, ten_mon)
values ('SQL01', 'Cơ sở dữ liệu'),
       ('JAVA01', 'Lập trình Java'),
       ('WEB01', 'Thiết kế Web'),
       ('MKT01', 'Marketing căn bản'),
       ('ENG01', 'Tiếng Anh giao tiếp');

-- =========================
-- 3) Dữ liệu bảng SinhVien
-- =========================
insert into SinhVien
    (ma_sv, ho_ten, email, gioi_tinh, que_quan, ngay_sinh, lop_id)
values ('SV001', 'Nguyen Van A', 'a@gmail.com', 'Nam', 'Ha Noi', '2004-01-10', 1),
       ('SV002', 'Tran Thi B', 'b@gmail.com', 'Nu', 'Hai Phong', '2004-03-15', 2),
       ('SV003', 'Le Van C', 'c@gmail.com', 'Nam', 'Da Nang', '2003-11-20', 3),
       ('SV004', 'Pham Thi D', 'd@gmail.com', 'Nu', 'Nam Dinh', '2004-07-08', 4),
       ('SV005', 'Hoang Van E', 'e@gmail.com', 'Nam', 'Nghe An', '2003-09-30', 5);

-- =========================
-- 4) Dữ liệu bảng BangDiem
-- =========================
insert into BangDiem
    (sinh_vien_id, mon_hoc_id, diem_so, hoc_ky)
values (1, 1, 8.50, 'HK1'),
       (2, 2, 7.25, 'HK1'),
       (3, 3, 9.00, 'HK1'),
       (4, 4, 6.75, 'HK1'),
       (5, 5, 8.00, 'HK1');

select *
from SinhVien
where email = 'd@gmail.com';

explain analyse
select *
from SinhVien
where email = 'd@gmail.com';

explain
select *
from SinhVien
where email = 'd@gmail.com';

create index ind_sinhvien_email on
    sinhvien (email);

drop index ind_sinhvien_email;

create index idx_sinhvien_lop_id
    on SinhVien (lop_id);

create index idx_sinhvien_que_quan
    on SinhVien (que_quan);

create index idx_sinhvien_gioitinh_quequan
    on SinhVien (gioi_tinh, que_quan);

explain analyse
select *
from sinhvien;

create or replace view v_bao_cao_diem as
select s.ma_sv, s.ho_ten, s.email, l.ten_lop, count(bd.id) as so_mon_hoc, avg(bd.diem_so) as dtb
from SinhVien s
         join LopHoc l on s.id = l.id
         join BangDiem bd on s.id = bd.id
group by s.ma_sv, s.ho_ten, s.email, l.ten_lop;

select *
from BangDiem;

select *
from v_bao_cao_diem;

create or replace view v_thong_ke_lop_hoc
as
select l.id,
       l.ma_lop,
       l.ten_lop,
       count(s.id)     as si_so,
       avg(bd.diem_so) as diem_trung_binh,
       case
           when avg(bd.diem_so) >= 8 then 'GIOI'
           when avg(bd.diem_so) >= 6.5 then 'KHA'
           when avg(bd.diem_so) < 6.5 then 'TRUNG BINH'
           else 'YEU'
           end
                       as phan_loai_hoc_luc
from LopHoc l
         join sinhvien s on l.id = s.id
         join BangDiem bd on s.id = bd.id
group by l.id, l.ma_lop, l.ten_lop
order by l.id;

select *
from v_thong_ke_lop_hoc;

create materialized view mv_thong_ke_toan_truong as
select s.ho_ten,
       s.que_quan,
       s.gioi_tinh,
       count(s.id) as so_luong,
       avg(bd.diem_so)
from SinhVien s
         join BangDiem bd on s.id = bd.id
group by s.ho_ten, s.que_quan, s.gioi_tinh;

select *
from mv_thong_ke_toan_truong;


create or replace view v_svca as
select ma_sv,
       ten_lop,
       email,
       dtb
from v_bao_cao_diem;

select *
from v_svca;

-- View cho giảng viên - ẩn thông tin nhạy cảm

CREATE VIEW v_giang_vien AS

SELECT ma_sv,
       ho_ten,
       ten_lop,
       dtb
FROM v_bao_cao_diem;

select *
from v_giang_vien;