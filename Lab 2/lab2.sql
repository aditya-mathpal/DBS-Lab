-- LAB-2:

-- 1
create table employee (
    EmpNo number(10) primary key,
    EmpName varchar(15) not null,
    Gender char(1) not null check (Gender = 'M' or Gender = 'F'),
    Salary number(10) not null,
    Address varchar(20) not null,
    DNo number(10)
);

-- 2
create table department (
    DeptNo number(10) primary key,
    DeptName varchar(15) unique not null,
    Location varchar(15)
);

-- 3
alter table employee add constraint c1 foreign key (DNo) references department (DeptNo);

-- 4
insert into employee values (101,'Aditya','M',10000000,'Mumbai',5);
insert into employee values (102,'Aditi','F',9000000,'Delhi',6);
insert into department values (5,'IT','Bangalore');
insert into department values (6,'Sales','Mumbai');

-- 5
insert into employee values (101,'John','X',10,'Mumbai',5); -- gender check constraint violated
insert into employee values (101,NULL,'M',10,'Mumbai',5); -- not null constraint violated
insert into department values (5,'IT','Bangalore'); -- unique constraint violated

-- 6
delete from department where deptname='IT';
/*
ERROR at line 1:
ORA-02292: integrity constraint (C37.SYS_C00151690) violated - child record
found
*/

-- 7
alter table employee add constraint c1 foreign key (DNo) references department (DeptNo) on delete cascade;

-- 8
alter table employee modify salary default 10000;

-- Import university database
@"D:\230905232\University.sql"
@"D:\230905232\smallRelations.sql"

-- 9
select name, dept_name from student;

-- 10
select id, name from instructor where dept_name = 'Comp. Sci.';

-- 11
select title from course where dept_name = 'Comp. Sci.' and credits = 3;

-- 12
select t.course_id, c.title from course c, takes t where t.course_id = c.course_id and t.id = 12345;

-- 13
select * from instructor where (salary > 40000) and (salary < 90000);

-- 14
