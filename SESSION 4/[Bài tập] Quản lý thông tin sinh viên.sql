create table students (
    students_is serial primary key ,
    stident_name varchar(50) not null ,
    age int,
    major varchar(50),
    gpa decimal(3,2)
);

insert into students values ('1','AN','20','CNTT','3.5');
insert into students
values ('2', 'binh', '21', 'Toan', '3.2');
insert into students
values ('3', 'Cuong', '22', 'CNTT', '3.8');
insert into students
values ('4', 'Duong', '20', 'vat ly', '3.0');
insert into students
values ('5', 'em', '21', 'CNTT', '2.9');


insert into students
values ('6','hhung','23','hoa hoc','3.4');

update students set gpa = '3.6' where students_is = 2;

delete from students where gpa <'3.0';

select stident_name, major, gpa from students order by gpa desc ;

select stident_name from students where major = 'CNTT';

select * from students where gpa between '3.0' and '3.6';

select * from students where stident_name ilike 'C%';

select * from students order by students_is asc limit 3;

select *
from students
order by students_is asc
limit 3 offset 1;


-- Thêm sinh viên mới: "Hùng", 23 tuổi, chuyên ngành "Hóa học", GPA 3.4
-- Cập nhật GPA của sinh viên "Bình" thành 3.6
-- Xóa sinh viên có GPA thấp hơn 3.0
-- Liệt kê tất cả sinh viên, chỉ hiển thị tên và chuyên ngành, sắp xếp theo GPA giảm dần
-- Liệt kê tên sinh viên duy nhất có chuyên ngành "CNTT"
-- Liệt kê sinh viên có GPA từ 3.0 đến 3.6
-- Liệt kê sinh viên có tên bắt đầu bằng chữ 'C' (sử dụng LIKE/ILIKE)
-- Hiển thị 3 sinh viên đầu tiên theo thứ tự tên tăng dần, hoặc lấy từ sinh viên thứ 2 đến thứ 4 bằng LIMIT và OFFSET