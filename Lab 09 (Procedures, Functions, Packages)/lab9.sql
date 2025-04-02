--- Lab 9

-- use the following commands before executing PL/SQL blocks:
/*
set serveroutput on
set verify off
*/

-- Procedures:
/*
1. Write a procedure to display a message “Good Day to You”.
*/
create or replace procedure message is begin
    dbms_output.put_line('Good day to you');
end;
/

begin message; end;
/
/*
output:
Good day to you
*/

/*
2. Based on the University Database Schema in Lab 2, write a procedure which takes 
the dept_name as input parameter and lists all the instructors  associated with the 
department as well as list all the courses offered by the department. Also, write an 
anonymous block with the procedure call.
*/
create or replace procedure pro (v_dept_name instructor.dept_name%type) is begin
    dbms_output.put_line('Instructors');
    for i in (select name from instructor where dept_name = v_dept_name) loop
        dbms_output.put_line(i.name);
    end loop;
    for c in (select course_id, title from course where dept_name = v_dept_name) loop
        dbms_output.put_line('Course ID: ' || rpad(c.course_id, 10) || 'Course Title: ' || rpad(c.title, 50));
    end loop;
end;
/

declare d instructor.dept_name%type := '&d'; begin pro(d); end;
/
/*
output:
Enter value for d: Music
Instructors
Mozart
Course ID: MU-199    Course Title: Music Video Production
*/

/*
3. Based on the University Database Schema in Lab 2, write a Pl/Sql block of code 
that lists the most popular course (highest number of students take it) for each of 
the departments. It should make use of a procedure course_popular which  finds 
the most popular course in the given department.
*/
create or replace procedure course_popular(v_dept_name course.dept_name%type) is
    v_course_id course.course_id%type;
    v_title course.title%type;
begin
    select c.course_id, c.title
    into v_course_id, v_title
    from course c
    join takes t on c.course_id = t.course_id
    where c.dept_name = v_dept_name
    group by c.course_id, c.title
    order by count(t.id) desc
    fetch first 1 row only;
    dbms_output.put_line('dept: ' || rpad(v_dept_name, 12) || ' | course id: ' || rpad(v_course_id, 10) || ' | title: ' || v_title);
end course_popular;
/

declare
    cursor dept_cursor is select distinct dept_name from course;
    v_dept_name course.dept_name%type;
begin
    for dept_rec in dept_cursor loop
        v_dept_name := dept_rec.dept_name;
        course_popular(v_dept_name);
    end loop;
end;
/

/*
output:
dept: Biology      | course id: BIO-101    | title: Intro. to Biology
dept: Comp. Sci.   | course id: CS-101     | title: Intro. to Computer Science
dept: Elec. Eng.   | course id: EE-181     | title: Intro. to Digital Systems
dept: Finance      | course id: FIN-201    | title: Investment Banking
dept: History      | course id: HIS-351    | title: World History
dept: Music        | course id: MU-199     | title: Music Video Production
dept: Physics      | course id: PHY-101    | title: Physical Principles
*/

/*
4. Based on the University Database Schema in Lab 2, write a procedure which takes 
the  dept-name  as  input  parameter  and  lists  all  the  students  associated  with  the 
department as well as list all the courses offered by the department. Also, write an 
anonymous block with the procedure call.
*/
create or replace procedure list_department_details(v_dept_name course.dept_name%type) is
begin
    dbms_output.put_line('Students in ' || v_dept_name || ' department:');
    
    for s in (select id, name from student where dept_name = v_dept_name) loop
        dbms_output.put_line('ID: ' || s.id || ' | Name: ' || s.name);
    end loop;

    dbms_output.put_line('Courses offered by ' || v_dept_name || ' department:');
    
    for c in (select course_id, title from course where dept_name = v_dept_name) loop
        dbms_output.put_line('Course ID: ' || c.course_id || ' | Title: ' || c.title);
    end loop;
end list_department_details;
/

begin list_department_details('Music'); end;
/
/*
output:
Students in Music department:
ID: 55739 | Name: Sanchez
Courses offered by Music department:
Course ID: MU-199 | Title: Music Video Production
*/

-- Functions:
/*
5. Write a function to return the Square of a given number and call it from an    
anonymous block.
*/
create or replace function square(n number)
    return number as res number;
begin
    res := n*n;
    return res;
end;
/

begin dbms_output.put_line(square(5)); end;
/
/*
output:
25
*/

