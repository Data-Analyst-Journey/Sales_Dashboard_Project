WITH customer_data AS (
    SELECT * FROM {{ ref('int_customer_revenue') }}
)
SELECT
    customer_code,
    total_revenue,
    avg_revenue,
    purchase_days,
    first_purchase,
    last_purchase,
    customer_lifetime_days,
    ROUND(total_revenue / NULLIF(purchase_days, 0), 2) AS revenue_per_day,
    ROUND(total_revenue / NULLIF(customer_lifetime_days, 0), 2) AS revenue_per_lifetime_day
FROM customer_data
ORDER BY total_revenue DESC    