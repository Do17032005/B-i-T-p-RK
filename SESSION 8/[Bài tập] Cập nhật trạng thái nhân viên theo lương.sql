
create table employees(
    id serial primary key ,
    name varchar(200),
    department varchar(50),
    salary numeric(10,2),
    bonus numeric(10,2) default 0
);

drop table employees;

insert into employees (name, department, salary) VALUES
    ('nguyen van A','Hr', '4000'),
    ('tran thi b','IT','6000'),
    ('le van c', 'finance','10500'),
    ('pham thi D','IT','8000'),
    ('do van e','HR','12000');

-- Yêu cầu xử lý:
--
-- Nếu nhân viên không tồn tại, ném lỗi "Employee not found"
-- Nếu lương < 5000 → cập nhật status = 'Junior'
-- Nếu lương từ 5000–10000 → cập nhật status = 'Mid-level'
-- Nếu lương > 10000 → cập nhật status = 'Senior’
-- Trả ra p_status sau khi cập nhật

create or replace procedure update_employee_status (in p_emp_id int, out p_status text)
language plpgsql
as $$
    declare
        v_salary numeric(10.2);
    begin
        select v_salary from employees where id = p_emp_id;

        if not FOUND then
            raise exception 'Employee not found';
        end if;

        IF v_salary < 5000 THEN
            p_status := 'Junior';
        ELSIF v_salary <= 10000 THEN
            p_status := 'Mid-level';
        ELSE
            p_status := 'Senior';
        END IF;

        update employees set

    end;
    $$