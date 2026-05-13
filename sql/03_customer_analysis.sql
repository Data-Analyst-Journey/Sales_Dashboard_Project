--===========================================
-- CUSTOMER ANALYSIS
--Purpose: Identify Customer Behavior
--===========================================
-- Top 10 customers by higher number of invoices 
SELECT customer_code, 
       COUNT(DISTINCT invoice_id) AS number_of_purchases,
	   SUM(total_buy) AS total_spent
FROM invoices_data
GROUP BY customer_code
ORDER BY number_of_purchases DESC
LIMIT 10;

-- Avg Customer revenue
SELECT AVG(customer_revenue) AS avg_customer_revenue
FROM (SELECT customer_code,SUM(total_buy) AS customer_revenue
       FROM invoices_data
	   GROUP BY customer_code)t;
	   
-- finding customers with more than one purchase
SELECT
    COUNT(customer_code) AS repeat_customers_count
FROM (SELECT  customer_code FROM invoices_data
GROUP BY customer_code
HAVING COUNT(DISTINCT invoice_id)>1) AS repeat_buyers;

-- How much time each customer buy 
SELECT  customer_code, COUNT(invoice_id) AS repeated_buy FROM invoices_data
GROUP BY customer_code
HAVING COUNT(DISTINCT invoice_id)>1
ORDER BY repeated_buy DESC;

-- AVG days between orders 
SELECT customer_code,round(AVG(next_date-gregorian_date)::numeric, 2)AS avg_days_between_orders
FROM(
  SELECT customer_code,gregorian_date,
         LEAD(gregorian_date) OVER (PARTITION BY customer_code ORDER BY gregorian_date)
		 AS next_date
		 FROM invoices_data)
WHERE next_date IS NOT NULL
GROUP BY customer_code
ORDER BY avg_days_between_orders; 

-- Top 20% customers share of total sales
SELECT ROUND(
      SUM(total_spent) 
       FILTER (WHERE rank<=total_customers*0.2)/
	   SUM(total_spent),3) AS top20_share
FROM(SELECT customer_code,
            SUM(total_buy) AS total_spent,
			RANK() OVER (ORDER BY SUM(total_buy)DESC) AS rank,
			COUNT(*)OVER() AS total_customers
			FROM invoices_data
			GROUP BY customer_code
			);	  

-- rank,total spending and percentage of total sales for top 20% of customers
WITH customer_totals AS (SELECT customer_code,
                                SUM(total_buy) AS total_spent,
								RANK() OVER(ORDER BY SUM(total_buy) DESC) AS rnk,
								COUNT(*) OVER() AS total_customers,
								SUM(SUM(total_buy))OVER() AS grand_total
						 FROM invoices_data
						 GROUP BY customer_code
								)
SELECT customer_code,
       total_spent,
	   rnk AS rank_in_all_customers,
	   ROUND(total_spent/grand_total*100,2) AS percent_of_total_sales
	   FROM customer_totals
	   WHERE rnk<=total_customers*0.2
	   ORDER BY rnk;
	   