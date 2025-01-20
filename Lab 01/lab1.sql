-- SAMPLE:
CREATE TABLE BRANCH 
(BRANCH_NAME VARCHAR (15) PRIMARY KEY, 
BRANCH_CITY VARCHAR (20), 
ASSETS NUMBER (10)); 
CREATE TABLE ACCOUNT 
(ACCOUNT_NUMBER NUMBER (10) PRIMARY KEY, 
BRANCH_NAME VARCHAR (15) REFERENCES BRANCH, 
BALANCE NUMBER (8)); 
CREATE TABLE CUSTOMER 
(CUSTOMER_NAME VARCHAR (20) PRIMARY KEY, 
CUSTOMER_STREET VARCHAR (15), 
CUSTOMER_CITY VARCHAR (10)); 
CREATE TABLE LOAN 
(LOAN_NUMBER NUMBER (10) PRIMARY KEY, 
BRANCH_NAME VARCHAR (15)REFERENCES BRANCH, 
AMOUNT NUMBER (10)) 
CREATE TABLE DEPOSITOR 
(CUSTOMER_NAME VARCHAR (20) REFERENCES CUSTOMER, 
ACCOUNT_NUMBER NUMBER (10) REFERENCES ACCOUNT, 
PRIMARY KEY (CUSTOMER_NAME, ACCOUNT_NUMBER)); 
CREATE TABLE BORROWER 
(CUSTOMER_NAME VARCHAR(20) REFERENCES CUSTOMER, 
LOAN_NUMBER  NUMBER(10) REFERENCES LOAN, 
PRIMARY KEY(CUSTOMER_NAME,LOAN_NUMBER)); 


insert into branch values ('SBIMN','Manipal',34532100);
insert into account values (230905,'SBIMN',1000000);
insert into customer values ('Aditya Mathpal','Surrey','Mumbai');
insert into customer values ('Person','Street','City');
insert into loan values (45643211,'SBIMN',50000);
insert into depositor values ('Aditya Mathpal',230905);
insert into borrower values('Person',45643211);

-- LAB-1:
-- 1
create table employee (
  emp_no number(10) primary key,
  emp_name varchar(15),
  emp_address varchar(20)
);

-- 2
insert into employee values (1,'John','Wall Street');
insert into employee values (2,'Jane','Mangalore');
insert into employee values (3,'Wayne','Wayne Manor');
insert into employee values (4,'Kent','Krypton');
insert into employee values (5,'Selina','Manipal');

-- 3
select emp_name from employee;

/*
EMP_NAME
---------------
John
Jane
Wayne
Kent
Selina
*/

-- 4
select * from employee where emp_address = 'Manipal';
/*

    EMP_NO EMP_NAME        EMP_ADDRESS
---------- --------------- --------------------
         5 Kyle            Manipal
*/

-- 5
alter table employee add (salary number(9));

-- 6
update employee set salary = 400000 where emp_no = 1;
update employee set salary = 350000 where emp_no = 2;
update employee set salary = 1000000 where emp_no = 3;
update employee set salary = 90000 where emp_no = 4;
update employee set salary = 35000 where emp_no = 5;

-- 7
desc employee;
/*
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMP_NO                                    NOT NULL NUMBER(10)
 EMP_NAME                                           VARCHAR2(15)
 EMP_ADDRESS                                        VARCHAR2(20)
 SALARY                                             NUMBER(9)
*/

-- 8
delete from employee where emp_address = 'Mangalore';

-- 9
rename employee to employee1;

-- 10
drop table employee1;