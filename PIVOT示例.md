# PIVOT示例

- [PIVOT示例](#pivot%E7%A4%BA%E4%BE%8B)
    - [测试表](#%E6%B5%8B%E8%AF%95%E8%A1%A8)
    - [语法](#%E8%AF%AD%E6%B3%95)
    - [NULL值的产生](#null%E5%80%BC%E7%9A%84%E4%BA%A7%E7%94%9F)
    - [去除NULL值](#%E5%8E%BB%E9%99%A4null%E5%80%BC)
    - [对多表连接的结果进行 行转列](#%E5%AF%B9%E5%A4%9A%E8%A1%A8%E8%BF%9E%E6%8E%A5%E7%9A%84%E7%BB%93%E6%9E%9C%E8%BF%9B%E8%A1%8C-%E8%A1%8C%E8%BD%AC%E5%88%97)

## 测试表
```sql
CREATE TABLE cq01
   (
       city varchar(20), -- 城市
       year int,         -- 年份
       quarter char(2),  -- 季度
       amount money      -- 总额
   );

INSERT INTO cq01 VALUES ( '北京', 2005, 'Q1', 1000 );
INSERT INTO cq01 VALUES ( '北京', 2005, 'Q2', 1100 );
INSERT INTO cq01 VALUES ( '北京', 2005, 'Q3', 1200 );
INSERT INTO cq01 VALUES ( '北京', 2005, 'Q4', 1300 );
INSERT INTO cq01 VALUES ( '北京', 2006, 'Q1', 2000 );
INSERT INTO cq01 VALUES ( '北京', 2006, 'Q2', 2100 );
INSERT INTO cq01 VALUES ( '北京', 2006, 'Q3', 2200 );
INSERT INTO cq01 VALUES ( '北京', 2006, 'Q4', 2300 );


CREATE TABLE cq02
   (
       city varchar(20), -- 城市
       year int,         -- 年份
       quarter char(2),  -- 季度
       amount money      -- 总额
   );

INSERT INTO cq02 VALUES ( '北京', 2005, 'Q1', 1000 );
INSERT INTO cq02 VALUES ( '北京', 2005, 'Q2', 1100 );
INSERT INTO cq02 VALUES ( '北京', 2005, 'Q3', 1200 );
INSERT INTO cq02 VALUES ( '北京', 2005, 'Q4', 1300 );
INSERT INTO cq02 VALUES ( '北京', 2006, 'Q1', 2000 );
INSERT INTO cq02 VALUES ( '北京', 2006, 'Q2', 2100 );
INSERT INTO cq02 VALUES ( '北京', 2006, 'Q3', 2200 );
INSERT INTO cq02 VALUES ( '北京', 2006, 'Q4', 2300 );
INSERT INTO cq02 VALUES ( '上海', 2005, 'Q1', 3000 );
INSERT INTO cq02 VALUES ( '上海', 2005, 'Q2', 3100 );
INSERT INTO cq02 VALUES ( '上海', 2005, 'Q3', 3200 );
INSERT INTO cq02 VALUES ( '上海', 2006, 'Q1', 4000 );
INSERT INTO cq02 VALUES ( '上海', 2006, 'Q2', 4100 );
INSERT INTO cq02 VALUES ( '上海', 2006, 'Q3', 4200 );



select * from cq01
select * from cq02

```

## 语法
```sql
SELECT <非透视的列>,
    [第一个透视的列] AS <列名称>,
    [第二个透视的列] AS <列名称>,
    ...
    [最后一个透视的列] AS <列名称>,
FROM
    (<生成数据的 SELECT 查询>)
    AS <源查询的别名>
PIVOT
(
    <聚合函数>(<要聚合的列>)
FOR
[<包含要成为列标题的值的列>]
    IN ( [第一个透视的列], [第二个透视的列],
    ... [最后一个透视的列])
) AS <透视表的别名>
<可选的 ORDER BY 子句>;
```

```sql
输入▼
SELECT Q1   AS 一季度, --行转列， 行值 转为 列名
       Q2   AS 二季度, --行转列
       Q3   AS 三季度, --行转列
       Q4   AS 四季度  --行转列
FROM   cq01            --源表

       PIVOT ( SUM (amount) --聚合函数
                FOR quarter --行转列的 基准列
                IN (
                    Q1,     --需要将哪些 行值 转为 列，必须比 select 后面的多
                    Q2,
                    Q3,
                    Q4
                   )
             ) AS p        --表别名,必须有

输出▼

一季度	二季度	三季度	四季度
-------------------------------------------
1000.00	1100.00	1200.00	1300.00
2000.00	2100.00	2200.00	2300.00
```

缺少 城市、年份2列，不清楚对应是是哪个城市、哪一年

下面的代码，添加输出 城市、年份

```sql
输入▼
SELECT city AS 城市,   --非透视的列,可选             --与上面的代码相比，增加了 city
       year AS 年份,   --非透视的列,可选             --与上面的代码相比，增加了 year
       Q1   AS 一季度, --行转列， 行值 转为 列名
       Q2   AS 二季度, --行转列
       Q3   AS 三季度, --行转列
       Q4   AS 四季度  --行转列
FROM   cq01            --源表

       PIVOT ( SUM (amount) --聚合函数
                FOR quarter --行转列的 基准列
                IN (
                    Q1,     --需要将哪些 行值 转为 列，必须比 select 后面的多
                    Q2,
                    Q3,
                    Q4
                   )
             ) AS p        --表别名,必须有

输出▼

城市	年份	一季度	二季度	三季度	四季度
----------------------------------------------------
北京	2005	1000.00	1100.00	1200.00	1300.00
北京	2006	2000.00	2100.00	2200.00	2300.00
```


**细节**
> `SELECT` 后面的 Q1、Q2...  必须比  `IN` 后面的少

> `SELECT` 后面的 Q1、Q2...；`FRO` 后面的 列名； `IN` 后面的 Q1、Q2... 是同一列

> 原始表格中有多列，以其中一列为基准，进行 行列转换



## NULL值的产生


```sql

CREATE TABLE cq20
   (
       num int identity(1,1),  -- 序号
       city varchar(20),       -- 城市
       year int,               -- 年份
       quarter char(2),        -- 季度
       amount money            -- 总额
   );

INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '北京', 2005, 'Q1', 1000 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '北京', 2005, 'Q2', 1100 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '北京', 2005, 'Q3', 1200 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '北京', 2005, 'Q4', 1300 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '北京', 2006, 'Q1', 2000 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '北京', 2006, 'Q2', 2100 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '北京', 2006, 'Q3', 2200 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '北京', 2006, 'Q4', 2300 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '上海', 2005, 'Q1', 3000 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '上海', 2005, 'Q2', 3100 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '上海', 2005, 'Q3', 3200 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '上海', 2006, 'Q1', 4000 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '上海', 2006, 'Q2', 4100 );
INSERT INTO cq20 (city,year,quarter,amount)  VALUES ( '上海', 2006, 'Q3', 4200 );

```

```sql
select * from  cq02

city	year	quarter	amount
------------------------------------
北京	2005	Q1	1000.00
北京	2005	Q2	1100.00
北京	2005	Q3	1200.00
北京	2005	Q4	1300.00
北京	2006	Q1	2000.00
北京	2006	Q2	2100.00
北京	2006	Q3	2200.00
北京	2006	Q4	2300.00
上海	2005	Q1	3000.00
上海	2005	Q2	3100.00
上海	2005	Q3	3200.00
上海	2006	Q1	4000.00
上海	2006	Q2	4100.00
上海	2006	Q3	4200.00
```

```sql
select * from  cq20

num	city	year	quarter	amount
-------------------------------------------
1	北京	2005	Q1	1000.00
2	北京	2005	Q2	1100.00
3	北京	2005	Q3	1200.00
4	北京	2005	Q4	1300.00
5	北京	2006	Q1	2000.00
6	北京	2006	Q2	2100.00
7	北京	2006	Q3	2200.00
8	北京	2006	Q4	2300.00
9	上海	2005	Q1	3000.00
10	上海	2005	Q2	3100.00
11	上海	2005	Q3	3200.00
12	上海	2006	Q1	4000.00
13	上海	2006	Q2	4100.00
14	上海	2006	Q3	4200.00
```


> `cq20` 比 `cq02` 多了一列序号



```sql

查询 cq02 ▼

SELECT city AS 城市, year as 年份, Q1 AS 一季度, Q2 AS 二季度, Q3 AS 三季度, Q4 AS 四季度

FROM   cq02

    PIVOT
            (
            SUM (amount) FOR quarter

            IN ( Q1,Q2, Q3, Q4 )

            ) AS p
```
```
输出▼

城市	年份	一季度	二季度	三季度	四季度
-----------------------------------------------------------
北京	2005	1000.00	1100.00	1200.00	1300.00
上海	2005	3000.00	3100.00	3200.00	NULL
北京	2006	2000.00	2100.00	2200.00	2300.00
上海	2006	4000.00	4100.00	4200.00	NULL
```


```sql

查询 cq20 ▼

SELECT num as 序号, city AS 城市, year as 年份, Q1 AS 一季度, Q2 AS 二季度, Q3 AS 三季度, Q4 AS 四季度

FROM   cq20

    PIVOT
            (
            SUM (amount) FOR quarter

            IN ( Q1,Q2, Q3, Q4 )

            ) AS p
```
```
输出▼

序号	城市	年份	一季度	二季度	三季度	四季度
--------------------------------------------------------
1	北京	2005	1000.00	NULL	NULL	NULL
2	北京	2005	NULL	1100.00	NULL	NULL
3	北京	2005	NULL	NULL	1200.00	NULL
4	北京	2005	NULL	NULL	NULL	1300.00
5	北京	2006	2000.00	NULL	NULL	NULL
6	北京	2006	NULL	2100.00	NULL	NULL
7	北京	2006	NULL	NULL	2200.00	NULL
8	北京	2006	NULL	NULL	NULL	2300.00
9	上海	2005	3000.00	NULL	NULL	NULL
10	上海	2005	NULL	3100.00	NULL	NULL
11	上海	2005	NULL	NULL	3200.00	NULL
12	上海	2006	4000.00	NULL	NULL	NULL
13	上海	2006	NULL	4100.00	NULL	NULL
14	上海	2006	NULL	NULL	4200.00	NULL
```

> 可以发现 查询cq20 后返回了多个NULL值

> 区别： `cq20` 比 `cq02` 多了一列序号

> 猜测：SQL 对行转列后的数据自动进行了聚合、分组
```
对于 cq02 ，sum 合计4个季度的总额，然后类似 `group by 城市,年份` 对 城市+年份 这2列所拼接成的值进行分组，值一样的合并为一组，返回数据

对于 cq20 ，sum 没有对4个季度进行合计，因为对SQL来说  `group by 序号,城市,年份` ，这3列所拼接成的值都是不一样的,所以返回了每一行。
```


## 去除NULL值

```sql

输入▼

select city as 城市 ,year as 年份 ,Q1 as 一季度 ,Q2 as 二季度 ,Q3 as 三季度,Q4 as 四季度

  from ( select city ,year ,quarter,amount from cq20) as cq02

    pivot
    (
        sum(amount) for quarter
        in (Q1,Q2,Q3,Q4)
    ) as p


输出▼

城市	年份	一季度	二季度	三季度	四季度
----------------------------------------------------
北京	2005	1000.00	1100.00	1200.00	1300.00
上海	2005	3000.00	3100.00	3200.00	NULL
北京	2006	2000.00	2100.00	2200.00	2300.00
上海	2006	4000.00	4100.00	4200.00	NULL

结果一致

```

代码用到了子查询，简单来说就是 删除了源表中的 `序号` 这一列的数据。

`select city ,year ,quarter,amount from cq20`

只返回 `city ,year ,quarter,amount`

这4列的值，序号 列 没有被选中，这样实际上就和 表 `cq02` 完全一样了。

这个可以延伸到多表连接

## 对多表连接的结果进行 行转列

```sql
-- 会员表
CREATE TABLE T_MEMBER (
    MEMBER_ID CHAR(02) PRIMARY KEY,
    MEMBER_NAME VARCHAR(20)
)
-- 商品表
CREATE TABLE T_PRODUCT (
    PRODUCT_ID CHAR(02) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(20)
)
-- 订单表
CREATE TABLE T_ORDER (
    ORDER_ID INT PRIMARY KEY,
    MEMBER_ID CHAR(02),
    PRODUCT_ID CHAR(02),
    QTY INT
)

-- 插入会员信息
INSERT INTO T_MEMBER VALUES ('M1', '张一')
INSERT INTO T_MEMBER VALUES ('M2', '张二')
INSERT INTO T_MEMBER VALUES ('M3', '张三')
INSERT INTO T_MEMBER VALUES ('M4', '张四')
INSERT INTO T_MEMBER VALUES ('M5', '张五')

-- 插入商品信息
INSERT INTO T_PRODUCT VALUES ('P1', '自行车')
INSERT INTO T_PRODUCT VALUES ('P2', '相机')
INSERT INTO T_PRODUCT VALUES ('P3', '笔记本')

-- 插入订单信息
INSERT INTO T_ORDER VALUES (1, 'M1', 'P1', 1)
INSERT INTO T_ORDER VALUES (2, 'M2', 'P2', 2)
INSERT INTO T_ORDER VALUES (3, 'M3', 'P1', 1)
INSERT INTO T_ORDER VALUES (4, 'M3', 'P1', 1)
INSERT INTO T_ORDER VALUES (5, 'M2', 'P3', 1)
INSERT INTO T_ORDER VALUES (6, 'M1', 'P2', 3)
INSERT INTO T_ORDER VALUES (7, 'M3', 'P1', 1)
INSERT INTO T_ORDER VALUES (8, 'M1', 'P1', 2)
INSERT INTO T_ORDER VALUES (9, 'M2', 'P3', 1)
INSERT INTO T_ORDER VALUES (10, 'M1', 'P2', 1)

```
表格如下
```
MEMBER_ID	MEMBER_NAME
-----------------------------------
M1	            张一
M2	            张二
M3	            张三
M4	            张四
M5	            张五



ORDER_ID	MEMBER_ID	PRODUCT_ID	QTY
-----------------------------------------------
1	        M1	        P1      	1
2	        M2	        P2      	2
3	        M3	        P1      	1
4	        M3	        P1      	1
5	        M2	        P3      	1
6	        M1	        P2      	3
7	        M3	        P1      	1
8	        M1	        P1      	2
9	        M2	        P3      	1
10	        M1	        P2      	1



PRODUCT_ID	PRODUCT_NAME
--------------------------------------------
P1	         自行车
P2	         相机
P3	         笔记本
```

要求：返回如下表格
```
会员名称	笔记本	相机	自行车
-----------------------------------
张二	2	2	NULL
张三	NULL	NULL	3
张一	NULL	4	3
```


-- 会员 + 商品 统计
```sql
SELECT T2.MEMBER_NAME AS 会员名称, T3.PRODUCT_NAME AS 商品名称, SUM(T1.QTY) AS 数量

  FROM T_ORDER AS T1 INNER JOIN T_MEMBER  AS T2 ON T1.MEMBER_ID  = T2.MEMBER_ID
                     INNER JOIN T_PRODUCT AS T3 ON T1.PRODUCT_ID = T3.PRODUCT_ID

GROUP BY T2.MEMBER_NAME, T3.PRODUCT_NAME


输出▼

会员名称	商品名称	数量
--------------------------------
张二	笔记本	2
张二	相机	2
张一	相机	4
张三	自行车	3
张一	自行车	3
```

```sql

SELECT *
  FROM (
        SELECT T2.MEMBER_NAME AS 会员名称, T3.PRODUCT_NAME AS 商品名称, SUM(T1.QTY) AS 数量

        FROM T_ORDER AS T1 INNER JOIN T_MEMBER  AS T2 ON T1.MEMBER_ID  = T2.MEMBER_ID
                            INNER JOIN T_PRODUCT AS T3 ON T1.PRODUCT_ID = T3.PRODUCT_ID

        GROUP BY T2.MEMBER_NAME, T3.PRODUCT_NAME) AS T  --这个括号里面的就是第一步的代码

PIVOT (SUM(数量) FOR 商品名称 IN(笔记本, 相机, 自行车)) AS PVT
```




参考资料：

http://www.cnblogs.com/lwhkdash/archive/2012/06/26/2562979.html

http://database.51cto.com/art/201107/276189_all.htm

未阅读：

http://blog.csdn.net/leshami/article/details/5385117

SELECT

'随便一个字符串, 单引号括起来:' AS [总人数],


列名、字段名中有空格之类的，使用中括号括起来 []





























```