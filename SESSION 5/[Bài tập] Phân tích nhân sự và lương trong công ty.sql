create  table department(
    dept_id serial primary key ,
    dept_name varchar(100)
);

create table employees(
    emp_id serial primary key ,
    emp_name varchar(50),
    dept_id int references department(dept_id),
    salary float,
    hire_date date
);

create table projects (
    prj_id serial primary key ,
    prj_name varchar(50),
    dept_id int references department(dept_id)
);


insert into department (dept_name)
values ('Hr'),
('nhan su'),
('IT'),
('MKT'),
('ke toan'),
('su kien');

insert into employees (emp_name, dept_id, salary, hire_date)
values ('huy','1','1000000','13-03-1999'),
       ('an', '1', '1500000', '18-03-1989'),
       ('thanh', '2', '1200000', '22-02-2000'),
       ('nhan', '3', '1100000', '07-12-2002'),
       ('thao', '4', '1400000', '26-1-2005'),
       ('kim', '5', '2500000', '5-1-1997'),
       ('nhat', '6', '1100000', '26-1-2005'),
       ('thinh', '6', '1100000', '21-1-2005'),
       ('hoai', '6', '1100000', '20-12-2005');

insert into projects (prj_name, dept_id)
VALUES ('appp= ngan hang', '2'),
       ('tuyen nhan su', '4'),
       ('san khau dien anh', '6'),
       ('quang cao', '3'),
       ('Quan ly', '1'),
       ('bang luong', '5');


--1 Hiển thị danh sách nhân viên gồm: Tên nhân viên, Phòng ban, Lương
-- dùng bí danh bảng ngắn (employees as e,departments as d).

select e.emp_name, e.salary, d.dept_id, d.dept_name
from employees e
join department d on e.emp_id = d.dept_id
group by e.emp_name, e.salary , d.dept_id, d.dept_name;


--2 Aggregate Functions:
-- Tính:
-- Tổng quỹ lương toàn công ty
-- Mức lương trung bình
-- Lương cao nhất, thấp nhất
-- Số nhân viên


select sum(salary)
from employees;

select avg(salary) from employees;

select max(salary), min(salary) from employees;

select count(employees.emp_id) from employees;


--3 GROUP BY / HAVING:
-- Tính mức lương trung bình của từng phòng ban
    select avg(e.salary), d.dept_name, d.dept_id from employees e
        join department d on e.emp_id = d.dept_id
        group by e.salary, d.dept_name, d.dept_id;
-- chỉ hiển thị những phòng ban có lương trung bình > 15.000.000
select avg(e.salary), d.dept_name, d.dept_id
from employees e
         join department d on e.emp_id = d.dept_id
group by e.salary, d.dept_name, d.dept_id having avg(e.salary) > 1500000;

--4 Liệt kê danh sách dự án (project) cùng với phòng ban phụ trách và nhân viên thuộc phòng ban đó
select p.dept_id, p.prj_name, e.emp_id, e.emp_name, d.dept_name
    from projects p join department d on p.dept_id = d.dept_id
join employees e on d.dept_id = e.dept_id


-- 5 Subquery:
-- Tìm nhân viên có lương cao nhất trong mỗi phòng ban
-- Gợi ý: Subquery lồng trong WHERE salary = (SELECT MAX(...))

/*
luong cao nhat cau tung p ban
lay tt cua tung p ban co luong = luong max
*/

select e.*
from employees e where (e.dept_id, e.salary) in
    (select e.dept_id, max(e.salary)
    from employees e group by e.dept_id) ;






