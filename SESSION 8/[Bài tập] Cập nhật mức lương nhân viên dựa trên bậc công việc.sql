-- Active: 1773844200417@@127.0.0.1@5432@ss8@public
create table employees(
    emp_id serial primary key ,
    emp_name varchar(50),
    job_level int,
    salary numeric
);

drop table employees;

insert into employees (emp_name, job_level, salary) VALUES
('diod','2','500000');


-- 1Tạo Procedure adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC) để:
-- Nhận emp_id của nhân viên
-- Cập nhật lương theo quy tắc trên
-- Trả về p_new_salary (lương mới) sau khi cập nhật

create or replace procedure adjust_salary(
    in p_emp_id int, out p_new_salary numeric
)
    language plpgsql
as
$$
    declare
        p_level int;
        p_salary numeric;
begin
        select e.job_level into p_level from employees e where e.emp_id = p_emp_id;
        select e.salary into p_salary from employees e where e.emp_id = p_emp_id;
--         select job_level, salaly
--         into p_level, p_salary

        if p_level =1 then
            p_new_salary := p_salary*1.05;
            elseif p_level =2 then
        p_new_salary := p_salary * 1.10;
        elseif p_level = 1 then
            p_new_salary := p_salary * 1.15;
        end if;

end;
$$;

call adjust_salary(1, null);

do
$$
    declare
        v_new_salary numeric;
    begin
        call adjust_salary(1, v_new_salary);
        raise notice 'New salary: %', v_new_salary;
    end
$$;