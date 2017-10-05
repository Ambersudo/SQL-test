# 左连接、右连接等各种JOIN


因工作需要，自己啃SQL，第一个遇到疑难点的就是各种 JOIN

选课表为演示进行理解

表student

  xnum   | xname | xcode
:------: | :---: | :---:
20171001 |  张三   |   A
20171002 |  李四   |   B
20171003 |  王五   |   C
20171005 |  赵六   |   C

表teaching

tnum | tname | tstu |   xnum
:--: | :---: | :--: | :------:
1001 |  鲁迅   |  张三  | 20171001
1001 |  鲁迅   |  李四  | 20171002
1002 |  季羡林  |  张三  | 20171001
1003 |  秦始皇  |  王五  | 20171003
1005 | 爱因斯坦  |  孙七  | 20171009



CREATE TABLE student
(
  snum varchar(20),
  sname varchar(20),
  scode varchar(20),
)


CREATE TABLE teaching
(
  tunm varchar(20),
  tname varchar(20),
  tstu varchar(20),
  snum varchar(20),
)



EXEC sp_rename 'student.xunm' , 'student.snum', 'column'

INSERT INTO student( snum, sname, scode )
VALUES ('20171001', '张三', 'A' );
INSERT INTO student( snum, sname, scode )
VALUES ('20171002', '李四', 'B' );
INSERT INTO student( snum, sname, scode )
VALUES ('20171003', '王五', 'C' );
INSERT INTO student( snum, sname, scode )
VALUES ('20171005', '赵六', 'C' );


INSERT INTO teaching( tnum, tname, tstu, snum )
VALUES ('1001', '鲁迅', '张三', '20171001' );
INSERT INTO teaching( tnum, tname, tstu, snum )
VALUES ('1001', '鲁迅', '李四', '20171002' );
INSERT INTO teaching( tnum, tname, tstu, snum )
VALUES ('1002', '季羡林', '张三', '20171001' );
INSERT INTO teaching( tnum, tname, tstu, snum )
VALUES ('1003', '秦始皇', '王五', '20171003' );
INSERT INTO teaching( tnum, tname, tstu, snum )
VALUES ('1005', '爱因斯坦', '孙七', '20171009' );

UPDATE teaching SET tunm = '1005'
WHERE tname = '爱因斯坦'
