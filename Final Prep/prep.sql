-- to delete all tables:
BEGIN
   FOR t IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
   END LOOP;
END;
/

-- use the following commands before executing PL/SQL blocks:
set serveroutput on
set verify off

-- Create the StudentTable
CREATE TABLE StudentTable (
    RollNo      NUMBER PRIMARY KEY,
    GPA         NUMBER(3,1),
    LetterGrade VARCHAR2(2)  -- initially null
);

-- Insert sample records into StudentTable
INSERT INTO StudentTable VALUES (1, 3.8, NULL);
INSERT INTO StudentTable VALUES (2, 5.2, NULL);
INSERT INTO StudentTable VALUES (3, 7.5, NULL);
INSERT INTO StudentTable VALUES (4, 8.6, NULL);
INSERT INTO StudentTable VALUES (5, 9.1, NULL);

COMMIT;

/*
Task 7A:
Write a PL/SQL block that asks the user for a RollNo (from StudentTable) and prints the corresponding GPA. Use an IF…THEN structure to check if the RollNo exists; if not, print an appropriate message.

Hint: Use a SELECT…INTO and exception handling for NO_DATA_FOUND.
*/
declare
v_r studenttable.rollno%type := &r;
v_gpa studenttable.gpa%type;
begin
    select gpa into v_gpa from studenttable where rollno = v_r;
    dbms_output.put_line('Roll No. ' || v_r || ' has a GPA of ' || v_gpa);
exception
    when NO_DATA_FOUND then dbms_output.put_line('No data found');
end;
/

/*
Task 7B:
Write a PL/SQL block that reads a RollNo’s GPA and then displays the corresponding letter grade based on this mapping:

GPA < 4.0 → F

4.0 ≤ GPA < 5.0 → E

5.0 ≤ GPA < 6.0 → D

6.0 ≤ GPA < 7.0 → C

7.0 ≤ GPA < 8.0 → B

8.0 ≤ GPA < 9.0 → A

9.0 ≤ GPA ≤ 10.0 → A+

Update the LetterGrade column accordingly and print the new record.
*/

declare
v_grade studenttable.lettergrade%type;
begin
    for i in (select * from studenttable) loop
        if i.gpa < 4.0 then update studenttable set lettergrade = 'F' where rollno = i.rollno;
        elsif i.gpa < 5.0 then update studenttable set lettergrade = 'E' where rollno = i.rollno;
        elsif i.gpa < 6.0 then update studenttable set lettergrade = 'D' where rollno = i.rollno;
        elsif i.gpa < 7.0 then update studenttable set lettergrade = 'C' where rollno = i.rollno;
        elsif i.gpa < 8.0 then update studenttable set lettergrade = 'B' where rollno = i.rollno;
        elsif i.gpa < 9.0 then update studenttable set lettergrade = 'A' where rollno = i.rollno;
        else update studenttable set lettergrade = 'A+' where rollno = i.rollno;
        end if;
    end loop;
end;
/

/*
Task 7C:
Write a PL/SQL block that uses a loop (your choice of a simple, WHILE, or FOR loop) to calculate and print the factorial of 5.
*/
declare
num number := &num;
num2 number := num;
res number;
i number := 1;
begin
    while num > 0 loop
        i := i*num;
        num := num-1;
    end loop;
    dbms_output.put_line('Factorial of ' || num2 ||' is ' || i);
end;
/

/*
Task 7D (Additional):
Write a PL/SQL block that accepts a salary value as input and raises a user-defined exception if the salary is negative. Otherwise, print a confirmation message.

You may create a test variable (you need not use a table for this if you prefer an anonymous block).
*/
declare
salary number := &salary;
negative_salary exception;
begin
    if salary < 0 then
        raise negative_salary;
    else
        dbms_output.put_line('Your salary is ' || salary);
    end if;
exception
    when negative_salary then
        dbms_output.put_line('Invalid salary.');
end;
/

/*
Lab 8 – CURSORS
Using the StudentTable defined above, perform the following:

Task 8A:
Write a PL/SQL block using an explicit cursor to select all records from StudentTable where GPA is above 7. For each fetched row, display the RollNo, GPA, and (if already calculated) LetterGrade.
*/
declare
    cursor c1 is (select * from studenttable);
    i c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into i;
        exit when c1%notfound;
        if i.gpa > 7 then
        dbms_output.put_line('Roll No. ' || i.rollno || ' GPA: ' || i.gpa || ' Grade: ' || i.lettergrade);
        end if;
    end loop;
