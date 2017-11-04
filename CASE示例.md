# CASE 示例

- [CASE 示例](#case-%E7%A4%BA%E4%BE%8B)
    - [CASE的两种表达式](#case%E7%9A%84%E4%B8%A4%E7%A7%8D%E8%A1%A8%E8%BE%BE%E5%BC%8F)
    - [例1](#%E4%BE%8B1)
    - [例2](#%E4%BE%8B2)
    - [例3](#%E4%BE%8B3)
    - [例4](#%E4%BE%8B4)
    - [问题汇总](#%E9%97%AE%E9%A2%98%E6%B1%87%E6%80%BB)



## CASE的两种表达式

- CASE 简单表达式，它通过将表达式与一组简单的表达式进行比较来确定结果。
```sql
CASE input_expression --比较的值  直接跟在 CASE 后面
     WHEN when_expression THEN result_expression
     [ ELSE else_result_expression ]-- ELSE 是可选的
END
```

- CASE 搜索表达式，它通过计算一组布尔表达式来确定结果。

```sql
CASE
     WHEN Boolean_expression THEN result_expression--比较的值  跟在 WHEN 后面
     [ ELSE else_result_expression ]-- ELSE 是可选的
END
```
- 这两种格式都支持可选的 ELSE 参数。
- input_expression, when_expression, result_expression, else_result_expression, Boolean_expression 基本都可以为任何有效表达式

- 来源：https://docs.microsoft.com/zh-cn/sql/t-sql/language-elements/case-transact-sql




## 例1

```sql
CREATE TABLE casetest
  (
     testid     VARCHAR(20),
     stuid      VARCHAR(20),
     classid    VARCHAR(20),
     testbase   VARCHAR(20),
     testbeyond VARCHAR(20),
     testpro    VARCHAR(20),
     testname   VARCHAR(20),
     testdate   DATE
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

```


表格如下


```
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

```

要求：将testbse里面的分数转换成ABCDE，规则是90分以上显示A，80分以上显示B，以此类推。

输入▼

```sql
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

```

输出▼

```
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

```

表格如下

```

number	 amount
--------------------------------------
RK1	     10
RK2	     20
RK3	     -30
RK4	     -10

```

要求：将上面的表格输出为如下格式

```
单号    收入    支出
--------------------------------------
RK1    10      0
RK2    20      0
RK3    0       30
RK4    0       10

```

输入▼

```sql
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
CREATE TABLE users
  (
     id   INT,
     NAME VARCHAR(20),
     sex  INT
  );

insert into users(id,name) values(1,'张一');
insert into users(id,name,sex) values(2,'张二',1);
insert into users(id,name) values(3,'张三');
insert into users(id,name) values(4,'张四');
insert into users(id,name,sex) values(5,'张五',2);
insert into users(id,name,sex) values(6,'张六',1);
insert into users(id,name,sex) values(7,'张七',2);
insert into users(id,name,sex) values(8,'张八',1);

```

表格如下

```

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

```

要求1：上表结果中的 sex 是用代码表示的，希望将代码用中文表示。1表示男，2表示女


输入▼

```sql
--以下 3 段代码的效果是一样的

SELECT id,
       name,
       sex,
       "sexreal" = CASE
                     WHEN sex = 1 THEN '男'
                     WHEN sex = 2 THEN '女'
                     ELSE '未知'
                   END
FROM   users


SELECT id,
       name,
       sex,
       ( CASE
           WHEN sex = 1 THEN '男'
           WHEN sex = 2 THEN '女'
           ELSE '未知'
         END ) AS sexreal
FROM   users


SELECT id,
       name,
       sex,
       "sexreal" = CASE sex
                     WHEN 1 THEN '男'
                     WHEN 2 THEN '女'
                     ELSE '未知'
                   END
FROM   users

```

输出▼

```
id	name	sex	sexreal
--------------------------------------
1	张一	NULL	未知
2	张二	1	男
3	张三	NULL	未知
4	张四	NULL	未知
5	张五	2	女
6	张六	1	男
7	张七	2	女
8	张八	1	男

```

要求2：将上表中各种性别的人数进行统计，输出为如下格式


```
男    女    未知
-----------------
3     2     3

```


输入▼

```sql

--首先，不知道从哪里入手，先把 CASE 的语句先写出来：

SELECT CASE sex
         WHEN   THEN
         WHEN   THEN
         ELSE
       END
FROM   users

--填充一下数据：

SELECT CASE sex
         WHEN 1 THEN '男'
         WHEN 2 THEN '女'
         ELSE '未知'
       END
FROM   users

```


输出▼

```

(无列名)
----------
未知
男
未知
未知
女
男
女
男

```

用人眼可以看出，有3男2女3未知，那如何对数据计数呢，所学过的函数只有 sum 或 count 者能做到


- 使用 sum 的思路


```sql

--原先的代码：
SELECT CASE sex
         WHEN 1 THEN '男'--更改为 when 1 then  1
         WHEN 2 THEN '女'--更改为 when 2 then  0
         ELSE '未知'--更改为 else 0
       END
FROM   users

--使用sum来计数，就是把所有的 男 = 1 ，这就有3个男的，就是有3个1，合计为3，更改上面的代码为如下：


SELECT CASE sex
         WHEN 1 THEN 1
         WHEN 2 THEN 0--去掉，不是男的就全部 = 0
         ELSE 0
       END
FROM   users

--不是男的就全部 = 0
--再精简一下代码：

SELECT CASE sex
         WHEN 1 THEN 1
         ELSE 0
       END
FROM   users


```

输出▼

```

(无列名)
-----------
0
1
0
0
0
1
0
1

```

这样对上面这个列的所有值求和，就能得到男的总数


```sql
SELECT SUM (CASE sex
              WHEN 1 THEN 1
              ELSE 0
            END) AS 男
FROM   users

```

输出▼

```
男
--------
3

```

对于后面的2列也如此操作：


```sql
SELECT SUM (CASE sex
              WHEN 1 THEN 1
              ELSE 0
            END) AS 男,

       SUM (CASE sex
              WHEN 2 THEN 1
              ELSE 0
            END) AS 女,

       SUM (CASE
              WHEN sex IS NULL THEN 1--不能使用 CASE sex WHEN  is null  THEN...
              ELSE 0
            END) AS 未知
FROM   users

```

输出▼

```
男	女	未知
----------------------
3	2	3

```

- 使用 count 的思路
```sql
--先傻瓜式的更改一下代码
SELECT COUNT (CASE sex
              WHEN 1 THEN 1
              ELSE 0
            END) AS 男,
FROM   users

```


输出▼

```
男
---------
8

上面的结果 是在下面的结果上生成的

(无列名)
---------
0
1
0
0
0
1
0
1

我们只要返回 1 的行，其他的行不需要返回

回到 CASE 简介：两种格式都支持可选的 ELSE 参数

不使用ELSE，只返回符号我们需求的行即可

```

更改代码如下

```sql
SELECT COUNT (CASE sex
              WHEN 1 THEN 1 --去掉 ELSE
            END) AS 男,

       COUNT (CASE sex
              WHEN 2 THEN 1
            END) AS 女,

       COUNT (CASE
              WHEN sex IS NULL THEN 1
            END) AS 未知
FROM   users

--结果与 sum 一致
```


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

```
表格如下

```
学号	课程	成绩
--------------------------------------
0001	语文	87
0001	数学	79
0001	英语	95
0002	语文	69
0002	数学	84
```

要求：将上面的表格输出为如下格式

```
学号    语文    数学    英语
--------------------------------------
0001    87     79      95
0002    69     84      0
```

输入▼

```sql
--一样，不知道从哪里入手，先把 CASE 的语句先写出来：


SELECT 学号,

    CASE
         WHEN   THEN
         WHEN   THEN
         ELSE
       END
FROM   Score

--填充一下数据：

SELECT 学号,

    CASE 课程 --只能用课程来筛选，每个人的成绩都是不一样的
         WHEN  '语文'  THEN '语文'
         WHEN  '数学'  THEN '数学'
         WHEN  '英语'  THEN '英语'
         ELSE 0
       END

FROM   Score
```

输出▼
```
消息 245，级别 16，状态 1，第 9 行
在将 varchar 值 '语文' 转换成数据类型 int 时失败。
```

把 ELSE 0 去掉

输入▼
```sql
SELECT 学号,

    CASE --只能用课程来筛选，每个人的成绩都是不一样的
         WHEN  课程 = '语文'  THEN '语文'
         WHEN  课程 = '数学'  THEN '数学'
         WHEN  课程 = '英语'  THEN '英语'
       END
FROM   Score
```

输出▼
```
学号	(无列名)
-----------------------
0001	语文
0001	数学
0001	英语
0002	语文
0002	数学
```

这不是我们想要的结果，我们需要返回各科对应的成绩

修改一下代码

输入▼

```sql
SELECT 学号,

    CASE
         WHEN  课程 = '语文'  THEN 课程 = 成绩
         WHEN  课程 = '数学'  THEN 课程 = 成绩
         WHEN  课程 = '英语'  THEN 课程 = 成绩
       END

FROM   Score
```

输出▼
```
消息 102，级别 15，状态 1，第 4 行
“=”附近有语法错误。

THEN 后面不能使用 课程 = 成绩，直接使用 成绩 即可
修改一下代码
```


输入▼

```sql
SELECT 学号,

    CASE
         WHEN  课程 = '语文'  THEN 成绩
         WHEN  课程 = '数学'  THEN 成绩
         WHEN  课程 = '英语'  THEN 成绩
       END

FROM   Score
```
输出▼

```
学号	(无列名)
------------------
0001	87
0001	79
0001	95
0002	69
0002	84
```
基本达到要求，调整一下代码

输入▼

```sql
SELECT 学号,
    (
      CASE
         WHEN  课程 = '语文'  THEN 成绩
       END
    ) AS 语文

FROM   Score
```

输出▼

```
学号	语文
---------------
0001	87
0001	NULL
0001	NULL
0002	69
0002	NULL
```

把数学、英语2列也加进来

输入▼

```sql
SELECT 学号,
    (
      CASE
         WHEN  课程 = '语文'  THEN 成绩
       END
    ) AS 语文,

    (
      CASE
         WHEN  课程 = '数学'  THEN 成绩
       END
    ) AS 数学,

    (
      CASE
         WHEN  课程 = '英语'  THEN 成绩
       END
    ) AS 英语

FROM   Score
```

输出▼

```

学号	语文	数学	英语
-----------------------------------
0001	87	NULL	NULL
0001	NULL	79	NULL
0001	NULL	NULL	95
0002	69	NULL	NULL
0002	NULL	84	NULL
```

进一步达到要求，但是存在重复的序号、NULL值

如何去重、去掉 NULL 呢？

所学过的函数只有 DISTINCT 或者能 GROUP BY 做到

```
DISTINCT

作用于单列，则不能返回各科的成绩

作用于全部列，则不能起到去重的作用
```

```
GROUP BY

必须与其他聚合函数一起使用：MAX、MIN、SUM、COUNT、AVG
```


```sql
SELECT   学号,

         SUM(
         CASE 　WHEN  课程='语文' THEN 成绩 　　ELSE 0
         END) AS 语文,

         SUM(
         CASE 　WHEN  课程='数学' THEN 成绩 　　ELSE 0
         END) AS 数学,

         SUM(
         CASE 　WHEN  课程='英语' THEN 成绩 　　ELSE 0
         END) AS 英语

         FROM Score

GROUP BY 学号


其中 MAX 与 SUM 返回的是正确的值

MIN、AVG、COUNT 返回的是错误的值

```


## 问题汇总
1. THEN 后面跟随的 result_expression 有什么要求？
1. GROUP BY 这段代码，应该如何去理解？其执行顺序是什么样的？
1. 为什么 MAX 与 SUM 返回的是正确的值， MIN 不行？



参考资料：

http://www.cnblogs.com/hanyinglong/archive/2013/03/05/2943706.html

http://www.cnblogs.com/Richardzhu/p/3571670.html

未学习：

http://www.cnblogs.com/kerrycode/archive/2010/07/28/1786547.html

http://www.cnblogs.com/prefect/p/5746624.html