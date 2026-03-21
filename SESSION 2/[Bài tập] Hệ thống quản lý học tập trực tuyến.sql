create schema elearning;

create schema elearning;

create table elearning.Students
(
    student_id serial primary key,
    first_name varchar(50)  not null,
    last_name  varchar(50)  not null,
    email      varchar(100) not null unique
);

create table elearning.Instructors
(
    instructor_id serial primary key,
    first_name    varchar(50)  not null,
    last_name     varchar(50)  not null,
    email         varchar(100) not null unique
);

CREATE Table elearning.Courses
(
    course_id     SERIAL PRIMARY KEY,
    course_name   VARCHAR(100) NOT NULL,
    instructor_id int,
    Foreign Key (instructor_id) REFERENCES elearning.Instructors (instructor_id)
);

CREATE TABLE elearning.Enrollments
(
    enrollment_id SERIAL PRIMARY KEY,
    student_id    int,
    course_id     int,
    enroll_date   date NOT NULL,
    Foreign Key (student_id) REFERENCES elearning.Students (student_id),
    Foreign Key (course_id) REFERENCES elearning.Courses (course_id)
);

CREATE TABLE elearning.Assignments
(
    assignment_id SERIAL PRIMARY KEY,
    course_id     int,
    title         VARCHAR(100) NOT NULL,
    due_date      date         NOT NULL,
    Foreign Key (course_id) REFERENCES elearning.Courses (course_id)
);

CREATE TABLE elearning.Submissions
(
    submission_id   SERIAL PRIMARY KEY,
    assignment_id   int,
    student_id      int,
    submission_date date NOT NULL,
    grade           int,
    Foreign Key (assignment_id) REFERENCES elearning.Assignments (assignment_id),
    Foreign Key (student_id) REFERENCES elearning.Students (student_id)
);



