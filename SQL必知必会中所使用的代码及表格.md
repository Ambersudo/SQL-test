# 代码

```sql

-----------------------------------------------------------
-- Sams Teach Yourself SQL in 10 Minutes
-- http://forta.com/books/0672336073/
-- Example table creation scripts for Microsoft SQL Server.
-----------------------------------------------------------


-------------------------
-- Create Customers table
-------------------------
CREATE TABLE Customers
(
  cust_id      char(10)  NOT NULL ,
  cust_name    char(50)  NOT NULL ,
  cust_address char(50)  NULL ,
  cust_city    char(50)  NULL ,
  cust_state   char(5)   NULL ,
  cust_zip     char(10)  NULL ,
  cust_country char(50)  NULL ,
  cust_contact char(50)  NULL ,
  cust_email   char(255) NULL
);

--------------------------
-- Create OrderItems table
--------------------------
CREATE TABLE OrderItems
(
  order_num  int          NOT NULL ,
  order_item int          NOT NULL ,
  prod_id    char(10)     NOT NULL ,
  quantity   int          NOT NULL ,
  item_price decimal(8,2) NOT NULL
);

----------------------
-- Create Orders table
----------------------
CREATE TABLE Orders
(
  order_num  int      NOT NULL ,
  order_date datetime NOT NULL ,
  cust_id    char(10) NOT NULL
);

------------------------
-- Create Products table
------------------------
CREATE TABLE Products
(
  prod_id    char(10)      NOT NULL ,
  vend_id    char(10)      NOT NULL ,
  prod_name  char(255)     NOT NULL ,
  prod_price decimal(8,2)  NOT NULL ,
  prod_desc  varchar(1000) NULL
);

-----------------------
-- Create Vendors table
-----------------------
CREATE TABLE Vendors
(
  vend_id      char(10) NOT NULL ,
  vend_name    char(50) NOT NULL ,
  vend_address char(50) NULL ,
  vend_city    char(50) NULL ,
  vend_state   char(5)  NULL ,
  vend_zip     char(10) NULL ,
  vend_country char(50) NULL
);

----------------------
-- Define primary keys
----------------------
ALTER TABLE Customers WITH NOCHECK ADD CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (cust_id);
ALTER TABLE OrderItems WITH NOCHECK ADD CONSTRAINT PK_OrderItems PRIMARY KEY CLUSTERED (order_num, order_item);
ALTER TABLE Orders WITH NOCHECK ADD CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (order_num);
ALTER TABLE Products WITH NOCHECK ADD CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (prod_id);
ALTER TABLE Vendors WITH NOCHECK ADD CONSTRAINT PK_Vendors PRIMARY KEY CLUSTERED (vend_id);

----------------------
-- Define foreign keys
----------------------
ALTER TABLE OrderItems ADD
CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_num) REFERENCES Orders (order_num),
CONSTRAINT FK_OrderItems_Products FOREIGN KEY (prod_id) REFERENCES Products (prod_id);
ALTER TABLE Orders ADD
CONSTRAINT FK_Orders_Customers FOREIGN KEY (cust_id) REFERENCES Customers (cust_id);
ALTER TABLE Products ADD
CONSTRAINT FK_Products_Vendors FOREIGN KEY (vend_id) REFERENCES Vendors (vend_id);


-------------------------------------------------------------
-- Sams Teach Yourself SQL in 10 Minutes
-- http://forta.com/books/0672336073/
-- Example table population scripts for Microsoft SQL Server.
-------------------------------------------------------------


---------------------------
-- Populate Customers table
---------------------------
INSERT INTO Customers(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email)
VALUES('1000000001', 'Village Toys', '200 Maple Lane', 'Detroit', 'MI', '44444', 'USA', 'John Smith', 'sales@villagetoys.com');
INSERT INTO Customers(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact)
VALUES('1000000002', 'Kids Place', '333 South Lake Drive', 'Columbus', 'OH', '43333', 'USA', 'Michelle Green');
INSERT INTO Customers(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email)
VALUES('1000000003', 'Fun4All', '1 Sunny Place', 'Muncie', 'IN', '42222', 'USA', 'Jim Jones', 'jjones@fun4all.com');
INSERT INTO Customers(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email)
VALUES('1000000004', 'Fun4All', '829 Riverside Drive', 'Phoenix', 'AZ', '88888', 'USA', 'Denise L. Stephens', 'dstephens@fun4all.com');
INSERT INTO Customers(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact)
VALUES('1000000005', 'The Toy Store', '4545 53rd Street', 'Chicago', 'IL', '54545', 'USA', 'Kim Howard');

-------------------------
-- Populate Vendors table
-------------------------
INSERT INTO Vendors(vend_id, vend_name, vend_address, vend_city, vend_state, vend_zip, vend_country)
VALUES('BRS01','Bears R Us','123 Main Street','Bear Town','MI','44444', 'USA');
INSERT INTO Vendors(vend_id, vend_name, vend_address, vend_city, vend_state, vend_zip, vend_country)
VALUES('BRE02','Bear Emporium','500 Park Street','Anytown','OH','44333', 'USA');
INSERT INTO Vendors(vend_id, vend_name, vend_address, vend_city, vend_state, vend_zip, vend_country)
VALUES('DLL01','Doll House Inc.','555 High Street','Dollsville','CA','99999', 'USA');
INSERT INTO Vendors(vend_id, vend_name, vend_address, vend_city, vend_state, vend_zip, vend_country)
VALUES('FRB01','Furball Inc.','1000 5th Avenue','New York','NY','11111', 'USA');
INSERT INTO Vendors(vend_id, vend_name, vend_address, vend_city, vend_state, vend_zip, vend_country)
VALUES('FNG01','Fun and Games','42 Galaxy Road','London', NULL,'N16 6PS', 'England');
INSERT INTO Vendors(vend_id, vend_name, vend_address, vend_city, vend_state, vend_zip, vend_country)
VALUES('JTS01','Jouets et ours','1 Rue Amusement','Paris', NULL,'45678', 'France');

--------------------------
-- Populate Products table
--------------------------
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('BR01', 'BRS01', '8 inch teddy bear', 5.99, '8 inch teddy bear, comes with cap and jacket');
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('BR02', 'BRS01', '12 inch teddy bear', 8.99, '12 inch teddy bear, comes with cap and jacket');
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('BR03', 'BRS01', '18 inch teddy bear', 11.99, '18 inch teddy bear, comes with cap and jacket');
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('BNBG01', 'DLL01', 'Fish bean bag toy', 3.49, 'Fish bean bag toy, complete with bean bag worms with which to feed it');
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('BNBG02', 'DLL01', 'Bird bean bag toy', 3.49, 'Bird bean bag toy, eggs are not included');
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('BNBG03', 'DLL01', 'Rabbit bean bag toy', 3.49, 'Rabbit bean bag toy, comes with bean bag carrots');
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('RGAN01', 'DLL01', 'Raggedy Ann', 4.99, '18 inch Raggedy Ann doll');
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('RYL01', 'FNG01', 'King doll', 9.49, '12 inch king doll with royal garments and crown');
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES('RYL02', 'FNG01', 'Queen doll', 9.49, '12 inch queen doll with royal garments and crown');

------------------------
-- Populate Orders table
------------------------
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(20005, '2012-05-01', '1000000001');
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(20006, '2012-01-12', '1000000003');
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(20007, '2012-01-30', '1000000004');
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(20008, '2012-02-03', '1000000005');
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(20009, '2012-02-08', '1000000001');

----------------------------
-- Populate OrderItems table
----------------------------
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20005, 1, 'BR01', 100, 5.49);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20005, 2, 'BR03', 100, 10.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20006, 1, 'BR01', 20, 5.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20006, 2, 'BR02', 10, 8.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20006, 3, 'BR03', 10, 11.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20007, 1, 'BR03', 50, 11.49);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20007, 2, 'BNBG01', 100, 2.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20007, 3, 'BNBG02', 100, 2.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20007, 4, 'BNBG03', 100, 2.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20007, 5, 'RGAN01', 50, 4.49);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20008, 1, 'RGAN01', 5, 4.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20008, 2, 'BR03', 5, 11.99);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20008, 3, 'BNBG01', 10, 3.49);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20008, 4, 'BNBG02', 10, 3.49);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20008, 5, 'BNBG03', 10, 3.49);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20009, 1, 'BNBG01', 250, 2.49);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20009, 2, 'BNBG02', 250, 2.49);
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20009, 3, 'BNBG03', 250, 2.49);
```

