-- LAB-3:

-- 1
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
union all
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

-- 2
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
intersect
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

-- 3
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
minus 
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

-- 4
select title from course minus select c.title from course c, takes t where c.course_id = t.course_id;

-- 5
select * from course where course_id in (
    select t.course_id from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
    intersect
    select t.course_id from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010
);

-- 6
select count(id) from takes where id in (select s.id from takes s, teaches i where s.course_id = i.course_id and i.id = 10101 and s.semester = i.semester and i.year = s.year and s.sec_id = i.sec_id);

-- 7
select c.course_id, c.title from course c where c.course_id in (select t.course_id from takes t where t.semester = 'Fall' and t.year = 2009) and c.course_id not in (select t.course_id from takes t where t.semester = 'Spring' and t.year = 2010);

-- 8
select name as student_name from student where name in (select name from instructor);

-- 9
select name as instructor_name from instructor where salary >any (select salary from instructor where dept_name = 'Biology');

-- 10
select name as instructor_name from instructor where salary >all (select salary from instructor where dept_name = 'Biology');

-- 11


-- 12
select unique d.dept_name from department d, instructor i where d.budget < (select avg(salary) from instructor);

-- 13
select course_id, title from course where exists (select 1 from teaches where semester = 'Fall' and year = 2009 intersect select 1 from teaches where semester = 'Spring' and year = 2010);