/*
6. Based on the University Database Schema in Lab 2, write a Pl/Sql block of code 
that lists the highest paid Instructor in each of the Department. It should make use 
of a function department_highest which returns the highest paid Instructor for the 
given branch.
*/
create or replace function department_highest(v_dept_name instructor.dept_name%type) 
return instructor%rowtype is
    v_instructor instructor%rowtype;
begin
    select * into v_instructor
    from instructor
    where dept_name = v_dept_name
    and salary = (select max(salary) from instructor where dept_name = v_dept_name);
    return v_instructor;
end department_highest;
/

declare
    cursor dept_cursor is select distinct dept_name from instructor;
    v_dept_name instructor.dept_name%type;
    v_instructor instructor%rowtype;
begin
    for dept_rec in dept_cursor loop
        v_dept_name := dept_rec.dept_name;
        v_instructor := department_highest(v_dept_name);
        dbms_output.put_line('Dept: ' || rpad(v_dept_name, 12) || ' | Highest paid instructor: ' || rpad(v_instructor.name, 12) || ' | Salary: ' || v_instructor.salary);
    end loop;
end;
/
/*
output:
Dept: Comp. Sci.   | Highest paid instructor: Brandt       | Salary: 92000
Dept: Finance      | Highest paid instructor: Wu           | Salary: 90000
Dept: Music        | Highest paid instructor: Mozart       | Salary: 40000
Dept: Physics      | Highest paid instructor: Einstein     | Salary: 95000
Dept: History      | Highest paid instructor: Califieri    | Salary: 62000
Dept: Biology      | Highest paid instructor: Crick        | Salary: 72000
Dept: Elec. Eng.   | Highest paid instructor: Kim          | Salary: 80000
*/

-- Packages:
/*
7. Based on the University Database Schema in Lab 2, create a package to include 
the following: 
    a) A named procedure to list the instructor_names of given department 
    b) A function which returns the max salary for the given department 
    c) Write a PL/SQL block to demonstrate the usage of above package components
*/
create or replace package pack as
    procedure pro(v_dept_name instructor.dept_name%type);
    function func(v_dept_name instructor.dept_name%type) return instructor.salary%type;
end pack;
/

create or replace package body pack as
    procedure pro(v_dept_name instructor.dept_name%type) is
    begin
        dbms_output.put_line('Instructors in ' || v_dept_name || ' department:');
        for i in (select name from instructor where dept_name = v_dept_name) loop
            dbms_output.put_line(i.name);
        end loop;
    end pro;

    function func(v_dept_name instructor.dept_name%type) return instructor.salary%type is
        v_max_salary instructor.salary%type;
    begin
        select max(salary) into v_max_salary from instructor where dept_name = v_dept_name;
        return v_max_salary;
    end func;
end pack;
/

declare
    v_max_salary instructor.salary%type;
begin
    pack.pro('Music');
    v_max_salary := pack.func('Music');
    dbms_output.put_line(chr(10) || 'Max salary in department ' || 'Music' || ' is: ' || v_max_salary);
end;
/
/*
output:
Instructors in Music department:
Mozart

Max salary in department Music is: 40000
*/

-- Parameter Modes: IN, OUT, IN OUT
/*
8. Write  a  PL/SQL  procedure  to  return  simple  and  compound  interest  (OUT 
parameters) along with the Total Sum (IN OUT) i.e. Sum of Principle and Interest 
taking as input the principle, rate of interest and number of years (IN parameters). 
Call this procedure from an anonymous block.
*/
create or replace procedure calc_interest(
    p_principal in number,
    p_rate in number,
    p_years in number,
    p_simple out number,
    p_compound out number,
    p_total in out number
) is
begin
    p_simple := (p_principal * p_rate * p_years) / 100;
    p_compound := p_principal * power((1 + p_rate / 100), p_years) - p_principal;
    p_total := p_principal + p_compound;
end calc_interest;
/

declare
    v_principal number := &principal;
    v_rate number := &rate;
    v_years number := &years;
    v_simple number;
    v_compound number;
    v_total number := v_principal;
begin
    calc_interest(v_principal, v_rate, v_years, v_simple, v_compound, v_total);

    dbms_output.put_line('simple interest: ' || v_simple);
    dbms_output.put_line('compound interest: ' || v_compound);
    dbms_output.put_line('total amount: ' || v_total);
end;
/
/*
output:
Enter value for principal: 10000
Enter value for rate: 5
Enter value for years: 3
simple interest: 1500
compound interest: 1576.25
total amount: 11576.25
*/