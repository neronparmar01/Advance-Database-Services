-- ***********************
-- Name: Neron Parmar
-- ID: 171690217
-- Date: 10/19/2023
-- Midterm Test DBS311
-- ***********************

-- QUESTION-31: Management is considering limiting the inventory to only those products 
-- returning at least a 25% profit. Any product returning less than a 25% profit 
-- (unit price less standard cost) would be dropped from inventory and not reordered. 
-- Determine which products generate less than a 25% profit and how many of these products 
-- have been sold. Use column headers that are appropriate. 
-- Q31 SOLUTION --
SELECT p.product_name AS "Product Name", p.list_price, p.standard_cost,
    (p.list_price - p.standard_cost) AS "Profit",
    ROUND((((p.list_price - p.standard_cost) / p.standard_cost) * 100),2) AS "Profit Margin"
FROM
    products p
INNER JOIN
    inventories i ON p.product_id = i.product_id
WHERE
    ((p.list_price - p.standard_cost) / p.standard_cost) * 100 < 25
ORDER BY "Profit Margin";
    
    
-- QUESTION-32: Identify the five most frequently purchased products and the percentage 
-- of profit each product generates. The percentage of profit can be calculated by using 
-- the formula ((unit price - standard cost)/standard cost*100). You can only use a single 
-- query, but it can include one or more subqueries. Display the product name, product id, 
-- total quantity and profit percentage.
-- Q32 SOLUTION --
SELECT p.product_name AS "Product Name", p.product_id,
      ROUND((((p.list_price - p.standard_cost) / p.standard_cost) * 100),2) AS "Profit Percentage",
      oi.quantity
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
FETCH FIRST 5 ROWS ONLY;




  
