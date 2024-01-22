-- ***********************
-- Name: Neron Parmar
-- ID: 171690217
-- Date: 10/12/23
-- Purpose: Lab 3 DBS311
-- ***********************

-- Question-1: Write a SQL query to display the last name and hire date of all employees who were hired before the employee with ID 107 got hired. Sort the result by the hire date.
-- Q1 Solution --
SELECT last_name, hire_date
FROM employees
WHERE hire_date<(SELECT hire_date
                FROM employees
                WHERE employee_id = 107)
ORDER BY hire_date;

-- Question-2: Write a SQL query to display customer name and credit limit for customers with lowest credit limit. Sort the result by customer name.
-- Q2 Solution --
SELECT name, credit_limit
FROM customers
WHERE credit_limit = (SELECT MIN(credit_limit) FROM customers)
ORDER BY name;

-- Question-3: Write a SQL query to display the product ID, product name, and list price of the highest paid product(s) in each category.  Sort by category ID. 
-- Q3 Solution -- 
SELECT product_id, product_name, list_price
FROM products
WHERE list_price IN (SELECT MAX(list_price)
                    FROM products
                    GROUP BY category_id)
ORDER BY category_id;

-- Question-4: Write a SQL query to display the category name of the most expensive (highest list price) product(s).
-- Q4 Solution --
SELECT pc.category_name
FROM products p
INNER JOIN product_categories pc ON p.category_id = pc.category_id
WHERE p.list_price = (SELECT MAX(list_price) FROM products);

-- Question-5: Write a SQL query to display product name and list price for products in category 1 which have the list price less than the lowest list price in ANY category.  Sort the output by top list prices first and then by the product name.'
-- Q5 Solution --
SELECT product_name, list_price
FROM products
WHERE category_id = 1
AND list_price < ANY(SELECT MIN(list_price)
                    FROM products
                    WHERE category_id <> 1
                    GROUP BY category_id)
ORDER BY list_price DESC, product_name;

-- Question-6: Display product ID, product name, and category ID for products of the category(s) that the lowest price product belongs to.
-- Q6 Solution -- 
SELECT product_id, product_name, category_id
FROM products
WHERE list_price IN (SELECT MIN(list_price)
                     FROM products
                     GROUP BY category_id)
ORDER BY category_id;