## A.1 样例表

本书中所用的表是一个假想玩具经销商使用的订单录入系统的组成部分。这些表用来完成以下几项任务：

- 管理供应商；
- 管理产品目录；
- 管理顾客列表；
- 录入顾客订单。

完成它们需要5个表（它们作为一个关系数据库设计的组成部分紧密关联）。以下各节给出每个表的描述。

> **说明：简化的例子** 这里使用的表不完整，现实世界中的订单录入系统还会记录这里所没有的大量数据（如工资和记账信息、发货追踪信息等）。不过，这些表确实示范了现实世界中你将遇到的各种数据的组织和关系。读者可以将这些技术用于自己的数据库。

### **表的描述**

下面介绍5个表及每个表内的列名。

**1\. `Vendors`表**

`Vendors`表存储销售产品的供应商。每个供应商在这个表中有一个记录，供应商ID列（`vend_id`）用于进行产品与供应商的匹配。

**表A-1 `Vendors`表的列**

 | 列            | 说 明
 | ------------ | ---------
 | vend_id      | 唯一的供应商ID  |
 | vend_name    | 供应商名      |
 | vend_address | 供应商的地址    |
 | vend_city    | 供应商所在城市   |
 | vend_state   | 供应商所在州    |
 | vend_zip     | 供应商地址邮政编码 |
 | vend_country | 供应商所在国家   |

