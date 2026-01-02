-- Q1

CREATE TABLE bank_accounts (
  account_no VARCHAR(10) PRIMARY KEY,
  holder_name VARCHAR(100),
  balance    NUMERIC(15,2)
);

INSERT INTO bank_accounts (account_no, holder_name, balance) VALUES ('A', 'Alice', 20000.00);
INSERT INTO bank_accounts (account_no, holder_name, balance) VALUES  ('B', 'Bob',   15000.00);
INSERT INTO bank_accounts (account_no, holder_name, balance) VALUES  ('C', 'Carol',  8000.00);

COMMIT

SELECT * FROM bank_accounts ORDER BY account_no;

START TRANSACTION trans;  

UPDATE bank_accounts
SET balance = balance - 5000
WHERE account_no = 'A';

UPDATE bank_accounts
SET balance = balance + 5000
WHERE account_no = 'B';

UPDATE bank_accounts
SET balance = balance + 12345  -- mistaken amount
WHERE account_no = 'C';

SELECT * FROM bank_accounts ORDER BY account_no;

ROLLBACK;

SELECT * FROM bank_accounts ORDER BY account_no;



-- Q2:

CREATE TABLE inventory (
  item_id   NUMBER PRIMARY KEY,
  item_name VARCHAR2(100),
  quantity  NUMBER
);

INSERT INTO inventory (item_id, item_name, quantity) VALUES (1, 'Item-1', 100);
INSERT INTO inventory (item_id, item_name, quantity) VALUES (2, 'Item-2', 200);
INSERT INTO inventory (item_id, item_name, quantity) VALUES (3, 'Item-3', 150);
INSERT INTO inventory (item_id, item_name, quantity) VALUES (4, 'Item-4', 50);

COMMIT; 

UPDATE inventory SET quantity = quantity - 10 WHERE item_id = 1;

SAVEPOINT sp1;

UPDATE inventory SET quantity = quantity - 20 WHERE item_id = 2;

SAVEPOINT sp2;

UPDATE inventory SET quantity = quantity - 5 WHERE item_id = 3;

SELECT * FROM inventory ORDER BY item_id;

ROLLBACK TO SAVEPOINT sp1;

SELECT * FROM inventory ORDER BY item_id;

COMMIT;

SELECT * FROM inventory ORDER BY item_id;



-- Q3: 

CREATE TABLE fees (
  student_id  NUMBER PRIMARY KEY,
  name        VARCHAR2(100),
  amount_paid NUMBER(12,2),
  total_fee   NUMBER(12,2)
);

INSERT INTO fees (student_id, name, amount_paid, total_fee) VALUES (1, 'Student-1', 1000, 5000);
INSERT INTO fees (student_id, name, amount_paid, total_fee) VALUES (2, 'Student-2', 1200, 5000);
INSERT INTO fees (student_id, name, amount_paid, total_fee) VALUES (3, 'Student-3', 500,  5000);

COMMIT;

SELECT * FROM fees ORDER BY student_id;

UPDATE fees SET amount_paid = amount_paid + 500 WHERE student_id = 1;

SELECT * FROM fees ORDER BY student_id;

SAVEPOINT halfway;

UPDATE fees SET amount_paid = amount_paid + 300 WHERE student_id = 2;

SELECT * FROM fees ORDER BY student_id;

ROLLBACK TO SAVEPOINT halfway;

SELECT * FROM fees ORDER BY student_id;

COMMIT;

SELECT * FROM fees ORDER BY student_id;



-- Q4:

CREATE TABLE products (
  product_id   NUMBER PRIMARY KEY,
  product_name VARCHAR2(100),
  stock        NUMBER
);

CREATE TABLE orders (
  order_id   NUMBER PRIMARY KEY,
  product_id NUMBER,
  quantity   NUMBER,
  CONSTRAINT fk_prod_or FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name, stock) VALUES (1, 'Widget', 100);
INSERT INTO products (product_id, product_name, stock) VALUES (2, 'Gadget', 50);
INSERT INTO products (product_id, product_name, stock) VALUES (3, 'Thingamajig', 25);

INSERT INTO orders (order_id, product_id, quantity) VALUES (1, 2, 5);

COMMIT;

SELECT 'INITIAL PRODUCTS' note, product_id, product_name, stock FROM products ORDER BY product_id;
SELECT 'INITIAL ORDERS'   note, order_id, product_id, quantity FROM orders ORDER BY order_id;

UPDATE products SET stock = stock - 10 WHERE product_id = 1;

INSERT INTO orders (order_id, product_id, quantity) VALUES (2, 1, 10);

DELETE FROM products WHERE product_id = 3;

SELECT 'IN TRANS - PRODUCTS' note, product_id, product_name, stock FROM products ORDER BY product_id;
SELECT 'IN TRANS - ORDERS'   note, order_id, product_id, quantity FROM orders ORDER BY order_id;

ROLLBACK;

SELECT 'AFTER ROLLBACK - PRODUCTS' note, product_id, product_name, stock FROM products ORDER BY product_id;
SELECT 'AFTER ROLLBACK - ORDERS'   note, order_id, product_id, quantity FROM orders ORDER BY order_id;

UPDATE products SET stock = stock - 10 WHERE product_id = 1;
INSERT INTO orders (order_id, product_id, quantity) VALUES (3, 1, 10);

COMMIT;

SELECT 'FINAL PRODUCTS' note, product_id, product_name, stock FROM products ORDER BY product_id;
SELECT 'FINAL ORDERS'   note, order_id, product_id, quantity FROM orders ORDER BY order_id;



-- Q5: 

CREATE TABLE employees (
  emp_id   NUMBER PRIMARY KEY,
  emp_name VARCHAR2(100),
  salary   NUMBER(12,2)
);

INSERT INTO employees (emp_id, emp_name, salary) VALUES (1, 'Alice', 50000);
INSERT INTO employees (emp_id, emp_name, salary) VALUES (2, 'Bob',   52000);
INSERT INTO employees (emp_id, emp_name, salary) VALUES (3, 'Carol', 48000);
INSERT INTO employees (emp_id, emp_name, salary) VALUES (4, 'David', 47000);
INSERT INTO employees (emp_id, emp_name, salary) VALUES (5, 'Eve',   53000);

COMMIT;

SELECT * FROM employees ORDER BY emp_id;

UPDATE employees SET salary = salary + 2000 WHERE emp_id = 1;

SAVEPOINT A;

UPDATE employees SET salary = salary + 1500 WHERE emp_id = 2;

SAVEPOINT B;

UPDATE employees SET salary = salary + 1000 WHERE emp_id = 3;

SELECT * FROM employees ORDER BY emp_id;

ROLLBACK TO SAVEPOINT A;

SELECT * FROM employees ORDER BY emp_id;

COMMIT;

SELECT * FROM employees ORDER BY emp_id;








