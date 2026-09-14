WITH daily AS (
    SELECT * FROM {{ ref('int_daily_sales') }}
)
SELECT
    weekday_num,
    weekday AS day_name,
    SUM(daily_revenue) AS total_revenue,
    AVG(daily_revenue) AS avg_daily_revenue,
    SUM(daily_orders) AS total_orders
FROM daily
GROUP BY weekday_num, weekday
ORDER BY weekday_num    