- 所有表都应该有主键。这个表应该用`vend_id`作为其主键。

**2\. `Products`表**

`Products`表包含产品目录，每行一个产品。每个产品有唯一的ID（`prod_id`列），并且借助`vend_id`（供应商的唯一ID）与供应商相关联。

**表A-2 `Products`表的列**

 | 列          | 说 明
 | ---------- | ----------------------------
 | prod_id    | 唯一的产品ID                      |
 | vend_id    | 产品供应商ID（关联到Vendors表的vend_id） |
 | prod_name  | 产品名                          |
 | prod_price | 产品价格                         |
 | prod_desc  | 产品描述                         |

- 所有表都应该有主键。这个表应该用`prod_id`作为其主键。
- 为实施引用完整性，应该在`vend_id`上定义一个外键，关联到`Vendors`的`vend_id`列。

**3\. `Customers`表**

`Customers`表存储所有顾客信息。每个顾客有唯一的ID（`cust_id`列）。

**表A-3 `Customers`表的列**

 | 列            | 说 明
 | ------------ | ---------
 | cust_id      | 唯一的顾客ID   |
 | cust_name    | 顾客名       |
 | cust_address | 顾客的地址     |
 | cust_city    | 顾客所在城市    |
 | cust_state   | 顾客所在州     |
 | cust_zip     | 顾客地址邮政编码  |
 | cust_country | 顾客所在国家    |
 | cust_contact | 顾客的联系名    |
 | cust_email   | 顾客的电子邮件地址 |

- 所有表都应该有主键。这个表应该用`cust_id`作为它的主键。

**4\. `Orders`表**

`Orders`表存储顾客订单（不是订单细节）。每个订单唯一编号（`order_num`列）。`Orders`表按`cust_id`列（关联到`Customers`表的顾客唯一ID）关联到相应的顾客。

**表A-4 `Orders`表的列**

 | 列          | 说 明
 | ---------- | -----------------------------
 | order_num  | 唯一的订单号                        |
 | order_date | 订单日期                          |
 | cust_id    | 订单顾客ID（关联到Customers表的cust_id） |

- 所有表都应该有主键。这个表应该用`order_num`作为其主键。
- 为实施引用完整性，应该在`cust_id`上定义一个外键，关联到`Customers`的`cust_id`列。 - **5\. `OrderItems`表**

`OrderItems`表存储每个订单中的实际物品，每个订单的每个物品一行。对于`Orders`表的每一行，在`OrderItems`表中有一行或多行。每个订单物品由订单号加订单物品（第一个物品、第二个物品等）唯一标识。订单物品用`order_num`列（关联到`Orders`表中订单的唯一ID）与其相应的订单相关联。此外，每个订单物品包含该物品的产品ID（把物品关联到`Products`表）。

**表A-5 `OrderItem`s表的列**

 | 列          | 说 明
 | ---------- | --------------------------
 | order_num  | 订单号（关联到Orders表的order_num）  |
 | order_item | 订单物品号（订单内的顺序）              |
 | prod_id    | 产品ID（关联到Products表的prod_id） |
 | quantity   | 物品数量                       |
 | item_price | 物品价格                       |

- 所有表都应该有主键。这个表应该用`order_num`和`order_item`作为其主键。
- 为实施引用完整性，应该在`order_num`和`prod_id`上定义外键，关联`order_num`到`Orders`的`order_num`列，关联`prod_id`到`Products`的`prod_id`列。

# Customers

 cust_id   |   cust_name   |     cust_address     | cust_city | cust_state | cust_zip | cust_country |    cust_contact    |      cust_email
