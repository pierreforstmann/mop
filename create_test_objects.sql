--------------------------
-- create_test_objects.sql
--------------------------

------------------------
-- Create schema objects
------------------------
 
set echo on

CONNECT app_data/password

DROP TABLE a;
DROP TABLE q;

create table q(
       id integer generated always as identity primary key,
       qtext varchar2(250) not null);

create table a(
	id int references q,
        no int not null,
        atext varchar2(250) not null,
	solution char  default 'n' check (solution = 'y' or solution = 'n'),
        constraint pk_a primary key(id,no));


----------------------------------------------
-- Grant privileges on schema objects to users
----------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON q TO app_code;
GRANT SELECT, INSERT, UPDATE, DELETE ON a TO app_code;

