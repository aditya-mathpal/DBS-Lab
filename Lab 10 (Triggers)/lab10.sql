--- Lab 10

-- use the following commands before executing PL/SQL blocks:
/*
set serveroutput on
set verify off
*/

-- Row Triggers
/*
1. Based on the University database Schema in Lab 2, write a row trigger that records 
along with the time any change made in the Takes (ID, course-id, sec-id, semester, 
year,  grade)  table  in  log_change_Takes  (Time_Of_Change,  ID,  courseid,sec-id, 
semester, year, grade).
*/

-- alter the date output format via the following command to include time:
-- ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

create table log_change_takes (
    Time_Of_Change date,
    ID varchar2(5),
    course_id varchar2(8),
    sec_id varchar2(8),
    semester varchar2(6),
    year number(4),
    grade varchar2(2)
);

create or replace trigger trig
after insert or update or delete on takes
for each row begin
    if inserting or updating then
        insert into log_change_takes values(sysdate, :new.id, :new.course_id, :new.sec_id, :new.semester, :new.year, :new.grade);
    elsif deleting then
        insert into log_change_takes values(sysdate, :old.id, :old.course_id, :old.sec_id, :old.semester, :old.year, :old.grade);
    end if;
end;
/

delete from takes where ID = 55739 and course_id = 'MU-199';
/*
output:
TIME_OF_CHANGE      ID    COURSE_I SEC_ID   SEMEST       YEAR GR
------------------- ----- -------- -------- ------ ---------- --
2025-04-03 14:44:33 55739 MU-199   1        Spring       2010 A-
*/

/*
2. Based on the University database schema in Lab: 2, write a row trigger to insert 
the existing values of the Instructor (ID, name, dept-name, salary) table into a new 
table Old_ Data_Instructor (ID, name, dept-name, salary) when the salary table is 
updated.
*/
create table old_data_instructor (
    id varchar2(5),
    name varchar2(20),
    dept_name varchar2(20),
    salary number(8, 2)
);

create or replace trigger log_instructor 
before update on instructor
for each row begin
    insert into old_data_instructor values (:old.id, :old.name, :old.dept_name, :old.salary);
end;
/

update instructor set salary = salary*1.2 where name = 'Srinivasan';

/*
output:
ID    NAME                 DEPT_NAME                SALARY
----- -------------------- -------------------- ----------
10101 Srinivasan           Comp. Sci.                65000
*/

-- Database Triggers
/*
3. Based on the University Schema, write a database trigger on Instructor that checks 
the following: 
 The name of the instructor is a valid name containing only alphabets. 
 The salary of an instructor is not zero and is positive 
 The  salary  does  not  exceed  the  budget  of  the  department  to  which  the 
instructor belongs.
*/
create or replace trigger check_instructor
before update or insert on instructor
for each row
declare v_budget department.budget%type;
begin
    select budget into v_budget from department where dept_name = :new.dept_name;
    if not regexp_like(:new.name, '^[A-Za-z]+$') or :new.salary <= 0 or :new.salary > v_budget then
        raise_application_error(-1, 'Error');
    end if;
end;
/

update instructor set salary = 999999 where name = 'Gold';
/*
output:
ERROR at line 1:
ORA-21000: error number argument to raise_application_error of -1 is out of range
ORA-06512: at "C37.CHECK_INSTRUCTOR", line 5
ORA-04088: error during execution of trigger 'C37.CHECK_INSTRUCTOR'
*/

/*
4. Create  a  transparent  audit  system  for  a  table  Client_master  (client_no,  name, 
address,  Bal_due).  The  system  must  keep  track  of  the  records  that  are  being 
deleted or updated. The functionality being when a record is deleted or modified 
the original record details and the date of operation are stored in the auditclient 
(client_no,  name,  bal_due,  operation,  userid,  opdate)  table,  then  the  delete  or 
update is allowed to go through.
*/
create table client_master (
    client_no number,
    name varchar2(20),
    address varchar2(20),
    bal_due number(10, 2)
);
insert into client_master values (999, 'James', 'Ontario', 10000);
create table auditclient (
    client_no number,
    name varchar2(20),
    bal_due number(10, 2),
    operation varchar2(10),
    userid number,
    opdate date
);

create or replace trigger log_client
before update or delete on client_master
for each row begin
    if deleting then
        insert into auditclient values (:old.client_no, :old.name, :old.bal_due, 'Deletion', 123, sysdate);
    elsif updating then
        insert into auditclient values (:old.client_no, :old.name, :old.bal_due, 'Modification', 123, sysdate);
    end if;
end;
/

delete from client_master where client_no = 999;
/*
output:
 CLIENT_NO NAME                    BAL_DUE OPERATION      USERID OPDATE
---------- -------------------- ---------- ---------- ---------- -------------------
       999 James                     10000 Deletion          123 2025-04-03 15:28:03
*/

-- Instead of Triggers
/*
5. Based on the University database Schema in Lab 2, create a view Advisor_Student 
which  is  a  natural  join  on  Advisor,  Student  and  Instructor  tables.  Create  an 
INSTEAD  OF  trigger  on  Advisor_Student  to  enable  the  user  to  delete  the 
corresponding entries in Advisor table.
*/
create view Advisor_Student as
select a.s_id, a.i_id
from advisor a
join student s on a.s_id = s.id
join instructor i on a.i_id = i.id;

create or replace trigger del
instead of delete on Advisor_Student
for each row begin
    delete from advisor where s_id = :old.s_id or i_id = :old.i_id;
end;
/

delete from Advisor_Student where s_id = 12345;

/*
output:
Record deleted
*/