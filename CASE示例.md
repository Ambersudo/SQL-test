
## 例1

```sql
create table casetest
(
    testid varchar(20),
    stuid varchar(20),
    classid varchar(20),
    testbase varchar(20),
    testbeyond varchar(20),
    testpro varchar(20),
    testname varchar(20),
    testdate date
)


insert into casetest values (1, 1, 1, 84, 88, 82, '第一次测试', '2005-02-15')
insert into casetest values (2, 1, 1, 88, 71, 84, '第二次测试', '2005-03-15')
insert into casetest values (3, 1, 1, 75, 95, 73, '第三次测试', '2005-04-15')
insert into casetest values (4, 304, 3, 56, 79, 68, '第一次测试', '2005-02-15')
insert into casetest values (5, 304, 3, 64, 46, 41, '第二次测试', '2005-03-15')
insert into casetest values (6, 304, 3, 92, 58, 74, '第三次测试', '2005-04-15')
insert into casetest values (7, 329, 5, 76, 57, 56, '第一次测试', '2005-02-15')
insert into casetest values (8, 329, 5, 69, 100, 82, '第二次测试', '2005-03-15')
insert into casetest values (9, 329, 5, 68, 55, 97, '第三次测试', '2005-04-15')
insert into casetest values (10, 350, 3, 80, 48, 59, '第一次测试', '2005-02-15')



表格如下

testid	stuid	classid   testbase	testbeyond	testpro	  testname	   testdate
-------------------------------------------------------------------------------------------------------
1	    1	    1	      84	    88	        82	      第一次测试	   2005-02-15
2	    1	    1	      88	    71	        84	      第二次测试	   2005-03-15
3	    1	    1	      75	    95	        73	      第三次测试	   2005-04-15
4	    304	    3	      56	    79	        68	      第一次测试	   2005-02-15
5	    304	    3	      64	    46	        41	      第二次测试	   2005-03-15
6	    304	    3	      92	    58	        74	      第三次测试	   2005-04-15
7	    329	    5	      76	    57	        56	      第一次测试	   2005-02-15
8	    329	    5	      69	    100	        82	      第二次测试	   2005-03-15
9	    329	    5	      68	    55	        97	      第三次测试	   2005-04-15
10	    350	    3	      80	    48	        59	      第一次测试	   2005-02-15


要求：将testbse里面的分数转换成ABCDE，规则是90分以上显示A，80分以上显示B，以此类推。

输入↓

Select testid, testbase,
    Case
         When testbase>=90 then 'A'
         When testbase>=80 then 'B'--不需要限制值小于 90 ，因为 >=90 就属于A
         When testbase>=70 then 'C'
         When testbase>=60 then 'D'
         Else 'E'
    End as testBaseLevel,
    testBeyond, testDate
from casetest

输出↓

testid	testbase	testBaseLevel	 testBeyond	 testDate
-----------------------------------------------------------
1	    84	         B	             88	         2005-02-15
2	    88	         B	             71	         2005-03-15
3	    75	         C	             95	         2005-04-15
4	    56	         E	             79	         2005-02-15
5	    64	         D	             46	         2005-03-15
6	    92	         A	             58	         2005-04-15
7	    76	         C	             57	         2005-02-15
8	    69	         D	             100         2005-03-15
9	    68	         D	             55	         2005-04-15
10	    80	         B	             48	         2005-02-15

```

## 例2

```sql

CREATE table PracticeTest
(
　　number varchar(10),
　　amount int
)

insert into PracticeTest(number,amount) values('RK1',10)
insert into PracticeTest(number,amount) values('RK2',20)
insert into PracticeTest(number,amount) values('RK3',-30)
insert into PracticeTest(number,amount) values('RK4',-10)

表格如下

number	 amount
--------------------------------------
RK1	     10
RK2	     20
RK3	     -30
RK4	     -10

要求：将上面的表格输出为如下格式

单号    收入    支出
--------------------------------------
RK1    10      0
RK2    20      0
RK3    0       30
RK4    0       10


输入↓
SELECT number AS 单号,
       CASE
         WHEN amount > 0 THEN amount
         ELSE 0
       END    AS 收入,
       CASE
         WHEN amount < 0 THEN -amount
         ELSE 0
       END    AS 支出
FROM   practicetest

```

