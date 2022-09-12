---------------------
-- create_test_qa.sql
---------------------

-----------------
-- create qa_pkg
-----------------

set echo on

CONNECT app_code/password

DROP SYNONYM q;
DROP SYNONYM a;

CREATE SYNONYM q FOR app_data.q;
CREATE SYNONYM a FOR app_data.a;

CREATE OR REPLACE PACKAGE qa_pkg
AS
  PROCEDURE get_q
    ( p_id         IN q.id%TYPE,
      p_result_set IN OUT SYS_REFCURSOR );

  PROCEDURE get_a
    ( p_id          IN a.id%TYPE,
      p_result_set  IN OUT SYS_REFCURSOR );

  PROCEDURE add_q 
    ( p_text        IN q.qtext%TYPE );

  PROCEDURE add_a 
    ( p_id          IN a.id%TYPE,
      p_no          IN a.no%TYPE,
      p_text        IN a.atext%TYPE,
      p_solution    IN a.solution%TYPE := 'n' );
END qa_pkg;
/

CREATE OR REPLACE PACKAGE BODY qa_pkg
AS
 PROCEDURE add_q
  ( p_text IN q.qtext%TYPE )
 IS
  l_id q.id%TYPE;
 BEGIN
  INSERT INTO q(qtext) VALUES (p_text) returning id into l_id;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Question: ' || l_id || ' saved.');
 END add_q;

 PROCEDURE add_a
   ( p_id          IN a.id%TYPE,
     p_no          IN a.no%TYPE,
     p_text        IN a.atext%TYPE,
     p_solution    IN a.solution%TYPE := 'n' )
 IS
  l_id q.id%TYPE;
 BEGIN
  IF (p_no <=0 OR p_no > 3)
  THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: Question no. must be 1, 2 or 3');
    RETURN;
  END IF;
  SELECT id INTO l_id FROM q WHERE id = p_id;
  INSERT INTO a(id, no, atext, solution) 
   VALUES(p_id, p_no, p_text, p_solution);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Answer: ' || p_no || ' for question: ' || l_id || ' saved.');
  EXCEPTION 
   WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: Question id=' || p_id || ' not found');
    ROLLBACK;
 END add_a;

 PROCEDURE get_q
   ( p_id         IN q.id%TYPE,
     p_result_set IN OUT SYS_REFCURSOR )
 IS
  l_cursor SYS_REFCURSOR;
 BEGIN
  OPEN p_result_set FOR
   SELECT id, qtext
   FROM q
   WHERE id = p_id;
 END get_q;

 PROCEDURE get_a
    ( p_id          IN a.id%TYPE,
      p_result_set  IN OUT SYS_REFCURSOR )
 IS
  l_cursor SYS_REFCURSOR;
 BEGIN
  OPEN p_result_set FOR
  SELECT id, no, atext, solution
  FROM a
  WHERE id = p_id
  ORDER BY id, no;
 END get_a;

END qa_pkg;

 
/
show errors

---------------------------------------------
-- Grant privileges on qa_pkg to users
---------------------------------------------

GRANT EXECUTE ON qa_pkg TO app_user;

