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
    dbms_output.put_line("Instructors")
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
Name: Mozart
Course ID: MU-199    Course Title: Music Video Production
*/

/*
3. Based on the University Database Schema in Lab 2, write a Pl/Sql block of code 
that lists the most popular course (highest number of students take it) for each of 
the departments. It should make use of a procedure course_popular which  finds 
the most popular course in the given department.
*/
create or replace procedure course_popular is
    v_dept_name department.dept_name%type;
begin
    for i in (
        select c.course_id, c.title
        from course c, takes t, department d
        where c.course_id = t.course_id
        group by t.dept_name
    ) loop
        dbms_output.put_line('Department: ' || t.dept_name);
        dbms_output.put_line('Course ID: ' || c.course_id || ' Course Title: ' || c.title);


/*
4. Based on the University Database Schema in Lab 2, write a procedure which takes 
the  dept-name  as  input  parameter  and  lists  all  the  students  associated  with  the 
department as well as list all the courses offered by the department. Also, write an 
anonymous block with the procedure call.
*/

-- Functions:
/*
5. Write a function to return the Square of a given number and call it from an    
anonymous block.
*/


/*
6. Based on the University Database Schema in Lab 2, write a Pl/Sql block of code 
that lists the highest paid Instructor in each of the Department. It should make use 
of a function department_highest which returns the highest paid Instructor for the 
given branch.
*/


-- Packages:
/*
7. Based on the University Database Schema in Lab 2, create a package to include 
the following: 
    a) A named procedure to list the instructor_names of given department 
    b) A function which returns the max salary for the given department 
    c) Write a PL/SQL block to demonstrate the usage of above package components
*/


-- Parameter Modes: IN, OUT, IN OUT
/*
8. Write  a  PL/SQL  procedure  to  return  simple  and  compound  interest  (OUT 
parameters) along with the Total Sum (IN OUT) i.e. Sum of Principle and Interest 
taking as input the principle, rate of interest and number of years (IN parameters). 
Call this procedure from an anonymous block.
*/

