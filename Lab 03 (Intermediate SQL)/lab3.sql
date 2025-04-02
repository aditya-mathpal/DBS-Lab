-- LAB-3:

/*
1. Find courses that ran in Fall 2009 or in Spring 2010
*/
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
union all
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

/*
2. Find courses that ran in Fall 2009 and in spring 2010
*/
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
intersect
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

/*
3. Find courses that ran in Fall 2009 but not in Spring 2010
*/
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
minus 
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

/*
4. Find the name of the course for which none of the students registered.
*/
select title from course minus select c.title from course c, takes t where c.course_id = t.course_id;

/*
5.  Find courses offered in Fall 2009 and in Spring 2010.
*/
select * from course where course_id in (
    select t.course_id from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
    intersect
    select t.course_id from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010
);

/*
6.  Find the total number of students who have taken course taught by the instructor 
with ID 10101.
*/
select count(id) from takes where id in (select s.id from takes s, teaches i where s.course_id = i.course_id and i.id = 10101 and s.semester = i.semester and i.year = s.year and s.sec_id = i.sec_id);

/*
7.  Find courses offered in Fall 2009 but not in Spring 2010. 
*/
select c.course_id, c.title from course c where c.course_id in (select t.course_id from takes t where t.semester = 'Fall' and t.year = 2009) and c.course_id not in (select t.course_id from takes t where t.semester = 'Spring' and t.year = 2010);

/*
8. Find the names of all students whose name is same as the instructor’s name. 
*/
select name as student_name from student where name in (select name from instructor);

/*
9. Find names of instructors with salary greater than that of some (at least one) instructor 
in the Biology department.
*/
select name as instructor_name from instructor where salary >any (select salary from instructor where dept_name = 'Biology');

/*
10.  Find  the  names  of  all  instructors  whose  salary  is  greater  than  the  salary  of  all 
instructors in the Biology department. 
*/
select name as instructor_name from instructor where salary >all (select salary from instructor where dept_name = 'Biology');

/*
11. Find the departments that have the highest average salary. 
*/
select dept_name, avg(salary) as avg_salary from instructor
group by dept_name
having avg(salary) = (select max(avg_salary) from (select avg(salary) as avg_salary from instructor group by dept_name));

/*
12. Find the names of those departments whose budget is lesser than the average salary 
of all instructors.
*/
select unique d.dept_name from department d, instructor i where d.budget < (select avg(salary) from instructor);

/*
13. Find all courses taught in both the Fall 2009 semester and in the Spring 2010 semester.
*/
select course_id, title from course where exists (select 1 from teaches where semester = 'Fall' and year = 2009 intersect select 1 from teaches where semester = 'Spring' and year = 2010);

/*
14. Find all students who have taken all courses offered in the Biology department. 
*/
select s.id, s.name from student s where not exists(select 1 from course c where c.dept_name = 'Biology' and not exists (select 1 from takes t where t.id = s.id and t.course_id = c.course_id));

/*
15.  Find all courses that were offered at most once in 2009.
*/
select course_id from section where year = 2009 group by course_id having count(course_id) < 2;

/*
16.  Find all the students who have opted at least two courses offered by CSE department. 
*/
select s.name from student s, takes t, course c where s.id = t.id and t.course_id = c.course_id and c.dept_name = 'Comp. Sci.' group by s.name having count(s.dept_name) > 1;

/*
17. Find the average instructors salary of those departments where the average salary is 
greater than 42000
*/
select avg_sal from (select avg(salary) as avg_sal from instructor group by dept_name having avg(salary) > 42000);

/*
18.  Create a view all_courses consisting of course sections offered by Physics 
department in the Fall 2009, with the building and room number of each section.
*/
create view all_courses as select s.course_id, s.building, s.room_number from section s, course c where c.dept_name = 'Physics' and s.semester = 'Fall' and s.year = 2009 and c.course_id = s.course_id;

/*
19.  Select all the courses from all_courses view. 
*/
select course_id from all_courses;

/*
20.  Create  a  view  department_total_salary  consisting  of  department  name  and  total 
salary of that department.
*/
create view department_total_salary as select dept_name, sum(salary) total_salary from instructor group by dept_name;