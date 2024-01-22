-- ***********************
-- Name: Neron Parmar
-- ID: 171690217
-- Date: 9/26/23
-- Purpose: Lab 1 DBS311
-- ***********************

-- Question-1: Write a query to display the tomorrow’s date in the following format: January 10th of year 2019 the result will depend on the day when you RUN/EXECUTE this query.  Label the column “Tomorrow”. Advanced Option:  Define an SQL variable called “tomorrow”, assign it a value of tomorrow’s date, use it in an SQL statement. 
-- Q1 Solution -- 
SELECT TO_CHAR(SYSDATE + 1, 'Month DD"th of year" YYYY') AS "TOMMOROW"
FROM DUAL;

-- Question-2: For each product in category 2, 3, and 5, show product ID, product name, list price, and the new list price increased by 2%. Display a new list price as a whole number. In your result, add a calculated column to show the difference of old and new list prices.
-- Q2 Solution -- 
SELECT product_id, product_name, list_price, 
       ROUND(list_price * 1.02 ) AS "New List Prices",
       ROUND((list_price * 1.02 - list_price)) AS "Price Difference"
FROM products
WHERE category_id IN (2,3,5)
ORDER BY category_id ASC, product_id ASC;

-- Question-3: For employees whose manager ID is 2, write a query that displays the employee’s Full Name and Job Title in the following format: SUMMER, PAYNE is Public Accountant.
-- Q3 Solution --
SELECT CONCAT(CONCAT(last_name, ', '), first_name) || ' is ' || job_title AS "Employee Description"
FROM employees
WHERE manager_id = 2;

-- Question-4: For each employee hired before October 2016, display the employee’s last name, hire date and calculate the number of YEARS between TODAY and the date the employee was hired. Label the column Years worked. Order your results by the number of years employed.  Round the number of years employed up to the closest whole number.
-- Q4 Solution -- 
SELECT last_name as "Last Name", hire_date "Hired On", ROUND((SYSDATE - hire_date) / 365) AS "Years Worked"
FROM employees
WHERE hire_date < TO_DATE('2016-10-01', 'YYYY-MM-DD')
ORDER BY "Years Worked";

-- Q5: Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of service, but only for those hired after 2016. Label the column REVIEW DAY. Format the dates to appear in the format like: TUESDAY, August the Thirty-First of year 2016. Sort by review date
-- Q5 Solution --
SELECT last_name, hire_date, 
        TO_CHAR(NEXT_DAY(LAST_DAY(ADD_MONTHS(hire_Date, -1)), 'TUESDAY'),
        'DAY, Month" the" DDspth "of year" YYYY') AS "Review Day"
FROM employees
WHERE hire_date > TO_DATE('2016-01-01', 'YYYY-MM-DD')
ORDER BY "Review Day";

-- Q6: For all warehouses, display warehouse id, warehouse name, city, and state. For warehouses with the null value for the state column, display “unknown”.
-- Q6 Solution -- 
SELECT wh.warehouse_id, wh.warehouse_name, lo.city, NVL(lo.state, 'UNKNOWN') AS "State"
FROM warehouses wh
LEFT OUTER JOIN locations lo ON wh.location_id = lo.location_id
ORDER BY  wh.warehouse_id;
