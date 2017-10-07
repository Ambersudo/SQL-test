--例1：使用子句列出订购物品 RGAN01 的所有顾客

SELECT order_num
FROM OrderItems
WHERE prod_id = 'RGAN01'

SELECT cust_id
FROM Orders
WHERE order_num IN ('20007', '20008')

SELECT *
FROM Customers
WHERE cust_id IN ('1000000004', '1000000005')

SELECT cust_id
FROM Orders
WHERE order_num IN 
    (SELECT order_num
    FROM OrderItems
    WHERE prod_id = 'RGAN01')

SELECT *
FROM Customers
WHERE cust_id IN 
    (SELECT cust_id
    FROM Orders
    WHERE order_num IN 
        (SELECT order_num
        FROM OrderItems
        WHERE prod_id = 'RGAN01')) 

--例2：显示Customers表中每个顾客的订单总数。订单与相应的顾客ID存储在Orders表中。

/*
思路反推：（在解决不了这个问题，答案又看不懂的情况下，复盘之前写这些代码的原因，及这些代码的问题，可能与最开始的想法有些出入，大致应该是一致的） 
原先的想法是：首先我们的结果是得到一个表，表中包含 每个客户的名字，及其对应的订单数量 顾客信息 使用SELECT 从表中获取
最后一个 订单数量 这个字段的数据如何形成 count ？，展现出来肯定还是使用
SELECT cust_id,
         cust_name,
         cust_contact
QU--01 前面这些都没有问题，问题在于订单数量如何获取，同时再与左侧字段的数据一一对应？不知道，卡在这里。
*/


--根据前面所学的，子句、嵌套，将整个查询语句拆分成以下2段 

SELECT cust_id,
         count(cust_id) AS pn1
FROM Orders
GROUP BY  cust_id --这段代码的结果是正确，问题在于，客户数量不完整，在 Orders 表中，有一个客户没有下单。


SELECT cust_id,
         cust_name,
         cust_contact,
         count(order_num)
FROM Customers, Orders
WHERE Customers.cust_id = Orders.cust_id
GROUP BY  cust_id --这个组合的代码，就是随便拼凑起来的了，很直白的参考之前所学的内容。组合有误。问题：错在哪里，如何更改？

SELECT cust_id,
         cust_name,
         cust_contact,
    (SELECT count(*)
    FROM Orders
    WHERE Customers.cust_id = Orders.cust_id) AS pn1
FROM Customers
GROUP BY  cust_id 
/*
QU--02 这是参考正确答案后修改的代码，多了group by 语句， 为什么不需要GROUP BY  函数，就能够分组？原先就不需要分组 ？
题目中原有的意思是，列出每个顾客的订单，0订单的也显示为0，而不是不显示。 select语句是抽取相关字段的数据
QU--01 问题：SELECT 子句中的数据如何 与 前面2列的数据一一对应？
WHERE 条件只适用于子句查询，这个子句查询是什么意思呢？
*/ 

--例2原文解释 

SELECT cust_name,
         cust_state,
    (SELECT COUNT(*)
    FROM Orders
    WHERE Orders.cust_id = Customers.cust_id) AS orders
FROM Customers
ORDER BY  cust_name; 
/*
使用子查询的另一方法是创建计算字段。假如需要显示Customers表中每个顾客的订单总数。订单与相应的顾客ID存储在Orders表中。 执行这个操作，要遵循下面的步骤： 
    1. 从Customers表中检索顾客列表； 
    2. 对于检索出的每个顾客，统计其在Orders表中的订单数目。 
正如前两课所述，可以使用SELECT COUNT(*)对表中的行进行计数，并且通过提供一条WHERE子句来过滤某个特定的顾客ID，仅对该顾客的订单进行计数。 
例如，下面的代码对顾客1000000001的订单进行计数：
*/

SELECT COUNT(*) AS orders
FROM Orders
WHERE cust_id = '1000000001'; 

--要对每个顾客执行 COUNT(*)，应该将它作为一个子查询。请看下面的代码：

SELECT cust_name,
         cust_state,
    (SELECT COUNT(*)
    FROM Orders
    WHERE Orders.cust_id = Customers.cust_id) AS orders
FROM Customers
ORDER BY  cust_name; 
/*
输出▼

cust_name                      cust_state  orders
-----------------------------  ----------  ------ 
Fun4All                         IN          1 
Fun4All                         AZ          1 
Kids Place OH 0 The Toy Store   IL          1 
Village Toys                    MI          2 

分析▼
这条SELECT语句对Customers表中每个顾客返回三列：cust_name、cust_state和orders。 
orders是一个计算字段，它是由圆括号中的子查询建立的。该子查询对检索出的每个顾客执行一次。 
在此例中，该子查询执行了5次，因为检索出了5个顾客。 

*/

