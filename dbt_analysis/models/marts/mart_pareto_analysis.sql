WITH customer_revenue AS (
    SELECT
        customer_code,
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        SUM(total_revenue) OVER () AS grand_total
    FROM {{ ref('int_customer_revenue') }}    
)
SELECT
    customer_code,
    total_revenue,
    revenue_rank,
    ROUND((total_revenue / grand_total) * 100, 2) AS revenue_percentage,
    ROUND(
        (SUM(total_revenue) OVER (ORDER BY revenue_rank) / grand_total) * 100, 2
    ) AS cumulative_percentage
FROM customer_revenue
ORDER BY revenue_rank    