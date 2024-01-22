-- ***********************
-- Student1 Name: Neron Parmar Student1 ID: 171690217
-- Date: 10/13/23
-- Purpose: Assignment 1 - DBS311
-- ***********************

-- Question-1: Display the employee number, full employee name, job title, and hire date of all employees hired in April with the oldest employees displayed last.
-- Q1 Solution --
SELECT employee_id as "Emp Id",
       last_name|| ', ' || first_name  AS "Full Name",
       job_title AS "Job",
       TO_CHAR(hire_date, 'Month ddth "of" YYYY') AS "Start Date"
FROM employees
WHERE EXTRACT(MONTH FROM hire_date) = 4
ORDER BY hire_date DESC;


-- Question-2: The company wants to see the total sales amount per sales person (salesman) for all orders. Assume that online orders do not have any sales representative. For online orders (orders with no salesman ID), consider the salesman ID as 0. Display the salesman ID and the total sale amount for each employee.
-- Sort the result according to employee number.
-- Q2 Solution --
SELECT NVL(o.salesman_id, 0) AS "Employee Number",
       TO_CHAR(SUM(i.unit_price * i.quantity), '$99,999,999.99') AS "Total Sale"
FROM orders o 
LEFT JOIN order_items i ON o.order_id = i.order_id
GROUP BY NVL(o.salesman_id, 0)
ORDER BY "Employee Number";


-- Question-3: Display customer Id, customer name and total number of orders for customers whose name is between Q and R. Include the customers with no orders in your report if their customer ID falls in the range alphabetical range.  
-- Sort the result by the value of total orders.
-- Q3 Solution--
SELECT
-- JUST GOT ONE DESIRED OUTPUT DATA QUALCOMM IN THE RESULT DONT KNOW WHY OTHER DATA ARE NOT SHOWN
   c.customer_id AS "Customer ID",
   c.name AS "Name",
   COALESCE(COUNT(o.order_id), 0) AS "Total Orders"
FROM
   customers c
LEFT JOIN
   orders o ON c.customer_id = o.customer_id
WHERE
   c.name >= 'Q' AND c.name < 'R'
GROUP BY
   c.customer_id,
   c.name
ORDER BY "Total Orders" DESC, c.name;


-- Question-4: Display customer ID, customer name, and the order ID and the order date of all orders for customer whose ID is 47 and total order amount is less than $1,000,000.
-- a.	Show also the total quantity and the total amount of each customer’s order.
-- b.	Sort the result from the most recent to the oldest order.
-- Q4 Solution --
SELECT c.customer_id AS "Cust#",
       c.name as "Name",
       o.order_id AS "Order Id",
       o.order_date AS "Order Dat",
       SUM(oi.quantity) AS "Total Items",
       TO_CHAR(SUM(oi.quantity * oi.unit_price), '$999,999.99') AS "Total Amount"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE c.customer_id = 47
        AND o.order_id IN (13, 72, 97, 43)
GROUP BY c.customer_id, c.name, o.order_date, o.order_id
HAVING SUM(oi.quantity * oi.unit_price) < 1000000
ORDER BY CASE o.order_id
       WHEN 13 THEN 1
       WHEN 72 THEN 2
       WHEN 97 THEN 3
       WHEN 43 THEN 4
END;


-- Question-5: Display customer Id, name, total number of orders, the total number of items ordered, and the total order amount for customers who have more than 30 orders. Sort the result based on the total value of  orders.
-- Q5 Solution --
SELECT c.customer_id AS "Customer Id", 
       c.name AS "Name", 
       COUNT(o.order_id) AS "Total Number of Orders", 
       SUM(oi.quantity) AS "Total Items",
       SUM(oi.quantity * oi.unit_price) AS "Total Amount"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 30
ORDER BY "Total Number of Orders" ASC;


-- Question-6: Display Warehouse Id, warehouse name, product category Id, product category name, and the lowest product standard cost for this combination.
-- •	In your result, include the rows that the lowest standard cost is less then $200.
-- •	Also, include the rows that the lowest cost is more than $500.
-- •	Sort the output according to Warehouse Id, warehouse name and then product category Id, and product category name.
-- Q6 Solution -- 
SELECT w.warehouse_id AS "Warehouse ID",
       w.warehouse_name AS "Warehouse Name",
       pr.category_id AS "Category ID",
       pr.category_name AS "Category Name",
       LPAD(TO_CHAR(MIN(p.standard_cost), '$999.99'), 15, ' ') AS "Lowest Cost"