/*
例2的另一种想法
QU--03 换一种思路，首先创建一个表（临时表？index，索引？不存储在硬盘，只暂存于内存中？）
每个顾客 及 每个顾客对应的订单号，无则为 NULL ——> 适用JOIN 
*/

SELECT Customers.cust_id,
         cust_name,
         cust_contact,
         order_num,
         order_date
FROM Customers, Orders
WHERE Customers.cust_id = Orders.cust_id 

/*
上面这段代码，如果顾客没有购买的话，就没有显示出来。不符合题目要求：列出每个顾客的订单，0订单的也显示为0，而不是不显示。 
QU--04 那么下面这段代码与 inner jion 很类似啊？ 有什么区别？
*/

SELECT Customers.cust_id,
         cust_name,
         cust_contact,
         order_num,
         order_date
FROM Customers
INNER JOIN Orders
    ON Customers.cust_id = Orders.cust_id

--ANS--04 这2段代码的的结果是一样的，其含义也都一样，都是以 cust_id 为链接，返回左右侧有关联的所有数据 

SELECT Customers.cust_id,
         cust_name,
         cust_contact,
         order_num,
         order_date
FROM Customers
LEFT JOIN Orders
    ON Customers.cust_id = Orders.cust_id

/*
然后再对上面的表进行count，统计每个客户的订单数量。 
MK--01 重点：左表对应的 右表，有多条记录时，汇总表中，也会体现多种表。
不仅仅是交集的概念，还有全排列的概念。
*/

/*
例1-2：使用连接列出订购物品 RGAN01 的所有顾客
思路： 左连接也分步骤，分子句来写，然后再组合 第一步连接购买该产品的顾客及其id 
*/

SELECT cust_id,
         prod_id
FROM OrderItems
LEFT JOIN Orders
    ON OrderItems.order_num = Orders.order_num
WHERE prod_id = 'RGAN01' 

/*
输出▼
cust_id    prod_id
---------- -------
1000000004 RGAN01
1000000005 RGAN01 

看到这个表，发现再使用子句，是一件很蠢的事情，应该继续使用连接
问题：如果我们没有看到这个表，我们能想得到使用连接是怎么一个过程的么？ 要有抽象思维，想象一个表？
*/

--根据已知条件 最终的表是XXX，再从后往前推

SELECT cust_name,
         cust_contact
FROM OrderItems
LEFT JOIN Orders
    ON OrderItems.order_num = Orders.order_num
WHERE prod_id = 'RGAN01'
LEFT JOIN Customers
    ON Orders.cust_id = Customers.cust_id --错误：关键字 'left' 附近有语法错误
    
SELECT cust_id,
         prod_id,
         cust_name,
         cust_contact
FROM OrderItems
LEFT JOIN Orders
    ON OrderItems.order_num = Orders.order_num
WHERE prod_id = 'RGAN01'
LEFT JOIN Customers
    ON Orders.cust_id = Customers.cust_id --QU--05仍然不行，一样的错误提示，多个LEFT JOIN 该如何连接？并且同时伴有WHERE
    
/*
例1-2原文解释 
如第11课所述，这个查询中的返回数据需要使用3个表。但在这里，我们没有在嵌套子查询中使用它们，而是使用了两个联结来连接表。
这里有三个WHERE子句条件。前两个关联联结中的表，后一个过滤产品RGAN01的数据。
*/

SELECT cust_name,
         cust_contact
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
        AND OrderItems.order_num = Orders.order_num
        AND prod_id = 'RGAN01' --where 后面的条件顺序是随意的，没有要求按照特定的顺序，下面2个代码的效果是一样的

SELECT cust_name,
         cust_contact
FROM Customers, Orders, OrderItems
WHERE prod_id = 'RGAN01'
        AND OrderItems.order_num = Orders.order_num
        AND Customers.cust_id = Orders.cust_id

SELECT cust_name,
         cust_contact
FROM Customers, Orders, OrderItems
WHERE OrderItems.order_num = Orders.order_num
        AND Customers.cust_id = Orders.cust_id
        AND prod_id = 'RGAN01' 

/*
QU--06 问题：上面的代码如何使用INNER JOIN 来写？
延伸：使用 JOIN 的时候，似乎是有顺序的？第一个连接，形成了一个临时表，这个临时表再与第三个表进行连接
但是由于这个临时表没有名字？没有定义？所以系统不能进行引用？ 那么，还是临时表的问题？
*/

