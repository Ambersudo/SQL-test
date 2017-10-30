--建表
create table stu
(
id int ,
name varchar(10)
);
insert into stu(name) values('张三'),('李四');
insert into stu(id,name) values(3,'王五');
insert into stu(id,name) values(4,'赵六');
insert into stu(id,name) values(5,null);
insert into stu(id,name) values(6,'张三');
insert into stu(id,name) values(1,'甲');
insert into stu(id,name) values(2,'乙');



create table co(
id int ,
name varchar(20)
);
insert into co(name) values('语文'),('数学');
insert into co(id,name) values(3,'英语');


create table stc(
sid int ,
cid int ,
score int
);
insert into stc values(1,1,80),(1,2,90),(2,1,90),(2,2,70);
insert into stc values(3,1,80)


select * from  stu
select * from  co
select * from  stc


Drop Table  stu
Drop Table  co
Drop Table  stc


--1. 查询 stu 表中重名的学生，结果包含id和name，按name,id升序

select id,name from

stu

where name in (select name from stu group by name having (count(*) >1 ))--不能理解，count是如何返回对应名字的计数的


--2. 在student_course表中查询平均分不及格的学生，列出学生id和平均分

select sid, avg(score) as 平均分
from stc

group by sid

having (avg(score) < 60)



--3. 在student_course表中查询每门课成绩都不低于80的学生id

select  sid from stc

where score not in (select score from stc where score < 80) --错误代码

--以下是正确代码
select distinct sid from stc

where sid not in (select sid from stc where score < 80)


--4. 查询每个学生的总成绩，结果列出 学生姓名 和总成绩


select name, c as 总成绩
from stu left join (select stc.sid,sum(stc.score) as c from stc  group by sid ) as b
on stu.id = b.sid


select name,sum(score)
from stu left join stc
on stu.id=stc.sid
group by name;

--5. 总成绩最高的学生，结果列出学生id和总成绩

select sid, sum(score) as 总成绩

from stc
group by sid
order by  总成绩 desc offset 0 rows  fetch first 1  rows only


--6. 在student_course表查询 课程1 成绩第2高的学生，如果第2高的不止一个则列出所有的学生

select * from stc
where cid=1 and score = (
select score from stc where cid = 1 group by score order by score desc limit 1,1
);


--7. 在student_course表查询各科成绩最高的学生，结果列出学生id、课程id和对应的成绩


select sid,cid, max(score)
from stc
--

select * from stc as x where score >=
(select max(score) from stc as y where cid=x.cid);--相关子查询，不能理解



--8. 在student_course表中查询每门课的前2名，结果按课程id升序，同一课程按成绩降序

select * from student_course x where
2>(select count(*) from student_course y where y.cid=x.cid and y.score>x.score)
order by cid,score desc;


--https://www.yanxurui.cc/posts/mysql/10-sql-interview-questions/