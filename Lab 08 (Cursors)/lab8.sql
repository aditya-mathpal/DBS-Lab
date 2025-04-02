-- Lab-8

-- this file contains some code from https://github.com/D-Coder-42/CSE-Labs/blob/main/DBMS%20Lab/Lab%208.sql

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
        insert into salary_raise (Instructor_Id, Raise_date, Raise_amt) values (s_id, s_raise_date, s_raise_amt);
    end loop;
    close c1;
end;
/
/*
output:
Instructor:
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

salary_raise:
INSTRUCTOR_ID	RAISE_DATE	RAISE_AMT
10101	        20-MAR-25	3250
12121	        20-MAR-25	4500
15151	        20-MAR-25	2000
22222	        20-MAR-25	4750
32343	        20-MAR-25	3000
33456	        20-MAR-25	4350
45565	        20-MAR-25	3750
58583	        20-MAR-25	3100
76543	        20-MAR-25	4000
76766	        20-MAR-25	3600
83821	        20-MAR-25	4600
98345	        20-MAR-25	4000
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
	cursor C is select * from TEACHES;
	N number;
	INST_NAME INSTRUCTOR.NAME %type;
	COURSE_ROW COURSE %rowtype;
	SECT_ROW SECTION % rowtype;
begin
	for T in C loop
		begin
			select count(*) into N from TAKES group by COURSE_ID, SEC_ID, SEMESTER, YEAR having COURSE_ID = T.COURSE_ID and SEC_ID = T.SEC_ID and SEMESTER = T.SEMESTER and YEAR = T.YEAR;
		exception
			when NO_DATA_FOUND then N := 0;
		end;

		select NAME into INST_NAME from INSTRUCTOR where ID = T.ID;
		select * into SECT_ROW from SECTION where COURSE_ID = T.COURSE_ID and SEC_ID = T.SEC_ID and SEMESTER = T.SEMESTER and YEAR = T.YEAR;
		select * into COURSE_ROW from COURSE where COURSE_ID = T.COURSE_ID;

		dbms_output.put_line('Course ID: ' || T.COURSE_ID || ' | Title: ' || COURSE_ROW.TITLE || ' | Department Name: ' || COURSE_ROW.DEPT_NAME || ' | Credits: ' || COURSE_ROW.CREDITS || ' | Instructor Name: ' || INST_NAME);
		dbms_output.put_line('Building: ' || SECT_ROW.BUILDING || ' | Room Number: ' || SECT_ROW.ROOM_NUMBER || ' Time Slot ID: ' || SECT_ROW.TIME_SLOT_ID || ' Total Students Enrolled: ' || N);
		dbms_output.put_line('_________________________________________________________________');
	end loop;
end;
/
/*
output:
Course ID: CS-101 | Title: Intro. to Computer Science | Department Name: Comp.
Sci. | Credits: 4 | Instructor Name: Srinivasan
Building: Packard | Room Number: 101 Time Slot ID: H Total Students Enrolled: 5
_________________________________________________________________
Course ID: CS-315 | Title: Robotics | Department Name: Comp. Sci. | Credits: 3 |
Instructor Name: Srinivasan
Building: Watson | Room Number: 120 Time Slot ID: D Total Students Enrolled: 2
_________________________________________________________________
Course ID: CS-347 | Title: Database System Concepts | Department Name: Comp.
Sci. | Credits: 3 | Instructor Name: Srinivasan
Building: Taylor | Room Number: 3128 Time Slot ID: A Total Students Enrolled: 2
_________________________________________________________________
Course ID: FIN-201 | Title: Investment Banking | Department Name: Finance |
Credits: 3 | Instructor Name: Wu
Building: Packard | Room Number: 101 Time Slot ID: B Total Students Enrolled: 1
_________________________________________________________________
Course ID: MU-199 | Title: Music Video Production | Department Name: Music |
Credits: 3 | Instructor Name: Mozart
Building: Packard | Room Number: 101 Time Slot ID: D Total Students Enrolled: 1
_________________________________________________________________
Course ID: PHY-101 | Title: Physical Principles | Department Name: Physics |
Credits: 4 | Instructor Name: Einstein
Building: Watson | Room Number: 100 Time Slot ID: A Total Students Enrolled: 1
_________________________________________________________________
Course ID: HIS-351 | Title: World History | Department Name: History | Credits:
3 | Instructor Name: El Said
Building: Painter | Room Number: 514 Time Slot ID: C Total Students Enrolled: 1
_________________________________________________________________
Course ID: CS-101 | Title: Intro. to Computer Science | Department Name: Comp.
Sci. | Credits: 4 | Instructor Name: Katz
Building: Packard | Room Number: 101 Time Slot ID: F Total Students Enrolled: 1
_________________________________________________________________
Course ID: CS-319 | Title: Image Processing | Department Name: Comp. Sci. |
Credits: 3 | Instructor Name: Katz
Building: Watson | Room Number: 100 Time Slot ID: B Total Students Enrolled: 1
_________________________________________________________________
Course ID: BIO-101 | Title: Intro. to Biology | Department Name: Biology |
Credits: 4 | Instructor Name: Crick
Building: Painter | Room Number: 514 Time Slot ID: B Total Students Enrolled: 1
_________________________________________________________________
Course ID: BIO-301 | Title: Genetics | Department Name: Biology | Credits: 4 |
Instructor Name: Crick
Building: Painter | Room Number: 514 Time Slot ID: A Total Students Enrolled: 1
_________________________________________________________________
Course ID: CS-190 | Title: Game Design | Department Name: Comp. Sci. | Credits:
4 | Instructor Name: Brandt
Building: Taylor | Room Number: 3128 Time Slot ID: E Total Students Enrolled: 0
_________________________________________________________________
Course ID: CS-190 | Title: Game Design | Department Name: Comp. Sci. | Credits:
4 | Instructor Name: Brandt
Building: Taylor | Room Number: 3128 Time Slot ID: A Total Students Enrolled: 2
_________________________________________________________________
Course ID: CS-319 | Title: Image Processing | Department Name: Comp. Sci. |
Credits: 3 | Instructor Name: Brandt
Building: Taylor | Room Number: 3128 Time Slot ID: C Total Students Enrolled: 1
_________________________________________________________________
Course ID: EE-181 | Title: Intro. to Digital Systems | Department Name: Elec.
Eng. | Credits: 3 | Instructor Name: Kim
Building: Taylor | Room Number: 3128 Time Slot ID: C Total Students Enrolled: 1
_________________________________________________________________
*/

