# 左连接、右连接等各种JOIN
>维基百科：需要对照查查看中英文版

> 中文版：https://zh.wikipedia.org/wiki/%E8%BF%9E%E6%8E%A5_(SQL)

> 英文版：https://en.wikipedia.org/wiki/Join_(SQL)


- [左连接、右连接等各种JOIN](#%E5%B7%A6%E8%BF%9E%E6%8E%A5%E3%80%81%E5%8F%B3%E8%BF%9E%E6%8E%A5%E7%AD%89%E5%90%84%E7%A7%8Djoin)
    - [测试表](#%E6%B5%8B%E8%AF%95%E8%A1%A8)
    - [1. 内连接(INNER JOIN)](#1-%E5%86%85%E8%BF%9E%E6%8E%A5inner-join)
        - [1.1 相等连接 (EQUI-JOIN，或 EQUIJOIN)](#11-%E7%9B%B8%E7%AD%89%E8%BF%9E%E6%8E%A5-equi-join%EF%BC%8C%E6%88%96-equijoin)
            - [1.1.1 自然连接(NATURAL JOIN)](#111-%E8%87%AA%E7%84%B6%E8%BF%9E%E6%8E%A5natural-join)
        - [1.2 交叉连接(CROSS JOIN)](#12-%E4%BA%A4%E5%8F%89%E8%BF%9E%E6%8E%A5cross-join)
    - [2. 外连接(OUTER JOIN)](#2-%E5%A4%96%E8%BF%9E%E6%8E%A5outer-join)
        - [2.1 左连接（LEFT JOIN）](#21-%E5%B7%A6%E8%BF%9E%E6%8E%A5%EF%BC%88left-join%EF%BC%89)
        - [2.2 右连接（RIGHT JOIN）](#22-%E5%8F%B3%E8%BF%9E%E6%8E%A5%EF%BC%88right-join%EF%BC%89)
        - [2.3 全连接（FULL JOIN）](#23-%E5%85%A8%E8%BF%9E%E6%8E%A5%EF%BC%88full-join%EF%BC%89)
    - [3. 自连接](#3-%E8%87%AA%E8%BF%9E%E6%8E%A5)



## 测试表
```sql
create table employee
(
LastName varchar(20),
DepartmentID int
)

create table department
(
DepartmentID int,
DepartmentName varchar(20)
)

insert into employee values ('鼠', 31     );
insert into employee values ('牛', 33     );
insert into employee values ('虎', 33     );
insert into employee values ('兔', 34     );
insert into employee values ('龙', 34     );
insert into employee values ('蛇', NULL   );
insert into employee values ('马', NULL   );
insert into employee values ('羊', 32     );
insert into employee values ('龙', 31     );

insert into department values (31, '销售部 ' );
insert into department values (33, '工程部 ' );
insert into department values (34, '秘书部 ' );
insert into department values (35, '市场部 ' );
```

```
表employee：

LastName	DepartmentID
-------------------------------
鼠       	31
牛       	33
虎       	33
兔       	34
龙       	34
蛇       	NULL
马       	NULL
羊         32
龙       	31



表department：

DepartmentID	DepartmentName
----------------------------
31          	销售部
33          	工程部
34          	秘书部
35          	市场部


注:
市场部   目前没有员工列出.
蛇、马   不在 部门表中的任何一个部门
龙      同时属于 31、34 两个部门
羊      所在的部门未列出
```

## 1. 内连接(INNER JOIN)
> 内连接"可以进一步被分为：相等连接，自然连接，和交叉连接

> 代码1 与 代码2 实质是一样的：
```
SQL 定义了两种不同语法方式去表示`连接`。
首先是`显式连接符号`，它显式地使用关键字 JOIN     ----------代码1
其次是`隐式连接符号`，它使用所谓的`隐式连接符号`   ----------代码2
```

```sql
代码1--显式内连接

SELECT *
FROM   employee
       INNER JOIN department
          ON employee.DepartmentID = department.DepartmentID

等价于:

代码2--隐式内连接

SELECT *
FROM   employee, department
WHERE  employee.DepartmentID = department.DepartmentID
```



输出▼

```
LastName	DepartmentID	DepartmentID	DepartmentName
------------------------------------------------------------
鼠	       31            	31	          销售部
牛	       33            	33	          工程部
虎	       33            	33	          工程部
兔	       34            	34	          秘书部
龙	       34            	34	          秘书部
龙	       31            	31	          销售部
```

> 返回2个表同时存在的数据，类似交集

### 1.1 相等连接 (EQUI-JOIN，或 EQUIJOIN)

> 在连接条件中使用等于号（=）运算符的连接

```sql
代码1属于相等连接

SELECT *
FROM   employee
       INNER JOIN department
          ON employee.DepartmentID = department.DepartmentID
```

另外一种可选的简短符号去表达相等连接，它使用 USING 关键字：

```sql
SELECT *
FROM   employee
       INNER JOIN department
          USING (DepartmentID)
```

> [Microsoft SQL Server 似乎不支持 USING 和 自然连接（NATURAL JOIN）](https://connect.microsoft.com/SQLServer/feedback/details/153679/natural-join-and-using-clause-in-joins)

#### 1.1.1 自然连接(NATURAL JOIN)
> 自然连接 是 相等连接的进一步特例化

```sql
SELECT *
FROM   employee NATURAL JOIN department
```

具体结果未知，Microsoft SQL Server 报错

### 1.2 交叉连接(CROSS JOIN)

> 它是所有类型的内连接的基础。把表视为行记录的集合，交叉连接即返回这两个集合的笛卡尔积。

```sql
显式的交叉连接实例:

SELECT *
FROM   employee CROSS JOIN department

隐式的交叉连接实例:

SELECT *
FROM   employee, department;
```

输出▼

```
LastName     DepartmentID     DepartmentID      DepartmentName
------------------------------------------------------------
鼠           31                 31                  销售部
牛           33                 31                  销售部
虎           33                 31                  销售部
兔           34                 31                  销售部
龙           34                 31                  销售部
蛇           NULL               31                  销售部
马           NULL               31                  销售部
羊           32                 31                  销售部
龙           31                 31                  销售部
鼠           31                 33                  工程部
牛           33                 33                  工程部
虎           33                 33                  工程部
兔           34                 33                  工程部
龙           34                 33                  工程部
蛇           NULL               33                  工程部
马           NULL               33                  工程部
羊           32                 33                  工程部
龙           31                 33                  工程部
鼠           31                 34                  秘书部
牛           33                 34                  秘书部
虎           33                 34                  秘书部
兔           34                 34                  秘书部
龙           34                 34                  秘书部
蛇           NULL               34                  秘书部
马           NULL               34                  秘书部
羊           32                 34                  秘书部
龙           31                 34                  秘书部
鼠           31                 35                  市场部
牛           33                 35                  市场部
虎           33                 35                  市场部
兔           34                 35                  市场部
龙           34                 35                  市场部
蛇           NULL               35                  市场部
马           NULL               35                  市场部
羊           32                 35                  市场部
龙           31                 35                  市场部

```

## 2. 外连接(OUTER JOIN)

> 外连接分为左连接（LEFT JOIN）或左外连接（LEFT OUTER JOIN）、右连接（RIGHT JOIN）或右外连接（RIGHT OUTER JOIN）、全连接（FULL JOIN）或全外连接（FULL OUTER JOIN）。我们就简单的叫：左连接、右连接和全连接。

> 辅助理解：

- [图解JOIN](https://zhuanlan.zhihu.com/p/29234064)
- [图解JOIN的补充](https://blog.jooq.org/2016/07/05/say-no-to-venn-diagrams-when-explaining-joins/)


### 2.1 左连接（LEFT JOIN）

```sql
SELECT *
FROM   department  LEFT  JOIN employee  --以 LEFT JOIN 左边的表为基准
          ON employee.DepartmentID = department.DepartmentID
```

### 2.2 右连接（RIGHT JOIN）
```sql
SELECT *
FROM   department RIGHT  JOIN employee  --以 RIGHT JOIN 右边的表为基准
          ON employee.DepartmentID = department.DepartmentID

-- 实际上显式的右连接很少使用, 因为它总是可以被替换成左连接--换换表的位置就可以了
-- 另外, 右连接相对于左连接并没有什么额外的功能.
```

### 2.3 全连接（FULL JOIN）
```sql
SELECT *
FROM   department
       FULL  JOIN employee
          ON employee.DepartmentID = department.DepartmentID
```

输出   2.1    2.2    2.3  ▼

```
左连接：以左表为基准，返回查询值。
DepartmentID     DepartmentName     LastName     DepartmentID
--------------------------------------------------------------------------
31               销售部              鼠              31      --左表有，右表有多条记录的，返回多条记录
31               销售部              龙              31
33               工程部              牛              33
33               工程部              虎              33
34               秘书部              兔              34
34               秘书部              龙              34
35               市场部              NULL            NULL    --左表有，右表没有的，显示为 NULL
                                                            --左表没有，右表有的，不返回

右连接：以右表为基准，返回查询值。
DepartmentID     DepartmentName     LastName     DepartmentID
--------------------------------------------------------------------------
31                销售部             鼠              31
33                工程部             牛              33
33                工程部             虎              33
34                秘书部             兔              34
34                秘书部             龙              34
NULL              NULL              蛇              NULL
NULL              NULL              马              NULL
NULL              NULL              羊              32
31                销售部             龙              31

全连接:返回左右连接的并集
DepartmentID     DepartmentName     LastName     DepartmentID
--------------------------------------------------------------------------
31               销售部               鼠            31
31               销售部               龙            31
33               工程部               牛            33
33               工程部               虎            33
34               秘书部               兔            34
34               秘书部               龙            34
35               市场部               NULL          NULL
NULL             NULL                蛇             NULL
NULL             NULL                马             NULL
NULL             NULL                羊             32

```

## 3. 自连接


```