end;
/

/*
Task 8B:
Write a PL/SQL block using a cursor FOR loop to update the LetterGrade column based on the GPA mapping described in Lab 7 Task 7B. (This demonstrates both a cursor and the use of WHERE CURRENT OF in an update.)

Optional: Show the updated table content after the update.
*/
declare
    cursor c1 is (select * from studenttable) for update;
    i c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into i;
        exit when c1%notfound;
        if i.gpa < 4 then update studenttable set lettergrade = 'F' where current of c1;
        elsif i.gpa < 5 then update studenttable set lettergrade = 'E' where current of c1;
        elsif i.gpa < 6 then update studenttable set lettergrade = 'D' where current of c1;
        elsif i.gpa < 7 then update studenttable set lettergrade = 'C' where current of c1;
        elsif i.gpa < 8 then update studenttable set lettergrade = 'B' where current of c1;
        elsif i.gpa < 9 then update studenttable set lettergrade = 'A' where current of c1;
        else update studenttable set lettergrade = 'A+' where current of c1;
        end if;
    end loop;
end;
/

/*
Lab 9 – PROCEDURES, FUNCTIONS, & PACKAGES
Task 9A – Procedure:
Create a stored procedure named print_hello that uses DBMS_OUTPUT.PUT_LINE to print "Hello World". Then show how to call it from an anonymous block.
*/
create or replace procedure print_hello is begin
    dbms_output.put_line('Hello World');
end;
/

begin print_hello; end;
/

/*
Task 9B – Function:
Create a function named sum_numbers that accepts two NUMBER parameters and returns their sum. Test this function in an anonymous block by printing the result.
*/
create or replace function sum_numbers(x number, y number) return number as begin
    return x+y;
end;
/

declare
a number := &a;
b number := &b;
begin dbms_output.put_line('Sum of ' || a || ' and ' || b || ' is ' || sum_numbers(a, b)); end;
/

/*
Task 9C – Package:
Create a package named math_pkg with:

A function factorial(n IN NUMBER) RETURN NUMBER that computes the factorial of its input.

A procedure print_factorial(n IN NUMBER) that calls factorial and prints the result using DBMS_OUTPUT.PUT_LINE.

Test the package in an anonymous PL/SQL block.
*/

create or replace package math_pkg as
    function factorial(n IN number) return number;
    procedure print_factorial(n IN number);
end math_pkg;
/

create or replace package body math_pkg as
    function factorial (n IN number) return number
    as i number := 1; n2 number := n;
    begin
        while n2 > 1 loop
            i := i*n2;
            n2 := n2-1;
        end loop;
    return i;
    end;

    procedure print_factorial(n IN number)
    as
    begin
        dbms_output.put_line('The factorial of ' || n || ' is ' || factorial(n));
    end;
end;
/

declare
n number := &n;
begin math_pkg.print_factorial(n); end;
/

/*
-- Create Product_master table
CREATE TABLE Product_master (
    product_no VARCHAR2(10) PRIMARY KEY,
    sell_price NUMBER
);

-- Create Old_price_table to store the previous price and change date
CREATE TABLE Old_price_table (
    product_no VARCHAR2(10),
    date_change DATE,
    Old_price NUMBER
);

-- Insert sample data into Product_master
INSERT INTO Product_master VALUES ('p00001', 3500);
INSERT INTO Product_master VALUES ('p00002', 5000);

COMMIT;
*/

/*
Lab 10 – TRIGGERS
Task 10A:
Create a trigger on the Product_master table that fires BEFORE UPDATE. The trigger should check if the new sell_price is less than 4000.

If it is, set the sell_price to 4000.

In either case (if an update occurs), record the old price along with the current date into Old_price_table for product 'p00001'.

Note: You may assume that the trigger is only needed for product 'p00001' for demonstration purposes. (In a real-world scenario, you might generalize it to all products.)
*/
create or replace trigger trig
before update on product_master
for each row begin
    if :new.sell_price < 4000 then
        :new.sell_price := 4000;
    end if;
    insert into old_price_table values(:old.product_no, sysdate, :old.sell_price);
end;
/