create table Students(
    student_id serial primary key ,
    name varchar(50) not null ,
    dob date
);


create table Courses (
    course_id serial primary key ,
    course_name varchar(100) not null ,
    credits int
);


create table Enrollments(
    enrollment_id serial primary key ,
    student_id int,
    foreign key (student_id) references students(student_id),
    course_id int,
    foreign key (course_id) references courses(course_id),
    grade varchar(10)  check ( grade in ('A', 'B', 'C', 'D') )
);


