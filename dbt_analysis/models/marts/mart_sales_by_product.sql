WITH product_data AS (
    SELECT * FROM {{ ref('int_product_revenue') }}
)
SELECT
    product_code,
    total_quantity,
    total_revenue,
    avg_revenue,
    sales_days,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM product_data
ORDER BY total_revenue DESC    