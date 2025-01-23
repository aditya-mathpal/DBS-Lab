-- LAB-3:

-- 1
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
union all
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

-- 2
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
intersect all -- doesn't work in oracle
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

-- 3
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Fall' and t.year = 2009
minus 
select t.course_id, c.title from takes t, course c where t.course_id = c.course_id and t.semester = 'Spring' and t.year = 2010;

-- 4
select title from course minus select c.title from course c, takes t where c.course_id = t.course_id;

-- 5
