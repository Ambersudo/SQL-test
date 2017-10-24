# 第8课 使用数据处理函数

这一课介绍什么是函数，DBMS支持何种函数，以及如何使用这些函数；还将讲解为什么SQL函数的使用可能会带来问题。

## 8.1 函数

与大多数其他计算机语言一样，SQL也可以用函数来处理数据。函数一般是在数据上执行的，为数据的转换和处理提供了方便。

前一课中用来去掉字符串尾的空格的`RTRIM()`就是一个函数。

### 函数带来的问题

在学习这一课并进行实践之前，你应该了解使用SQL函数所存在的问题。

与几乎所有DBMS都等同地支持SQL语句（如`SELECT`）不同，每一个DBMS都有特定的函数。事实上，只有少数几个函数被所有主要的DBMS等同地支持。虽然所有类型的函数一般都可以在每个DBMS中使用，但各个函数的名称和语法可能极其不同。为了说明可能存在的问题，表8-1列出了3个常用的函数及其在各个DBMS中的语法：

**表8-1 DBMS函数的差异**

 函　　数 | 语　　法
 --------|--------
 提取字符串的组成部分 | Access使用MID()；DB2、Oracle、PostgreSQL和SQLite使用SUBSTR()；MySQL和SQL Server使用SUBSTRING()
 数据类型转换 | Access和Oracle使用多个函数，每种类型的转换有一个函数；DB2和PostgreSQL使用CAST()；MariaDB、MySQL和SQL Server使用CONVERT()
 取当前日期 | Access使用NOW()；DB2和PostgreSQL使用CURRENT_DATE；MariaDB和MySQL使用CURDATE()；Oracle使用SYSDATE；SQL Server使用GETDATE()；SQLite使用DATE()

可以看到，与SQL语句不一样，SQL函数不是可移植的。这表示为特定SQL实现编写的代码在其他实现中可能不正常。

> **可移植（portable）**
> 所编写的代码可以在多个系统上运行。

为了代码的可移植，许多SQL程序员不赞成使用特定于实现的功能。虽然这样做很有好处，但有的时候并不利于应用程序的性能。如果不使用这些函数，编写某些应用程序代码会很艰难。必须利用其他方法来实现DBMS可以非常有效完成的工作。

> **提示：是否应该使用函数？**
> 现在，你面临是否应该使用函数的选择。决定权在你，使用或是不使用也没有对错之分。如果你决定使用函数，应该保证做好代码注释，以便以后你（或其他人）能确切地知道所编写的SQL代码的含义。

## 8.2 使用函数

大多数SQL实现支持以下类型的函数。

*   用于处理文本字符串（如删除或填充值，转换值为大写或小写）的文本函数。
*   用于在数值数据上进行算术操作（如返回绝对值，进行代数运算）的数值函数。
*   用于处理日期和时间值并从这些值中提取特定成分（如返回两个日期之差，检查日期有效性）的日期和时间函数。
*   返回DBMS正使用的特殊信息（如返回用户登录信息）的系统函数。

我们在上一课看到函数用作`SELECT`语句的列表成分，但函数的作用不仅于此。它还可以作为`SELECT`语句的其他成分，如在`WHERE`子句中使用，在其他SQL语句中使用等，后面会做更多的介绍。

### 8.2.1 文本处理函数

在上一课，我们已经看过一个文本处理函数的例子，其中使用`RTRIM()`函数来去除列值右边的空格。下面是另一个例子，这次使用的是`UPPER()`函数：

**输入▼**

```
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase
FROM Vendors
ORDER BY vend_name;

```

**输出▼**

```
vend_name                       vend_name_upcase
---------------------------     ----------------------------
Bear Emporium                   BEAR EMPORIUM
Bears R Us                      BEARS R US
Doll House Inc.                 DOLL HOUSE INC.
Fun and Games                   FUN AND GAMES
Furball Inc.                    FURBALL INC.
Jouets et ours                  JOUETS ET OURS

```

**分析▼**
可以看到，`UPPER()`将文本转换为大写，因此本例子中每个供应商都列出两次，第一次为`Vendors`表中存储的值，第二次作为列`vend_name_upcase`转换为大写。

表8-2列出了一些常用的文本处理函数。

**表8-2 常用的文本处理函数**

| 函　　数                                | 说　　明                |
| ------------------------------------- | --------------------- |
| LEFT()（或使用子字符串函数）          | 返回字符串左边的字符  |
| LENGTH()（也使用DATALENGTH()或LEN()） | 返回字符串的长度      |
| LOWER()（Access使用LCASE()）          | 将字符串转换为小写    |
| LTRIM()                               | 去掉字符串左边的空格  |
| RIGHT()（或使用子字符串函数）         | 返回字符串右边的字符  |
| RTRIM()                               | 去掉字符串右边的空格  |
| SOUNDEX()                             | 返回字符串的SOUNDEX值 |
| UPPER()（Access使用UCASE()）          | 将字符串转换为大写    |

表8-2中的`SOUNDEX`需要做进一步的解释。`SOUNDEX`是一个将任何文本串转换为描述其语音表示的字母数字模式的算法。`SOUNDEX`考虑了类似的发音字符和音节，使得能对字符串进行发音比较而不是字母比较。虽然`SOUNDEX`不是SQL概念，但多数DBMS都提供对`SOUNDEX`的支持。

> **说明：`SOUNDEX`支持**
> Microsoft Access和PostgreSQL不支持`SOUNDEX()`，因此以下的例子不适用于这些DBMS。
>
> 另外，如果在创建SQLite时使用了`SQLITE_SOUNDEX`编译时选项，那么`SOUNDEX()`在SQLite中就可用。因为`SQLITE_SOUNDEX`不是默认的编译时选项，所以多数SQLite实现不支持`SOUNDEX()`。

下面给出一个使用`SOUNDEX()`函数的例子。`Customers`表中有一个顾客`Kids Place`，其联系名为`Michelle Green`。但如果这是错误的输入，此联系名实际上应该是`Michael Green`，该怎么办呢？显然，按正确的联系名搜索不会返回数据，如下所示：

**输入▼**

```
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_contact = 'Michael Green';

```

**输出▼**

```
cust_name                      cust_contact
--------------------------     ----------------------------

```

现在试一下使用`SOUNDEX()`函数进行搜索，它匹配所有发音类似于`Michael Green`的联系名：

**输入▼**

```
SELECT cust_name, cust_contact
FROM Customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');

```

**输出▼**

```
cust_name                      cust_contact
--------------------------     ----------------------------
Kids Place                     Michelle Green

```

**分析▼**
在这个例子中，`WHERE`子句使用`SOUNDEX()`函数把`cust_contact`列值和搜索字符串转换为它们的`SOUNDEX`值。因为`Michael Green`和`Michelle Green`发音相似，所以它们的`SOUNDEX`值匹配，因此`WHERE`子句正确地过滤出了所需的数据。

### 8.2.2 日期和时间处理函数

日期和时间采用相应的数据类型存储在表中，每种DBMS都有自己的特殊形式。日期和时间值以特殊的格式存储，以便能快速和有效地排序或过滤，并且节省物理存储空间。

应用程序一般不使用日期和时间的存储格式，因此日期和时间函数总是用来读取、统计和处理这些值。由于这个原因，日期和时间函数在SQL中具有重要的作用。遗憾的是，它们很不一致，可移植性最差。

我们举个简单的例子，来说明日期处理函数的用法。`Orders`表中包含的订单都带有订单日期。为在SQL Server中检索2012年的所有订单，可如下进行：

**输入▼**

```
SELECT order_num
FROM Orders
WHERE DATEPART(yy, order_date) = 2012;

```

**输出▼**

```
order_num
-----------
20005
20006
20007
20008
20009

```

在Access中使用如下版本：

**输入▼**

```
SELECT order_num
FROM Orders
WHERE DATEPART('yyyy', order_date) = 2012;

```

**分析▼**
这个例子（SQL Server和Sybase版本以及Access版本）使用了`DATEPART()`函数，顾名思义，此函数返回日期的某一部分。`DATEPART()`函数有两个参数，它们分别是返回的成分和从中返回成分的日期。在此例子中，`DATEPART()`只从`order_date`列中返回年份。通过与`2012`比较，`WHERE`子句只过滤出此年份的订单。

下面是使用名为`DATE_PART()`的类似函数的PostgreSQL版本：

**输入▼**

```
SELECT order_num
FROM Orders
WHERE DATE_PART('year', order_date) = 2012;

```

Oracle没有`DATEPART()`函数，不过有几个可用来完成相同检索的日期处理函数。例如：

**输入▼**

```
SELECT order_num
FROM Orders
WHERE to_number(to_char(order_date, 'YYYY')) = 2012;

```

**分析▼**
在这个例子中，`to_char()`函数用来提取日期的成分，`to_number()`用来将提取出的成分转换为数值，以便能与`2012`进行比较。

完成相同工作的另一方法是使用`BETWEEN`操作符：

**输入▼**

```
SELECT order_num
FROM Orders
WHERE order_date BETWEEN to_date('01-01-2012')
AND to_date('12-31-2012');

```

**分析▼**
在此例子中，Oracle的`to_date()`函数用来将两个字符串转换为日期。一个包含2012年1月1日，另一个包含2012年12月31日。`BETWEEN`操作符用来找出两个日期之间的所有订单。值得注意的是，相同的代码在SQL Server中不起作用，因为它不支持`to_date()`函数。但是，如果用`DATEPART()`替换`to_date()`，当然可以使用这种类型的语句。

MySQL和MariaDB具有各种日期处理函数，但没有`DATEPART()`。MySQL和MariaDB用户可使用名为`YEAR()`的函数从日期中提取年份：

**输入▼**

```
SELECT order_num
FROM Orders
WHERE YEAR(order_date) = 2012;

```

在SQLite中有个小技巧：

**输入▼**

```
SELECT order_num
FROM Orders
WHERE strftime('%Y', order_date) = 2012;

```

这里给出的例子提取和使用日期的成分（年）。按月份过滤，可以进行相同的处理，指定`AND`操作符以及年和月份的比较。

DBMS提供的功能远不止简单的日期成分提取。大多数DBMS具有比较日期、执行基于日期的运算、选择日期格式等的函数。但是，可以看到，不同DBMS的日期-时间处理函数可能不同。关于具体DBMS支持的日期-时间处理函数，请参阅相应的文档。

### 8.2.3 数值处理函数

数值处理函数仅处理数值数据。这些函数一般主要用于代数、三角或几何运算，因此不像字符串或日期-时间处理函数使用那么频繁。

具有讽刺意味的是，在主要DBMS的函数中，数值函数是最一致、最统一的函数。表8-3列出一些常用的数值处理函数。

**表8-3 常用数值处理函数**

| 函　　数 | 说　　明         |
| ------ | -----------------|
| ABS()  | 返回一个数的绝对值 |
| COS()  | 返回一个角度的余弦 |
| EXP()  | 返回一个数的指数值 |
| PI()   | 返回圆周率         |
| SIN()  | 返回一个角度的正弦 |
| SQRT() | 返回一个数的平方根 |
| TAN()  | 返回一个角度的正切 |

关于具体DBMS所支持的算术处理函数，请参阅相应的文档。

## 8.3 小结

这一课介绍了如何使用SQL的数据处理函数。虽然这些函数在格式化、处理和过滤数据中非常有用，但它们在各种SQL实现中很不一致（SQL Server和Oracle之间的差异说明了这一点）。

# 第9课 汇总数据

这一课介绍什么是SQL的聚集函数，如何利用它们汇总表的数据。

## 9.1 聚集函数

我们经常需要汇总数据而不用把它们实际检索出来，为此SQL提供了专门的函数。使用这些函数，SQL查询可用于检索数据，以便分析和报表生成。这种类型的检索例子有：

*   确定表中行数（或者满足某个条件或包含某个特定值的行数）；
*   获得表中某些行的和；
*   找出表列（或所有行或某些特定的行）的最大值、最小值、平均值。

上述例子都需要汇总表中的数据，而不需要实际数据本身。因此，返回实际表数据纯属浪费时间和处理资源（更不用说带宽了）。再说一遍，我们实际想要的是汇总信息。

为方便这种类型的检索，SQL给出了5个聚集函数，见表9-1。这些函数能进行上述检索。与前一章介绍的数据处理函数不同，SQL的聚集函数在各种主要SQL实现中得到了相当一致的支持。

> **聚集函数（aggregate function）** 对某些行运行的函数，计算并返回一个值。

**表9-1 SQL聚集函数**

| 函　　数  | 说　　明           |
| ------- | ---------------- |
| AVG()   | 返回某列的平均值 |
| COUNT() | 返回某列的行数   |
| MAX()   | 返回某列的最大值 |
| MIN()   | 返回某列的最小值 |
| SUM()   | 返回某列值之和   |

以下说明各函数的使用。

### 9.1.1 AVG()函数

`AVG()`通过对表中行数计数并计算其列值之和，求得该列的平均值。`AVG()`可用来返回所有列的平均值，也可以用来返回特定列或行的平均值。

下面的例子使用`AVG()`返回`Products`表中所有产品的平均价格：

**输入▼**

```
SELECT AVG(prod_price) AS avg_price
FROM Products;

```

**输出▼**

```
avg_price
-------------
6.823333

```

**分析▼**
此`SELECT`语句返回值`avg_price`，它包含`Products`表中所有产品的平均价格。如第7课所述，`avg_price`是一个别名。

`AVG()`也可以用来确定特定列或行的平均值。下面的例子返回特定供应商所提供产品的平均价格：

**输入▼**

```
SELECT AVG(prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

```

**输出▼**

```
avg_price
-----------
3.8650

```

**分析▼**
这条`SELECT`语句与前一条的不同之处在于，它包含了`WHERE`子句。此`WHERE`子句仅过滤出`vend_id`为`DLL01`的产品，因此`avg_price`中返回的值只是该供应商产品的平均值。

