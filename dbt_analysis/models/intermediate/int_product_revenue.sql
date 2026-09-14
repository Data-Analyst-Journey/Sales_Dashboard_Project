WITH sales AS (
    SELECT
        product_code,
        quantity,
        revenue,
        sale_date
    FROM {{ ref('stg_sales_data') }}    
)
SELECT
    product_code,
    SUM(quantity) AS total_quantity,
    SUM(revenue) AS total_revenue,
    AVG(revenue) AS avg_revenue,
    COUNT(DISTINCT sale_date) AS sales_days
FROM sales
GROUP BY product_code
ORDER BY total_revenue DESC    