:--------: | :-----------: | :------------------: | :-------: | :--------: | :------: | :----------: | :----------------: | :-------------------:
1000000001 | Village Toys  |    200 Maple Lane    |  Detroit  |     MI     |  44444   |     USA      |     John Smith     | sales@villagetoys.com
1000000002 |  Kids Place   | 333 South Lake Drive | Columbus  |     OH     |  43333   |     USA      |   Michelle Green   |         NULL
1000000003 |    Fun4All    |    1 Sunny Place     |  Muncie   |     IN     |  42222   |     USA      |     Jim Jones      |  jjones@fun4all.com
1000000004 |    Fun4All    | 829 Riverside Drive  |  Phoenix  |     AZ     |  88888   |     USA      | Denise L. Stephens | dstephens@fun4all.com
1000000005 | The Toy Store |   4545 53rd Street   |  Chicago  |     IL     |  54545   |     USA      |     Kim Howard     |         NULL

# Vendors

vend_id |    vend_name    |  vend_address   | vend_city  | vend_state | vend_zip | vend_country
:-----: | :-------------: | :-------------: | :--------: | :--------: | :------: | :----------:
 BRE02  |  Bear Emporium  | 500 Park Street |  Anytown   |     OH     |  44333   |     USA
 BRS01  |   Bears R Us    | 123 Main Street | Bear Town  |     MI     |  44444   |     USA
 DLL01  | Doll House Inc. | 555 High Street | Dollsville |     CA     |  99999   |     USA
 FNG01  |  Fun and Games  | 42 Galaxy Road  |   London   |    NULL    | N16 6PS  |   England
 FRB01  |  Furball Inc.   | 1000 5th Avenue |  New York  |     NY     |  11111   |     USA
 JTS01  | Jouets et ours  | 1 Rue Amusement |   Paris    |    NULL    |  45678   |    France

# Products

prod_id | vend_id |      prod_name      | prod_price | prod_desc
:-----: | :-----: | :-----------------: | :--------: | ---------------------------------------------------------------------
BNBG01  |  DLL01  |  Fish bean bag toy  |    3.49    | Fish bean bag toy, complete with bean bag worms with which to feed it
BNBG02  |  DLL01  |  Bird bean bag toy  |    3.49    | Bird bean bag toy, eggs are not included
BNBG03  |  DLL01  | Rabbit bean bag toy |    3.49    | Rabbit bean bag toy, comes with bean bag carrots
 BR01   |  BRS01  |  8 inch teddy bear  |    5.99    | 8 inch teddy bear, comes with cap and jacket
 BR02   |  BRS01  | 12 inch teddy bear  |    8.99    | 12 inch teddy bear, comes with cap and jacket
 BR03   |  BRS01  | 18 inch teddy bear  |   11.99    | 18 inch teddy bear, comes with cap and jacket
RGAN01  |  DLL01  |     Raggedy Ann     |    4.99    | 18 inch Raggedy Ann doll
 RYL01  |  FNG01  |      King doll      |    9.49    | 12 inch king doll with royal garments and crown
 RYL02  |  FNG01  |     Queen doll      |    9.49    | 12 inch queen doll with royal garments and crown

# OrderItems

order_num | order_item | prod_id | quantity | item_price
:-------: | :--------: | :-----: | :------: | :--------:
  20005   |     1      |  BR01   |   100    |    5.49
  20005   |     2      |  BR03   |   100    |   10.99
  20006   |     1      |  BR01   |    20    |    5.99
  20006   |     2      |  BR02   |    10    |    8.99
  20006   |     3      |  BR03   |    10    |   11.99
  20007   |     1      |  BR03   |    50    |   11.49
  20007   |     2      | BNBG01  |   100    |    2.99
  20007   |     3      | BNBG02  |   100    |    2.99
  20007   |     4      | BNBG03  |   100    |    2.99
  20007   |     5      | RGAN01  |    50    |    4.49
  20008   |     1      | RGAN01  |    5     |    4.99
  20008   |     2      |  BR03   |    5     |   11.99
  20008   |     3      | BNBG01  |    10    |    3.49
  20008   |     4      | BNBG02  |    10    |    3.49
  20008   |     5      | BNBG03  |    10    |    3.49
  20009   |     1      | BNBG01  |   250    |    2.49
  20009   |     2      | BNBG02  |   250    |    2.49
  20009   |     3      | BNBG03  |   250    |    2.49

# Orders

order_num |     order_date     |  cust_id
:-------: | :----------------: | :--------:
  20005   | 2012/05/01 0:00:00 | 1000000001
  20006   | 2012/01/12 0:00:00 | 1000000003
  20007   | 2012/01/30 0:00:00 | 1000000004
  20008   | 2012/02/03 0:00:00 | 1000000005
  20009   | 2012/02/08 0:00:00 | 1000000001
