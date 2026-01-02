-- 1. Create a BEFORE INSERT trigger on a table named STUDENTS that automatically converts student names to uppercase before insertion.

CREATE OR REPLACE TRIGGER trg_name_upper
BEFORE INSERT
ON students
FOR EACH ROW
BEGIN
  IF :NEW.name IS NOT NULL THEN
    :NEW.name := upper(:NEW.name);
  END IF;
END;


-- 2. Write a trigger that prevents deletion of rows from the EMPLOYEES table during weekends.

CREATE OR REPLACE TRIGGER trg_no_delete_weekends
BEFORE DELETE
ON employees
FOR EACH ROW
DECLARE
  v_day_abbr VARCHAR2(3);
BEGIN
  v_day_abbr := upper(TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'));

  IF v_day_abbr in('SAT', 'SUN') THEN
    RAISE_APPLICATION_ERROR(-20001, 'Deletion from EMPLOYEES is not allowed on weekends (Sat/Sun).');
  END IF;
END;


-- 3. Create a trigger that logs all UPDATE operations on the SALARY column of the EMPLOYEES table into a separate LOG_SALARY_AUDIT table.

-- Audit table DDL
CREATE TABLE log_salary_audit (
  audit_id     NUMBER PRIMARY KEY,
  emp_id       NUMBER,
  old_salary   NUMBER,
  new_salary   NUMBER,
  changed_by   VARCHAR2(30),
  changed_at   DATE,
  change_reason VARCHAR2(200) 
);

CREATE SEQUENCE seq_log_salary_audit START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_audit_salary_update
AFTER UPDATE OF salary
ON employees
FOR EACH ROW
BEGIN
  IF ( (:OLD.salary IS NULL AND :NEW.salary IS NOT NULL)
       OR (:OLD.salary IS NOT NULL AND :NEW.salary IS NULL)
       OR (:OLD.salary <> :NEW.salary) ) THEN

    INSERT INTO log_salary_audit (
      audit_id,
      emp_id,
      old_salary,
      new_salary,
      changed_by,
      changed_at
    ) VALUES (
      seq_log_salary_audit.NEXTVAL,
      :OLD.emp_id,            -- or :NEW.emp_id depending on your PK column name
      :OLD.salary,
      :NEW.salary,
      SYS_CONTEXT('USERENV','SESSION_USER'),
      SYSDATE
    );
  END IF;
END;


-- 4. Design a BEFORE UPDATE trigger that ensures the PRICE of a product in the PRODUCTS table cannot be set to a negative value.

CREATE OR REPLACE TRIGGER trg_products_no_negative_price
BEFORE UPDATE OF price
ON products
FOR EACH ROW
BEGIN
  IF :NEW.price IS NOT NULL AND :NEW.price < 0 THEN
    RAISE_APPLICATION_ERROR(-20010, 'PRICE cannot be negative.');
  END IF;
END;


-- 5. Write a trigger that inserts the username and timestamp whenever a record is inserted into the COURSES table.

CREATE OR REPLACE TRIGGER trg_courses_insert_audit
AFTER INSERT
ON courses
FOR EACH ROW
BEGIN
  INSERT INTO courses_insert_audit (audit_id,course_id,inserted_by,inserted_at) 
  VALUES (seq_courses_insert_audit.NEXTVAL,:NEW.course_id,SYS_CONTEXT('USERENV','SESSION_USER'),SYSTIMESTAMP
  );
END;


-- 6. Create a trigger that automatically sets a DEFAULT department_id value in the EMP table if none is provided during insertion.

CREATE OR REPLACE TRIGGER trg_emp_default_dept_const
BEFORE INSERT
ON emp
FOR EACH ROW
BEGIN
  IF :NEW.department_id IS NULL THEN
    :NEW.department_id := 10; 
  END IF;
END;


-- 7. Develop a compound trigger for the SALES table that calculates total sales amount before and after bulk inserts

CREATE OR REPLACE TRIGGER trg_sales_bulk_amount
FOR INSERT ON sales
COMPOUND TRIGGER

  v_before_total   NUMBER := 0;
  v_inserted_total NUMBER := 0;
  v_count          NUMBER := 0;

  BEFORE STATEMENT IS
  BEGIN
    SELECT NVL(SUM(amount), 0) INTO v_before_total FROM sales;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_before_total := 0;
  END BEFORE STATEMENT;

  BEFORE EACH ROW IS
  BEGIN
    IF :NEW.amount IS NOT NULL THEN
      v_inserted_total := v_inserted_total + :NEW.amount;
    END IF;
    v_count := v_count + 1;
  END BEFORE EACH ROW;

  AFTER STATEMENT IS
    v_after_total NUMBER;
  BEGRT INTO sales_bulk_audit (audit_id, before_total, inserted_total, after_total, inserted_count, created_by, created_at) 
    VALUES(seq_sales_bulk_audit.NEXTVAL,v_before_tov_count,SYS_CONTEXT('USERENV','SESSION_USER')SYSTIMESTAMP);
  END AFTER STATEMENT;
END trg_sales_bulk_amount;


-- 8. Create a DDL trigger that audits every CREATE or DROP statement executed in your schema and stores details in SCHEMA_DDL_LOG.

CREATE TABLE schema_ddl_log (
  log_id       NUMBER PRIMARY KEY,
  evt_time     TIMESTAMP,
  evt_user     VARCHAR2(30),
  evt_type     VARCHAR2(30),
  obj_owner    VARCHAR2(30),
  obj_type     VARCHAR2(30),
  obj_name     VARCHAR2(128),
  sql_text     CLOB
);

CREATE SEQUENCE seq_schema_ddl_log START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_schema_ddl_audit
AFTER DDL ON SCHEMA
DECLARE
  v_sql_line  VARCHAR2(32767);
  v_sql_all   CLOB := EMPTY_CLOB();
  i PLS_INTEGER := 1;
BEGIN
  IF ORA_SYSEVENT IN ('CREATE', 'DROP') THEN
    LOOP
      v_sql_line := ORA_SQL_TXT(i);
      EXIT WHEN v_sql_line IS NULL;
      v_sql_all := v_sql_all || v_sql_line;
      i := i + 1;
    END LOOP;

    INSERT INTO schema_ddl_log (log_id, evt_time, evt_user, evt_type, obj_owner, obj_type, obj_name, sql_text) 
    VALUES(seq_schema_ddl_log.NEXTVAL,SYSTIMESTAMP,SYS_CONTEXT('USERENV','SESSION_USER'),ORA_SYSEVENT,ORA_DICT_OBJ_OWNER,ORA_DICT_OBJ_TYPE,ORA_DICT_OBJ_NAME,v_sql_all
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END trg_schema_ddl_audit;


-- 9. Write a trigger that prevents updates on an ORDER table if the order_status is marked as &#39;SHIPPED&#39;.

CREATE OR REPLACE TRIGGER trg_orders_block_update_when_shipped
BEFORE UPDATE
ON orders
FOR EACH ROW
BEGIN
  IF :OLD.order_status IS NOT NULL AND UPPER(:OLD.order_status) = 'SHIPPED' THEN
    RAISE_APPLICATION_ERROR(-20020, 'Cannot update an order that is already SHIPPED.');
  END IF;
END;


-- 10.  Create a schema-level LOGON trigger that records each user’s login time and username into LOGIN_AUDIT table.

CREATE OR REPLACE TRIGGER trg_logon_audit_db
AFTER LOGON ON DATABASE
DECLARE
  v_user  VARCHAR2(30) := SYS_CONTEXT('USERENV','SESSION_USER');
BEGIN
  BEGIN
    INSERT INTO login_audit (
      audit_id, username, logon_time, machine, program, terminal)VALUES (seq_login_audit.NEXTVAL,v_user,SYSTIMESTAMP,SYS_CONTEXT('USERENV','HOST'),SYS_CONTEXT('USERENV','PROGRAM'),SYS_CONTEXT('USERENV','TERMINAL'));
  EXCEPTION
    WHEN OTHERS THEN
      NULL; 
  END;
END;


