-- ***********************
-- Name: Neron Parmar
-- ID: 171690217
-- Date: 10/4/23
-- Purpose: Lab 2 DBS311
-- ***********************

-- Question-1: For each job title display the number of employees. 
-- Q1 Solution --
SELECT job_title, COUNT (*) AS number_of_employees
FROM employees
GROUP BY job_title
ORDER BY number_of_employees;

-- Question-2: Display the Highest, Lowest and Average customer credit limits. Name these results High, Low and Avg. Add a column that shows the difference between the highest and lowest credit limits.
-- Use the round function to display two digits after the decimal point.
-- Q2 Solution --
SELECT MAX(credit_limit) AS  "High",
       MIN(credit_limit) AS "Low",
       ROUND(AVG(credit_limit),2) AS "Avg",
      (MAX(credit_limit) - MIN(credit_limit)) AS "Difference"
FROM customers;

-- Question-3: Display the order id and the total order amount for orders with the total amount over $1000,000.
-- Q3 Solution -- 
SELECT order_id, SUM(unit_price * quantity) AS "Total Amount"
FROM order_items
GROUP BY order_id
HAVING SUM(unit_price * quantity) > 1000000;

-- Question-4: Display the warehouse id, warehouse name, and the total number of products for each warehouse.
-- Q4 Solution --
SELECT w.warehouse_id, w.warehouse_name, COALESCE(SUM(i.quantity), 0) AS "Total Products"
FROM warehouses w
LEFT JOIN inventories i
ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id , w.warehouse_name
ORDER BY w.warehouse_id;

-- Question-5: For each customer display the number of orders issued by the customer. If the customer does not have any orders, the result show display 0.
-- Q5 Solution --
SELECT c.customer_id, c.name  AS "Customer Name", 
       COALESCE(COUNT(o.customer_id),0) AS "Total number of Orders"
FROM customers c
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY c.customer_id;

-- Question-6: Write a SQL query to show the total and the average sale amount for each category.
-- Q6 Solution -- 
SELECT category_id, SUM(standard_cost * list_price) AS "Total Amount",
       ROUND(AVG(standard_cost * list_price), 2) AS "Average Amount"
FROM products
GROUP BY category_id
ORDER BY "Total Amount" DESC;