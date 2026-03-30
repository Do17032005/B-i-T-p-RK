create table std(
    std_id serial primary key ,
    name varchar(50),
    major varchar(50)
);

create table courses(
    cs_id serial primary key ,
    cs_name varchar(50),
    credit int
);

create table enrollments(
    std_id int references std(std_id),
    cs_id int references courses(cs_id),
    score numeric(5,2)
);


insert into std(name, major) VALUES ('an','CNTT'),
                                    ('do','CNTT'),
                                    ('minh','ke toan'),
                                    ('hoa','mkt'),
                                    ('ha','mkt'),
                                    ('thanh','luat');

insert into courses(cs_name, credit)
VALUES ('300 bai code','1500000'),
       ('luat co ban', '2000000'),
       ('nhap mon ke toan','1200000'),
       ('co so mkt','2500000');

insert into enrollments(std_id, cs_id, score)
VALUES ('1', '1','9.0'),
       ('2','1','9.0'),
       ('3','3','8.5'),
        ('4','4','6.5'),
        ('5','4','9.5'),
        ('6','2','7.2');


--1 Liệt kê danh sách sinh viên cùng tên môn học và điểm
    select s.name as "ten sinh vien", c.cs_name as "ten mon hoc", en.score as "diem"  from enrollments en join std s on en.std_id = s.std_id
    join courses c on en.cs_id = c.cs_id group by s.name, c.cs_name, en.score;
-- dùng bí danh bảng ngắn (vd. s, c, e)
-- và bí danh cột như Tên sinh viên, Môn học, Điểm

--2 Aggregate Functions:
-- Tính cho từng sinh viên:
-- Điểm trung bình
-- Điểm cao nhất
-- Điểm thấp nhất

select s.std_id, s.name, avg(en.score), max(en.score), min(en.score) from std s
    join enrollments en on s.std_id = en.std_id
group by s.std_id, s.name;


--3 se
select s.major, avg(e.score) from std s join enrollments e on s.std_id = e.std_id group by s.major;

--4
select *
from std s join enrollments en on s.std_id = en.std_id
join courses c on en.cs_id = c.cs_id;

--5
/*
lay diem tb toan trg
lay tt sv co diem tb cao hon tb toan truong
*/

select s.std_id, s.name, avg(e.score)
from std s join enrollments e on s.std_id = e.std_id
group by s.std_id, s.name
having avg(e.score) > (select avg(e.score) from enrollments e);

select avg(e.score)
from enrollments e;