> **警告：只用于单个列**
> **AVG()**只能用来确定特定数值列的平均值，而且列名必须作为函数参数给出。为了获得多个列的平均值，必须使用多个`AVG()`函数。

> **说明：`NULL`值**
> `AVG()`函数忽略列值为`NULL`的行。

### 9.1.2 COUNT()函数

`COUNT()`函数进行计数。可利用`COUNT()`确定表中行的数目或符合特定条件的行的数目。

`COUNT()`函数有两种使用方式：

*   使用`COUNT(*)`对表中行的数目进行计数，不管表列中包含的是空值（`NULL`）还是非空值。
*   使用`COUNT(column)`对特定列中具有值的行进行计数，忽略`NULL`值。

下面的例子返回`Customers`表中顾客的总数：

**输入▼**

```
SELECT COUNT(*) AS num_cust
FROM Customers;

```

**输出▼**

```
num_cust
--------
5

```

**分析▼**
在此例子中，利用`COUNT(*)`对所有行计数，不管行中各列有什么值。计数值在`num_cust`中返回。

下面的例子只对具有电子邮件地址的客户计数：

**输入▼**

```
SELECT COUNT(cust_email) AS num_cust
FROM Customers;

```

**输出▼**

```
num_cust
--------
3

```

**分析▼**
这条`SELECT`语句使用`COUNT(cust_email)`对`cust_email`列中有值的行进行计数。在此例子中，`cust_email`的计数为`3`（表示5个顾客中只有3个顾客有电子邮件地址）。

> **说明：`NULL`值**
> 如果指定列名，则`COUNT()`函数会忽略指定列的值为空的行，但如果`COUNT()`函数中用的是星号（`*`），则不忽略。

### 9.1.3 MAX()函数

`MAX()`返回指定列中的最大值。`MAX()`要求指定列名，如下所示：

**输入▼**

```
SELECT MAX(prod_price) AS max_price
FROM Products;

```

**输出▼**

```
max_price
----------
11.9900

```

**分析▼**
这里，`MAX()`返回`Products`表中最贵物品的价格。

> **提示：对非数值数据使用`MAX()`**
> 虽然`MAX()`一般用来找出最大的数值或日期值，但许多（并非所有）DBMS允许将它用来返回任意列中的最大值，包括返回文本列中的最大值。在用于文本数据时，`MAX()`返回按该列排序后的最后一行。

> **说明：`NULL`值**
> `MAX()`函数忽略列值为`NULL`的行。

### 9.1.4 MIN()函数

`MIN()`的功能正好与`MAX()`功能相反，它返回指定列的最小值。与`MAX()`一样，`MIN()`要求指定列名，如下所示：

**输入▼**

```
SELECT MIN(prod_price) AS min_price
FROM Products;

```

**输出▼**

```
min_price
----------
3.4900

```

**分析▼**
其中`MIN()`返回`Products`表中最便宜物品的价格。

> **提示：对非数值数据使用`MIN()`**
> 虽然`MIN()`一般用来找出最小的数值或日期值，但许多（并非所有）DBMS允许将它用来返回任意列中的最小值，包括返回文本列中的最小值。在用于文本数据时，`MIN()`返回该列排序后最前面的行。

> **说明：`NULL`值**
> `MIN()`函数忽略列值为`NULL`的行。

### 9.1.5 SUM()函数

`SUM()`用来返回指定列值的和（总计）。下面举一个例子，`OrderItems`包含订单中实际的物品，每个物品有相应的数量。可如下检索所订购物品的总数（所有`quantity`值之和）：

**输入▼**

```
SELECT SUM(quantity) AS items_ordered
FROM OrderItems
WHERE order_num = 20005;

```

**输出▼**

```
items_ordered
----------
200

```

**分析▼**
函数`SUM(quantity)`返回订单中所有物品数量之和，`WHERE`子句保证只统计某个物品订单中的物品。

`SUM()`也可以用来合计计算值。在下面的例子中，合计每项物品的`item_price*quantity`，得出总的订单金额：

**输入▼**

```
SELECT SUM(item_price*quantity) AS total_price
FROM OrderItems
WHERE order_num = 20005;

```

**输出▼**

```
total_price
----------
1648.0000

```

**分析▼**
函数`SUM(item_price*quantity)`返回订单中所有物品价钱之和，`WHERE`子句同样保证只统计某个物品订单中的物品。

> **提示：在多个列上进行计算**
> 如本例所示，利用标准的算术操作符，所有聚集函数都可用来执行多个列上的计算。

> **说明：`NULL`值**
> `SUM()`函数忽略列值为`NULL`的行。

## 9.2 聚集不同值

以上5个聚集函数都可以如下使用：

*   对所有行执行计算，指定`ALL`参数或不指定参数（因为`ALL`是默认行为）。
*   只包含不同的值，指定`DISTINCT`参数。

> **提示：`ALL`为默认**
> `ALL`参数不需要指定，因为它是默认行为。如果不指定`DISTINCT`，则假定为`ALL`。

> **说明：不要在Access中使用**
> Microsoft Access在聚集函数中不支持`DISTINCT`，因此下面的例子不适合于Access。要在Access得到类似的结果，需要使用子查询把`DISTINCT`数据返回到外部`SELECT COUNT(*)`语句。

下面的例子使用`AVG()`函数返回特定供应商提供的产品的平均价格。它与上面的`SELECT`语句相同，但使用了`DISTINCT`参数，因此平均值只考虑各个不同的价格：

**输入▼**

```
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

```

**输出▼**

```
avg_price
-----------
4.2400

```

**分析▼**
可以看到，在使用了`DISTINCT`后，此例子中的`avg_price`比较高，因为有多个物品具有相同的较低价格。排除它们提升了平均价格。

> **警告：`DISTINCT`不能用于`COUNT(*)`**
> 如果指定列名，则`DISTINCT`只能用于`COUNT()`。`DISTINCT`不能用于`COUNT(*)`。类似地，`DISTINCT`必须使用列名，不能用于计算或表达式。

> **提示：将`DISTINCT`用于`MIN()`和`MAX()`**
> 虽然`DISTINCT`从技术上可用于`MIN()`和`MAX()`，但这样做实际上没有价值。一个列中的最小值和最大值不管是否只考虑不同值，结果都是相同的。

> **说明：其他聚集参数**
> 除了这里介绍的`DISTINCT`和`ALL`参数，有的DBMS还支持其他参数，如支持对查询结果的子集进行计算的`TOP`和`TOP PERCENT`。为了解具体的DBMS支持哪些参数，请参阅相应的文档。

## 9.3 组合聚集函数

目前为止的所有聚集函数例子都只涉及单个函数。但实际上，`SELECT`语句可根据需要包含多个聚集函数。请看下面的例子：

**输入▼**

```
SELECT COUNT(*) AS num_items,
       MIN(prod_price) AS price_min,
       MAX(prod_price) AS price_max,
       AVG(prod_price) AS price_avg
FROM Products;

```

**输出▼**

```
num_items      price_min           price_max p         rice_avg
----------     ---------------     ---------------     ---------
9              3.4900              11.9900             6.823333

```

**分析▼**
这里用单条`SELECT`语句执行了4个聚集计算，返回4个值（`Products`表中物品的数目，产品价格的最高值、最低值以及平均值）。

> **警告：取别名**
> 在指定别名以包含某个聚集函数的结果时，不应该使用表中实际的列名。虽然这样做也算合法，但许多SQL实现不支持，可能会产生模糊的错误消息。

## 9.4 小结

聚集函数用来汇总数据。SQL支持5个聚集函数，可以用多种方法使用它们，返回所需的结果。这些函数很高效，它们返回结果一般比你在自己的客户端应用程序中计算要快得多。

# 第10课 分组数据

这一课介绍如何分组数据，以便汇总表内容的子集。这涉及两个新`SELECT`语句子句：`GROUP BY`子句和`HAVING`子句。

## 10.1 数据分组

从上一课得知，使用SQL聚集函数可以汇总数据。这样，我们就能够对行进行计数，计算和与平均数，不检索所有数据就获得最大值和最小值。

目前为止的所有计算都是在表的所有数据或匹配特定的`WHERE`子句的数据上进行的。比如下面的例子返回供应商`DLL01`提供的产品数目：

**输入▼**

```
SELECT COUNT(*) AS num_prods
FROM Products
WHERE vend_id = 'DLL01';

```

**输出▼**

```
num_prods
-----------
4

```

如果要返回每个供应商提供的产品数目，该怎么办？或者返回只提供一项产品的供应商的产品，或者返回提供10个以上产品的供应商的产品，怎么办？

这就是分组大显身手的时候了。使用分组可以将数据分为多个逻辑组，对每个组进行聚集计算。

## 10.2 创建分组

分组是使用`SELECT`语句的`GROUP BY`子句建立的。理解分组的最好办法是看一个例子：

**输入▼**

```
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id;

```

**输出▼**

```
vend_id     num_prods
-------     ---------
BRS01       3
DLL01       4
FNG01       2

```

**分析▼**
上面的`SELECT`语句指定了两个列：`vend_id`包含产品供应商的ID，`num_prods`为计算字段（用`COUNT(*)`函数建立）。`GROUP BY`子句指示DBMS按`vend_id`排序并分组数据。这就会对每个`vend_id`而不是整个表计算`num_prods`一次。从输出中可以看到，供应商`BRS01`有`3`个产品，供应商`DLL01`有`4`个产品，而供应商`FNG01`有`2`个产品。

