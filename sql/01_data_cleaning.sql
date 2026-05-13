--======================================
-- DATA CLEANING SCRIPT
-- Purpose: Clean and validate raw data
--=======================================
-- Creating table
CREATE TABLE invoices_data( 
       invoice_id TEXT,
	   customer_code VARCHAR,
	   product_code TEXT,
	   quantity FLOAT,
	   unit_price BIGINT,
	   invoice_date VARCHAR,
	   row_id TEXT,
	   total_buy BIGINT,
	   Gregorian_Date DATE
	   )
  
-- checking for data type
SELECT column_name,data_type
FROM information_schema.columns
WHERE table_name = 'invoices_data';

-- Creating Index
CREATE INDEX idx_invoice_date ON invoices_data(gregorian_date);
CREATE INDEX idx_customer ON invoices_data(customer_code);
CREATE INDEX idx_product ON invoices_data(product_code);

-- Number of all records
SELECT COUNT(*) AS total_rows
FROM invoices_data;

-- Finding null values
SELECT * 
FROM invoices_data
WHERE quantity IS NULL
   OR unit_price IS NULL
   OR total_buy IS NULL
   OR customer_code IS NULL
   OR product_code IS NULL
   OR gregorian_date IS NULL;
   
-- Check for negative values
SELECT *
FROM invoices_data
WHERE quantity<0 OR unit_price<0 OR total_buy<0;

-- Finding false values in total buy
SELECT * 
   FROM invoices_data
   WHERE total_buy <> quantity * unit_price;

-- Finding repeated values
SELECT invoice_id, product_code,
       COUNT(*) AS cnt
FROM invoices_data
GROUP BY invoice_id,product_code
HAVING COUNT(*)>1;

-- Finding wrong values
SELECT *
   FROM invoices_data
   WHERE quantity::TEXT !~ '^[0-9]+(\.[0-9]+)?$'
   OR    unit_price::TEXT !~'^[0-9]+(\.[0-9]+)?$'
   OR    total_buy::TEXT !~ '^[0-9]+(\.[0-9]+)?$';

--Checking for invalid date values
SELECT max(gregorian_date), min(gregorian_date)
FROM invoices_data;