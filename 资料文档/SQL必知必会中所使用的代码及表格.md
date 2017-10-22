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


# Customers

 cust_id唯一的顾客ID   |   cust_name顾客名   |     cust_address顾客的地址     | cust_city顾客所在城市 | cust_state顾客所在州 | cust_zip顾客地址邮政编码 | cust_country顾客所在国家 |    cust_contact顾客的联系名    |      cust_email顾客的电子邮件地址
:--------: | :-----------: | :------------------: | :-------: | :--------: | :------: | :----------: | :----------------: | :-------------------:
1000000001 | Village Toys  |    200 Maple Lane    |  Detroit  |     MI     |  44444   |     USA      |     John Smith     | sales@villagetoys.com
1000000002 |  Kids Place   | 333 South Lake Drive | Columbus  |     OH     |  43333   |     USA      |   Michelle Green   |         NULL
1000000003 |    Fun4All    |    1 Sunny Place     |  Muncie   |     IN     |  42222   |     USA      |     Jim Jones      |  jjones@fun4all.com
1000000004 |    Fun4All    | 829 Riverside Drive  |  Phoenix  |     AZ     |  88888   |     USA      | Denise L. Stephens | dstephens@fun4all.com
1000000005 | The Toy Store |   4545 53rd Street   |  Chicago  |     IL     |  54545   |     USA      |     Kim Howard     |         NULL


# Vendors

vend_id唯一的供应商ID |    vend_name供应商名    |  vend_address供应商的地址   | vend_city供应商所在城市  | vend_state供应商所在州 | vend_zip供应商地址邮政编码 | vend_country供应商所在国家
:-----: | :-------------: | :-------------: | :--------: | :--------: | :------: | :----------:
 BRE02  |  Bear Emporium  | 500 Park Street |  Anytown   |     OH     |  44333   |     USA
 BRS01  |   Bears R Us    | 123 Main Street | Bear Town  |     MI     |  44444   |     USA
 DLL01  | Doll House Inc. | 555 High Street | Dollsville |     CA     |  99999   |     USA
 FNG01  |  Fun and Games  | 42 Galaxy Road  |   London   |    NULL    | N16 6PS  |   England
 FRB01  |  Furball Inc.   | 1000 5th Avenue |  New York  |     NY     |  11111   |     USA
 JTS01  | Jouets et ours  | 1 Rue Amusement |   Paris    |    NULL    |  45678   |    France

# Products

prod_id唯一的产品ID | vend_id产品供应商ID |      prod_name产品名      | prod_price产品价格 | prod_desc产品描述
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

# OrderItems 存储每个订单中的实际物品，一个订单中会有多个物品

order_num订单号 | order_item订单物品号（订单内的顺序） | prod_id产品ID | quantity物品数量 | item_price物品价格
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

order_num唯一的订单号 |     order_date订单日期     |  cust_id订单顾客ID
:-------: | :----------------: | :--------:
  20005   | 2012/05/01 0:00:00 | 1000000001
  20006   | 2012/01/12 0:00:00 | 1000000003
  20007   | 2012/01/30 0:00:00 | 1000000004
  20008   | 2012/02/03 0:00:00 | 1000000005
  20009   | 2012/02/08 0:00:00 | 1000000001
