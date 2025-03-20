-- Lab-8

-- use the following commands before executing PL/SQL blocks:
/*
set serveroutput on
set verify off
*/

-- CursorName %ISOPEN / FOUND / NOT FOUND: 
/*
1. The HRD manager has decided to raise the salary of all the Instructors in a given 
department number by 5%. Whenever, any such raise is given to the instructor, a 
record for the same is maintained in the salary_raise table. It includes the Instuctor 
Id, the date when the raise was given and the actual raise amount. Write a PL/SQL 
block to update the salary of each Instructor and insert a record in the salary_raise 
table.  
salary_raise(Instructor_Id, Raise_date, Raise_amt)
*/
create table salary_raise (
    Instructor_Id number(5) primary key,
    Raise_date date,
    Raise_amt number(8, 2)
);
declare
    cursor c1 is select * from instructor;
    i c1%rowtype;
    s_id number(5);
    s_raise_date date;
    s_raise_amt number(8, 2);
begin
    open c1;
    loop
        fetch c1 into i;
        exit when c1%notfound;
        s_id := i.id;
        s_raise_date := to_date('20-03-2025', 'DD-MM-YYYY');
        s_raise_amt := 0.05 * i.salary;
        update instructor set salary = 1.05 * salary where id = i.id;
    end loop;
    close c1;
end;
/
/*
output:
ID    NAME                 DEPT_NAME                SALARY
----- -------------------- -------------------- ----------
10101 Srinivasan           Comp. Sci.                68250
12121 Wu                   Finance                   94500
15151 Mozart               Music                     42000
22222 Einstein             Physics                   99750
32343 El Said              History                   63000
33456 Gold                 Physics                   91350
45565 Katz                 Comp. Sci.                78750
58583 Califieri            History                   65100
76543 Singh                Finance                   84000
76766 Crick                Biology                   75600
83821 Brandt               Comp. Sci.                96600
98345 Kim                  Elec. Eng.                84000
*/

-- CursorName%ROWCOUNT:
/*
2. Write a PL/SQL block that will display the ID, name, dept_name  and tot_cred  of 
the first 10 students with lowest total credit.
*/
declare
    cursor c1 is select * from student order by tot_cred;
    i c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into i;
        exit when c1%rowcount > 10;
        dbms_output.put_line('ID:  ' || i.id || '  Name:  ' || rpad(i.name, 10) || '  Dept_Name:  ' || rpad(i.dept_name, 12) || '  Total Credits:  ' || i.tot_cred);
    end loop;
    close c1;
end;
/
/*
output:
ID:  70557  Name:  Snow        Dept_Name:  Physics       Total Credits:  0
ID:  12345  Name:  Shankar     Dept_Name:  Comp. Sci.    Total Credits:  32
ID:  55739  Name:  Sanchez     Dept_Name:  Music         Total Credits:  38
ID:  45678  Name:  Levy        Dept_Name:  Physics       Total Credits:  46
ID:  54321  Name:  Williams    Dept_Name:  Comp. Sci.    Total Credits:  54
ID:  44553  Name:  Peltier     Dept_Name:  Physics       Total Credits:  56
ID:  76543  Name:  Brown       Dept_Name:  Comp. Sci.    Total Credits:  58
ID:  76653  Name:  Aoi         Dept_Name:  Elec. Eng.    Total Credits:  60
ID:  19991  Name:  Brandt      Dept_Name:  History       Total Credits:  80
ID:  98765  Name:  Bourikas    Dept_Name:  Elec. Eng.    Total Credits:  98
*/

-- Cursor For Loops:
/*
3. Print the Course details and the total number of students registered for each course 
along with the course details - (Course-id, title, dept-name, credits, 
instructor_name, building, room-number, time-slot-id, tot_student_no )
*/
declare
    cursor c1 is 

/*
4. Find all students who take the course with Course-id: CS101 and if he/ she has 
less than 30 total credit (tot-cred), deregister the student from that course. (Delete 
the entry in Takes table)
*/


-- Where Current of: 
/*
5. Alter StudentTable(refer Lab No. 8 Exercise) by resetting column LetterGrade to 
F.  Then  write  a  PL/SQL  block    to  update  the  table  by  mapping  GPA  to  the 
corresponding letter grade for each student. 
*/


-- Parameterized Cursors:
/*
6. Write a PL/SQL block to print the list of Instructors teaching a specified course.
*/


/*
7. Write a PL/SQL block to list the students who have registered for a course taught 
by his/her advisor.
*/