-- models/staging/stg_sales_data.sql

WITH source_data AS (
    SELECT
        invoice_id,
        customer_code,
        product_code,
        quantity,
        unit_price,
        "date" AS sale_date, 
        revenue,
        weekday,
        weekday_num, 
        -- Optional: extract year and month for time-based analysis
        EXTRACT(YEAR FROM "date") AS sale_year,
        EXTRACT(MONTH FROM "date") AS sale_month

    FROM {{ ref('sales_data_cleaned') }} 
)
SELECT
    invoice_id,
    customer_code,
    product_code,
    quantity,
    unit_price,
    sale_date,
    revenue,
    weekday,
    weekday_num,
    sale_year,
    sale_month

FROM source_data
-- Remove rows with missing critical fields
WHERE customer_code IS NOT NULL 
  AND product_code IS NOT NULL
  AND quantity > 0