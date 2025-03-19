-- LAB-7

create table studenttable (
    rollno number(2),
    gpa number(3, 2)
);
insert into studenttable values(1, 5.8);
insert into studenttable values(2, 6.5);
insert into studenttable values(3, 3.4);
insert into studenttable values(4, 7.8);
insert into studenttable values(5, 9.5);

/*
    ROLLNO        GPA
---------- ----------
         1        5.8
         2        6.5
         3        3.4
         4        7.8
         5        9.5
*/

-- use the following commands before executing PL/SQL blocks:
/*
set serveroutput on
set verify off
*/

/*
1. Write a PL/SQL block to display the GPA of given student.
*/
declare
    r number(2);
    g number(3, 2);
begin
    r := &r;
    select gpa into g from studenttable where rollno = r;
    dbms_output.put_line('GPA: ' || g);
end;
/
/*
output:
Enter value for r: 4
GPA: 7.8
*/

/*
2. Write a PL/SQL block to display the letter grade(0-4: F; 4-5: E; 5-6: D; 6-7: C;                 
7-8: B; 8-9: A; 9-10: A+} of given student. 
*/
declare
    grade char(2);
    g number(3,2);
    r number(2);
begin
    r := &r;
    select gpa into g from studenttable where rollno = r;
    if g < 4 then grade := 'F';
    elsif g < 5 then grade := 'E';
    elsif g < 6 then grade := 'D';
    elsif g < 7 then grade := 'C';
    elsif g < 8 then grade := 'B';
    elsif g < 9 then grade := 'A';
    elsif g <= 10 then grade := 'A+';
    end if;
    dbms_output.put_line('Grade: ' || grade);
end;
/
/*
output:
Enter value for r: 4
Grade: B
*/

/*
3. Input the date of issue and date of return for a book. Calculate and display the fine 
with the appropriate message using a PL/SQL block.
*/
declare
    doi date;
    dor date;
    diff number;
    fine number;
begin
    doi := to_date('&doi', 'DD-MM-YYYY');
    dor := to_date('&dor', 'DD-MM-YYYY');
    diff := dor - doi;
    if diff > 30 then fine := 5 * diff;
    elsif diff > 15 then fine := 2 * diff;
    elsif diff > 7 then fine := diff;
    else fine := 0;
    end if;
    dbms_output.put_line('Fine: Rs. ' || fine);
end;
/
/*
output:
Enter value for doi: 7-2-2025
Enter value for dor: 27-2-2025
Fine: Rs. 40
*/

/*
4. Write a PL/SQL block to print the letter grade of all the students(RollNo: 1 - 5).
*/
declare
    grade char(2);
    g number(3,2);
begin
    for i in (select * from studenttable) loop
        if i.gpa < 4 then grade := 'F';
        elsif i.gpa < 5 then grade := 'E';
        elsif i.gpa < 6 then grade := 'D';
        elsif i.gpa < 7 then grade := 'C';
        elsif i.gpa < 8 then grade := 'B';
        elsif i.gpa < 9 then grade := 'A';
        elsif i.gpa <= 10 then grade := 'A+';
        end if;
        dbms_output.put_line('Roll No ' || i.rollno || ' Grade: ' || grade);
    end loop;
end;
/
/*
output:
Roll No 1 Grade: D
Roll No 2 Grade: C
Roll No 3 Grade: F
Roll No 4 Grade: B
Roll No 5 Grade: A+
*/

/*
5. Alter StudentTable by appending an additional column LetterGrade Varchar2(2). 
Then write a PL/SQL block  to update the table with letter grade of each student.
*/
alter table studenttable add lettergrade varchar2(2);
begin
    for i in (select * from studenttable) loop
        if i.gpa < 4 then update studenttable set lettergrade = 'F' where rollno = i.rollno;
        elsif i.gpa < 5 then update studenttable set lettergrade = 'E' where rollno = i.rollno;
        elsif i.gpa < 6 then update studenttable set lettergrade = 'D' where rollno = i.rollno;
        elsif i.gpa < 7 then update studenttable set lettergrade = 'C' where rollno = i.rollno;
        elsif i.gpa < 8 then update studenttable set lettergrade = 'B' where rollno = i.rollno;
        elsif i.gpa < 9 then update studenttable set lettergrade = 'A' where rollno = i.rollno;
        elsif i.gpa <= 10 then update studenttable set lettergrade = 'A+' where rollno = i.rollno;
        end if;
    end loop;
end;
/
/*
output:
ROLLNO	GPA	LETTERGRADE
1	    5.8	D
2	    6.5	C
3	    3.4	F
4	    7.8	B
5	    9.5	A+

/*
6. Write a PL/SQL block to find the student with max. GPA without using aggregate 
function.
*/
declare
    maxgpa number(3,2);
    roll number(2);
begin
    maxgpa := 0;
    for i in (select * from studenttable) loop
        if i.gpa > maxgpa then
            maxgpa := i.gpa;
            roll := i.rollno;
        end if;
    end loop;
    dbms_output.put_line('Roll No: ' || roll || ' GPA: ' || maxgpa);
end;
/
/*
output:
Roll No: 5 GPA: 9.5
*/

/*
7. Implement lab exercise 4 using GOTO.
*/
declare
    grade char(2);
    g number(3,2);
begin
    for i in (select * from studenttable) loop
        if i.gpa < 4 then grade := 'F'; goto print; end if;
        if i.gpa < 5 then grade := 'E'; goto print; end if;
        if i.gpa < 6 then grade := 'D'; goto print; end if;
        if i.gpa < 7 then grade := 'C'; goto print; end if;
        if i.gpa < 8 then grade := 'B'; goto print; end if;
        if i.gpa < 9 then grade := 'A'; goto print; end if;
        grade := 'A+';
        <<print>>
        dbms_output.put_line('Roll No ' || i.rollno || ' Grade: ' || grade);
    end loop;
end;
/
/*
output:
Roll No 1 Grade: D 
Roll No 2 Grade: C 
Roll No 3 Grade: F 
Roll No 4 Grade: B 
Roll No 5 Grade: A+
*/

/*
8. Based  on  the  University  database  schema,  write  a  PL/SQL  block  to  display  the 
details  of  the  Instructor  whose  name  is  supplied  by  the  user.  Use  exceptions  to 
show appropriate error message for the following cases: 
a. Multiple instructors with the same name 
b. No instructor for the given name
*/
declare
    n varchar2(20);
    i instructor%rowtype;
begin
    n := &n;
    select * into i from instructor where name = n;
    dbms_output.put_line('ID: ' || i.id || ' Name: ' || i.name || ' Dept: ' || i.dept_name);
exception
    when no_data_found then dbms_output.put_line('No instructor found for the given name');
    when too_many_rows then dbms_output.put_line('Multiple instructors with the same name');
end;
/
/*
output:
Enter value for n: Mozart
ID: 15151 Name: Mozart Dept: Music
*/