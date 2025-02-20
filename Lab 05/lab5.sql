-- LAB-5

/*
1. Retrieve  the  birth  date  and  address  of  the  employee(s)  whose name is ‘John B. 
Smith’.  Retrieve  the  name  and  address  of  all  employees  who  work  for  the 
‘Research’ department.
*/
select bdate, address from employee where fname = 'John' and minit = 'B' and lname = 'Smith';
select e.fname || ' ' || e.minit || '. ' || e.lname as name, e.address as address from employee e, department d where d.dname = 'Research' and d.dnumber = e.dno;

/*
2. For every project located in ‘Stafford’, list the project number, the controlling  
department number, and the department manager’s last name, address, and birth 
date.
*/
select p.pnumber, d.dnumber, e.lname, e.address, e.bdate
from project p, employee e, department d
where p.plocation = 'Stafford' and p.dnum = d.dnumber and d.mgr_ssn = e.ssn;

/*
3. For each employee, retrieve the employee’s first and last name and the first and 
last name of his or her immediate supervisor.
*/
select e1.fname || ' ' || e1.minit || '. ' || e1.lname as emp_name, 
    e2.fname || ' ' || e2.minit || '. ' || e2.lname as super_name
from employee e1, employee e2
where e1.super_ssn = e2.ssn;

/*
4. Make  a list of all project numbers  for projects that involve an employee  whose 
last  name is ‘Smith’, either as a worker or as a manager of the department that 
controls the project.
*/
select p.pnumber
from project p, employee e, works_on w
where p.pnumber = w.pno and w.essn = e.ssn and e.lname = 'Smith';

/*
5. Show the resulting salaries if every employee working on the ‘ProductX’ project 
is given a 10 percent raise.
*/
select e.fname || ' ' || e.minit || '. ' || e.lname as name, e.salary * 1.1 as raised_salary
from employee e, project p, works_on w
where p.pname = 'ProductX' and p.pnumber = w.pno and w.essn = e.ssn;

/*
6. Retrieve  a  list  of  employees  and  the  projects  they  are  working  on,  ordered  by 
department and, within each department, ordered alphabetically by last name, then 
first name.
*/
select e.fname || ' ' || e.minit || '. ' || e.lname as name, p.pname as project_name, d.dname as department_name
from employee e, project p, works_on w, department d
where p.pnumber = w.pno and w.essn = e.ssn and e.dno = d.dnumber
order by d.dname, e.lname, e.fname;

/*
7. Retrieve the name of each employee who has a dependent with the same first name 
and is the same sex as the employee. 
*/
select e.fname || ' ' || e.minit || '. ' || e.lname as name
from dependent d, employee e
where d.essn = e.ssn and d.dependent_name = e.fname and d.sex = e.sex;

/*
8. Retrieve the names of employees who have no dependents.
*/
select e.fname || ' ' || e.minit || '. ' || e.lname as name
from employee e
where not exists(
    select 1
    from dependent d
    where e.ssn = d.essn
);

/*
9. List the names of managers who have at least one dependent.
*/
select unique(e.fname || ' ' || e.minit || '. ' || e.lname) as name
from employee e, dependent d
where e.ssn = d.essn;

/*
10. Find the sum of the salaries of all employees, the maximum salary, the minimum 
salary, and the average salary.
*/
select sum(salary) as cumulative_salary,
    max(salary) as max_salary,
    min(salary) as min_salary,
    avg(salary) as avg_salary
from employee;

/*
11. For each project, retrieve the project number, the project name, and the number 
of employees who work on that project.
*/
select p.pnumber, p.pname, count(w.essn) as emp_count
from project p, works_on w
where p.pnumber = w.pno
group by p.pnumber, p.pname;

/*
12. For each project on which more than two employees work, retrieve the project 
number, the project name, and the number of employees who work on the 
project.
*/
select *
from (
    select p.pnumber, p.pname, count(w.essn) as emp_count
    from project p, works_on w
    where p.pnumber = w.pno
    group by p.pnumber, p.pname
)
where emp_count > 2;

/*
13. For each department that has more than five employees, retrieve the department 
number and the number of its employees who are making more than 40,000.
*/
select *
from (
    select dno, count(ssn) as emp_count
    from employee
    where salary > 40000
    group by dno
)
where emp_count > 5;