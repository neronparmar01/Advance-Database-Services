-- ***********************
-- Name: Neron Parmar
-- ID: 171690217
-- Date: 11/2/23
-- Purpose: Lab 5 DBS311
-- ***********************

SET SERVEROUTPUT ON;

-- Question 1: Create a stored procedure that takes an integer as input and prints 
-- The number is even if the input is divisible by 2, or The number is odd if it's not.
-- Q1 Solution --
CREATE OR REPLACE PROCEDURE check_even_odd(input_number IN NUMBER) AS
BEGIN
    IF MOD(input_number, 2) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('The number is an even number');
    ELSE
      DBMS_OUTPUT.PUT_LINE('The number is an odd number');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An error occured');
END;
-- Checking -- 
BEGIN
check_even_odd(7);
END;


-- QUESTION 2: Creating a stored procedure called find_employee that takes an employee 
-- number as input (of type NUMBER) and prints the employee's first name, last name, 
-- email, phone, hire date, and job title from the employee table. Also ensuring that 
-- it displays an error message for any errors.
-- Q2 SOLUTION --
CREATE OR REPLACE PROCEDURE find_employee(emp_employee_id IN NUMBER) AS
  emp_first_name EMPLOYEES.first_name%TYPE;
  emp_last_name EMPLOYEES.last_name%TYPE;
  emp_email EMPLOYEES.email%TYPE;
  emp_phone EMPLOYEES.phone%TYPE;
  emp_hire_date EMPLOYEES.hire_date%TYPE;
  emp_job_title EMPLOYEES.job_title%TYPE;
BEGIN
  SELECT first_name, last_name, email, phone, hire_date, job_title
  INTO emp_first_name, emp_last_name, emp_email, emp_phone, emp_hire_date, emp_job_title
  FROM employees
  WHERE employee_id = emp_employee_id;

    DBMS_OUTPUT.PUT_LINE('First name: ' || emp_first_name);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || emp_last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || emp_email);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || emp_phone);
    DBMS_OUTPUT.PUT_LINE('Hire date: ' || TO_CHAR(emp_hire_date, 'DD-MON-YY'));
    DBMS_OUTPUT.PUT_LINE('Job title: ' || emp_job_title);
    
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('An Error Occurred...! No data found for Employee ID ' || emp_employee_id);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('An Error Occurred...! Multiple rows found for Employee ID ' || emp_employee_id);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An Unknown Error Occurred...!');
END;
-- CHECKING --
BEGIN
find_employee(107);
END;

-- QUESTION 3: creating a stored procedure in a database to update the prices of products 
-- in a specific category by adding a given amount to their current prices and then 
-- displaying the number of rows that were updated.
-- Q3 SOLUTION --
CREATE OR REPLACE PROCEDURE update_price_by_cat(cat_category_id IN products.category_id%TYPE , amount IN products.list_price%TYPE) AS cat_count NUMBER;
ROWS_UPDATED NUMBER;
BEGIN

  SELECT COUNT(category_id) 
  INTO cat_count 
  FROM products
  WHERE category_id = cat_category_id;
  
  IF (cat_count > 0) THEN
        UPDATE products SET list_price = list_price + amount 
        WHERE category_id = cat_Category_id;
        ROWS_UPDATED := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Number of Rows Updated: ' || ROWS_UPDATED);
  ELSE
        DBMS_OUTPUT.PUT_LINE('An Error Occurred...! Category ID must be greater than 0');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('An Error Occurred...! No data found');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('An Error Occurred...! Multiple rows found for the result');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An Unknown Error Occurred...!');
END;
-- CHECKING --
DECLARE
    cat_category_id products.category_id%TYPE := 1;
    amount products.list_price%TYPE := 5;
BEGIN
    update_price_by_cat(cat_category_id, amount);
END;


-- QUESTION 4: Write a stored procedure called update_price_under_avg that calculates 
-- the average price of all products. If the average price is less than or equal to 
-- $1000 then increase the price of products below the average by 2% and if the 
-- average price is over $1000 then increase the price of products below the average by 1%. 
-- Report the number of updated rows or display an error message for any issues.
-- Q4 SOLUTION --
CREATE OR REPLACE PROCEDURE update_price_under_avg AS 
      updated_average NUMBER;
      updated_update_rate NUMBER;
      ROWS_UPDATED NUMBER;
BEGIN
     SELECT AVG(list_price) 
     INTO updated_average 
     FROM products;
     
IF (updated_average <= 1000) THEN 
  updated_update_rate := 1.02;
ELSE 
  updated_update_rate := 1.01;
END IF;

UPDATE products
SET list_price = list_price * updated_update_rate
WHERE list_price < updated_average;

ROWS_UPDATED := SQL%ROWCOUNT;

DBMS_OUTPUT.PUT_LINE('Number of Rows Updated: ' || ROWS_UPDATED);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('An Error Occurred...! No data found');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An Unknown Error Occurred...!');
END;
-- CHECKING -- 
BEGIN
  update_price_under_avg();
END;


-- QUESTION 5: Write a procedure called prodcut_price_report. This procedure will show number of products in each category
-- like expensive, cheap and fair. For this using the formula: 
-- If the list price is less then (avg_price - min_price) / 2 then product's price is 
-- cheap. If the list price is greater than, (max_price - avg_price) / 2 then product's 
-- price is expensive. If the list price is between then (avg_price - min_price) / 2
-- and (max_price - avg_price) / 2, the end values included then product's price is fair.
-- Q5 SOLUTION --
CREATE OR REPLACE PROCEDURE product_price_report AS
  avg_price NUMBER;
  min_price NUMBER;
  max_price NUMBER;
  cheap_count NUMBER := 0;
  fair_count NUMBER := 0;
  exp_count NUMBER := 0;

BEGIN
  -- Calculate the average, minimum, and maximum prices
  SELECT AVG(list_price), MIN(list_price), MAX(list_price)
  INTO avg_price, min_price, max_price
  FROM products;

  -- Count products in each price category
  FOR product_rec IN (SELECT list_price FROM products) LOOP
    IF product_rec.list_price < (avg_price - min_price) / 2 THEN
      cheap_count := cheap_count + 1;
    ELSIF product_rec.list_price > (max_price - avg_price) / 2 THEN
      exp_count := exp_count + 1;
    ELSE
      fair_count := fair_count + 1;
    END IF;
  END LOOP;

  -- Output the results
  DBMS_OUTPUT.PUT_LINE('Cheap: ' || cheap_count);
  DBMS_OUTPUT.PUT_LINE('Fair: ' || fair_count);
  DBMS_OUTPUT.PUT_LINE('Expensive: ' || exp_count);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ERROR! NO RECORDS FOUND');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR OCCURRED');
END;

BEGIN
  product_price_report;
END;







