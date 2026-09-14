SELECT
    sale_date,
    weekday,
    weekday_num,
    EXTRACT(DOW FROM sale_date) AS day_of_week,
    EXTRACT(MONTH FROM sale_date) AS month,
    EXTRACT(YEAR FROM sale_date) AS year,
    SUM(revenue) AS daily_revenue,
    COUNT(DISTINCT invoice_id) AS daily_orders
FROM {{ ref('stg_sales_data') }}
GROUP BY sale_date, weekday, weekday_num
ORDER BY sale_date    