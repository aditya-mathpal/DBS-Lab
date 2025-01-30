-- LAB-4:

/*
1. Find the number of students in each course.
*/
select t.course_id, count(s.id) as student_count from student s, takes t group by course_id;

/*
2. Find those departments where the number of students is at least 4.
*/
select count(distinct id) as student_count, dept_name
from student
group by dept_name
having count(distinct id) >= 4;

/*
3. Find the total number of courses in each department.
*/
select count(course_id) as num_courses, dept_name
from course
group by dept_name;

/*
4. Find the names and average salaries of all departments whose average salary is 
greater than 42000.
*/
select dept_name, round(avg(salary)) as avg_salary
from instructor
group by dept_name
having avg(salary) > 42000;

/*
5. Find the enrolment of each section that was offered in Spring 2009.
*/
select s.semester, s.year, s.sec_id, count(distinct t.id) as student_count
from takes t, section s
where s.semester = t.semester and s.semester = 'Spring' and s.year = t.year and s.year = 2009 and t.sec_id = s.sec_id
group by s.semester, s.year, s.sec_id;

/*
6. List all the courses with prerequisite courses, then display course id in increasing 
order.
*/
select course_id
from prereq
order by course_id;

/*
7. Display the details of instructors sorting the salary in decreasing order. 
*/
select * from instructor order by salary desc;

/*
8. Find the maximum total salary across the departments.
*/
select dept_name, max(salary) as max_salary
from instructor
group by dept_name;

/*
9. Find the average instructors’ salaries of those departments where the average 
salary is greater than 42000.
*/
select dept_name, round(avg(salary)) as avg_salary
from instructor
group by dept_name
having avg(salary) > 42000;

/*
10. Find the sections that had the maximum enrolment in Spring 2010
*/
select s.semester, s.year, s.sec_id, count(distinct t.id) as student_count
from takes t, section s
where s.semester = t.semester and s.semester = 'Spring' and s.year = t.year and s.year = 2010 and t.sec_id = s.sec_id
group by s.semester, s.year, s.sec_id
having count(distinct t.id) = (
    select max(student_count) from (
        select count(distinct t.id) as student_count
        from takes t, section s
        where s.semester = t.semester and s.semester = 'Spring' and s.year = t.year and s.year = 2010 and t.sec_id = s.sec_id
        group by s.semester, s.year, s.sec_id
    )
);

/*
11. Find  the  names  of  all  instructors  who  teach  all students that belong to ‘CSE’ 
department.
*/
select distinct i.name
from instructor i, teaches teach, takes take, student s
where teach.semester = take.semester
    and teach.year = take.year
    and teach.course_id = take.course_id
    and teach.sec_id = take.sec_id
    and s.dept_name = 'Comp. Sci.';

/*
12. Find the average salary  of those department where the average salary is  greater 
than 50000 and total number of instructors in the department are more than 5.
*/
select dept_name, round(avg(salary)) as avg_salary
from instructor
group by dept_name
having avg(salary) > 50000 and count(id) > 5;

/*
13. Find all departments with the maximum budget.
*/
with maxBudget as (
    select max(budget) as max_budget
    from department
)
select dept_name, budget
from department
where budget = (select max_budget from maxBudget);

/*
14. Find all departments where the total salary is greater than the average of the total 
salary at all departments.
*/
with totalSalary as (
    select dept_name, sum(salary) as total_salary
    from instructor
    group by dept_name
)
select dept_name, total_salary
from totalSalary
where total_salary > (select avg(total_salary) from totalSalary);

/*
15. Transfer all the students from CSE department to IT department.
*/
savepoint sp;
insert into department values ('Info. Tech.', 'Taylor', 90000);
update student set dept_name = 'Info. Tech.' where dept_name = 'Comp. Sci.';
rollback to savepoint sp;

/*
16. Increase salaries of instructors whose salary is over $100,000 by 3%, and all  
others receive a 5% raise
*/
savepoint sp;
update instructor set salary = case
    when salary > 100000 then salary * 1.03
    else salary * 1.05
end;
rollback to savepoint sp;