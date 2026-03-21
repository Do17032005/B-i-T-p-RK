create table Departments(
    department_id serial primary key ,
    department_name varchar(50)
);


create table Employees (
    emp_id serial primary key ,
    name varchar(50) not null ,
    dob date,
    department_id int,
    foreign key (department_id) references departments(department_id)
);

create table Projects (
    project_id serial primary key ,
    project_name varchar(50),
    start_date date,
    end_date date
);

create table EmployeeProjects(
    emp_id serial primary key ,
    project_id int ,
    foreign key (project_id) references projects(project_id)
);