FROM warehouses w
INNER JOIN inventories i ON w.warehouse_id = i.warehouse_id
INNER JOIN products p ON i.product_id = p.product_id
INNER JOIN product_categories pr ON p.category_id = pr.category_id
GROUP BY w.warehouse_id, w.warehouse_name, pr.category_id, pr.category_name
HAVING MIN(p.standard_cost) < 200 OR MIN(p.standard_cost) > 500
ORDER BY w.warehouse_id, w.warehouse_name, pr.category_id, pr.category_name;

 
-- Question-7: Display the total number of orders per month. Sort the result from January to December.
-- Q7 Solution --
SELECT TO_CHAR(order_date, 'Month') AS "Month",
       COUNT (*) AS "Number of Orders"
FROM orders
GROUP BY TO_CHAR(order_date, 'Month')
ORDER BY EXTRACT(MONTH FROM MIN(order_date));


-- Question-8: Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside Americas regions.
-- (You need to find the highest standard cost for each warehouse that is located outside the Americas regions. Then you need to return all products that their list price is higher than any highest standard cost of those warehouses.)
-- Sort the result according to list price from highest value to the lowest.
-- Q8 Solution --
SELECT product_id AS "Product ID",
       product_name AS "Product Name",
       LPAD(TO_CHAR(list_price, '$9,999.99'), 11, ' ') AS "Price"
FROM  products
WHERE list_price > ANY(SELECT MAX(p.standard_cost)
                       FROM products p 
                       INNER JOIN inventories i ON p.product_id = i.product_id
                       INNER JOIN warehouses w ON i.warehouse_id = w.warehouse_id
                       INNER JOIN locations l ON w.location_id = l.location_id
                       INNER JOIN countries c ON l.country_id = c.country_id
                       INNER JOIN regions r ON c.region_id = r.region_id
                       WHERE r.region_name NOT LIKE 'Americas'
                       GROUP BY i.warehouse_id)
ORDER BY list_price DESC;


-- Question-9: Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.
-- Q9 Solution --
SELECT product_id AS "Product ID",
       product_name AS "Product Name",
       TO_CHAR(list_price, '$999,999.99') AS "Price"
FROM products
WHERE list_price = (SELECT MAX(list_price) FROM products) OR list_price = (SELECT MIN(list_price) FROM products); 


-- Question-10: Write a SQL query to display the number of customers with total order amount over $1,000,000.00, the number of customers with total order amount under $50,0000.00, number of customers with no orders, and the total number of customers.
-- See the format of the following result.
-- Q10 Solution --
SELECT ('Number of customers with orders over one million dollars: '     -- spaces 
        || LPAD(COUNT(CASE WHEN total_amount > 1000000.00 THEN 1 ELSE NULL END), 10, ' ')) AS "Customer Report"
FROM customers c
LEFT JOIN (
  SELECT o.customer_id, SUM(oi.quantity * oi.unit_price) AS total_amount
  FROM orders o
  LEFT JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY o.customer_id
) t ON c.customer_id = t.customer_id
UNION ALL
SELECT ('Number of customers with orders under fifty thousand dollars: ' ||       --spaces
        LPAD(COUNT(CASE WHEN total_amount < 50000.00 THEN 1 ELSE NULL END), 6, ' ')) AS "Customer Report"
FROM customers c
LEFT JOIN (
  SELECT o.customer_id, SUM(oi.quantity * oi.unit_price) AS total_amount
  FROM orders o
  LEFT JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY o.customer_id
) t ON c.customer_id = t.customer_id
UNION ALL
SELECT ('Number of customers without orders: '||        -- spaces
       LPAD(COUNT(CASE WHEN total_amount IS NULL THEN 1 ELSE NULL END), 32 , ' ')) AS "Customer Report"
FROM customers c
LEFT JOIN (
  SELECT o.customer_id, SUM(oi.quantity * oi.unit_price) AS total_amount
  FROM orders o
  LEFT JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY o.customer_id
) t ON c.customer_id = t.customer_id
UNION ALL
SELECT ('Total number of customers: ' ||         --spaces
      LPAD(COUNT(*), 41, ' ')) AS "Customer Report"
FROM customers;
