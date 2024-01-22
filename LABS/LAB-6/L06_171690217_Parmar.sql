-- ***********************
-- Name: Neron Parmar
-- ID: 171690217
-- Date: 11/16/23
-- Purpose: Lab 6 DBS311
-- ***********************


SET SERVEROUTPUT ON;

-- QUESTION-1 --
-- Write a store procedure that gets an integer number n and calculates and displays its 
-- factorial.
-- Q-1 SOLUTION --
CREATE OR REPLACE PROCEDURE calculate_factorial(n IN NUMBER)
AS
  result NUMBER := 1;
BEGIN 
    IF n < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Factorial cannot be negative');
    ELSE
      FOR i IN 1..n
      LOOP 
        result := result * i;
      END LOOP;
      
      DBMS_OUTPUT.PUT_LINE('Factorial of ' || n || '! = ' || result);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error...!');
END;
-- Calling the procedure
BEGIN
    calculate_factorial(10);
    calculate_factorial(0);
    calculate_factorial(-1);
END;
    

-- QUESTION-2 --
-- The company wants to calculate the employees’ annual salary:
-- The first year of employment, the amount of salary is the base salary which is $10,000.
-- Every year after that, the salary increases by 5%.
-- Write a stored procedure named calculate_salary which gets an employee ID and for that employee calculates the salary based on the number of years the employee has been working in the company.  (Use a loop construct to calculate the salary).
-- The procedure calculates and prints the salary.
-- Q-2 SOLUTION --
CREATE OR REPLACE PROCEDURE calculate_salary(s_employee_id employees.employee_id%TYPE)
IS
  s_base_salary NUMBER :=10000;
  s_year_worked NUMBER;
  s_first_name employees.first_name%TYPE;
  s_last_name employees.last_name%TYPE;
  s_salary NUMBER := s_base_salary;
  i INT := 0;
BEGIN 
    SELECT 
      first_name,
      last_name,
      TRUNC(TO_CHAR(SYSDATE - hire_date) / 365)
    INTO 
      s_first_name,
      s_last_name,
      s_year_worked
    FROM 
      employees
    WHERE employee_id = s_employee_id;
    
    FOR i IN 1..s_year_worked
    LOOP
      s_salary := s_salary * 1.05;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('First Name: ' || s_first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || s_last_name);
    DBMS_OUTPUT.PUT_LINE('Salary: $' || TO_CHAR(s_salary , '99999.99'));
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN DBMS_OUTPUT.PUT_LINE('Employee with ID ' || s_employee_id || ' does not exist');
    WHEN OTHERS
    THEN DBMS_OUTPUT.PUT_LINE('Error...!');
END;
-- Calling the procedure
BEGIN
  calculate_salary(107);
  calculate_salary(108);
END;


-- QUESTION-3 --
-- Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, and the city where the warehouse is located in the following format for all warehouses:
-- Warehouse ID:
-- Warehouse name:
-- City:
-- State:
-- If the value of state does not exist (null), display “no state”.
-- The value of warehouse ID ranges from 1 to 9.
-- You can use a loop to find and display the information of each warehouse inside the loop.
-- (Use a loop construct to answer this question. Do not use cursors.) 
-- Q-3 SOLUTION --
CREATE OR REPLACE PROCEDURE warehouses_report
AS
    w_warehouse_id   warehouses.warehouse_id %TYPE;
    w_warehouse_name warehouses.warehouse_name %TYPE;
    w_city           locations.city %TYPE;
    w_state          locations.state %TYPE;
BEGIN
    FOR i IN 1..9
    LOOP
        SELECT w.warehouse_id, w.warehouse_name, l.city, NVL(l.state, 'no state')
        INTO w_warehouse_id, w_warehouse_name, w_city, w_state
        FROM warehouses w
        INNER JOIN locations l ON w.location_id = l.location_id
        WHERE w.warehouse_id = i;

        DBMS_OUTPUT.put_line('Warehouse ID: ' || w_warehouse_id);
        DBMS_OUTPUT.put_line('Warehouse name: ' || w_warehouse_name);
        DBMS_OUTPUT.put_line('City: ' || w_city);
        DBMS_OUTPUT.put_line('State: ' || w_state);
        DBMS_OUTPUT.put_line('-----------------');
    END LOOP;
END;
-- Calling the procedure
BEGIN
    warehouses_report();
END;















