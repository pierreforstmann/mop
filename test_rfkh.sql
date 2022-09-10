--
-- test_rfkh.sql
--
-- test retrieving foreign key hierarchy
--
drop table a;
drop table e;
drop table d;
drop table c;
drop table b;
drop table b1;
drop table d1;
drop table bb1;
drop table bb2;
drop table dd1;
drop table dd2;
drop table ddd1;
drop table dddd1;
drop table ddddd1;
--
create table ddddd1(x int primary key);
create table dddd1(x int primary key references ddddd1);
create table ddd1(x int primary key references dddd1);
create table bb1(x int primary key);
create table bb2(x int primary key);
create table dd1(x int primary key references ddd1);
create table dd2(x int primary key);
create table b1(x int primary key references bb1, y references bb2);
create table d1(x int primary key references dd1, y references dd2);
create table b(x int primary key references b1);
create table c(x int primary key);
create table d(x int primary key references d1);
create table e(x int primary key);
create table a(x int primary key references b, y references c, z references d, x1 references e);

purge recyclebin;
set pagesize 100
select * from table(cast (depends('A', 1) as myTableType));