/*
4. Find all students who take the course with Course-id: CS101 and if he/ she has 
less than 30 total credit (tot-cred), deregister the student from that course. (Delete 
the entry in Takes table)
*/
declare
    cursor c1 is select * from takes where course_id = 'CS-101';
    i c1%rowtype;
    s_id number(5);
begin
    open c1;
    loop
        fetch c1 into i;
        exit when c1%notfound;
        s_id := i.id;
        delete from takes where id = s_id and course_id = 'CS-101' and (select tot_cred from student where id = s_id) < 30;
    end loop;
    close c1;
end;
/
/*
output:
ID	    COURSE_ID	SEC_ID	SEMESTER	YEAR	GRADE
00128	CS-101	    1	    Fall	    2009	A
00128	CS-347	    1	    Fall	    2009	A-
12345	CS-101	    1	    Fall	    2009	C
12345	CS-190	    2	    Spring	    2009	A
12345	CS-315	    1	    Spring	    2010	A
12345	CS-347	    1	    Fall	    2009	A
19991	HIS-351	    1	    Spring	    2010	B
23121	FIN-201	    1	    Spring	    2010	C+
44553	PHY-101	    1	    Fall	    2009	B-
45678	CS-101	    1	    Fall	    2009	F
45678	CS-101	    1	    Spring	    2010	B+
45678	CS-319	    1	    Spring	    2010	B
54321	CS-101	    1	    Fall	    2009	A-
54321	CS-190	    2	    Spring	    2009	B+
55739	MU-199	    1	    Spring	    2010	A-
76543	CS-101	    1	    Fall	    2009	A
76543	CS-319	    2	    Spring	    2010	A
76653	EE-181	    1	    Spring	    2009	C
98765	CS-101	    1	    Fall	    2009	C-
98765	CS-315	    1	    Spring	    2010	B
98988	BIO-101	    1	    Summer	    2009	A
98988	BIO-301	    1	    Summer	    2010	- 
*/

-- Where Current of: 
/*
5. Alter StudentTable(refer Lab No. 7 Exercise) by resetting column LetterGrade to 
F.  Then  write  a  PL/SQL  block    to  update  the  table  by  mapping  GPA  to  the 
corresponding letter grade for each student. 
*/
update STUDENT_TABLE set LETTERGRADE = 'F';

