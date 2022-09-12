----------------------------
-- create_test_schemas.sql
----------------------------

set echo on

-----------------
-- Create schemas
-----------------

DROP USER app_data CASCADE;
DROP USER app_code CASCADE;
DROP USER app_user CASCADE;

CREATE USER app_data IDENTIFIED BY password 
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;
 
CREATE USER app_code IDENTIFIED BY password
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;
 
CREATE USER app_user IDENTIFIED BY password;
 
------------------------------
-- Grant privileges to schemas
------------------------------

GRANT CREATE SESSION TO app_data;
GRANT CREATE TABLE, CREATE VIEW, CREATE TRIGGER, CREATE SEQUENCE TO app_data;

GRANT CREATE SESSION, CREATE PROCEDURE, CREATE SYNONYM TO app_code;

GRANT CREATE SESSION, CREATE SYNONYM TO app_user;
