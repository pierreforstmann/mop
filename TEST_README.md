# TEST: a very simple PL/SQL application

TEST is a very simple application written in PL/SQL that shows how to implement a <a href="https://asktom.oracle.com/pls/apex/f?p=100:551:::NO:551:P551_CLASS_ID:3241:">SmartDB application</a>:

- The connect user does not own database objects
- The connect user can execute PL/SQL API units only
- PL/SQL API units handle transactions
- SQL statements are written by human hand
- SQL statements exploit the full power of set-based SQL

Credits: this example is based on <a href=https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/developing-simple-database-application.html#GUID-98FFDC3A-FD76-4466-921C-F0E411829CD7>
Developing a Simple Oracle Database Application chapter from  2 Day Developer's Guide </a>.

There are 3 schemas:
- `APP_DATA` owning the tables and indexes
- `APP_CODE` owning the PL/SQL package that execute DML statements on `APP_DATA` tables
- `APP_USER` does not own any objects, does not have any privilege on `APP_DATA` objects and only has EXECUTE privilege on `APP_CODE` PL/SQL package.

## Installing TEST application

Connect with a user account having administration privileges and run:

``` 
@create_test_schemas
...
@create_test_objects
...
@create_test_qa
...
```

## Running TEST application

```
SQL> connect app_user/password
Connected.
SQL> 
SQL> set serveroutput on
SQL> set linesize 120
SQL> col grantee format a20
SQL> col owner format a20
SQL> col table_name format a20
SQL> col privilege format a20
SQL> col username format a20
SQL> col qtext format a50
SQL> col atext format a50
SQL> --
SQL> select grantee, owner, table_name, privilege from user_tab_privs where grantee='APP_USER';

GRANTEE 	     OWNER		  TABLE_NAME	       PRIVILEGE
-------------------- -------------------- -------------------- --------------------
APP_USER	     APP_CODE		  QA_PKG	       EXECUTE

SQL> select * from user_sys_privs ;

USERNAME	     PRIVILEGE		  ADM COM INH
-------------------- -------------------- --- --- ---
APP_USER	     CREATE SYNONYM	  NO  NO  NO
APP_USER	     CREATE SESSION	  NO  NO  NO

SQL> select * from user_role_privs ;

no rows selected

SQL> --
SQL> exec app_code.qa_pkg.add_q('Question 1 ...');
Question : 7 created.

PL/SQL procedure successfully completed.

SQL> --
SQL> exec app_code.qa_pkg.add_a(7, 1, '... Q1 - Answer 1 ... ');

PL/SQL procedure successfully completed.

SQL> --
SQL> var c refcursor
SQL> exec app_code.qa_pkg.get_q(7, :c);

PL/SQL procedure successfully completed.

SQL> print c

	ID QTEXT
---------- --------------------------------------------------
	 7 Question 1 ...

SQL> --
SQL> exec app_code.qa_pkg.get_a(7, :c);

PL/SQL procedure successfully completed.

SQL> print

	ID	   NO ATEXT						 S
---------- ---------- -------------------------------------------------- -
	 7	    1 ... Q1 - Answer 1 ...				 n

SQL> --
SQL> 
```