declare
	cursor C is select * from STUDENT_TABLE for update;
	GPA STUDENT_TABLE.GPA %type;
begin
	for STD in C loop
		GPA := STD.GPA;
		if GPA <= 4 then
			update STUDENT_TABLE set LETTERGRADE = 'F' where current of C;	
		elsif GPA <= 5 then
			update STUDENT_TABLE set LETTERGRADE = 'E' where current of C;
		elsif GPA <= 6 then
			update STUDENT_TABLE set LETTERGRADE = 'D' where current of C;
		elsif GPA <= 7 then
			update STUDENT_TABLE set LETTERGRADE = 'C' where current of C;
		elsif GPA <= 8 then
			update STUDENT_TABLE set LETTERGRADE = 'B' where current of C;
		elsif GPA <= 9 then
			update STUDENT_TABLE set LETTERGRADE = 'A' where current of C;
		else
			update STUDENT_TABLE set LETTERGRADE = 'A+' where current of C;
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
*/


-- Parameterized Cursors:
/*
6. Write a PL/SQL block to print the list of Instructors teaching a specified course.
*/
declare
	cursor C (CID TEACHES.COURSE_ID %type) is select distinct ID from TEACHES where COURSE_ID = CID;
	INST_NAME INSTRUCTOR.NAME %type;
	CID TEACHES.COURSE_ID %type;
begin
	CID := '&Course_ID';
	for I in C(CID) loop
		select NAME into INST_NAME from INSTRUCTOR where ID = I.ID;
		dbms_output.put_line('ID: ' || I.ID || ' | Name: ' || INST_NAME);
	end loop;
end;
/
/*
output:
Enter value for course_id: CS-101
old   6:        CID := '&Course_ID';
new   6:        CID := 'CS-101';
ID: 10101 | Name: Srinivasan
ID: 45565 | Name: Katz
*/

/*
7. Write a PL/SQL block to list the students who have registered for a course taught 
by his/her advisor.
*/
DECLARE
    -- A cursor to get students who are taking courses taught by their advisors
    CURSOR C1 IS
        SELECT DISTINCT s.ID AS student_id, s.NAME AS student_name, t.COURSE_ID, t.SEC_ID, t.SEMESTER, t.YEAR
        FROM student s
        JOIN advisor a ON s.ID = a.S_ID  -- Join students with their advisor
        JOIN takes t ON s.ID = t.ID     -- Join students with the courses they are taking
        JOIN teaches te ON t.COURSE_ID = te.COURSE_ID AND t.SEC_ID = te.SEC_ID
        WHERE a.I_ID = te.ID;  -- Ensure the course is taught by the advisor (match advisor's ID)

    stdName student.NAME%TYPE;  -- Variable to store the student's name
BEGIN
    -- Loop through each student and their course
    FOR student_record IN C1 LOOP
        -- Output the student's ID, name, and the course they are taking
        DBMS_OUTPUT.PUT_LINE('Student ID: ' || student_record.student_id || 
                             ' | Name: ' || student_record.student_name ||
                             ' | Course ID: ' || student_record.COURSE_ID ||
                             ' | Section ID: ' || student_record.SEC_ID ||
                             ' | Semester: ' || student_record.SEMESTER ||
                             ' | Year: ' || student_record.YEAR);
    END LOOP;
END;
/
/*
output:
Student ID: 12345 | Name: Shankar | Course ID: CS-315 | Section ID: 1 |
Semester: Spring | Year: 2010
Student ID: 76653 | Name: Aoi | Course ID: EE-181 | Section ID: 1 | Semester:
Spring | Year: 2009
Student ID: 00128 | Name: Zhang | Course ID: CS-101 | Section ID: 1 | Semester:
Fall | Year: 2009
Student ID: 76543 | Name: Brown | Course ID: CS-101 | Section ID: 1 | Semester:
Fall | Year: 2009
Student ID: 44553 | Name: Peltier | Course ID: PHY-101 | Section ID: 1 |
Semester: Fall | Year: 2009
Student ID: 98988 | Name: Tanaka | Course ID: BIO-101 | Section ID: 1 |
Semester: Summer | Year: 2009
Student ID: 12345 | Name: Shankar | Course ID: CS-347 | Section ID: 1 |
Semester: Fall | Year: 2009
Student ID: 98988 | Name: Tanaka | Course ID: BIO-301 | Section ID: 1 |
Semester: Summer | Year: 2010
*/