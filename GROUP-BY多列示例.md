
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
| a   | b   | c   | d   | e   |
| --- | --- | --- | --- | --- |
| 1   | a   | 甲  | W   | 2   |
| 1   | a   | 甲  | W   | 2   |
| 1   | a   | 甲  | W   | 3   |
| 1   | a   | 乙  | W   | 3   |
| 1   | a   | 乙  | X   | 4   |
| 1   | b   | 乙  | X   | 4   |
| 1   | b   | 乙  | Y   | 5   |
| 1   | b   | 丙  | Y   | 5   |
| 1   | b   | 丙  | Z   | 6   |
| 1   | b   | 丙  | Z   | 6   |


然后开始测试 group by 列数更改会有什么结果

---

输入▼

```sql
select a, conut(b) from gbt
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
select b, count(a)
from gbt
group by b
```

输出▼

```
a	b	(无列名)
----------------------------------------
1	a	5
1	b	5
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

1. a,b,c,d 的顺序不影响结果

1. 整个流程：首先把a,b,c,d 四列的内容拼接起来
    - 1a甲W
    - 1a甲W
    - 1a甲W
    - 1a乙W
    - 1a乙X
    - 1b乙X
    - 1b乙Y
    - 1b丙Y
    - 1b丙Z
    - 1b丙Z

    然后，再对拼接的结果进行：
    1. 分组：相同的内容合并为1组,共有7个不同的组合
    1. 计数：count 计算各组的数量：3个1a甲W， 1个1a乙W， 1个1a乙X，1个1b乙X, 1个1b乙Y， 1个1b丙Y， 2个1b丙Z
1. group by 后面的多个列的内容拼接之后，分组去重，count计数
1. 可以说是把，group by 后面的多个列，看作是1个列，类似多列的主键，内容不重复
1. 问题：a,b,c,d 后面的 e 列，并没有包含在内， 1a甲W2 与 1a甲W3 差别在于 1a甲W 后面e列的 2 与 3 的区别，想要统计不重复的


