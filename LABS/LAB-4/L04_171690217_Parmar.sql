-- ***********************
-- Name: Neron Parmar
-- ID: 171690217
-- Date: 10/19/23
-- Purpose: Lab 4 DBS311
-- ***********************

-- Question-1: Display cities that no warehouse is located in them. (use set operators to answer this question)
-- Q1 Solution --
SELECT city
FROM locations
WHERE location_id NOT IN (SELECT location_id
                          FROM warehouses)
ORDER BY city;

-- Question-2: Display the category ID, category name, and the number of products in category 1, 2, and 5. In your result, display first the number of products in category 5, then category 1 and then 2.
-- Q2 Solution --
SELECT pc.category_id, pc.category_name, COUNT(*)
FROM product_categories pc
LEFT OUTER JOIN products p ON pc.category_id = p.category_id
GROUP BY pc.category_id, pc.category_name
HAVING pc.category_id < 3 OR pc.category_id = 5
ORDER BY COUNT(*) DESC;

-- Question-3: Display product ID for ordered products whose quantity in the inventory is greater than 5. (You are not allowed to use JOIN for this question.)
-- Q3 Solution --
SELECT product_id
FROM products
INTERSECT (SELECT product_id
          FROM inventories
          WHERE quantity > 5);
          
-- Question-4: We need a single report to display all warehouses and the state that they are located in and all states regardless of whether they have warehouses in them or not.
-- Q4 Solution --
SELECT w.warehouse_name, l.state
FROM warehouses w
LEFT JOIN locations l ON w.location_id = l.location_id
UNION ALL
SELECT NULL AS warehouse_name, l.state
FROM locations l
ORDER BY state;



