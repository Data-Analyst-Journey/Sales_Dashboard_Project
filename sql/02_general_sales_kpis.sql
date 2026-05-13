--=======================================
-- GENERAL SALES KPIs
-- Purpose: Analyse total sale's indexes
--=======================================
-- total revenue, unique customers,total orders, total products
SELECT
     SUM(total_buy) AS total_revenue,
	 COUNT(DISTINCT customer_code) AS unique_customers,
	 COUNT(DISTINCT invoice_id) AS total_orders,
	 COUNT(DISTINCT product_code) AS total_products
FROM invoices_data;

-- AOV value	 
SELECT AVG(order_value) AS avg_order_value
FROM(SELECT invoice_id, SUM(total_buy)AS order_value
     FROM invoices_data
     GROUP BY invoice_id);

-- Daily Revenue
SELECT gregorian_date,
       SUM(total_buy) AS revenue
FROM invoices_data
GROUP BY gregorian_date
ORDER BY revenue DESC;

-- Daily orders
SELECT gregorian_date, 
       COUNT(DISTINCT invoice_id) AS orders 
FROM invoices_data
GROUP BY gregorian_date
ORDER BY orders DESC;

-- weekly revenue
SELECT 
       DATE_TRUNC('week',gregorian_date) AS week,
       SUM(total_buy) AS revenue
FROM invoices_data
GROUP BY week
ORDER BY revenue DESC;

-- monthly revenue and number of orders to identify trends
SELECT DATE_TRUNC('month',Gregorian_Date) AS month,
       SUM(total_buy) AS monthly_revenue,
	   COUNT(DISTINCT invoice_id) AS monthly_orders
FROM invoices_data
GROUP BY 1
ORDER BY 1;

-- Which Day has the most revenue in a week & percentage of all revenue
WITH daily_sales AS (
SELECT 
   to_char(gregorian_date, 'Day') AS day_of_week,
   EXTRACT (DOW FROM gregorian_date) AS day_num,
   COUNT(DISTINCT invoice_id) AS num_invoices,
   SUM(total_buy) AS total_sales,
   AVG(total_buy) AS avg_sales_per_invoice
FROM invoices_data
WHERE gregorian_date >= '2025-03-01' AND gregorian_date <'2025-10-01'
GROUP BY day_of_week,day_num),
total_all_sales AS (
    SELECT SUM(total_sales) AS grand_total
	FROM daily_sales
)
SELECT 
   d.day_of_week,
   d.day_num,
   d.total_sales,
   ROUND((d.total_sales/t.grand_total)*100,2) AS percentage_of_total,
   d.num_invoices,
   d.avg_sales_per_invoice
FROM daily_sales d, total_all_sales t
ORDER BY d.total_sales DESC;

-- Total income per product-top 10
SELECT product_code, 
      SUM(total_buy) AS total_income_by_product
FROM invoices_data
GROUP BY product_code
ORDER BY total_income_by_product DESC
LIMIT 10;

--Finding total quantity sold per product
SELECT product_code,
  SUM(quantity) AS total_quantity_sold
FROM invoices_data
GROUP BY product_code
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Top SElling products by revenue
SELECT product_code,
       SUM(total_buy) AS total_revenue
FROM invoices_data
GROUP BY product_code
ORDER BY total_revenue DESC
LIMIT 10;

-- Products which have been purchased exactly once
SELECT product_code          
FROM invoices_data
GROUP BY product_code
HAVING COUNT(*)=1;

-- Calculate the percentage of products that were purchased only once
WITH SinglePurchaseProducts AS (
  SELECT product_code
  FROM invoices_data
  GROUP BY product_code
  HAVING COUNT(*)=1
)
SELECT (
     COUNT(spp.product_code)*100.0)/(SELECT COUNT(DISTINCT product_code)
	 FROM invoices_data)AS percentage_single_purchase
FROM SinglePurchaseProducts spp;

-- AVG of buying per product
SELECT product_code, ROUND(AVG(quantity)::numeric,2) AS avg_quantity
FROM invoices_data
GROUP BY product_code
ORDER BY avg_quantity DESC;

-- Growing Saling amount
SELECT month, revenue,revenue - LAG(revenue)OVER (ORDER BY month) 
       AS monthly_growth
FROM (SELECT DATE_TRUNC('month',gregorian_date) AS month,
       SUM(total_buy) AS revenue
	   FROM invoices_data
	   GROUP BY month)
ORDER BY month;	