## 例3

```sql


create table users
(
    id int,
    name varchar(20),
    sex int
);


insert into users(id,name) values(1,'张一');
insert into users(id,name,sex) values(2,'张二',1);
insert into users(id,name) values(3,'张三');
insert into users(id,name) values(4,'张四');
insert into users(id,name,sex) values(5,'张五',2);
insert into users(id,name,sex) values(6,'张六',1);
insert into users(id,name,sex) values(7,'张七',2);
insert into users(id,name,sex) values(8,'张八',1);

表格如下

id	name	sex
--------------------------------------
1	张一	NULL
2	张二	1
3	张三	NULL
4	张四	NULL
5	张五	2
6	张六	1
7	张七	2
8	张八	1


要求1
上表结果中的"sex"是用代码表示的，希望将代码用中文表示。1表示男，2表示女


输入↓

以下 3 段代码的效果是一样的

SELECT id,
       NAME,
       sex,
       "sexreal" = CASE
                     WHEN sex = 1 THEN '男'
                     WHEN sex = 2 THEN '女'
                     ELSE '未知'
                   END
FROM   users

SELECT id,
       NAME,
       sex,
       ( CASE
           WHEN sex = 1 THEN '男'
           WHEN sex = 2 THEN '女'
           ELSE '未知'
         END ) AS sexreal
FROM   users

SELECT id,
       NAME,
       sex,
       "sexreal" = CASE sex
                     WHEN 1 THEN '男'
                     WHEN 2 THEN '女'
                     ELSE '未知'
                   END
FROM   users

输出↓
id	NAME	sex	sexreal
--------------------------------------
1	张一	NULL	未知
2	张二	1	男
3	张三	NULL	未知
4	张四	NULL	未知
5	张五	2	女
6	张六	1	男
7	张七	2	女
8	张八	1	男


要求2：将上表中各种性别的人数进行统计，输出为如下格式

男    女    未知
-----------------
3     2     3



输入↓

select
   sum(case u.sex when 1 then 1 else 0 end)男性,
   sum(case u.sex when 2 then 1 else 0 end)女性,
   sum(case when u.sex <>1 and u.sex<>2 then 1 else 0 end)性别为空
 from users u;


select
   count(case when u.sex=1 then 1 end)男性,
   count(case when u.sex=2 then 1 end)女,
   count(case when u.sex <>1 and u.sex<>2 then 1 end)性别为空
 from users u;





```

提升：将sum与case结合使用

## 例4

```sql

create table Score
　(
　　　学号 nvarchar(10),
　　　课程 nvarchar(10),
　　　成绩 int
　)

insert into Score values('0001','语文',87)
insert into Score values('0001','数学',79)
insert into Score values('0001','英语',95)
insert into Score values('0002','语文',69)
insert into Score values('0002','数学',84)

表格如下

学号	课程	成绩
--------------------------------------
0001	语文	87
0001	数学	79
0001	英语	95
0002	语文	69
0002	数学	84


要求：将上面的表格输出为如下格式


学号    语文    数学    英语
--------------------------------------
0001    87     79      95
0002    69     84      0


输入↓

SELECT   学号,

         SUM(
         CASE 　WHEN  课程='语文' THEN 成绩 　　else 0
         END) AS 语文,

         SUM(
         CASE 　WHEN  课程='数学' THEN 成绩 　　else 0
         END) AS 数学,

         SUM(
         CASE 　WHEN  课程='英语' THEN 成绩 　　else 0
         END) AS 英语

         FROM score

GROUP BY 学号

```