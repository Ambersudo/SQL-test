# SQL-test

## 学习记录

1. 所有的代码，使用测试表试一下就知道结果了

## 问题记录

汇总于[Issues](https://github.com/lpd743663/SQL-test/issues)



```sql

题目1：需要列出订购物品 RGAN01 的所有顾客

select order_num
from OrderItems
where prod_id = 'RGAN01'

select cust_id
from Orders
where order_num in ('20007', '20008')

select *
from Customers
where cust_id in ('1000000004', '1000000005')



select cust_id
from Orders
where order_num in (select order_num
                            from OrderItems
                            where prod_id = 'RGAN01')

select *
from Customers
where cust_id in (select cust_id
                        from Orders
                        where order_num in (select order_num
                                                    from OrderItems
                                                    where prod_id = 'RGAN01'))



题目2：显示Customers表中每个顾客的订单总数。订单与相应的顾客ID存储在Orders表中。

/*
思路反推：（在解决不了这个问题，答案又看不懂的情况下，复盘之前写这些代码的原因，及这些代码的问题，可能与最开始的想法有些出入，大致应该是一致的）

  原先的想法是：首先我们的结果是得到一个表，表中包含 每个客户的名字，及其对应的订单数量
  顾客信息 使用select 从表中获取，最后一个 订单数量 这个字段的数据如何形成 count ？，展现出来肯定还是使用select
  select cust_id, cust_name, cust_contact
  前面这些都没有问题，问题在于订单数量如何获取，同时再与左侧字段的数据一一对应？
  不知道，卡在这里。
  */


--根据前面所学的，子句、嵌套，将整个查询语句拆分成以下2段
select cust_id, count(cust_id) as pn1
from Orders
group by cust_id --这段代码的结果是正确，问题在于，客户数量不完整，在 Orders 表中，有一个客户没有下单。


select cust_id, cust_name, cust_contact, count(order_num)
from Customers, Orders
where Customers.cust_id =  Orders.cust_id
group by cust_id /*这个组合的代码，就是随便拼凑起来的了，很直白的参考之前所学的内容。组合有误。
问题：错在哪里，如何更改？
*/


select cust_id,
		 cust_name,
	     cust_contact,
	     (select count(*)
	     from Orders
	     where Customers.cust_id =  Orders.cust_id) as pn1
from Customers
group by cust_id  /*这是参考正确答案后修改的代码，多了group by 语句，
为什么不需要 group by 函数，就能够分组？原先就不需要分组 ？#FF0000
题目中原有的意思是，列出每个顾客的订单，0订单的也显示为0，而不是不显示。
select语句是抽取相关字段的数据，问题：select 字句中的数据如何 与 前面2列的数据一一对应？
where 条件只适用于字句查询，这个字句查询是什么意思呢？
*/



正确答案：
    SELECT cust_name,
           cust_state,
           (SELECT COUNT(*)
            FROM Orders
            WHERE Orders.cust_id = Customers.cust_id) AS orders
    FROM Customers
    ORDER BY cust_name;


/*
换一种思路，首先创建一个表（临时表？index，索引？不存储在硬盘，只暂存于内存中？）#FF0000
每个顾客 及 每个顾客对应的订单号，无则为NULL ——> 适用JOIN
*/

select Customers.cust_id, cust_name, cust_contact, order_num, order_date
from Customers, Orders
where Customers.cust_id =  Orders.cust_id

/*
上面这段代码，如果顾客没有购买的话，就没有显示出来。不符合题目要求：列出每个顾客的订单，0订单的也显示为0，而不是不显示。
那么下面这段代码与 inner jion 很类似啊？ 有什么区别？#FF0000
*/

select Customers.cust_id, cust_name, cust_contact, order_num, order_date
from Customers left join  Orders
on Customers.cust_id =  Orders.cust_id

/*
然后再对上面的表进行count，统计每个客户的订单数量。

重点：左表对应的  右表，有多条记录时，汇总表中，也会体现多种表。
不仅仅是交集的概念，还有全排列的概念。#FF0000
*/

```
