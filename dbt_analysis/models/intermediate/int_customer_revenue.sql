WITH sales As (
    SELECT
        customer_code,
        revenue,
        sale_date
    FROM {{ ref('stg_sales_data') }}    
)

SELECT
    customer_code,
    COUNT(DISTINCT sale_date) AS purchase_days,
    SUM(revenue) AS total_revenue,
    AVG(revenue) AS avg_revenue,
    MIN(sale_date) AS first_purchase,
    MAX(sale_date) AS last_purchase,
    ((MAX(sale_date) - MIN(sale_date))) AS customer_lifetime_days
FROM sales
GROUP BY customer_code    