因为使用了`GROUP BY`，就不必指定要计算和估值的每个组了。系统会自动完成。`GROUP BY`子句指示DBMS分组数据，然后对每个组而不是整个结果集进行聚集。
[qu++01（算是解决了）:这个分析乍看过去，都懂，但是看了下面的说明，以及后面的习题，发现还是没有理解透](https://github.com/lpd743663/SQL-test/issues/5)： `GROUP BY`返回不重复的值，将相同的值合并为一个分组。

在使用`GROUP BY`子句前，需要知道一些重要的规定。

*   `GROUP BY`子句可以包含任意数目的列，因而可以对分组进行嵌套，更细致地进行数据分组。mk++01：缺案例说明
*   如果在`GROUP BY`子句中嵌套了分组，数据将在最后指定的分组上进行汇总。换句话说，在建立分组时，指定的所有列都一起计算（所以不能从个别的列取回数据）。
*   `GROUP BY`子句中列出的每一列都必须是检索列或有效的表达式（但不能是聚集函数）。如果在`SELECT`中使用表达式，则必须在`GROUP BY`子句中指定相同的表达式。不能使用别名。[qu++02有效的表达式（但不能是聚集函数） 是指什么？](https://github.com/lpd743663/SQL-test/issues/6)[qu++03（已经解决）`SELECT` 后面的列的数量、列名 与 `GROUP BY` 后面的列的数量、列名（同一个列名代表同一列），有什么关联、关系？](https://github.com/lpd743663/SQL-test/issues/7):
*   大多数SQL实现不允许`GROUP BY`列带有长度可变的数据类型（如文本或备注型字段）。
*   除聚集计算语句外，`SELECT`语句中的每一列都必须在`GROUP BY`子句中给出。
*   如果分组列中包含具有`NULL`值的行，则`NULL`将作为一个分组返回。如果列中有多行`NULL`值，它们将分为一组。
*   `GROUP BY`子句必须出现在`WHERE`子句之后，`ORDER BY`子句之前。

> **提示：`ALL`子句**
> Microsoft SQL Server等有些SQL实现在`GROUP BY`中支持可选的`ALL`子句。这个子句可用来返回所有分组，即使是没有匹配行的分组也返回（在此情况下，聚集将返回`NULL`）。具体的DBMS是否支持`ALL`，请参阅相应的文档。

> **警告：通过相对位置指定列**
> 有的SQL实现允许根据`SELECT`列表中的位置指定`GROUP BY`的列。例如，`GROUP BY 2, 1`可表示按选择的第二个列分组，然后再按第一个列分组。虽然这种速记语法很方便，但并非所有SQL实现都支持，并且使用它容易在编辑SQL语句时出错。

## 10.3 过滤分组

除了能用`GROUP BY`分组数据外，SQL还允许过滤分组，规定包括哪些分组，排除哪些分组。例如，你可能想要列出至少有两个订单的所有顾客。为此，必须基于完整的分组而不是个别的行进行过滤。

我们已经看到了`WHERE`子句的作用（第4课提及）。但是，在这个例子中`WHERE`不能完成任务，因为`WHERE`过滤指定的是行而不是分组。事实上，`WHERE`没有分组的概念。

那么，不使用`WHERE`使用什么呢？SQL为此提供了另一个子句，就是`HAVING`子句。`HAVING`非常类似于`WHERE`。事实上，目前为止所学过的所有类型的`WHERE`子句都可以用`HAVING`来替代。唯一的差别是，`WHERE`过滤行，而`HAVING`过滤分组。

> **提示：`HAVING`支持所有`WHERE`操作符**
> 在第4课和第5课中，我们学习了`WHERE`子句的条件（包括通配符条件和带多个操作符的子句）。学过的这些有关`WHERE`的所有技术和选项都适用于`HAVING`。它们的句法是相同的，只是关键字有差别。

那么，怎么过滤分组呢？请看以下的例子：

**输入▼**

```
SELECT cust_id, COUNT(*) AS orders
FROM Orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;

```

**输出▼**

```
cust_id        orders
----------     -----------
1000000001     2

```

**分析▼**
这条`SELECT`语句的前三行类似于上面的语句。最后一行增加了`HAVING`子句，它过滤`COUNT(*) >= 2`（两个以上订单）的那些分组。
qu++04：之前没有注意到的问题，`HAVING`和`WHERE`后面的列，并不需要出现在`SELECT`后面，我想问什么问题？
可以看到，`WHERE`子句在这里不起作用，因为过滤是基于分组聚集值，而不是特定行的值。

> **说明：`HAVING`和`WHERE`的差别**
> 这里有另一种理解方法，`WHERE`在数据分组前进行过滤，`HAVING`在数据分组后进行过滤。这是一个重要的区别，`WHERE`排除的行不包括在分组中。这可能会改变计算值，从而影响`HAVING`子句中基于这些值过滤掉的分组。

那么，有没有在一条语句中同时使用`WHERE`和`HAVING`子句的需要呢？事实上，确实有。假如想进一步过滤上面的语句，使它返回过去12个月内具有两个以上订单的顾客。为此，可增加一条`WHERE`子句，过滤出过去12个月内下过的订单，然后再增加`HAVING`子句过滤出具有两个以上订单的分组。

为了更好地理解，来看下面的例子，它列出具有两个以上产品且其价格大于等于`4`的供应商：

**输入▼**

```
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT(*) >= 2;

```

**输出▼**

```
vend_id     num_prods
-------     -----------
BRS01       3
FNG01       2

```

**分析▼**
这条语句中，第一行是使用了聚集函数的基本`SELECT`语句，很像前面的例子。`WHERE`子句过滤所有`prod_price`至少为`4`的行，然后按`vend_id`分组数据，`HAVING`子句过滤计数为2或2以上的分组。如果没有`WHERE`子句，就会多检索出一行（供应商`DLL01`，销售`4`个产品，价格都在`4`以下）：

**输入▼**

```
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id
HAVING COUNT(*) >= 2;

```

**输出▼**

```
vend_id     num_prods
-------     -----------
BRS01       3
DLL01       4
FNG01       2

```

> **说明：使用`HAVING`和`WHERE`**
> `HAVING`与`WHERE`非常类似，如果不指定`GROUP BY`，则大多数DBMS会同等对待它们。不过，你自己要能区分这一点。使用`HAVING`时应该结合`GROUP BY`子句，而`WHERE`子句用于标准的行级过滤。

## 10.4 分组和排序

`GROUP BY`和`ORDER BY`经常完成相同的工作，但它们非常不同，理解这一点很重要。表10-1汇总了它们之间的差别。

**表10-1 ORDER BY与GROUP BY**

| ORDER BY | GROUP BY |
|----------|----------|
| 对产生的输出排序 | 对行分组，但输出可能不是分组的顺序 |
| 任意列都可以使用（甚至非选择的列也可以使用） | 只可能使用选择列或表达式列，而且必须使用每个选择列表达式 |
| 不一定需要 | 如果与聚集函数一起使用列（或表达式），则必须使用 |

表10-1中列出的第一项差别极为重要。我们经常发现，用`GROUP BY`分组的数据确实是以分组顺序输出的。但并不总是这样，这不是SQL规范所要求的。此外，即使特定的DBMS总是按给出的`GROUP BY`子句排序数据，用户也可能会要求以不同的顺序排序。就因为你以某种方式分组数据（获得特定的分组聚集值），并不表示你需要以相同的方式排序输出。应该提供明确的`ORDER BY`子句，即使其效果等同于`GROUP BY`子句。

> **提示：不要忘记`ORDER BY`**
> 一般在使用`GROUP BY`子句时，应该也给出`ORDER BY`子句。这是保证数据正确排序的唯一方法。千万不要仅依赖`GROUP BY`排序数据。

为说明`GROUP BY`和`ORDER BY`的使用方法，来看一个例子。下面的`SELECT`语句类似于前面那些例子。它检索包含三个或更多物品的订单号和订购物品的数目：

**输入▼**

```
SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 3;

```

**输出▼**

```
order_num     items
---------     -----
20006         3
20007         5
20008         5
20009         3

```

要按订购物品的数目排序输出，需要添加`ORDER BY`子句，如下所示：

**输入▼**

```
SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 3
ORDER BY items, order_num;

```

> **说明：Access的不兼容性**
> Microsoft Access不允许按别名排序，因此这个例子在Access中将失败。解决方法是用实际的计算或字段位置替换`items`（在`ORDER BY`子句中），即`ORDER BY COUNT(*), order_num`或`ORDER BY 2, order_num`。

**输出▼**

```
order_num     items
---------     -----
20006         3
20009         3
20007         5
20008         5

```

**分析▼**
在这个例子中，使用`GROUP BY`子句按订单号（`order_num`列）分组数据，以便`COUNT(*)`函数能够返回每个订单中的物品数目。`HAVING`子句过滤数据，使得只返回包含三个或更多物品的订单。最后，用`ORDER BY`子句排序输出。

## 10.5 SELECT子句顺序

下面回顾一下`SELECT`语句中子句的顺序。表10-2以在`SELECT`语句中使用时必须遵循的次序，列出迄今为止所学过的子句。

**表10-2 `SELECT`子句及其顺序**

| 子　　句   | 说　　明             | 是否必须使用           |
| -------- | ------------------ | ---------------------- |
| SELECT   | 要返回的列或表达式 | 是                     |
| FROM     | 从中检索数据的表   | 仅在从表选择数据时使用 |
| WHERE    | 行级过滤           | 否                     |
| GROUP BY | 分组说明           | 仅在按组计算聚集时使用 |
| HAVING   | 组级过滤           | 否                     |
| ORDER BY | 输出排序顺序       | 否                     |


## 10.6 小结

上一课介绍了如何用SQL聚集函数对数据进行汇总计算。这一课讲授了如何使用`GROUP BY`子句对多组数据进行汇总计算，返回每个组的结果。我们看到了如何使用`HAVING`子句过滤特定的组，还知道了`ORDER BY`和`GROUP BY`之间以及`WHERE`和`HAVING`之间的差异。

# 第11课 使用子查询

这一课介绍什么是子查询，如何使用它们。

## 11.1 子查询

`SELECT`语句是SQL的查询。我们迄今为止所看到的所有`SELECT`语句都是简单查询，即从单个数据库表中检索数据的单条语句。

> **查询（query）**
> 任何SQL语句都是查询。但此术语一般指`SELECT`语句。

SQL还允许创建子查询（subquery），即嵌套在其他查询中的查询。为什么要这样做呢？理解这个概念的最好方法是考察几个例子。

> **说明：MySQL支持**
> 如果使用MySQL，应该知道对子查询的支持是从4.1版本引入的。MySQL的早期版本不支持子查询。

## 11.2 利用子查询进行过滤

本书所有课中使用的数据库表都是关系表（关于每个表及关系的描述，请参阅附录A）。订单存储在两个表中。每个订单包含订单编号、客户ID、订单日期，在`Orders`表中存储为一行。各订单的物品存储在相关的`OrderItems`表中。`Orders`表不存储顾客信息，只存储顾客ID。顾客的实际信息存储在`Customers`表中。

现在，假如需要列出订购物品`RGAN01`的所有顾客，应该怎样检索？下面列出具体的步骤。

1.  检索包含物品`RGAN01`的所有订单的编号。
2.  检索具有前一步骤列出的订单编号的所有顾客的ID。
3.  检索前一步骤返回的所有顾客ID的顾客信息。

上述每个步骤都可以单独作为一个查询来执行。可以把一条`SELECT`语句返回的结果用于另一条`SELECT`语句的`WHERE`子句。

也可以使用子查询来把3个查询组合成一条语句。

第一条`SELECT`语句的含义很明确，它对`prod_id`为`RGAN01`的所有订单物品，检索其`order_num`列。输出列出了两个包含此物品的订单：

**输入▼**

```
SELECT order_num
FROM OrderItems
WHERE prod_id = 'RGAN01';

```

**输出▼**

```
order_num
-----------
20007
20008

```

现在，我们知道了哪个订单包含要检索的物品，下一步查询与订单`20007`和`20008`相关的顾客ID。利用第5课介绍的`IN`子句，编写如下的`SELECT`语句：

**输入▼**

```
SELECT cust_id
FROM Orders
WHERE order_num IN (20007,20008);

```

**输出▼**

```
cust_id
----------
1000000004
1000000005

```

现在，结合这两个查询，把第一个查询（返回订单号的那一个）变为子查询。请看下面的`SELECT`语句：

**输入▼**

```
SELECT cust_id
FROM Orders
WHERE order_num IN (SELECT order_num
                    FROM OrderItems
                    WHERE prod_id = 'RGAN01');

```

**输出▼**

```
cust_id
----------
1000000004
1000000005

```

**分析▼**
在`SELECT`语句中，子查询总是从内向外处理。在处理上面的`SELECT`语句时，DBMS实际上执行了两个操作。

首先，它执行下面的查询：

```
SELECT order_num FROM orderitems WHERE prod_id='RGAN01'

```

此查询返回两个订单号：`20007`和`20008`。然后，这两个值以`IN`操作符要求的逗号分隔的格式传递给外部查询的`WHERE`子句。外部查询变成：

```
SELECT cust_id FROM orders WHERE order_num IN (20007,20008)

```

可以看到，输出是正确的，与前面硬编码`WHERE`子句所返回的值相同。

> **提示：格式化SQL**
> 包含子查询的`SELECT`语句难以阅读和调试，它们在较为复杂时更是如此。如上所示，把子查询分解为多行并进行适当的缩进，能极大地简化子查询的使用。
>
> 顺便一提，这就是颜色编码起作用的地方，好的DBMS客户端正是出于这个原因使用了颜色代码SQL。

现在得到了订购物品`RGAN01`的所有顾客的ID。下一步是检索这些顾客ID的顾客信息。检索两列的SQL语句为：

**输入▼**

```
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN ('1000000004','1000000005');

```

可以把其中的`WHERE`子句转换为子查询，而不是硬编码这些顾客ID：

**输入▼**

```
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
                  FROM Order
                  WHERE order_num IN (SELECT order_num
                                      FROM OrderItems
                                      WHERE prod_id = 'RGAN01'));

```

**输出▼**

```
cust_name                         cust_contact
-----------------------------     --------------------
Fun4All                           Denise L. Stephens
The Toy Store                     Kim Howard

```

**分析▼**
为了执行上述`SELECT`语句，DBMS实际上必须执行三条`SELECT`语句。最里边的子查询返回订单号列表，此列表用于其外面的子查询的`WHERE`子句。外面的子查询返回顾客ID列表，此顾客ID列表用于最外层查询的`WHERE`子句。最外层查询返回所需的数据。

可见，在`WHERE`子句中使用子查询能够编写出功能很强且很灵活的SQL语句。对于能嵌套的子查询的数目没有限制，不过在实际使用时由于性能的限制，不能嵌套太多的子查询。

> **警告：只能是单列**
> 作为子查询的`SELECT`语句只能查询单个列。企图检索多个列将返回错误。mk++02：缺案例说明

> **警告：子查询和性能**
> 这里给出的代码有效，并且获得了所需的结果。但是，使用子查询并不总是执行这类数据检索的最有效方法。更多的论述，请参阅第12课，其中将再次给出这个例子。

## 11.3 作为计算字段使用子查询

使用子查询的另一方法是创建计算字段。假如需要显示`Customers`表中每个顾客的订单总数。订单与相应的顾客ID存储在`Orders`表中。

执行这个操作，要遵循下面的步骤：

1.  从`Customers`表中检索顾客列表；
2.  对于检索出的每个顾客，统计其在`Orders`表中的订单数目。

正如前两课所述，可以使用`SELECT COUNT(*)`对表中的行进行计数，并且通过提供一条`WHERE`子句来过滤某个特定的顾客ID，仅对该顾客的订单进行计数。例如，下面的代码对顾客`1000000001`的订单进行计数：

[ex++01独立写代码的过程](https://github.com/lpd743663/SQL-test/issues/8)

**输入▼**

```
SELECT COUNT(*) AS orders
FROM Orders
WHERE cust_id = '1000000001';

```

要对每个顾客执行`COUNT(*)`，应该将它作为一个子查询。请看下面的代码：

**输入▼**

```
SELECT cust_name,
       cust_state,
       (SELECT COUNT(*)
        FROM Orders
        WHERE Orders.cust_id = Customers.cust_id) AS orders
FROM Customers
ORDER BY cust_name;

```

**输出▼**

```
cust_name                     cust_state     orders
-------------------------     ----------     ------
Fun4All                       IN             1
Fun4All                       AZ             1
Kids Place                    OH             0
The Toy Store                 IL             1
Village Toys                  MI             2

```

**分析▼**
这条`SELECT`语句对`Customers`表中每个顾客返回三列：`cust_name`、`cust_state`和`orders`。`orders`是一个计算字段，它是由圆括号中的子查询建立的。该子查询对检索出的每个顾客执行一次。在此例中，该子查询执行了5次，因为检索出了5个顾客。

子查询中的`WHERE`子句与前面使用的`WHERE`子句稍有不同，因为它使用了完全限定列名，而不只是列名（`cust_id`）。它指定表名和列名（`Orders.cust_id`和`Customers.cust_id`）。下面的`WHERE`子句告诉SQL，比较`Orders`表中的`cust_id`和当前正从`Customers`表中检索的`cust_id`：

```
WHERE Orders.cust_id = Customers.cust_id

```

用一个句点分隔表名和列名，这种语法必须在有可能混淆列名时使用。在这个例子中，有两个`cust_id`列：一个在`Customers`中，另一个在`Orders`中。如果不采用完全限定列名，DBMS会认为要对`Orders`表中的`cust_id`自身进行比较。因为

```
SELECT COUNT(*) FROM Orders WHERE cust_id = cust_id

```

总是返回`Orders`表中订单的总数，而这个结果不是我们想要的：

**输入▼**

```
SELECT cust_name,
       cust_state,
       (SELECT COUNT(*)
        FROM Orders
        WHERE cust_id = cust_id) AS orders
FROM Customers
ORDER BY cust_name;

```

**输出▼**

```
cust_name                     cust_state     orders
-------------------------     ----------     ------
Fun4All                       IN             5
Fun4All                       AZ             5
Kids Place                    OH             5
The Toy Store                 IL             5
Village Toys                  MI             5

```

虽然子查询在构造这种`SELECT`语句时极有用，但必须注意限制有歧义的列。

> **警告：完全限定列名**
> 你已经看到了为什么要使用完全限定列名，没有具体指定就会返回错误结果，因为DBMS会误解你的意思。有时候，由于出现冲突列名而导致的歧义性，会引起DBMS抛出错误信息。例如，`WHERE`或`ORDER BY`子句指定的某个列名可能会出现在多个表中。好的做法是，如果在`SELECT`语句中操作多个表，就应使用完全限定列名来避免歧义。

> **提示：不止一种解决方案**
> 正如这一课前面所述，虽然这里给出的样例代码运行良好，但它并不是解决这种数据检索的最有效方法。在后面两课学习JOIN时，我们还会遇到这个例子。

## 11.4 小结

这一课学习了什么是子查询，如何使用它们。子查询常用于`WHERE`子句的`IN`操作符中，以及用来填充计算列。我们举了这两种操作类型的例子。

# 第12课 联结表

这一课会介绍什么是联结，为什么使用联结，如何编写使用联结的`SELECT`语句。

## 12.1 联结

SQL最强大的功能之一就是能在数据查询的执行中联结（join）表。联结是利用SQL的`SELECT`能执行的最重要的操作，很好地理解联结及其语法是学习SQL的极为重要的部分。

在能够有效地使用联结前，必须了解关系表以及关系数据库设计的一些基础知识。下面的介绍并不能涵盖这一主题的所有内容，但作为入门已经够了。

### 12.1.1 关系表

理解关系表，最好是来看个例子。

有一个包含产品目录的数据库表，其中每类物品占一行。对于每一种物品，要存储的信息包括产品描述、价格，以及生产该产品的供应商。

现在有同一供应商生产的多种物品，那么在何处存储供应商名、地址、联系方法等供应商信息呢？将这些数据与产品信息分开存储的理由是：

*   同一供应商生产的每个产品，其供应商信息都是相同的，对每个产品重复此信息既浪费时间又浪费存储空间；
*   如果供应商信息发生变化，例如供应商迁址或电话号码变动，只需修改一次即可；
*   如果有重复数据（即每种产品都存储供应商信息），则很难保证每次输入该数据的方式都相同。不一致的数据在报表中就很难利用。

关键是，相同的数据出现多次决不是一件好事，这是关系数据库设计的基础。关系表的设计就是要把信息分解成多个表，一类数据一个表。各表通过某些共同的值互相关联（所以才叫关系数据库）。

在这个例子中可建立两个表：一个存储供应商信息，另一个存储产品信息。`Vendors`表包含所有供应商信息，每个供应商占一行，具有唯一的标识。此标识称为主键（primary key），可以是供应商ID或任何其他唯一值。

`Products`表只存储产品信息，除了存储供应商ID（`Vendors`表的主键）外，它不存储其他有关供应商的信息。`Vendors`表的主键将`Vendors`表与`Products`表关联，利用供应商ID能从`Vendors`表中找出相应供应商的详细信息。

这样做的好处是：

*   供应商信息不重复，不会浪费时间和空间；
*   如果供应商信息变动，可以只更新`Vendors`表中的单个记录，相关表中的数据不用改动；
*   由于数据不重复，数据显然是一致的，使得处理数据和生成报表更简单。

总之，关系数据可以有效地存储，方便地处理。因此，关系数据库的可伸缩性远比非关系数据库要好。

> **可伸缩（scale）**
> 能够适应不断增加的工作量而不失败。设计良好的数据库或应用程序称为可伸缩性好（scale well）。

### 12.1.2 为什么使用联结

如前所述，将数据分解为多个表能更有效地存储，更方便地处理，并且可伸缩性更好。但这些好处是有代价的。

如果数据存储在多个表中，怎样用一条`SELECT`语句就检索出数据呢？

答案是使用联结。简单说，联结是一种机制，用来在一条`SELECT`语句中关联表，因此称为联结。使用特殊的语法，可以联结多个表返回一组输出，联结在运行时关联表中正确的行。

> **说明：使用交互式DBMS工具**
> 重要的是，要理解联结不是物理实体。换句话说，它在实际的数据库表中并不存在。DBMS会根据需要建立联结，它在查询执行期间一直存在。
>
> 许多DBMS提供图形界面，用来交互式地定义表关系。这些工具极其有助于维护引用完整性。在使用关系表时，仅在关系列中插入合法数据是非常重要的。回到这里的例子，如果`Products`表中存储了无效的供应商ID，则相应的产品不可访问，因为它们没有关联到某个供应商。为避免这种情况发生，可指示数据库只允许在`Products`表的供应商ID列中出现合法值（即出现在`Vendors`表中的供应商）。引用完整性表示DBMS强制实施数据完整性规则。这些规则一般由提供了界面的DBMS管理。

## 12.2 创建联结

创建联结非常简单，指定要联结的所有表以及关联它们的方式即可。请看下面的例子：

**输入▼**

```
SELECT vend_name, prod_name, prod_price
FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id;

```

**输出▼**

```
vend_name                prod_name                prod_price
--------------------     --------------------     ----------
Doll House Inc.          Fish bean bag toy        3.4900
Doll House Inc.          Bird bean bag toy        3.4900
Doll House Inc.          Rabbit bean bag toy      3.4900
Bears R Us               8 inch teddy bear        5.9900
Bears R Us               12 inch teddy bear       8.9900
Bears R Us               18 inch teddy bear       11.9900
Doll House Inc.          Raggedy Ann              4.9900
Fun and Games            King doll                9.4900
Fun and Games            Queen doll               9.4900

```

**分析▼**
我们来看这段代码。`SELECT`语句与前面所有语句一样指定要检索的列。这里最大的差别是所指定的两列（`prod_name`和`prod_price`）在一个表中，而第三列（`vend_name`）在另一个表中。

现在来看`FROM`子句。与以前的`SELECT`语句不一样，这条语句的`FROM`子句列出了两个表：`Vendors`和`Products`。它们就是这条`SELECT`语句联结的两个表的名字。这两个表用`WHERE`子句正确地联结，`WHERE`子句指示DBMS将`Vendors`表中的`vend_id`与`Products`表中的`vend_id`匹配起来。

可以看到，要匹配的两列指定为`Vendors.vend_id`和`Products.vend_id`。这里需要这种完全限定列名，如果只给出`vend_id`，DBMS就不知道指的是哪一个（每个表中有一个）。从前面的输出可以看到，一条`SELECT`语句返回了两个不同表中的数据。

> **警告：完全限定列名**
> 就像前一课提到的，在引用的列可能出现歧义时，必须使用完全限定列名（用一个句点分隔表名和列名）。如果引用一个没有用表名限制的具有歧义的列名，大多数DBMS会返回错误。

### 12.2.1 WHERE子句的重要性

使用`WHERE`子句建立联结关系似乎有点奇怪，但实际上是有个很充分的理由的。要记住，在一条`SELECT`语句中联结几个表时，相应的关系是在运行中构造的。在数据库表的定义中没有指示DBMS如何对表进行联结的内容。你必须自己做这件事情。在联结两个表时，实际要做的是将第一个表中的每一行与第二个表中的每一行配对。`WHERE`子句作为过滤条件，只包含那些匹配给定条件（这里是联结条件）的行。没有`WHERE`子句，第一个表中的每一行将与第二个表中的每一行配对，而不管它们逻辑上是否能配在一起。

> **笛卡儿积（cartesian product）**
> 由没有联结条件的表关系返回的结果为笛卡儿积。检索出的行的数目将是第一个表中的行数乘以第二个表中的行数。

理解这一点，请看下面的`SELECT`语句及其输出：

**输入▼**

```
SELECT vend_name, prod_name, prod_price
FROM Vendors, Products;

```

**输出▼**

```
vend_name            prod_name                         prod_price
----------------     ----------------------------      ----------
Bears R Us           8 inch teddy bear                 5.99
Bears R Us           12 inch teddy bear                8.99
Bears R Us           18 inch teddy bear                11.99
Bears R Us           Fish bean bag toy                 3.49
Bears R Us           Bird bean bag toy                 3.49
Bears R Us           Rabbit bean bag toy               3.49
Bears R Us           Raggedy Ann                       4.99
Bears R Us           King doll                         9.49
Bears R Us           Queen doll                        9.49
Bear Emporium        8 inch teddy bear                 5.99
Bear Emporium        12 inch teddy bear                8.99
Bear Emporium        18 inch teddy bear                11.99
Bear Emporium        Fish bean bag toy                 3.49
Bear Emporium        Bird bean bag toy                 3.49
Bear Emporium        Rabbit bean bag toy               3.49
Bear Emporium        Raggedy Ann                       4.99
Bear Emporium        King doll                         9.49
Bear Emporium        Queen doll                        9.49
Doll House Inc.      8 inch teddy bear                 5.99
Doll House Inc.      12 inch teddy bear                8.99
Doll House Inc.      18 inch teddy bear                11.99
Doll House Inc.      Fish bean bag toy                 3.49
Doll House Inc.      Bird bean bag toy                 3.49
Doll House Inc.      Rabbit bean bag toy               3.49
Doll House Inc.      Raggedy Ann                       4.99
Doll House Inc.      King doll                         9.49
Doll House Inc.      Queen doll                        9.49
Furball Inc.         8 inch teddy bear                 5.99
Furball Inc.         12 inch teddy bear                8.99
Furball Inc.         18 inch teddy bear                11.99
Furball Inc.         Fish bean bag toy                 3.49
Furball Inc.         Bird bean bag toy                 3.49
Furball Inc.         Rabbit bean bag toy               3.49
Furball Inc.         Raggedy Ann                       4.99
Furball Inc.         King doll                         9.49
Furball Inc.         Queen doll                        9.49
Fun and Games        8 inch teddy bear                 5.99
Fun and Games        12 inch teddy bear                8.99
Fun and Games        18 inch teddy bear                11.99
Fun and Games        Fish bean bag toy                 3.49
Fun and Games        Bird bean bag toy                 3.49
Fun and Games        Rabbit bean bag toy               3.49
Fun and Games        Raggedy Ann                       4.99
Fun and Games        King doll                         9.49
Fun and Games        Queen doll                        9.49
Jouets et ours       8 inch teddy bear                 5.99
Jouets et ours       12 inch teddy bear                8.99
Jouets et ours       18 inch teddy bear                11.99
Jouets et ours       Fish bean bag toy                 3.49
Jouets et ours       Bird bean bag toy                 3.49
Jouets et ours       Rabbit bean bag toy               3.49
Jouets et ours       Raggedy Ann                       4.99
Jouets et ours       King doll                         9.49
Jouets et ours       Queen doll                        9.49

```

**分析▼**
从上面的输出可以看到，相应的笛卡儿积不是我们想要的。这里返回的数据用每个供应商匹配了每个产品，包括了供应商不正确的产品（即使供应商根本就没有产品）。

> **警告：不要忘了`WHERE`子句**
> 要保证所有联结都有`WHERE`子句，否则DBMS将返回比想要的数据多得多的数据。同理，要保证`WHERE`子句的正确性。不正确的过滤条件会导致DBMS返回不正确的数据。

> **提示：叉联结**
> 有时，返回笛卡儿积的联结，也称叉联结（cross join）。

### 12.2.2 内联结

目前为止使用的联结称为等值联结（equijoin），它基于两个表之间的相等测试。这种联结也称为内联结（inner join）。其实，可以对这种联结使用稍微不同的语法，明确指定联结的类型。下面的`SELECT`语句返回与前面例子完全相同的数据：

**输入▼**

```
SELECT vend_name, prod_name, prod_price
FROM Vendors INNER JOIN Products
 ON Vendors.vend_id = Products.vend_id;

```

**分析▼**
此语句中的`SELECT`与前面的`SELECT`语句相同，但`FROM`子句不同。这里，两个表之间的关系是以`INNER JOIN`指定的部分`FROM`子句。在使用这种语法时，联结条件用特定的`ON`子句而不是`WHERE`子句给出。传递给`ON`的实际条件与传递给`WHERE`的相同。

至于选用哪种语法，请参阅具体的DBMS文档。

> **说明：“正确的”语法**
> ANSI SQL规范首选`INNER JOIN`语法，之前使用的是简单的等值语法。其实，SQL语言纯正论者是用鄙视的眼光看待简单语法的。这就是说，DBMS的确支持简单格式和标准格式，我建议你要理解这两种格式，具体使用就看你用哪个更顺手了。

### 12.2.3 联结多个表

SQL不限制一条`SELECT`语句中可以联结的表的数目。创建联结的基本规则也相同。首先列出所有表，然后定义表之间的关系。例如：

**输入▼**

```
SELECT prod_name, vend_name, prod_price, quantity
FROM OrderItems, Products, Vendors
WHERE Products.vend_id = Vendors.vend_id
 AND OrderItems.prod_id = Products.prod_id
 AND order_num = 20007;

```

**输出▼**

```
prod_name           vend_name         prod_price     quantity
---------------     -------------     ----------     --------
18 inch teddy bear  Bears R Us        11.9900        50
Fish bean bag toy   Doll House Inc.   3.4900         100
Bird bean bag toy   Doll House Inc.   3.4900         100
Rabbit bean bag toy Doll House Inc.   3.4900         100
Raggedy Ann         Doll House Inc.   4.9900         50

```

**分析▼**
这个例子显示订单`20007`中的物品。订单物品存储在`OrderItems`表中。每个产品按其产品ID存储，它引用`Products`表中的产品。这些产品通过供应商ID联结到`Vendors`表中相应的供应商，供应商ID存储在每个产品的记录中。这里的`FROM`子句列出三个表，`WHERE`子句定义这两个联结条件，而第三个联结条件用来过滤出订单`20007`中的物品。

> **警告：性能考虑**
> DBMS在运行时关联指定的每个表，以处理联结。这种处理可能非常耗费资源，因此应该注意，不要联结不必要的表。联结的表越多，性能下降越厉害。

> **警告：联结中表的最大数目**
> 虽然SQL本身不限制每个联结约束中表的数目，但实际上许多DBMS都有限制。请参阅具体的DBMS文档以了解其限制。

现在回顾一下第11课中的例子，如下的`SELECT`语句返回订购产品`RGAN01`的顾客列表：

**输入▼**

```
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
                  FROM Orders
                  WHERE order_num IN (SELECT order_num
                                      FROM OrderItems
                                      WHERE prod_id = 'RGAN01'));

```

如第11课所述，子查询并不总是执行复杂`SELECT`操作的最有效方法，下面是使用联结的相同查询：

[ex++02我的想法：使用连接的写法，替代之前的子查询](https://github.com/lpd743663/SQL-test/issues/9)


**输入▼**

```
SELECT cust_name, cust_contact
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
 AND OrderItems.order_num = Orders.order_num
 AND prod_id = 'RGAN01';
 --where 后面的条件顺序是随意的，没有要求按照特定的顺序，调整语句顺序的结果是一样的,那么跟性能是否有关？
```

**输出▼**

```
cust_name                         cust_contact
-----------------------------     --------------------
Fun4All                           Denise L. Stephens
The Toy Store                     Kim Howard

```

**分析▼**
如第11课所述，这个查询中的返回数据需要使用3个表。但在这里，我们没有在嵌套子查询中使用它们，而是使用了两个联结来连接表。这里有三个`WHERE`子句条件。前两个关联联结中的表，后一个过滤产品`RGAN01`的数据。

> **提示：多做实验**
> 可以看到，执行任一给定的SQL操作一般不止一种方法。很少有绝对正确或绝对错误的方法。性能可能会受操作类型、所使用的DBMS、表中数据量、是否存在索引或键等条件的影响。因此，有必要试验不同的选择机制，找出最适合具体情况的方法。

## 12.3 小结

联结是SQL中一个最重要、最强大的特性，有效地使用联结需要对关系数据库设计有基本的了解。本课在介绍联结时，讲述了一些关系数据库设计的基本知识，包括等值联结（也称为内联结）这种最常用的联结。下一课将介绍如何创建其他类型的联结。

# 第13课 创建高级联结

本课讲解另外一些联结（包括它们的含义和使用方法），介绍如何使用表别名，如何对被联结的表使用聚集函数。

## 13.1 使用表别名

第7课介绍了如何使用别名引用被检索的表列。给列起别名的语法如下：

**输入▼**

```
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')'
       AS vend_title
FROM Vendors
ORDER BY vend_name;

```

SQL除了可以对列名和计算字段使用别名，还允许给表名起别名。这样做有两个主要理由：

*   缩短SQL语句；
*   允许在一条`SELECT`语句中多次使用相同的表。

请看下面的`SELECT`语句。它与前一课例子中所用的语句基本相同，但改成了使用别名：

**输入▼**

```
SELECT cust_name, cust_contact
FROM Customers AS C, Orders AS O, OrderItems AS OI
WHERE C.cust_id = O.cust_id
 AND OI.order_num = O.order_num
 AND prod_id = 'RGAN01';

```

**分析▼**
可以看到，`FROM`子句中的三个表全都有别名。`Customers AS C`使用`C`作为`Customers`的别名，如此等等。这样，就可以使用省略的`C`而不用全名`Customers`。在这个例子中，表别名只用于`WHERE`子句。其实它不仅能用于`WHERE`子句，还可以用于`SELECT`的列表、`ORDER BY`子句以及其他语句部分。

> **警告：Oracle中没有`AS`**
> Oracle不支持`AS`关键字。要在Oracle中使用别名，可以不用`AS`，简单地指定列名即可（因此，应该是`Customers C`，而不是`Customers AS C`）。

需要注意，表别名只在查询执行中使用。与列别名不一样，表别名不返回到客户端。

## 13.2 使用不同类型的联结

迄今为止，我们使用的只是内联结或**等值联结**的简单联结。现在来看三种其他联结：自联结（self-join）、自然联结（natural join）和外联结（outer join）。

### 13.2.1 自联结

如前所述，使用表别名的一个主要原因是能在一条`SELECT`语句中不止一次引用相同的表。下面举一个例子。

假如要给与Jim Jones同一公司的所有顾客发送一封信件。这个查询要求首先找出Jim Jones工作的公司，然后找出在该公司工作的顾客。下面是解决此问题的一种方法：

**输入▼**

```
SELECT cust_id, cust_name, cust_contact
FROM Customers
WHERE cust_name = (SELECT cust_name
                   FROM Customers
                   WHERE cust_contact = 'Jim Jones');

```

**输出▼**

```
cust_id      cust_name          cust_contact
--------     --------------     --------------
1000000003   Fun4All            Jim Jones
1000000004   Fun4All            Denise L. Stephens

```

**分析▼**
这是第一种解决方案，使用了子查询。内部的`SELECT`语句做了一个简单检索，返回Jim Jones工作公司的`cust_name`。该名字用于外部查询的`WHERE`子句中，以检索出为该公司工作的所有雇员（第11课中讲授了子查询，更多信息请参阅该课）。

现在来看使用联结的相同查询：

**输入▼**

```
SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM Customers AS c1, Customers AS c2
WHERE c1.cust_name = c2.cust_name
 AND c2.cust_contact = 'Jim Jones';

```

**输出▼**

```
cust_id     cust_name       cust_contact
-------     -----------     --------------
1000000003  Fun4All         Jim Jones
1000000004  Fun4All         Denise L. Stephens

```

> **提示：Oracle中没有`AS`**
> Oracle用户应该记住去掉`AS`。

**分析▼**
此查询中需要的两个表实际上是相同的表，因此`Customers`表在`FROM`子句中出现了两次。虽然这是完全合法的，但对`Customers`的引用具有歧义性，因为DBMS不知道你引用的是哪个`Customers`表。

解决此问题，需要使用表别名。`Customers`第一次出现用了别名`C1`，第二次出现用了别名`C2`。现在可以将这些别名用作表名。例如，`SELECT`语句使用`C1`前缀明确给出所需列的全名。如果不这样，DBMS将返回错误，因为名为`cust_id`、`cust_name`、`cust_contact`的列各有两个。DBMS不知道想要的是哪一列（即使它们其实是同一列）。`WHERE`首先联结两个表，然后按第二个表中的`cust_contact`过滤数据，返回所需的数据。

> **提示：用自联结而不用子查询**
> 自联结通常作为外部语句，用来替代从相同表中检索数据的使用子查询语句。虽然最终的结果是相同的，但许多DBMS处理联结远比处理子查询快得多。应该试一下两种方法，以确定哪一种的性能更好。

### 13.2.2 自然联结

无论何时对表进行联结，应该至少有一列不止出现在一个表中（被联结的列）。标准的联结（前一课中介绍的内联结）返回所有数据，相同的列甚至多次出现。自然联结排除多次出现，使每一列只返回一次。

怎样完成这项工作呢？答案是，系统不完成这项工作，由你自己完成它。自然联结要求你只能选择那些唯一的列，一般通过对一个表使用通配符（`SELECT *`），而对其他表的列使用明确的子集来完成。下面举一个例子：

**输入▼**

```
SELECT C.*, O.order_num, O.order_date,
       OI.prod_id, OI.quantity, OI.item_price
FROM Customers AS C, Orders AS O, OrderItems AS OI
WHERE C.cust_id = O.cust_id
 AND OI.order_num = O.order_num
 AND prod_id = 'RGAN01';

```

> **提示：Oracle中没有`AS`**
> Oracle用户应该记住去掉`AS`。

**分析▼**
在这个例子中，通配符只对第一个表使用。所有其他列明确列出，所以没有重复的列被检索出来。

事实上，我们迄今为止建立的每个内联结都是自然联结，很可能永远都不会用到不是自然联结的内联结。

### 13.2.3 外联结

许多联结将一个表中的行与另一个表中的行相关联，但有时候需要包含没有关联行的那些行。例如，可能需要使用联结完成以下工作：

*   对每个顾客下的订单进行计数，包括那些至今尚未下订单的顾客；
*   列出所有产品以及订购数量，包括没有人订购的产品；
*   计算平均销售规模，包括那些至今尚未下订单的顾客。

在上述例子中，联结包含了那些在相关表中没有关联行的行。这种联结称为外联结。

> **警告：语法差别**
> 需要注意，用来创建外联结的语法在不同的SQL实现中可能稍有不同。下面段落中描述的各种语法形式覆盖了大多数实现，在继续学习之前请参阅你使用的DBMS文档，以确定其语法。

下面的`SELECT`语句给出了一个简单的内联结。它检索所有顾客及其订单：

**输入▼**

```
SELECT Customers.cust_id, Orders.order_num
FROM Customers INNER JOIN Orders
 ON Customers.cust_id = Orders.cust_id;

```

外联结语法类似。要检索包括没有订单顾客在内的所有顾客，可如下进行：

**输入▼**

```
SELECT Customers.cust_id, Orders.order_num
FROM Customers LEFT OUTER JOIN Orders
 ON Customers.cust_id = Orders.cust_id;

```

**输出▼**

```
cust_id        order_num
----------     ---------
1000000001     20005
1000000001     20009
1000000002     NULL
1000000003     20006
1000000004     20007
1000000005     20008

```

**分析▼**
类似上一课提到的内联结，这条`SELECT`语句使用了关键字`OUTER JOIN`来指定联结类型（而不是在`WHERE`子句中指定）。但是，与内联结关联两个表中的行不同的是，外联结还包括没有关联行的行。在使用`OUTER JOIN`语法时，必须使用`RIGHT`或`LEFT`关键字指定包括其所有行的表（`RIGHT`指出的是`OUTER JOIN`右边的表，而`LEFT`指出的是`OUTER JOIN`左边的表）。上面的例子使用`LEFT OUTER JOIN`从`FROM`子句左边的表（`Customers`表）中选择所有行。为了从右边的表中选择所有行，需要使用`RIGHT OUTER JOIN`，如下例所示：

**输入▼**

```
SELECT Customers.cust_id, Orders.order_num
FROM Customers RIGHT OUTER JOIN Orders
 ON Orders.cust_id = Customers.cust_id;

```

> **警告：SQLite外联结**
> SQLite支持`LEFT OUTER JOIN`，但不支持`RIGHT OUTER JOIN`。幸好，如果你确实需要在SQLite中使用`RIGHT OUTER JOIN`，有一种更简单的办法，这将在下面的提示中介绍。

> **提示：外联结的类型**
> 要记住，总是有两种基本的外联结形式：左外联结和右外联结。它们之间的唯一差别是所关联的表的顺序。换句话说，调整`FROM`或`WHERE`子句中表的顺序，左外联结可以转换为右外联结。因此，这两种外联结可以互换使用，哪个方便就用哪个。

还存在另一种外联结，就是全外联结（full outer join），它检索两个表中的所有行并关联那些可以关联的行。与左外联结或右外联结包含一个表的不关联的行不同，全外联结包含两个表的不关联的行。全外联结的语法如下：

**输入▼**

```
SELECT Customers.cust_id, Orders.order_num
FROM Orders FULL OUTER JOIN Customers
ON Orders.cust_id = Customers.cust_id;

```

> **警告：`FULL OUTER JOIN`的支持**
> Access、MariaDB、MySQL、Open Office Base或SQLite不支持`FULL OUTER JOIN`语法。

## 13.3 使用带聚集函数的联结

如第9课所述，聚集函数用来汇总数据。虽然至今为止我们举的聚集函数的例子都只是从一个表中汇总数据，但这些函数也可以与联结一起使用。

我们来看个例子，要检索所有顾客及每个顾客所下的订单数，下面的代码使用`COUNT()`函数完成此工作：

**输入▼**

```
SELECT Customers.cust_id,
       COUNT(Orders.order_num) AS num_ord
FROM Customers INNER JOIN Orders
 ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;

```

**输出▼**

```
cust_id        um_ord
----------     --------
1000000001     2
1000000003     1
1000000004     1
1000000005     1

```

**分析▼**
这条`SELECT`语句使用`INNER JOIN`将`Customers`和`Orders`表互相关联。`GROUP BY`子句按顾客分组数据，因此，函数调用`COUNT(Orders.order_num)`对每个顾客的订单计数，将它作为`num_ord`返回。

聚集函数也可以方便地与其他联结一起使用。请看下面的例子：

**输入▼**

```
SELECT Customers.cust_id,
       COUNT(Orders.order_num) AS num_ord
FROM Customers LEFT OUTER JOIN Orders
 ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;

```

> **提示：Oracle中没有`AS`**
> 再次提醒Oracle用户，请记住删除`AS`。

**输出▼**

```
cust_id        num_ord
----------     -------
1000000001     2
1000000002     0
1000000003     1
1000000004     1
1000000005     1

```

**分析▼**
这个例子使用左外部联结来包含所有顾客，甚至包含那些没有任何订单的顾客。结果中也包含了顾客`1000000002`，他有`0`个订单。

## 13.4 使用联结和联结条件

在总结讨论联结的这两课前，有必要汇总一下联结及其使用的要点。

*   注意所使用的联结类型。一般我们使用内联结，但使用外联结也有效。
*   关于确切的联结语法，应该查看具体的文档，看相应的DBMS支持何种语法（大多数DBMS使用这两课中描述的某种语法）。
*   保证使用正确的联结条件（不管采用哪种语法），否则会返回不正确的数据。
*   应该总是提供联结条件，否则会得出笛卡儿积。
*   在一个联结中可以包含多个表，甚至可以对每个联结采用不同的联结类型。虽然这样做是合法的，一般也很有用，但应该在一起测试它们前分别测试每个联结。这会使故障排除更为简单。

## 13.5 小结

本课是上一课的延续，首先讲授了如何以及为什么使用别名，然后讨论不同的联结类型以及每类联结所使用的语法。我们还介绍了如何与联结一起使用聚集函数，以及在使用联结时应该注意的问题。

# 第14课 组合查询

本课讲述如何利用`UNION`操作符将多条`SELECT`语句组合成一个结果集。

## 14.1 组合查询

多数SQL查询只包含从一个或多个表中返回数据的单条`SELECT`语句。但是，SQL也允许执行多个查询（多条`SELECT`语句），并将结果作为一个查询结果集返回。这些组合查询通常称为**并**（union）或**复合查询**（compound query）。

主要有两种情况需要使用组合查询：

*   在一个查询中从不同的表返回结构数据；
*   对一个表执行多个查询，按一个查询返回数据。

> **提示：组合查询和多个`WHERE`条件**
> 多数情况下，组合相同表的两个查询所完成的工作与具有多个`WHERE`子句条件的一个查询所完成的工作相同。换句话说，任何具有多个`WHERE`子句的`SELECT`语句都可以作为一个组合查询，在下面可以看到这一点。

## 14.2 创建组合查询

可用`UNION`操作符来组合数条SQL查询。利用`UNION`，可给出多条`SELECT`语句，将它们的结果组合成一个结果集。

### 14.2.1 使用UNION

使用`UNION`很简单，所要做的只是给出每条`SELECT`语句，在各条语句之间放上关键字`UNION`。

举个例子，假如需要Illinois、Indiana和Michigan等美国几个州的所有顾客的报表，还想包括不管位于哪个州的所有的`Fun4All`。当然可以利用`WHERE`子句来完成此工作，不过这次我们使用`UNION`。

如上所述，创建`UNION`涉及编写多条`SELECT`语句。首先来看单条语句：

**输入▼**

```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI');

```

**输出▼**

```
cust_name       cust_contact      cust_email
-----------     -------------     ------------
Village Toys    John Smith        sales@villagetoys.com
Fun4All         Jim Jones         jjones@fun4all.com
The Toy Store   Kim Howard        NULL

```

**输入▼**

```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

```

**输出▼**

```
cust_name       cust_contact         cust_email
-----------     -------------        ------------
Fun4All         Jim Jones            jjones@fun4all.com
Fun4All         Denise L. Stephens   dstephens@fun4all.com

```

**分析▼**
第一条`SELECT`把Illinois、Indiana、Michigan等州的缩写传递给`IN`子句，检索出这些州的所有行。第二条`SELECT`利用简单的相等测试找出所有`Fun4All`。

组合这两条语句，可以如下进行：

**输入▼**

```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

```

**输出▼**

```
cust_name       cust_contact        cust_email
-----------     -----------         ----------------
Fun4All         Denise L. Stephens  dstephens@fun4all.com
Fun4All         Jim Jones           jjones@fun4all.com
Village Toys    John Smith          sales@villagetoys.com
The Toy Store   Kim Howard          NULL

```

**分析▼**
这条语句由前面的两条`SELECT`语句组成，之间用`UNION`关键字分隔。`UNION`指示DBMS执行这两条`SELECT`语句，并把输出组合成一个查询结果集。

为了便于参考，这里给出使用多条`WHERE`子句而不是`UNION`的相同查询：

**输入▼**

```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
 OR cust_name = 'Fun4All';

```

在这个简单的例子中，使用`UNION`可能比使用`WHERE`子句更为复杂。但对于较复杂的过滤条件，或者从多个表（而不是一个表）中检索数据的情形，使用`UNION`可能会使处理更简单。

> **提示：`UNION`的限制**
> 使用`UNION`组合`SELECT`语句的数目，SQL没有标准限制。但是，最好是参考一下具体的DBMS文档，了解它是否对`UNION`能组合的最大语句数目有限制。

> **警告：性能问题**
> 多数好的DBMS使用内部查询优化程序，在处理各条`SELECT`语句前组合它们。理论上讲，这意味着从性能上看使用多条`WHERE`子句条件还是`UNION`应该没有实际的差别。不过我说的是理论上，实践中多数查询优化程序并不能达到理想状态，所以最好测试一下这两种方法，看哪种工作得更好。

### 14.2.2 UNION规则

可以看到，`UNION`非常容易使用，但在进行组合时需要注意几条规则。

*   `UNION`必须由两条或两条以上的`SELECT`语句组成，语句之间用关键字`UNION`分隔（因此，如果组合四条`SELECT`语句，将要使用三个`UNION`关键字）。
*   `UNION`中的每个查询必须包含相同的列、表达式或聚集函数（不过，各个列不需要以相同的次序列出）。
*   列数据类型必须兼容：类型不必完全相同，但必须是DBMS可以隐含转换的类型（例如，不同的数值类型或不同的日期类型）。

如果遵守了这些基本规则或限制，则可以将`UNION`用于任何数据检索操作。

### 14.2.3 包含或取消重复的行

回到14.2.1节，我们看看所用的`SELECT`语句。注意到在分别执行语句时，第一条`SELECT`语句返回3行，第二条`SELECT`语句返回2行。而在用`UNION`组合两条`SELECT`语句后，只返回4行而不是5行。

`UNION`从查询结果集中自动去除了重复的行；换句话说，它的行为与一条`SELECT`语句中使用多个`WHERE`子句条件一样。因为Indiana州有一个Fun4All单位，所以两条`SELECT`语句都返回该行。使用`UNION`时，重复的行会被自动取消。

这是`UNION`的默认行为，如果愿意也可以改变它。事实上，如果想返回所有的匹配行，可使用`UNION ALL`而不是`UNION`。

请看下面的例子：

**输入▼**

```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION ALL
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

```

**输出▼**

```
cust_name       cust_contact         cust_email
-----------     -------------        ------------
Village Toys    John Smith           sales@villagetoys.com
Fun4All         Jim Jones            jjones@fun4all.com
The Toy Store   Kim Howard           NULL
Fun4All         Jim Jones            jjones@fun4all.com
Fun4All         Denise L. Stephens   dstephens@fun4all.com

```

**分析▼**
使用`UNION ALL`，DBMS不取消重复的行。因此，这里返回5行，其中有一行出现两次。

> **提示：`UNION`与`WHERE`**
> 这一课一开始我们说过，`UNION`几乎总是完成与多个`WHERE`条件相同的工作。`UNION ALL`为`UNION`的一种形式，它完成`WHERE`子句完成不了的工作。如果确实需要每个条件的匹配行全部出现（包括重复行），就必须使用`UNION ALL`，而不是`WHERE`。

### 14.2.4 对组合查询结果排序

`SELECT`语句的输出用`ORDER BY`子句排序。在用`UNION`组合查询时，只能使用一条`ORDER BY`子句，它必须位于最后一条`SELECT`语句之后。对于结果集，不存在用一种方式排序一部分，而又用另一种方式排序另一部分的情况，因此不允许使用多条`ORDER BY`子句。

下面的例子对前面`UNION`返回的结果进行排序：

**输入▼**

```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;

```

**输出▼**

```
cust_name       cust_contact         cust_email
-----------     -------------        -------------
Fun4All         Denise L. Stephens   dstephens@fun4all.com
Fun4All         Jim Jones            jjones@fun4all.com
The Toy Store   Kim Howard           NULL
Village Toys    John Smith           sales@villagetoys.com

```

**分析▼**
这条`UNION`在最后一条`SELECT`语句后使用了`ORDER BY`子句。虽然`ORDER BY`子句似乎只是最后一条`SELECT`语句的组成部分，但实际上DBMS将用它来排序所有`SELECT`语句返回的所有结果。

> **说明：其他类型的`UNION`**
> 某些DBMS还支持另外两种`UNION`：`EXCEPT`（有时称为`MINUS`）可用来检索只在第一个表中存在而在第二个表中不存在的行；而`INTERSECT`可用来检索两个表中都存在的行。实际上，这些`UNION`很少使用，因为相同的结果可利用联结得到。

> **提示：操作多个表**
> 为了简单，本课中的例子都是使用`UNION`来组合针对同一表的多个查询。实际上，`UNION`在需要组合多个表的数据时也很有用，即使是有不匹配列名的表，在这种情况下，可以将UNION与别名组合，检索一个结果集。

## 14.3 小结

这一课讲授如何用`UNION`操作符来组合`SELECT`语句。利用`UNION`，可以把多条查询的结果作为一条组合查询返回，不管结果中有无重复。使用`UNION`可极大地简化复杂的`WHERE`子句，简化从多个表中检索数据的工作。

# 第15课 插入数据

这一课介绍如何利用SQL的`INSERT`语句将数据插入表中。

## 15.1 数据插入

毫无疑问，`SELECT`是最常用的SQL语句了，这就是前14课都在讲它的原因。但是，还有其他3个常用的SQL语句需要学习。第一个就是`INSERT`（下一课介绍另外两个）。

顾名思义，`INSERT`用来将行插入（或添加）到数据库表。插入有几种方式：

*   插入完整的行；
*   插入行的一部分；
*   插入某些查询的结果。

下面逐一介绍这些内容。

> **提示：插入及系统安全**
> 使用`INSERT`语句可能需要客户端/服务器DBMS中的特定安全权限。在你试图使用`INSERT`前，应该保证自己有足够的安全权限。

### 15.1.1 插入完整的行

把数据插入表中的最简单方法是使用基本的`INSERT`语法，它要求指定表名和插入到新行中的值。下面举一个例子：

**输入▼**

```
INSERT INTO Customers
VALUES('1000000006',
       'Toy Land',
       '123 Any Street',
       'New York',
       'NY',
       '11111',
       'USA',
       NULL,
       NULL);

```

**分析▼** 这个例子将一个新顾客插入到`Customers`表中。存储到表中每一列的数据在`VALUES`子句中给出，必须给每一列提供一个值。如果某列没有值，如上面的`cust_contact`和`cust_email`列，则应该使用`NULL`值（假定表允许对该列指定空值）。各列必须以它们在表定义中出现的次序填充。

> **提示：`INTO`关键字**
> 在某些SQL实现中，跟在`INSERT`之后的`INTO`关键字是可选的。但是，即使不一定需要，最好还是提供这个关键字，这样做将保证SQL代码在DBMS之间可移植。

虽然这种语法很简单，但并不安全，应该尽量避免使用。上面的SQL语句高度依赖于表中列的定义次序，还依赖于其容易获得的次序信息。即使可以得到这种次序信息，也不能保证各列在下一次表结构变动后保持完全相同的次序。因此，编写依赖于特定列次序的SQL语句是很不安全的，这样做迟早会出问题。

编写`INSERT`语句的更安全（不过更烦琐）的方法如下：

**输入▼**

```
INSERT INTO Customers(cust_id,
                      cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip,
                      cust_country,
                      cust_contact,
                      cust_email)
VALUES('1000000006',
       'Toy Land',
       '123 Any Street',
       'New York',
       'NY',
       '11111',
       'USA',
       NULL,
       NULL);

```

**分析▼**
这个例子与前一个`INSERT`语句的工作完全相同，但在表名后的括号里明确给出了列名。在插入行时，DBMS将用`VALUES`列表中的相应值填入列表中的对应项。`VALUES`中的第一个值对应于第一个指定列名，第二个值对应于第二个列名，如此等等。

因为提供了列名，`VALUES`必须以其指定的次序匹配指定的列名，不一定按各列出现在表中的实际次序。其优点是，即使表的结构改变，这条`INSERT`语句仍然能正确工作。

下面的`INSERT`语句填充所有列（与前面的一样），但以一种不同的次序填充。因为给出了列名，所以插入结果仍然正确：

**输入▼**

```
INSERT INTO Customers(cust_id,
                      cust_contact,
                      cust_email,
                      cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip)
VALUES('1000000006',
       NULL,
       NULL,
       'Toy Land',
       '123 Any Street',
       'New York',
       'NY',
       '11111');

```

> **提示：总是使用列的列表**
> 不要使用没有明确给出列的`INSERT`语句。给出列能使SQL代码继续发挥作用，即使表结构发生了变化。

> **警告：小心使用`VALUES`**
> 不管使用哪种`INSERT`语法，`VALUES`的数目都必须正确。如果不提供列名，则必须给每个表列提供一个值；如果提供列名，则必须给列出的每个列一个值。否则，就会产生一条错误消息，相应的行不能成功插入。

### 15.1.2 插入部分行

正如所述，使用`INSERT`的推荐方法是明确给出表的列名。使用这种语法，还可以省略列，这表示可以只给某些列提供值，给其他列不提供值。

请看下面的例子：

**输入▼**

```
INSERT INTO Customers(cust_id,
                      cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip,
                      cust_country)
VALUES('1000000006',
       'Toy Land',
       '123 Any Street',
       'New York',
       'NY',
       '11111',
       'USA');

```

**分析▼**
在本课前面的例子中，没有给`cust_contact`和`cust_email`这两列提供值。这表示没必要在`INSERT`语句中包含它们。因此，这里的`INSERT`语句省略了这两列及其对应的值。

> **警告：省略列**
> 如果表的定义允许，则可以在`INSERT`操作中省略某些列。省略的列必须满足以下某个条件。
>
> *   该列定义为允许`NULL`值（无值或空值）。
> *   在表定义中给出默认值。这表示如果不给出值，将使用默认值。
>
> 如果对表中不允许`NULL`值且没有默认值的列不给出值，DBMS将产生错误消息，并且相应的行插入不成功。

> **警告：省略所需的值**
> 如果表中不允许有`NULL`值或者默认值，这时却省略了表中的值，DBMS就会产生错误消息，相应的行不能成功插入。

### 15.1.3 插入检索出的数据

`INSERT`一般用来给表插入具有指定列值的行。`INSERT`还存在另一种形式，可以利用它将`SELECT`语句的结果插入表中，这就是所谓的`INSERT SELECT`。顾名思义，它是由一条`INSERT`语句和一条`SELECT`语句组成的。

假如想把另一表中的顾客列合并到`Customers`表中。不需要每次读取一行再将它用`INSERT`插入，可以如下进行：

**输入▼**

```
INSERT INTO Customers(cust_id,
                      cust_contact,
                      cust_email,
                      cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip,
                      cust_country)
SELECT cust_id,
       cust_contact,
       cust_email,
       cust_name,
       cust_address,
       cust_city,
       cust_state,
       cust_zip,
       cust_country
FROM CustNew;

```

> **说明：新例子的说明**
> 这个例子从一个名为`CustNew`的表中读出数据并插入到`Customers`表。为了试验这个例子，应该首先创建和填充`CustNew`表。`CustNew`表的结构与附录A中描述的`Customers`表相同。在填充`CustNew`时，不应该使用已经在`Customers`中用过的`cust_id`值（如果主键值重复，后续的`INSERT`操作将会失败）。

**分析▼**
这个例子使用`INSERT SELECT`从`CustNew`中将所有数据导入`Customers`。`SELECT`语句从`CustNew`检索出要插入的值，而不是列出它们。`SELECT`中列出的每一列对应于`Customers`表名后所跟的每一列。这条语句将插入多少行呢？这依赖于`CustNew`表有多少行。如果这个表为空，则没有行被插入（也不产生错误，因为操作仍然是合法的）。如果这个表确实有数据，则所有数据将被插入到`Customers`。
mk++03：列数一致，行数（包括0）没有限制。
> **提示：`INSERT SELECT`中的列名**
> 为简单起见，这个例子在`INSERT`和`SELECT`语句中使用了相同的列名。但是，不一定要求列名匹配。事实上，DBMS一点儿也不关心`SELECT`返回的列名。它使用的是列的位置，因此`SELECT`中的第一列（不管其列名）将用来填充表列中指定的第一列，第二列将用来填充表列中指定的第二列，如此等等。mk++04：列的名字无所谓，列的位置要正确。

`INSERT SELECT`中`SELECT`语句可以包含`WHERE`子句，以过滤插入的数据。

> **提示：插入多行**
> `INSERT`通常只插入一行。要插入多行，必须执行多个`INSERT`语句。`INSERT SELECT`是个例外，它可以用一条`INSERT`插入多行，不管`SELECT`语句返回多少行，都将被`INSERT`插入。

## 15.2 从一个表复制到另一个表

有一种数据插入不使用`INSERT`语句。要将一个表的内容复制到一个全新的表（运行中创建的表），可以使用`SELECT INTO`语句。

> **说明：DB2不支持**
> DB2不支持这里描述的`SELECT INTO`。

与`INSERT SELECT`将数据添加到一个已经存在的表不同，`SELECT INTO`将数据复制到一个新表（有的DBMS可以覆盖已经存在的表，这依赖于所使用的具体DBMS）。

> **说明：`INSERT SELECT`与`SELECT INTO`**
> 它们之间的一个重要差别是前者导出数据，而后者导入数据。

下面的例子说明如何使用`SELECT INTO`：

**输入▼**

```
SELECT *
INTO CustCopy
FROM Customers;

```

**分析▼**
这条`SELECT`语句创建一个名为`CustCopy`的新表，并把`Customers`表的整个内容复制到新表中。因为这里使用的是`SELECT *`，所以将在`CustCopy`表中创建（并填充）与`Customers`表的每一列相同的列。要想只复制部分的列，可以明确给出列名，而不是使用`*`通配符。

MariaDB、MySQL、Oracle、PostgreSQL和SQLite使用的语法稍有不同：

**输入▼**

```
CREATE TABLE CustCopy AS
SELECT * FROM Customers;

```

在使用`SELECT INTO`时，需要知道一些事情：

*   任何`SELECT`选项和子句都可以使用，包括`WHERE`和`GROUP BY`；
*   可利用联结从多个表插入数据；
*   不管从多少个表中检索数据，数据都只能插入到一个表中。

> **提示：进行表的复制**
> `SELECT INTO`是试验新SQL语句前进行表复制的很好工具。先进行复制，可在复制的数据上测试SQL代码，而不会影响实际的数据。

> **说明：更多例子**
> 如果想看`INSERT`用法的更多例子，请参阅附录A中给出的样例表填充脚本。

## 15.3 小结

这一课介绍如何将行插入到数据库表中。我们学习了使用`INSERT`的几种方法，为什么要明确使用列名，如何用`INSERT SELECT`从其他表中导入行，如何用`SELECT INTO`将行导出到一个新表。下一课将讲述如何使用`UPDATE`和`DELETE`进一步操作表数据。

# 第16课 更新和删除数据

这一课介绍如何利用`UPDATE`和`DELETE`语句进一步操作表数据。

## 16.1 更新数据

更新（修改）表中的数据，可以使用`UPDATE`语句。有两种使用`UPDATE`的方式：

*   更新表中的特定行；
*   更新表中的所有行。

下面分别介绍。

> **警告：不要省略`WHERE`子句**
> 在使用`UPDATE`时一定要细心。因为稍不注意，就会更新表中的所有行。使用这条语句前，请完整地阅读本节。

> **提示：`UPDATE`与安全**
> 在客户端/服务器的DBMS中，使用`UPDATE`语句可能需要特殊的安全权限。在你使用`UPDATE`前，应该保证自己有足够的安全权限。

使用`UPDATE`语句非常容易，甚至可以说太容易了。基本的`UPDATE`语句由三部分组成，分别是：

*   要更新的表；
*   列名和它们的新值；
*   确定要更新哪些行的过滤条件。

举一个简单例子。客户`1000000005`现在有了电子邮件地址，因此他的记录需要更新，语句如下：

**输入▼**

```
UPDATE Customers
SET cust_email = 'kim@thetoystore.com'
WHERE cust_id = '1000000005';

```

`UPDATE`语句总是以要更新的表名开始。在这个例子中，要更新的表名为`Customers`。`SET`命令用来将新值赋给被更新的列。在这里，`SET`子句设置`cust_email`列为指定的值：

```
SET cust_email = 'kim@thetoystore.com'

```

`UPDATE`语句以`WHERE`子句结束，它告诉DBMS更新哪一行。没有`WHERE`子句，DBMS将会用这个电子邮件地址更新`Customers`表中的所有行，这不是我们希望的。

更新多个列的语法稍有不同：

**输入▼**

```
UPDATE Customers
SET cust_contact = 'Sam Roberts',
    cust_email = 'sam@toyland.com'
WHERE cust_id = '1000000006';

```

在更新多个列时，只需要使用一条`SET`命令，每个“列=值”对之间用逗号分隔（最后一列之后不用逗号）。在此例子中，更新顾客`1000000006`的`cust_contact`和`cust_email`列。

> **提示：在`UPDATE`语句中使用子查询**
> `UPDATE`语句中可以使用子查询，使得能用`SELECT`语句检索出的数据更新列数据。关于子查询及使用的更多内容，请参阅第11课。

> **提示：`FROM`关键字**
> 有的SQL实现支持在`UPDATE`语句中使用`FROM`子句，用一个表的数据更新另一个表的行。如想知道你的DBMS是否支持这个特性，请参阅它的文档。

要删除某个列的值，可设置它为`NULL`（假如表定义允许`NULL`值）。如下进行：

**输入▼**

```
UPDATE Customers
SET cust_email = NULL
WHERE cust_id = '1000000005';

```

其中`NULL`用来去除`cust_email`列中的值。这与保存空字符串很不同（空字符串用`''`表示，是一个值），而`NULL`表示没有值。[qu++05：空字符串 与 NULL 的区别是什么？](https://github.com/lpd743663/SQL-test/issues/10)

## 16.2 删除数据

从一个表中删除（去掉）数据，使用`DELETE`语句。有两种使用`DELETE`的方式：

*   从表中删除特定的行；
*   从表中删除所有行。

下面分别介绍。

> **警告：不要省略`WHERE`子句**
> 在使用`DELETE`时一定要细心。因为稍不注意，就会错误地删除表中所有行。在使用这条语句前，请完整地阅读本节。

> **提示：`DELETE`与安全**
> 在客户端/服务器的DBMS中，使用`DELETE`语句可能需要特殊的安全权限。在你使用`DELETE`前，应该保证自己有足够的安全权限。

前面说过，`UPDATE`非常容易使用，而`DELETE`更容易使用。

下面的语句从`Customers`表中删除一行：

**输入▼**

```
DELETE FROM Customers
WHERE cust_id = '1000000006';

```

这条语句很容易理解。`DELETE FROM`要求指定从中删除数据的表名，`WHERE`子句过滤要删除的行。在这个例子中，只删除顾客`1000000006`。如果省略`WHERE`子句，它将删除表中每个顾客。

> **提示：友好的外键**
> 第12课介绍了联结，简单联结两个表只需要这两个表中的常用字段。也可以让DBMS通过使用外键来严格实施关系（这些定义在附录A中）。存在外键时，DBMS使用它们实施引用完整性。例如要向`Products`表中插入一个新产品，DBMS不允许通过未知的供应商id插入它，因为`vend_id`列是作为外键连接到`Vendors`表的。那么，这与`DELETE`有什么关系呢？使用外键确保引用完整性的一个好处是，DBMS通常可以防止删除某个关系需要用到的行。例如，要从`Products`表中删除一个产品，而这个产品用在`OrderItems`的已有订单中，那么`DELETE`语句将抛出错误并中止。这是总要定义外键的另一个理由。

> **提示：`FROM`关键字**
> 在某些SQL实现中，跟在`DELETE`后的关键字`FROM`是可选的。但是即使不需要，也最好提供这个关键字。这样做将保证SQL代码在DBMS之间可移植。

mk++05：`DELETE`不需要列名或通配符。`DELETE`删除整行而不是删除列。要删除指定的列，请使用`UPDATE`语句。

> **说明：删除表的内容而不是表**
> `DELETE`语句从表中删除行，甚至是删除表中所有行。但是，`DELETE`不删除表本身。

> **提示：更快的删除**
> 如果想从表中删除所有行，不要使用`DELETE`。可使用`TRUNCATE TABLE`语句，它完成相同的工作，而速度更快（因为不记录数据的变动）。

## 16.3 更新和删除的指导原则

前一节使用的`UPDATE`和`DELETE`语句都有`WHERE`子句，这样做的理由很充分。如果省略了`WHERE`子句，则`UPDATE`或`DELETE`将被应用到表中所有的行。换句话说，如果执行`UPDATE`而不带`WHERE`子句，则表中每一行都将用新值更新。类似地，如果执行`DELETE`语句而不带`WHERE`子句，表的所有数据都将被删除。

下面是许多SQL程序员使用`UPDATE`或`DELETE`时所遵循的重要原则。

*   除非确实打算更新和删除每一行，否则绝对不要使用不带`WHERE`子句的`UPDATE`或`DELETE`语句。
*   保证每个表都有主键（如果忘记这个内容，请参阅第12课），尽可能像`WHERE`子句那样使用它（可以指定各主键、多个值或值的范围）。
*   在`UPDATE`或`DELETE`语句使用`WHERE`子句前，应该先用`SELECT`进行测试，保证它过滤的是正确的记录，以防编写的`WHERE`子句不正确。
*   使用强制实施引用完整性的数据库（关于这个内容，请参阅第12课），这样DBMS将不允许删除其数据与其他表相关联的行。
*   有的DBMS允许数据库管理员施加约束，防止执行不带`WHERE`子句的`UPDATE`或`DELETE`语句。如果所采用的DBMS支持这个特性，应该使用它。

若是SQL没有撤销（undo）按钮，应该非常小心地使用`UPDATE`和`DELETE`，否则你会发现自己更新或删除了错误的数据。

## 16.4 小结

这一课讲述了如何使用`UPDATE`和`DELETE`语句处理表中的数据。我们学习了这些语句的语法，知道了它们可能存在的危险，了解了为什么`WHERE`子句对`UPDATE`和`DELETE`语句很重要，还学习了为保证数据安全而应该遵循的一些指导原则。

# 第17课 创建和操纵表

这一课讲授创建、更改和删除表的基本知识。

## 17.1 创建表

SQL不仅用于表数据操纵，还用来执行数据库和表的所有操作，包括表本身的创建和处理。

一般有两种创建表的方法：

*   多数DBMS都具有交互式创建和管理数据库表的工具；
*   表也可以直接用SQL语句操纵。

用程序创建表，可以使用SQL的`CREATE TABLE`语句。需要注意的是，使用交互式工具时实际上就是使用SQL语句。这些语句不是用户编写的，界面工具会自动生成并执行相应的SQL语句（更改已有的表时也是这样）。

> **警告：语法差别**
> 在不同的SQL实现中，`CREATE TABLE`语句的语法可能有所不同。对于具体的DBMS支持何种语法，请参阅相应的文档。

这一课不会介绍创建表时可以使用的所有选项，那超出了本课的范围，我只给出一些基本选项。详细的信息说明，请参阅具体的DBMS文档。

> **说明：DBMS创建表的具体例子**
> 关于DBMS的`CREATE TABLE`语句的具体例子，请参阅附录A中给出的样例表创建脚本。

### 17.1.1 表创建基础

利用`CREATE TABLE`创建表，必须给出下列信息：

*   新表的名字，在关键字`CREATE TABLE`之后给出；
*   表列的名字和定义，用逗号分隔；
*   有的DBMS还要求指定表的位置。

下面的SQL语句创建本书中所用的`Products`表：

**输入▼**

```
CREATE TABLE Products
(
    prod_id       CHAR(10)          NOT NULL,
    vend_id       CHAR(10)          NOT NULL,
    prod_name     CHAR(254)         NOT NULL,
    prod_price    DECIMAL(8,2)      NOT NULL,
    prod_desc     VARCHAR(1000)     NULL
);

```

**分析▼**
从上面的例子可以看到，表名紧跟`CREATE TABLE`关键字。实际的表定义（所有列）括在圆括号之中，各列之间用逗号分隔。这个表由5列组成。每列的定义以列名（它在表中必须是唯一的）开始，后跟列的数据类型（关于数据类型的解释，请参阅第1课。此外，附录D列出了常见的数据类型及兼容性）。整条语句以圆括号后的分号结束。

前面提到，不同DBMS的`CREATE TABLE`的语法有所不同，这个简单脚本也说明了这一点。这条语句在Oracle、PostgreSQL、SQL Server和SQLite中有效，而对于MySQL，`varchar`必须替换为`text`；对于DB2，必须从最后一列中去掉`NULL`。这就是对于不同的DBMS，要编写不同的表创建脚本的原因（参见附录A）。

> **提示：语句格式化**
> 回想一下在SQL语句中忽略的空格。语句可以在一个长行上输入，也可以分成许多行，它们没有差别。这样，你就可以用最适合自己的方式安排语句的格式。前面的`CREATE TABLE`语句就是SQL语句格式化的一个好例子，代码安排在多个行上，列定义进行了恰当的缩进，更易阅读和编辑。以何种格式安排SQL语句并没有规定，但我强烈推荐采用某种缩进格式。

> **提示：替换现有的表**
> 在创建新的表时，指定的表名必须不存在，否则会出错。防止意外覆盖已有的表，SQL要求首先手工删除该表（请参阅后面的内容），然后再重建它，而不是简单地用创建表语句覆盖它。

### 17.1.2 使用NULL值

第4课提到，`NULL`值就是没有值或缺值。允许`NULL`值的列也允许在插入行时不给出该列的值。不允许`NULL`值的列不接受没有列值的行，换句话说，在插入或更新行时，该列必须有值。

每个表列要么是`NULL`列，要么是`NOT NULL`列，这种状态在创建时由表的定义规定。请看下面的例子：

**输入▼**

```
CREATE TABLE Orders
(
    order_num      INTEGER      NOT NULL,
    order_date     DATETIME     NOT NULL,
    cust_id        CHAR(10)     NOT NULL
);

```

**分析▼** 这条语句创建本书中所用的`Orders`表。`Orders`包含三列：订单号、订单日期和顾客ID。这三列都需要，因此每一列的定义都含有关键字`NOT NULL`。这就会阻止插入没有值的列。如果插入没有值的列，将返回错误，且插入失败。

下一个例子将创建混合了`NULL`和`NOT NULL`列的表：

**输入▼**

```
CREATE TABLE Vendors
(
    vend_id          CHAR(10)     NOT NULL,
    vend_name        CHAR(50)     NOT NULL,
    vend_address     CHAR(50)     ,
    vend_city        CHAR(50)     ,
    vend_state       CHAR(5)      ,
    vend_zip         CHAR(10)     ,
    vend_country     CHAR(50)
);

```

**分析▼**
这条语句创建本书中使用的`Vendors`表。供应商ID和供应商名字列是必需的，因此指定为`NOT NULL`。其余五列全都允许`NULL`值，所以不指定`NOT NULL`。`NULL`为默认设置，如果不指定`NOT NULL`，就认为指定的是`NULL`。

> **警告：指定`NULL`**
> 在不指定`NOT NULL`时，多数DBMS认为指定的是`NULL`，但不是所有的DBMS都这样。DB2要求指定关键字`NULL`，如果不指定将出错。关于完整的语法信息，请参阅具体的DBMS文档。

> **提示：主键和`NULL`值**
> 第1课介绍过，主键是其值唯一标识表中每一行的列。只有不允许`NULL`值的列可作为主键，允许`NULL`值的列不能作为唯一标识。

> **警告：理解`NULL`**
> 不要把`NULL`值与空字符串相混淆。`NULL`值是没有值，不是空字符串。如果指定`''`（两个单引号，其间没有字符），这在`NOT NULL`列中是允许的。空字符串是一个有效的值，它不是无值。`NULL`值用关键字`NULL`而不是空字符串指定。[mk++06](https://github.com/lpd743663/SQL-test/issues/10)=qu++05

### 17.1.3 指定默认值

SQL允许指定默认值，在插入行时如果不给出值，DBMS将自动采用默认值。默认值在`CREATE TABLE`语句的列定义中用关键字`DEFAULT`指定。

请看下面的例子：

**输入▼**

```
CREATE TABLE OrderItems
(
    order_num      INTEGER          NOT NULL,
    order_item     INTEGER          NOT NULL,
    prod_id        CHAR(10)         NOT NULL,
    quantity       INTEGER          NOT NULL      DEFAULT 1,
    item_price     DECIMAL(8,2)     NOT NULL
);

```

**分析▼**
这条语句创建`OrderItems`表，包含构成订单的各项（订单本身存储在`Orders`表中）。`quantity`列为订单中每个物品的数量。在这个例子中，这一列的描述增加了`DEFAULT 1`，指示DBMS，如果不给出数量则使用数量`1`。

默认值经常用于日期或时间戳列。例如，通过指定引用系统日期的函数或变量，将系统日期用作默认日期。MySQL用户指定`DEFAULT CURRENT_DATE()`，Oracle用户指定`DEFAULT SYSDATE`，而SQL Server用户指定`DEFAULT GETDATE()`。遗憾的是，这条获得系统日期的命令在不同的DBMS中几乎都是不同的。表17-1列出了这条命令在某些DBMS中的语法。这里若未列出某个DBMS，请参阅相应的文档。

**表17-1 获得系统日期**

| DBMS | 函数/变量 |
|------|----------|
| Access | NOW() |
| DB2 | CURRENT_DATE |
| MySQL | CURRENT_DATE() |
| Oracle | SYSDATE |
| PostgreSQL | CURRENT_DATE |
| SQL Server | GETDATE() |
| SQLite | date('now') |

> **提示：使用`DEFAULT`而不是`NULL`值**
> 许多数据库开发人员喜欢使用`DEFAULT`值而不是`NULL`列，对于用于计算或数据分组的列更是如此。

## 17.2 更新表

更新表定义，可以使用`ALTER TABLE`语句。虽然所有的DBMS都支持`ALTER TABLE`，但它们所允许更新的内容差别很大。以下是使用`ALTER TABLE`时需要考虑的事情。

*   理想情况下，不要在表中包含数据时对其进行更新。应该在表的设计过程中充分考虑未来可能的需求，避免今后对表的结构做大改动。
*   所有的DBMS都允许给现有的表增加列，不过对所增加列的数据类型（以及`NULL`和`DEFAULT`的使用）有所限制。
*   许多DBMS不允许删除或更改表中的列。
*   多数DBMS允许重新命名表中的列。
*   许多DBMS限制对已经填有数据的列进行更改，对未填有数据的列几乎没有限制。

可以看出，对已有表做更改既复杂又不统一。对表的结构能进行何种更改，请参阅具体的DBMS文档。

使用`ALTER TABLE`更改表结构，必须给出下面的信息：

*   在`ALTER TABLE`之后给出要更改的表名（该表必须存在，否则将出错）；
*   列出要做哪些更改。

因为给已有表增加列可能是所有DBMS都支持的唯一操作，所以我们举个这样的例子：

**输入▼**

```
ALTER TABLE Vendors
ADD vend_phone CHAR(20);

```

**分析▼**
这条语句给`Vendors`表增加一个名为`vend_phone`的列，其数据类型为`CHAR`。

更改或删除列、增加约束或增加键，这些操作也使用类似的语法（注意，下面的例子并非对所有DBMS都有效）：

**输入▼**

```
ALTER TABLE Vendors
DROP COLUMN vend_phone;

```

复杂的表结构更改一般需要手动删除过程，它涉及以下步骤：

1.  用新的列布局创建一个新表；
2.  使用`INSERT SELECT`语句（关于这条语句的详细介绍，请参阅第15课）从旧表复制数据到新表。有必要的话，可以使用转换函数和计算字段；
3.  检验包含所需数据的新表；
4.  重命名旧表（如果确定，可以删除它）；
5.  用旧表原来的名字重命名新表；
6.  根据需要，重新创建触发器、存储过程、索引和外键。

> **说明：`ALTER TABLE`和SQLite**
> SQLite对使用`ALTER TABLE`执行的操作有所限制。最重要的一个限制是，它不支持使用`ALTER TABLE`定义主键和外键，这些必须在最初创建表时指定。

> **警告：小心使用`ALTER TABLE`**
> 使用`ALTER TABLE`要极为小心，应该在进行改动前做完整的备份（模式和数据的备份）。数据库表的更改不能撤销，如果增加了不需要的列，也许无法删除它们。类似地，如果删除了不应该删除的列，可能会丢失该列中的所有数据。

## 17.3 删除表

删除表（删除整个表而不是其内容）非常简单，使用`DROP TABLE`语句即可：

**输入▼**

```
DROP TABLE CustCopy;

```

**分析▼**
这条语句删除`CustCopy`表（第15课中创建的）。删除表没有确认，也不能撤销，执行这条语句将永久删除该表。

> **提示：使用关系规则防止意外删除**
> 许多DBMS允许强制实施有关规则，防止删除与其他表相关联的表。在实施这些规则时，如果对某个表发布一条`DROP TABLE`语句，且该表是某个关系的组成部分，则DBMS将阻止这条语句执行，直到该关系被删除为止。如果允许，应该启用这些选项，它能防止意外删除有用的表。

## 17.4 重命名表

每个DBMS对表重命名的支持有所不同。对于这个操作，不存在严格的标准。DB2、MariaDB、MySQL、Oracle和PostgreSQL用户使用`RENAME`语句，SQL Server用户使用`sp_rename`存储过程，SQLite用户使用`ALTER TABLE`语句。

所有重命名操作的基本语法都要求指定旧表名和新表名。不过，存在DBMS实现差异。关于具体的语法，请参阅相应的DBMS文档。

## 17.5 小结

这一课介绍了几条新的SQL语句。`CREATE TABLE`用来创建新表，`ALTER TABLE`用来更改表列（或其他诸如约束或索引等对象），而`DROP TABLE`用来完整地删除一个表。这些语句必须小心使用，并且应该在备份后使用。由于这些语句的语法在不同的DBMS中有所不同，所以更详细的信息请参阅相应的DBMS文档。




笔记记录




13.2.1

--找出Jim Jones工作的公司，然后找出在该公司工作的顾客

SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM Customers AS c1, Customers AS c2
WHERE c1.cust_name = c2.cust_name
AND c2.cust_contact = 'Jim Jones'
ORDER BY cust_contact

/*
居然还有这种操作，自连接，可以看作有2个一摸一样的表，2个表之间进行连接

第一种理解：
c2限制条件，只选择 cust_contact = 'Jim Jones' 的行，其对应的 cust_name 为 Fun4All
c1 c2 通过 cust_name 列进行连接， 同时cust_name  为 Fun4All


MK--02自连接是最难理解的，书本放到最前面来讲，感觉其他的左右之类的不是很难
第二种理解
c1  c2 全部连接  返回笛卡儿积
在其中筛选符合相关条件的行

原文解释：
WHERE首先联结两个表，然后按第二个表中的cust_contact过滤数据，返回所需的数据。
*/
SELECT c1. *
FROM FROM Customers AS c1, Customers AS c2
WHERE c2.cust_contact = 'Jim Jones'
AND


SELECT C.*, O.order_num, O.order_date,
       OI.prod_id, OI.quantity, OI.item_price
FROM Customers AS C, Orders AS O, OrderItems AS OI
WHERE C.cust_id = O.cust_id
 AND OI.order_num = O.order_num
 AND prod_id = 'RGAN01';





/*
QU--07最大的问题：13.2.3外联结，如下要求，我没有意识到要从哪几个表中来获取数据！！！
从哪些表可以获取以下数据？下面的题目是3个表，还是1个表？  3个表！

对每个顾客下的订单进行计数，包括那些至今尚未下订单的顾客；
列出所有产品以及订购数量，包括没有人订购的产品；
计算平均销售规模，包括那些至今尚未下订单的顾客。
*/

--要检索所有顾客及每个顾客所下的订单数

SELECT cust_name, cust_contact, COUNT(Orders.cust_id)
FROM Customers LEFT JOIN Orders
ON Customers.cust_id = Orders.cust_id
/*
提示：选择列表中的列 'cust_name' 无效，因为该列没有包含在聚合函数(指count)或 GROUP BY 子句中。

说明：select 出来的字段名，必须被count 或者group by 函数所使用
group by 一次只能出现一个？
所以，select 后面只能跟随一个字段，再 count 一个字段？

这又是错误的语句，更大的问题在于，不清楚题目到底是要什么数据。
书籍有问题，提出问题，不是马上解决，而是又讲解基础
*/

SELECT cust_name, COUNT(Orders.cust_id)
FROM Customers LEFT JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP BY cust_name

SELECT Customers.cust_id, COUNT(Orders.cust_id)
FROM Customers LEFT JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id
/*
以上2个句子，使用 Customers.cust_id 和 cust_name 所得到的结果不一样
其中  cust_name 指公司名，同一个公司有2个采购员，那么使用 不重复的cust_contact 的结果应该与cust_id 一致
*/

SELECT cust_contact, COUNT(Orders.cust_id)
FROM Customers LEFT JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP BY cust_contact

--MK--03重点：我们如何决定使用什么字段？使用cust_id 可以与外界再进行关联！！！

SELECT Customers.cust_id,
       COUNT(Orders.order_num) AS num_ord
FROM Customers INNER JOIN Orders
 ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;


--它检索所有顾客及其订单：

--包含未下单客户的
SELECT Customers.cust_id, order_num
FROM Customers LEFT JOIN Orders
ON Customers.cust_id = Orders.cust_id

--忽略未下单客户的
SELECT Customers.cust_id, order_num
FROM Customers INNER JOIN Orders
ON Customers.cust_id = Orders.cust_id

--等价于
SELECT Customers.cust_id, order_num
FROM Customers, Orders
WHERE Customers.cust_id = Orders.cust_id


--右连接--有时候左右连接的是结果是一样的，那么是什么样的数据才会产生相同的结果？
SELECT Customers.cust_id, Orders.order_num
FROM Customers RIGHT OUTER JOIN Orders
ON Orders.cust_id = Customers.cust_id;

--全连接,这个数据代表什么？我们什么时候使用 全连接、自连接、左右连接

SELECT Customers.cust_id, Orders.order_num
FROM Orders FULL OUTER JOIN Customers
ON Orders.cust_id = Customers.cust_id;


/*
需要Illinois、Indiana和Michigan等美国几个州的所有（的）顾客的报表，
还想包括不管位于哪个州的所有的Fun4All。
*/

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION ALL
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
OR cust_name = 'Fun4All';
