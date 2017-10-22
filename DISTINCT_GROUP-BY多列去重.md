
# DISTINCT、GROUP BY 多列去重

## 实验数据
```sql
create table gbt
(
a varchar(20),
b varchar(20),
c varchar(20),
d varchar(20),
e varchar(20)
)

insert into gbt (a, b, c, d, e) values ('1', 'a', '甲', 'W', '2')
insert into gbt (a, b, c, d, e) values ('1', 'a', '甲', 'W', '2')
insert into gbt (a, b, c, d, e) values ('1', 'a', '甲', 'W', '3')
insert into gbt (a, b, c, d, e) values ('1', 'a', '乙', 'W', '3')
insert into gbt (a, b, c, d, e) values ('1', 'a', '乙', 'X', '4')
insert into gbt (a, b, c, d, e) values ('1', 'b', '乙', 'X', '4')
insert into gbt (a, b, c, d, e) values ('1', 'b', '乙', 'Y', '5')
insert into gbt (a, b, c, d, e) values ('1', 'b', '丙', 'Y', '5')
insert into gbt (a, b, c, d, e) values ('1', 'b', '丙', 'Z', '6')
insert into gbt (a, b, c, d, e) values ('1', 'b', '丙', 'Z', '6')

select * from gbt

```

表格如图：

 a   | b   | c   | d   | e
 --- | --- | --- | --- | ---
 1   | a   | 甲  | W   | 2
 1   | a   | 甲  | W   | 2
 1   | a   | 甲  | W   | 3
 1   | a   | 乙  | W   | 3
 1   | a   | 乙  | X   | 4
 1   | b   | 乙  | X   | 4
 1   | b   | 乙  | Y   | 5
 1   | b   | 丙  | Y   | 5
 1   | b   | 丙  | Z   | 6
 1   | b   | 丙  | Z   | 6

## DISTINCT

要求1：查询 c 列，甲乙丙不重复的数据，同时返回 d 列的数据

输入▼

```sql
select distinct c, d from gbt
```
输出▼

```
c	d
----------------------------------------
丙	Y
丙	Z
甲	W
乙	W
乙	X
乙	Y
```

c列怎么还是有重复值？distinct没起作用？

测试一下单列是什么情况

输入▼

```sql
select distinct c from gbt
```

输出▼

```
c
----------------------------------------
丙
甲
乙
```

看来作用是起了的

为什么2列的时候没有起作用呢？

查了资料：distinct 同时作用了两列，也就是必须得 c 列 与 d 列 都相同的才会被排除

调整一下代码

输入▼

```sql
select distinct c, distinct d from gbt
```
输出▼

```
消息 156，级别 15，状态 1，第 1 行
关键字 'distinct' 附近有语法错误。
```

查了资料，distinct必须放在第1列的前面，或者与聚合函数一起使用。

调整一下代码

输入▼

```sql

select c,count(d)
from gbt
group by c
```

输出▼

```
c	(无列名)
----------------------------------------
丙	3     表明 c列的丙 与 d列的值  所形成的组合有3个
甲	3     表明 c列的甲 与 d列的值  所形成的组合有3个
乙	4     表明 c列的乙 与 d列的值  所形成的组合有4个
```

输入▼

```sql

select c, count(distinct d)
from gbt
group by c

```

输出▼

```
c	(无列名)
----------------------------------------
丙	2     表明 c列的丙 与 d列的值  所形成的 不重复的组合有  2个
甲	1     表明 c列的甲 与 d列的值  所形成的 不重复的组合有  1个
乙	3     表明 c列的乙 与 d列的值  所形成的 不重复的组合有  3个
```

到这里我们发现，这个题目没有实质上的意义，对数据所进行的操作是没有道理的

就单以 c、 d 两列数据来说

 c   | d
 --- | ---
 甲  | W
 甲  | W
 甲  | W
 乙  | W
 乙  | X
 乙  | X
 乙  | Y
 丙  | Y
 丙  | Z
 丙  | Z

c列可以返回不同的值，甲、乙、丙，但是其对应的 d 列的值要取哪个？

例如乙， 乙与 d 列形成了：乙+W 、 乙+ X 、 乙+Y 。3个不重复的组合，那么是要W、X、Y中的哪个？

所以问题是没有意思的。

> 延伸：如果 c 列代表用户，d 列代表不同用户的每次购物的下单时间

> 那么要求返回最近的订单时间就有意思了


输入▼

```sql
代码暂时不知道怎么写，先空着
这个题目跟 1对多 的 join 有相似之处
```



---


## GROUP BY

---

输入▼

```sql
select a, count(b) from gbt
group by a
```

输出▼

```
a	(无列名)
----------------------------------------
1	10
```

---

输入▼

```sql
select b, count(a)
from gbt
group by b
```

输出▼

```
b	(无列名)
----------------------------------------
a	5
b	5
```

---
输入▼

```sql
select a, b, c, count(a)
from gbt
group by a, b, c
```

输出▼

```
a	b	c	(无列名)
----------------------------------------
1	a	甲	3
1	a	乙	2
1	b	丙	3
1	b	乙	2
```

---
输入▼

```sql
select a, b, c,d ,count(d)
from gbt
group by a, b , c,d
```

输出▼

```
a	b	c	d	(无列名)
----------------------------------------
1	a	甲	W	3
1	a	乙	W	1
1	a	乙	X	1
1	b	丙	Y	1
1	b	丙	Z	2
1	b	乙	X	1
1	b	乙	Y	1
```

---
输入▼

```sql
select a, b, c,d ,count(d)
from gbt
group by d, c, b, a

```

输出▼

```

a	b	c	d	(无列名)
----------------------------------------
1	a	甲	W	3
1	a	乙	W	1
1	a	乙	X	1
1	b	乙	X	1
1	b	丙	Y	1
1	b	乙	Y	1
1	b	丙	Z	2
```

---


以 group by a, b , c,d 为例

1. group by 后面的 a,b,c,d 的顺序不影响结果

1. 整个流程：首先把a,b,c,d 四列的内容拼接起来，当作一个列
    - 1 + a + 甲 + W
    - 1 + a + 甲 + W
    - 1 + a + 甲 + W
    - 1 + a + 乙 + W
    - 1 + a + 乙 + X
    - 1 + b + 乙 + X
    - 1 + b + 乙 + Y
    - 1 + b + 丙 + Y
    - 1 + b + 丙 + Z
    - 1 + b + 丙 + Z

    然后，再对拼接的结果进行：
    1. 分组：相同的内容合并为1组,共有7个不同的组合
    1. 计数：count 计算各组的数量：3个1a甲W， 1个1a乙W， 1个1a乙X，1个1b乙X, 1个1b乙Y， 1个1b丙Y， 2个1b丙Z
1. group by 后面的多个列的内容拼接之后，分组去重，count计数


## 关于拼接的理解

表a

 fname | lname
 ----- | -----
 秦    | 始皇
 秦始  | 皇




输入▼
```sql
select distinct fname, lname from a
```

输出▼
```
fname    lname
----------------------------------------
秦       始皇
秦始     皇


第一行拼接的结果： 秦 + 始皇      而不是  秦始皇

第二行拼接的结果： 秦始 + 皇      而不是  秦始皇

如果拼接成  秦始皇  的话，就只返回一个值了

```

> 对上面的例子来讲， 1 + a + 甲 + W 与 1a + 甲 + W 是不同的
