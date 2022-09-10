## Retrieving foreign key hierarchy

First database objects using `rfkh.sql`.

### Examples

#### Create tables and constraints:

```
create table c(x int primary key);
create table p(x int primary key references c); 
create table pp(x int primary key references p); 
create table ppp(x int primary key references pp); 
```

#### Display constraint information stored in data dictionary:

```
col table_name format a20
col constraint_name format a20
col r_constraint_name format a20
col constraint_type format a15
SQL> select table_name, constraint_type, constraint_name, r_constraint_name	from user_constraints;

TABLE_NAME	     CONSTRAINT_TYPE CONSTRAINT_NAME	  R_CONSTRAINT_NAME
-------------------- --------------- -------------------- --------------------
C		     P		     SYS_C008391
P		     P		     SYS_C008392
P		     R		     SYS_C008393	  SYS_C008391
PP		     P		     SYS_C008394
PP		     R		     SYS_C008395	  SYS_C008392
PPP		     P		     SYS_C008396
PPP		     R		     SYS_C008397	  SYS_C008394
```

#### Display foreign key hierarchies:

Run the select statement calling `depends` function with following arguments:
1. the table name which is the root of the foreign key hierarchy to display 
2. a starting level number.

```
SQL> select * from table(cast (depends('P', 1) as myTableType));

LEVEL_NUMBER TABLE_NAME
------------ --------------------

	   1 P
	   2 C

SQL> select * from table(cast (depends('PP', 1) as myTableType));

LEVEL_NUMBER TABLE_NAME
------------ --------------------

	   1 PP
	   2 P
	   3 C

SQL> select * from table(cast (depends('PPP', 1) as myTableType));

LEVEL_NUMBER TABLE_NAME
------------ --------------------

	   1 PPP
	   2 PP
	   3 P
	   4 C
```
