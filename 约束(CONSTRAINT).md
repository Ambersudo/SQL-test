# 约束(CONSTRAINT)

## 转载信息
```
原文链接：http://blog.csdn.net/leshami/article/details/5711367
```

- [约束(CONSTRAINT)](#%E7%BA%A6%E6%9D%9Fconstraint)
    - [转载信息](#%E8%BD%AC%E8%BD%BD%E4%BF%A1%E6%81%AF)
    - [一、几类数据完整性](#%E4%B8%80%E3%80%81%E5%87%A0%E7%B1%BB%E6%95%B0%E6%8D%AE%E5%AE%8C%E6%95%B4%E6%80%A7)
    - [二、约束](#%E4%BA%8C%E3%80%81%E7%BA%A6%E6%9D%9F)
    - [三、建表时约束定义](#%E4%B8%89%E3%80%81%E5%BB%BA%E8%A1%A8%E6%97%B6%E7%BA%A6%E6%9D%9F%E5%AE%9A%E4%B9%89)
        - [1. 定义各种不同的约束](#1-%E5%AE%9A%E4%B9%89%E5%90%84%E7%A7%8D%E4%B8%8D%E5%90%8C%E7%9A%84%E7%BA%A6%E6%9D%9F)
        - [2. 查看约束的定义信息](#2-%E6%9F%A5%E7%9C%8B%E7%BA%A6%E6%9D%9F%E7%9A%84%E5%AE%9A%E4%B9%89%E4%BF%A1%E6%81%AF)
        - [3. 定义符合主键约束](#3-%E5%AE%9A%E4%B9%89%E7%AC%A6%E5%90%88%E4%B8%BB%E9%94%AE%E7%BA%A6%E6%9D%9F)
        - [4. 几种不同约束的冲突提示](#4-%E5%87%A0%E7%A7%8D%E4%B8%8D%E5%90%8C%E7%BA%A6%E6%9D%9F%E7%9A%84%E5%86%B2%E7%AA%81%E6%8F%90%E7%A4%BA)
            - [a. 主键约束提示](#a-%E4%B8%BB%E9%94%AE%E7%BA%A6%E6%9D%9F%E6%8F%90%E7%A4%BA)
            - [b. 非空约束提示](#b-%E9%9D%9E%E7%A9%BA%E7%BA%A6%E6%9D%9F%E6%8F%90%E7%A4%BA)
            - [c. 唯一约束提示](#c-%E5%94%AF%E4%B8%80%E7%BA%A6%E6%9D%9F%E6%8F%90%E7%A4%BA)
            - [d. CHECK约束提示](#d-check%E7%BA%A6%E6%9D%9F%E6%8F%90%E7%A4%BA)
            - [e. 外键约束提示](#e-%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F%E6%8F%90%E7%A4%BA)
        - [5. 补充](#5-%E8%A1%A5%E5%85%85)
            - [a. CHECK 约束](#a-check-%E7%BA%A6%E6%9D%9F)
            - [b. FOREIGN KEY 约束](#b-foreign-key-%E7%BA%A6%E6%9D%9F)
            - [c. 外键约束对delete语句的影响](#c-%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F%E5%AF%B9delete%E8%AF%AD%E5%8F%A5%E7%9A%84%E5%BD%B1%E5%93%8D)
            - [d. 外键约束对 insert 语句的影响](#d-%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F%E5%AF%B9-insert-%E8%AF%AD%E5%8F%A5%E7%9A%84%E5%BD%B1%E5%93%8D)
            - [e. 外键约束对 delete 语句的影响](#e-%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F%E5%AF%B9-delete-%E8%AF%AD%E5%8F%A5%E7%9A%84%E5%BD%B1%E5%93%8D)
            - [f. 外键约束对 update 语句的影响](#f-%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F%E5%AF%B9-update-%E8%AF%AD%E5%8F%A5%E7%9A%84%E5%BD%B1%E5%93%8D)
            - [g. 外键约束对 DDL 语句的影响](#g-%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F%E5%AF%B9-ddl-%E8%AF%AD%E5%8F%A5%E7%9A%84%E5%BD%B1%E5%93%8D)
            - [h. ON DELETE SET NULL 和　ON DELETE CASCADE 对外键约束的影响](#h-on-delete-set-null-%E5%92%8C-on-delete-cascade-%E5%AF%B9%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F%E7%9A%84%E5%BD%B1%E5%93%8D)
            - [i. 为从表删除约束后新增带 on delete set null 的外键约束](#i-%E4%B8%BA%E4%BB%8E%E8%A1%A8%E5%88%A0%E9%99%A4%E7%BA%A6%E6%9D%9F%E5%90%8E%E6%96%B0%E5%A2%9E%E5%B8%A6-on-delete-set-null-%E7%9A%84%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F)
    - [四、建表后的约束定义](#%E5%9B%9B%E3%80%81%E5%BB%BA%E8%A1%A8%E5%90%8E%E7%9A%84%E7%BA%A6%E6%9D%9F%E5%AE%9A%E4%B9%89)
        - [1. 添加主键约束](#1-%E6%B7%BB%E5%8A%A0%E4%B8%BB%E9%94%AE%E7%BA%A6%E6%9D%9F)
        - [2. 添加非空约束](#2-%E6%B7%BB%E5%8A%A0%E9%9D%9E%E7%A9%BA%E7%BA%A6%E6%9D%9F)
        - [3. 添加唯一约束](#3-%E6%B7%BB%E5%8A%A0%E5%94%AF%E4%B8%80%E7%BA%A6%E6%9D%9F)
        - [4. 添加CHECK约束](#4-%E6%B7%BB%E5%8A%A0check%E7%BA%A6%E6%9D%9F)
        - [5. 添加外键约束](#5-%E6%B7%BB%E5%8A%A0%E5%A4%96%E9%94%AE%E7%BA%A6%E6%9D%9F)
        - [6. 禁用约束](#6-%E7%A6%81%E7%94%A8%E7%BA%A6%E6%9D%9F)
        - [7. 启用约束](#7-%E5%90%AF%E7%94%A8%E7%BA%A6%E6%9D%9F)
        - [8. 删除约束](#8-%E5%88%A0%E9%99%A4%E7%BA%A6%E6%9D%9F)
        - [9. 级联约束](#9-%E7%BA%A7%E8%81%94%E7%BA%A6%E6%9D%9F)
        - [10. 延迟约束](#10-%E5%BB%B6%E8%BF%9F%E7%BA%A6%E6%9D%9F)


## 一、几类数据完整性

- 实体完整性：表中记录不重复(任何两条记录不全等)并且每条记录都有一个非空主键

- 域完整性：表中字段值必须与字段数据类型、格式、有效范围相吻合

- 参照完整性：不能引用不存在的值

- 自定义完整性：根据特定业务领域定义的需求完整性


    **保证数据完整性的几种常用方法**

    - 约束(最常用)
    - 过程
    - 函
    - 触发器


    **数据完整性的具体应用**

    - 实体完整性：primary key、unique、索引(index)
    - 域完整性：check、foreign key、not null、数据类型
    - 参照完整性：foreign key
    - 自定义完整性：根据业务选用相应的约束类型

## 二、约束

约束是表、列级的强制规定、是防止那些无效或有问题的数据输入到表中。当对该表进行DML
操作时，如果操作违反约束条件或规则，ORACLE就会拒绝执行，并给出提示。

约束放置在表中，以下五种约束

    NOT NULL           非空约束C     指定的列不允许为空值
    UNIQUE             唯一约束U     指定的列中没有重复值，或该表中每一个值或者每一组值都将是唯一的
    PRIMARY KEY        主键约束P     唯一的标识出表的每一行,且不允许空值值,一个表只能有一个主键约束
    FOREIGN KEY        外键约束R     一个表中的列引用了其它表中的列，使得存在依赖关系，可以指向引用自身的列
    CHECK              条件约束C     指定该列是否满足某个条件

约束命名规则

    如果不指定约束名Oracle server 自动按照SYS_Cn 的格式指定约束名，也可手动指定，
    推荐的约束命名是：约束类型_表名_列名。

        NN：NOT NULL          非空约束，比如nn_emp_sal
        UK：UNIQUE KEY        唯一约束
        PK：PRIMARY KEY       主键约束
        FK：FOREIGN KEY       外键约束
        CK：CHECK             条件约束

何时创建约束

    建表的同时
    建表之后

可以在表级或列级定义约束

    列级约束：只能引用一个列并且它属于列定义的一部分，可定义成任意类型的完整性约束。
    表级约束：可引用一个或多个列，并且它属于表定义的一部分，可定义除NOT NULL外的其它约束。

可以通过数据字典视图查看约束

    user_constraints
    dba_constraints
    all_constraints
    user_cons_columns   列级上的约束
    dba_cons_columns    列级上的约束


建表时约束定义的基本格式

    字段定义constraint 约束名约否类型（字段名）－－>unique,primary key,check
    字段定义constraint 约否名foreingn key (字段名）references 表名（字段名）--->foreign

## 三、建表时约束定义

### 1. 定义各种不同的约束
```sql
--创建一个用于作外键的表tb_dept
    CREATE TABLE tb_dept
        (
            deptno NUMBER(4) PRIMARY KEY,
            deptname VARCHAR2(20),
            loc VARCHAR(50)
        );

--建表时创建约束，没有指定约束名，则系统将自动命名约束名
    CREATE TABLE tb_constraint_1
        (
            empno NUMBER PRIMARY KEY,                    --主键约束
            ename VARCHAR2(20) NOT NULL,                 --非空约束
            email VARCHAR2(60) UNIQUE,                   --唯一约束
            sal   NUMBER(5) CHECK(sal>1500),             --核查约束
            deptno NUMBER(4) REFERENCES tb_dept(deptno)  --外键约束
        );

--建表时指定了约束名
    CREATE TABLE tb_constraint_2
        (
            empno NUMBER CONSTRAINT pk_tb_cons2_empno PRIMARY KEY,
            ename VARCHAR2(20) CONSTRAINT nn_tb_cons2_empno NOT NULL,
            email VARCHAR2(60) CONSTRAINT un_tb_cons2_email UNIQUE,
            sal   NUMBER(5) CONSTRAINT ck_tb_cons2_sal CHECK(sal>1500),
            deptno NUMBER(4) CONSTRAINT fk_tb_cons2_dept REFERENCES tb_dept(deptno)
        );
```

### 2. 查看约束的定义信息
```sql
--查看表的约束
    SELECT owner,constraint_name,constraint_type,table_name,status,deferrable,validated
        FROM user_constraints
        ORDER BY table_name;
```

    OWNER          CONSTRAINT_NAME      C TABLE_NAME          STATUS    DEFERRABLE       VALIDATED
    ------------- -------------------   --------------------  --------  --------------   ---------
    ROBINSON        SYS_C005543          C TB_CONSTRAINT_1    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        SYS_C005545          P TB_CONSTRAINT_1    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        SYS_C005546          U TB_CONSTRAINT_1    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        SYS_C005544          C TB_CONSTRAINT_1    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        SYS_C005547          R TB_CONSTRAINT_1    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        UN_TB_CONS2_EMAIL    U TB_CONSTRAINT_2    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        PK_TB_CONS2_EMPNO    P TB_CONSTRAINT_2    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        NN_TB_CONS2_EMPNO    C TB_CONSTRAINT_2    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        CK_TB_CONS2_SAL      C TB_CONSTRAINT_2    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        FK_TB_CONS2_DEPT     R TB_CONSTRAINT_2    ENABLED   NOT DEFERRABLE   VALIDATED
    ROBINSON        SYS_C005542          P TB_DEPT            ENABLED   NOT DEFERRABLE   VALIDATED

```sql
--查看列的约束
    SELECT * FROM user_cons_columns;
```

    OWNER           CONSTRAINT_NAME           TABLE_NAME                COLUMN_NAME       POSITION
    --------------- ----------------------    --------------------      -----------       ----------
    ROBINSON        FK_TB_CONS2_DEPT          TB_CONSTRAINT_2           DEPTNO                1
    ROBINSON        CK_TB_CONS2_SAL           TB_CONSTRAINT_2           SAL
    ROBINSON        UN_TB_CONS2_EMAIL         TB_CONSTRAINT_2           EMAIL                 1
    ROBINSON        NN_TB_CONS2_EMPNO         TB_CONSTRAINT_2           ENAME
    ROBINSON        PK_TB_CONS2_EMPNO         TB_CONSTRAINT_2           EMPNO                 1
    ROBINSON        SYS_C005542               TB_DEPT                   DEPTNO                1
    ROBINSON        SYS_C005547               TB_CONSTRAINT_1           DEPTNO                1
    ROBINSON        SYS_C005544               TB_CONSTRAINT_1           SAL
    ROBINSON        SYS_C005546               TB_CONSTRAINT_1           EMAIL                 1
    ROBINSON        SYS_C005543               TB_CONSTRAINT_1           ENAME
    ROBINSON        SYS_C005545               TB_CONSTRAINT_1           EMPNO                 1

### 3. 定义符合主键约束
```sql
--定义复合主键
    CREATE TABLE tb_constraint_3
        (
            empno NUMBER,
            ename VARCHAR2(20),
            email VARCHAR2(20) UNIQUE,
            CONSTRAINT pk_tb_cons3_empno_ename PRIMARY KEY(empno,ename)
        );
```

```sql
--查询TB_CONSTRAINT_3的约束信息
    SELECT owner,constraint_name,constraint_type,table_name,status,deferrable,validated
        FROM user_constraints
        WHERE table_name = 'TB_CONSTRAINT_3';
```
    OWNER        CONSTRAINT_NAME              C TABLE_NAME          STATUS     DEFERRABLE       VALIDATED
    ------------ -------------------------   --------------------   --------   --------------   ----------
    ROBINSON     PK_TB_CONS3_EMPNO_ENAME      P TB_CONSTRAINT_3     ENABLED    NOT DEFERRABLE   VALIDATED
    ROBINSON     SYS_C005554                  U TB_CONSTRAINT_3     ENABLED    NOT DEFERRABLE   VALIDATED

```sql
--两列上具有相同的约束名
    SELECT * FROM user_cons_columns  WHERE table_name = 'TB_CONSTRAINT_3';
```

    OWNER               CONSTRAINT_NAME           TABLE_NAME           COLUMN_NAME       POSITION
    ------------------  ---------------------     -----------------    ------------      ----------
    ROBINSON            SYS_C005554               TB_CONSTRAINT_3      EMAIL                    1
    ROBINSON            PK_TB_CONS3_EMPNO_ENAME   TB_CONSTRAINT_3      ENAME                    2
    ROBINSON            PK_TB_CONS3_EMPNO_ENAME   TB_CONSTRAINT_3      EMPNO                    1


### 4. 几种不同约束的冲突提示
```sql
--创建一个序列用于产生主键
    CREATE SEQUENCE cons_sequence
        INCREMENT BY 1
        START WITH 100
        MAXVALUE 200
        NOCACHE
        NOCYCLE;

--为表tb_dept插入记录
    INSERT INTO tb_dept
        SELECT 10,'Development','ShenZhen' FROM DUAL
        UNION ALL
        SELECT 20,'Customer','ShangHai' FROM DUAL;

    2 rows created.

--为表tb_constraint_2插入记录
    INSERT INTO tb_constraint_2
        VALUES(cons_sequence.nextval,'Robinson','Robinson@hotmail.com',2000,10);

    1 row created.
```

#### a. 主键约束提示
```sql
--下面使用currval值，提示主键冲突，从PK_TB_CONS2_EMPNO即可得知是主键列冲突，这就是自定义约束名的好处
    INSERT INTO tb_constraint_2
    VALUES(cons_sequence.currval,'Jack','Jack@hotmail.com',2200,10);

    INSERT INTO tb_constraint_2
    *
    ERROR at line 1:
    ORA-00001: unique constraint (ROBINSON.PK_TB_CONS2_EMPNO) violated
```

#### b. 非空约束提示
```sql
--注意在Oracle中，空字符串('')被当成空值，下面的错误提示即是，什么原因不清楚
    INSERT INTO tb_constraint_2
    VALUES(cons_sequence.nextval,'','Jack@hotmail.com',2200,10);
    VALUES(cons_sequence.nextval,'','Jack@hotmail.com',2200,10)
                            *
    ERROR at line 2:
    ORA-01400: cannot insert NULL into ("ROBINSON"."TB_CONSTRAINT_2"."ENAME")

--下面这条记录插入的才是ename为空值的插入语句
    INSERT INTO tb_constraint_2
    VALUES(cons_sequence.nextval,NULL,'Jack@hotmail.com',2200,10);
    VALUES(cons_sequence.nextval,NULL,'Jack@hotmail.com',2200,10)
                            *
    ERROR at line 2:
    ORA-01400: cannot insert NULL into ("ROBINSON"."TB_CONSTRAINT_2"."ENAME")


--下面是在SQL server 2005中的演示，不存在上述出现的问题
--理论上空字符串('')并不等于NULL,不知道为什么在Oracle 10g中出现了错误提示
    CREATE TABLE tb_constraint_1
    (
        empno int PRIMARY KEY,                          --主键约束
        ename VARCHAR(20) NOT NULL,                     --非空约束
        email VARCHAR(60) UNIQUE,                       --唯一约束
        sal   int CHECK(sal>1500)                       --核查约束
        -- deptno NUMBER(4) REFERENCES tb_dept(deptno)  --外键约束
    );

    INSERT INTO tb_constraint_1
    SELECT 15,'Andy','Andy@hotmail.com',1800;

    INSERT INTO tb_constraint_1      --ename为''的记录插入成功
    SELECT 16,'','John@hotmail.com',1800;

    SELECT * FROM tb_constraint_1 WHERE ename IS NOT NULL;


    empno   ename    email                   sal
    ------- -------  -------------------     ------
    15      Andy     Andy@hotmail.com        1800
    16               John@hotmail.com        1800

    (2 row(s) affected)

```

#### c. 唯一约束提示
```sql
--ORACLE在唯一键列上自动生成一个唯一索引以实现唯一性
--提示email字段唯一性冲突
    INSERT INTO tb_constraint_2
    VALUES(cons_sequence.nextval,'Jack','Robinson@hotmail.com',2400,20);
    INSERT INTO tb_constraint_2
    *
    ERROR at line 1:
    ORA-00001: unique constraint (ROBINSON.UN_TB_CONS2_EMAIL) violated
```

#### d. CHECK约束提示
```sql
--提示check约束sal字段冲突
    INSERT INTO tb_constraint_2
    VALUES(cons_sequence.nextval,'Henry','Henry@hotmail.com',1350,40);
    INSERT INTO tb_constraint_2
    *
    ERROR at line 1:
    ORA-02290: check constraint (ROBINSON.CK_TB_CONS2_SAL) violated
```

#### e. 外键约束提示
```sql
--提示不符合外键约束
    INSERT INTO tb_constraint_2
    VALUES(cons_sequence.nextval,'Henry','Henry@hotmail.com',1550,40);
    INSERT INTO tb_constraint_2
    *
    ERROR at line 1:
    ORA-02291: integrity constraint (ROBINSON.FK_TB_CONS2_DEPT) violated - parent
    key not found
```

### 5. 补充

#### a. CHECK 约束

定义每一行必须满足的条件，以下的表达式是不允许的

    出现 CURRVAL, NEXTVAL, LEVEL, 和 ROWNUM 伪列
    使用 SYSDATE, UID, USER, 和 USERENV 函数
    在查询中涉及到其它列的值

#### b. FOREIGN KEY 约束
    外键约束是用来维护从表和主表的引用完整性的，所以外键约束要涉及两个表。

    FOREIGN KEY:        在表级指定子表中的列
    REFERENCES:         标示在父表中的列
    ON DELETE CASCADE:  当父表中的列被删除时，子表中相对应的列也被删除
    ON DELETE SET NULL: 子表中相应的列置空

    如果子表在建外键时，该列的数据并不在父表，则无法创建该约束。

#### c. 外键约束对delete语句的影响
    DELETE FROM tb_constraint_2;

    2 rows deleted.

    ROLLBACK;

    Rollback complete.

    --子表tb_constraint_2中有记录存在，故不能删除父表中的相关记录
    DELETE FROM tb_dept;
    DELETE FROM tb_dept
    *
    ERROR at line 1:
    ORA-02292: integrity constraint (ROBINSON.FK_TB_CONS2_DEPT) violated - child record found


#### d. 外键约束对 insert 语句的影响

    插入数据的外键字段值必须在主表中存在，只有从表才有可能违反约束，主表不会。

#### e. 外键约束对 delete 语句的影响

    删除主表数据时，如果从表有对该数据的引用，要先将从表中的数据处理好。主表才有可能违反约束。

#### f. 外键约束对 update 语句的影响

    主从表都有可能违反外键约束，操作一个表必须将另一个表的数据处理好。

#### g. 外键约束对 DDL 语句的影响

    删除主表时，才有可能违约约束。

#### h. ON DELETE SET NULL 和　ON DELETE CASCADE 对外键约束的影响
    ON DELETE SET NULL 子句的作用是，当主表中的一行数据被删除时，ORACLE自动将从表中依赖于
    它的记录外键值改为空。

#### i. 为从表删除约束后新增带 on delete set null 的外键约束
```sql
    ALTER TABLE tb_constraint_2
    DROP CONSTRAINT FK_TB_CONS2_DEPT ;

    ALTER TABLE tb_constraint_2
    ADD CONSTRAINT fk_tb_cons2_deptno
    FOREIGN KEY(deptno) REFERENCES tb_dept(deptno)
    ON DELETE SET NULL;

    SELECT * FROM tb_constraint_2;

    EMPNO     ENAME       EMAIL                    SAL        DEPTNO
    --------- ---------   ----------------------   ------     -------
    113       Robinson    Robinson@hotmail.com     2000       10
    114       Mark        Mark@hotmail.com         3000       20

--删除主表中deptno为的记录
    DELETE FROM tb_dept WHERE deptno = 10 ;

    1 row deleted.

--从表中deptno为的被置为NULL
    SELECT * FROM tb_constraint_2;

    EMPNO    ENAME       EMAIL                   SAL        DEPTNO
    -------- ---------   ---------------------   ------     ----------
    113      Robinson    Robinson@hotmail.com    2000
    114      Mark        Mark@hotmail.com        3000       20


    ON DELETE CASCADE 子句的作用是，当主表中的一行数据被删除时，ORACLE自动将从表中依赖于它的记录外键也删除。

--为从表删除约束后新增带on delete cascade的外键约束
    ALTER TABLE tb_constraint_2
    DROP CONSTRAINT fk_tb_cons2_deptno;

    ALTER TABLE tb_constraint_2
    ADD CONSTRAINT fk_tb_cons2_deptno
    FOREIGN KEY(deptno) REFERENCES tb_dept(deptno)
    ON DELETE CASCADE;

--主表中deptno 为的记录被删除
    DELETE FROM tb_dept WHERE deptno = 20 ;

    1 row deleted.

--从表中deptno 为的记录被删除
    SELECT * FROM tb_constraint_2;

    EMPNO   ENAME      EMAIL                   SAL     DEPTNO
    ------  --------   ---------------------   ------  ----------
    113     Robinson   Robinson@hotmail.com    2000

```

## 四、建表后的约束定义
使用ALTER TABLE 语句:
添加或删除约束, 但是不能修改约束
有效化或无效化约束
添加 NOT NULL 约束要使用 MODIFY 语句

```sql
    DROP TABLE tb_constraint_2;

    Table dropped.

    CREATE TABLE tb_cons2
        (
            empno  NUMBER,
            ename  VARCHAR2(20),
            email  VARCHAR2(60),
            sal    NUMBER(5),
            deptno NUMBER(4)
        );
```

### 1. 添加主键约束
```sql
    ALTER TABLE tb_cons2
    ADD CONSTRAINT pk_tb_cons2_empno PRIMARY KEY(empno);
```

### 2. 添加非空约束
```sql
--注意添加非空约束使用的是modify 而非add
    ALTER TABLE tb_cons2
    ADD CONSTRIANT nn_tb_cons2_ename NOT NULL(ename);
    ADD CONSTRIANT nn_tb_cons2_ename NOT NULL
                    *
    ERROR at line 2:
    ORA-00902: invalid datatype

    ALTER TABLE tb_cons2
    ADD CONSTRIANT nn_tb_cons2_ename ename NOT NULL;
    ADD CONSTRIANT nn_tb_cons2_ename ename NOT NULL
                                *
    ERROR at line 2:
    ORA-01735: invalid ALTER TABLE option

    ALTER TABLE tb_cons2
    MODIFY (ename CONSTRAINT nn_tb_cons2_ename NOT NULL);
```

### 3. 添加唯一约束
```sql
    ALTER TABLE tb_cons2
    ADD CONSTRAINT uk_tb_cons2_email UNIQUE(email);
```

### 4. 添加CHECK约束
```sql
    ALTER TABLE tb_cons2
    ADD CONSTRAINT ck_tb_cons2_sal CHECK(sal>1500);
```

### 5. 添加外键约束
```sql
    ALTER TABLE tb_cons2
    ADD CONSTRAINT fk_tb_cons2_tb_dept_deptno
    FOREIGN KEY(deptno) REFERENCES tb_dept(deptno)
    ON DELETE CASCADE;
```

### 6. 禁用约束

默认情况下创建的约束是启用的

```sql
--添加一个新列comm以及一个check约束并将其置为禁用模式
    ALTER TABLE tb_cons2
    ADD comm NUMBER(4) CONSTRAINT ck_cons2_comm CHECK(comm>0) DISABLE;

    SELECT owner,constraint_name,constraint_type,table_name,status,deferrable,validated
    FROM user_constraints
    WHERE table_name = 'TB_DEPT';

    OWNER       CONSTRAINT_NAME   C TABLE_NAME   STATUS     DEFERRABLE        VALIDATED
    ---------   ---------------   ------------   -------    ---------------   --------
    ROBINSON    SYS_C005542       P TB_DEPT      ENABLED    NOT DEFERRABLE    VALIDATED

--下面禁用tb_dept表的主键约束,提示存在依赖性,不能成功禁用该约束
    ALTER TABLE tb_dept
    DISABLE CONSTRAINT SYS_C005542 ;
    ALTER TABLE tb_dept
    *
    ERROR at line 1:
    ORA-02297: cannot disable constraint (ROBINSON.SYS_C005542) - dependencies exist

--通过增加CASCADE来实现级联禁用约束
    ALTER TABLE tb_dept
    DISABLE CONSTRAINT SYS_C005542 CASCADE;

--下面的查询可以看到基于tb_dept表存在外键约束的tb_cons2 ,tb_constraint_1上的外键列约束都被禁用
    SELECT constraint_name,constraint_type,table_name,status,deferrable,validated
    FROM user_constraints
    WHERE validated ='NOT VALIDATED';

    CONSTRAINT_NAME                C TABLE_NAME             STATUS   DEFERRABLE     VALIDATED
    ------------------------------ - ---------------------- -------- -------------- -------------
    CK_CONS2_COMM                  C TB_CONS2               DISABLED NOT DEFERRABLE NOT VALIDATED
    FK_TB_CONS2_TB_DEPT_DEPTNO     R TB_CONS2               DISABLED NOT DEFERRABLE NOT VALIDATED
    SYS_C005542                    P TB_DEPT                DISABLED NOT DEFERRABLE NOT VALIDATED
    SYS_C005547                    R TB_CONSTRAINT_1        DISABLED NOT DEFERRABLE NOT VALIDATED
    UK_TB_CONS2_EMAIL              U TB_CONS2               DISABLED NOT DEFERRABLE NOT VALIDATED
```

### 7. 启用约束

ENABLE子句可将当前无效的约束启用

当定义或启用 UNIQUE 或 PRIMARY KEY 约束时系统会自动创建 UNIQUE 或 PRIMARY KEY 索引
```sql
--启用约束时不支持CASCADE，对被级联禁用的约束应根据需要逐个启用
    ALTER TABLE tb_dept
    ENABLE CONSTRAINT SYS_C005542 CASCADE;
    ENABLE CONSTRAINT SYS_C005542 CASCADE
                                *
    ERROR at line 2:
    ORA-00933: SQL command not properly ended

    ALTER TABLE tb_dept
    ENABLE CONSTRAINT SYS_C005542 ;

--可以使用ENABLE NOVALIDATE，实现只对新数据应用某个约束
--约束默认的是ENABLE VALIDATE，即对所有的行实现约束检查
    ALTER TABLE tb_cons2
    ENABLE NOVALIDATE CONSTRAINT ck_cons2_comm;
```

### 8. 删除约束
```sql
    ALTER TABLE tb_cons2
    DROP CONSTRAINT uk_tb_cons2_email;

--使用下面的方法可以级联删除主表主键及从表的外键
    ALTER TABLE table_name DROP PRIMARY KEY CASCADE

--使用drop primary key cascade删除主表主键及从表外键
    ALTER TABLE tb_dept
    DROP PRIMARY KEY CASCADE;

--删除后可以看到不存在tb_dept主键约束及tb_cons2外键的记录
    SELECT constraint_name,constraint_type,table_name,status,deferrable,validated
    FROM user_constraints
    ORDER BY table_name;

    CONSTRAINT_NAME             C TABLE_NAME          STATUS          DEFERRABLE         VALIDATED
    -----------------------     ------------------    -------------   ---------------    -----------
    CK_TB_CONS2_SAL             C TB_CONS2            ENABLED  NOT    DEFERRABLE         VALIDATED
    NN_TB_CONS2_ENAME           C TB_CONS2            ENABLED  NOT    DEFERRABLE         VALIDATED
    PK_TB_CONS2_EMPNO           P TB_CONS2            ENABLED  NOT    DEFERRABLE         VALIDATED
    UK_TB_CONS2_EMAIL           U TB_CONS2            DISABLED NOT    DEFERRABLE NOT     VALIDATED
    SYS_C005546                 U TB_CONSTRAINT_1     ENABLED  NOT    DEFERRABLE         VALIDATED
    SYS_C005545                 P TB_CONSTRAINT_1     ENABLED  NOT    DEFERRABLE         VALIDATED
    SYS_C005543                 C TB_CONSTRAINT_1     ENABLED  NOT    DEFERRABLE         VALIDATED
    SYS_C005544                 C TB_CONSTRAINT_1     ENABLED  NOT    DEFERRABLE         VALIDATED
    PK_TB_CONS3_EMPNO_ENAME     P TB_CONSTRAINT_3     ENABLED  NOT    DEFERRABLE         VALIDATED
    SYS_C005554                 U TB_CONSTRAINT_3     ENABLED  NOT    DEFERRABLE         VALIDATED
```

### 9. 级联约束

CASCADE CONSTRAINTS子句在DROP COLUMN子句中使用

    该子句会删除涉及到在已删除列上定义的主键或唯一关键字的所有引用完整性约束

    该子句也将删除在已删除列上定义的所有多列约束
```sql
    CREATE TABLE tb_cons3
        (
            empno NUMBER PRIMARY KEY,
            sal   NUMBER ,
            comm  NUMBER,
            mgr   NUMBER,
            CONSTRAINT fk_tb_cons3 FOREIGN KEY(mgr) REFERENCES tb_cons3(empno),
            CONSTRAINT ck_tb_cons3_sal CHECK(empno > 0 AND sal > 0),
            CONSTRAINT ck_tb_cons3_comm CHECK(comm > 0)
        );
    Table created.

--下面提示主键列不能删除
    ALTER TABLE tb_cons3 DROP COLUMN empno;
    ALTER TABLE tb_cons3 DROP COLUMN empno
                                *
    ERROR at line 1:
    ORA-12992: cannot drop parent key column

--下面提示sal被多列约束，也不能删除
    ALTER TABLE tb_cons3 DROP COLUMN sal;
    ALTER TABLE tb_cons3 DROP COLUMN sal
                                *
    ERROR at line 1:
    ORA-12991: column is referenced in a multi-column constraint

--使用带有CASCADE CONSTRAINTS的DROP COLUMN 该表中的pk,fk,及ck_sal都将被删除
    ALTER TABLE tb_cons3 DROP COLUMN empno CASCADE CONSTRAINTS;

    Table altered.
```

### 10. 延迟约束

指仅当事物被提交时强制执行约束

在添加约束时可以使用DEFERRABLE子句来指定约束为延迟约束

对于已经存在的约束不能修改为DEFERRABLE延迟约束，只能删除后重建时指定DEFERRABLE子句

使用DEFERRABLE子句时可以使用INITIALY IMMEDIATE或INITIALY DEFERRED

    INITIALY IMMEDIATE：缺省的行为，即实时实施约束行为

    INITIALY DEFERRED：延迟约束行为到提交时予以检查

```sql
--创建tb_cust表
    CREATE TABLE tb_cust
        (
            custid NUMBER(4) NOT NULL,
            custname VARCHAR2(20)
        );

    Table created.

--为表添加主键约束并启用延迟约束
    ALTER TABLE tb_cust
    ADD CONSTRAINT pk_tb_cust_custid PRIMARY KEY(custid)
    DEFERRABLE INITIALLY DEFERRED;

    Table altered.

--插入条记录后提交，给出违反了约束并出现回滚
    INSERT INTO tb_cust SELECT 10,'Jay' FROM DUAL;

    1 row created.

    INSERT INTO tb_cust SELECT 10,'SAM' FROM DUAL;

    1 row created.

    COMMIT;
    COMMIT
    *
    ERROR at line 1:
    ORA-02091: transaction rolled back
    ORA-00001: unique constraint (ROBINSON.PK_TB_CUST_CUSTID) violated

--将约束置为实时启用
    SET CONSTRAINT pk_tb_cust_custid IMMEDIATE;

    Constraint set.

--插入两条新纪录，未执行commit前时约束已起作用
    INSERT INTO tb_cust SELECT 10,'Robinson' FROM DUAL;

    1 row created.

    INSERT INTO tb_cust SELECT 10,'Jack' FROM DUAL;
    INSERT INTO tb_cust SELECT 10,'Jack' FROM DUAL
    *
    ERROR at line 1:
    ORA-00001: unique constraint (ROBINSON.PK_TB_CUST_CUSTID) violated


    COMMIT;

    Commit complete.

--查看最后插入的记录
    SELECT * FROM tb_cust;

    CUSTID      CUSTNAME
    ------      --------
    10          Robinson