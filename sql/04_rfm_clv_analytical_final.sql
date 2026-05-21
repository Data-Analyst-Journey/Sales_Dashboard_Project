--======================================
-- RFM SEGMENTATION
-- Purpose: Calculating Recency, Frequency and Monetary per customer
--=================================================
WITH reference_date AS (
    SELECT MAX(gregorian_date) AS ref_date
	FROM invoices_data
	),
rfm_base AS (
SELECT
    i.customer_code,
	rd.ref_date,
	(rd.ref_date-MAX(i.gregorian_date))::integer AS recency,
	COUNT(DISTINCT i.invoice_id) AS frequency, 
	SUM(i.total_buy) AS monetary
FROM invoices_data i
CROSS JOIN reference_date rd
GROUP BY i.customer_code,
rd.ref_date
),
rfm_scored AS (
   SELECT 
       customer_code,
	   recency,
	   frequency,
	   monetary,
	   NTILE(5) OVER (ORDER BY recency DESC) AS r_score, -- less is better
	   NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,-- more is better
	   NTILE(5) OVER (ORDER BY monetary ASC) AS m_score --more is better
   FROM rfm_base	   
),
rfm_final AS (
  SELECT 
     customer_code,
	 recency,
	 frequency,
	 monetary,
	 r_score,
	 f_score,
	 m_score,
	 (r_score + f_score + m_score) AS rfm_score,
	 CASE
	     WHEN r_score = 5 AND f_score>=4 AND m_score>=4 THEN 'CHAMPIONS'
		 WHEN r_score>=4 AND f_score>=3 AND m_score>=3 THEN 'LOYAL'
		 WHEN r_score>=3 AND f_score>=3 AND m_score>=2 THEN 'POTENTIAL_LOYALIST'
		 WHEN r_score>=4 AND f_score=1 THEN 'NEW_CUSTOMER'
		 WHEN r_score>=3 AND f_score=1 THEN 'PROMISING'
		 WHEN r_score>=2 AND f_score>=2 AND m_score>=2 THEN 'NEED_ATTENTION'
		 WHEN r_score<=2 AND f_score>=3 THEN 'AT_RISK'
		 WHEN r_score=1 AND f_score>=3 THEN 'CANT_LOSE_THEM'
		 WHEN r_score=1 AND f_score=1 THEN 'LOST'
		 ELSE 'OTHER'
		     END AS segment
		 FROM rfm_scored
		 )
SELECT
      segment,
	  COUNT(customer_code) AS customer_count,
	  ROUND(AVG(recency),1) AS avg_recency,
	  ROUND(AVG(frequency),1) AS avg_frequency,
	  ROUND(AVG(monetary),2) AS avg_monetary,
	  ROUND(AVG(rfm_score),2) AS avg_rfm_score
	  FROM rfm_final
	  GROUP BY segment
	  ORDER BY avg_rfm_score DESC;
	  
-- Pairing the products
WITH pairs AS (
   SELECT
       a.invoice_id,
	   a.product_code AS product_a,
	   b.product_code AS product_b,
	   a.total_buy AS amount_a,
	   b.total_buy AS amount_b
   FROM invoices_data a
   JOIN invoices_data b
       ON a.invoice_id = b.invoice_id
	   AND a.product_code < b.product_code )
SELECT * FROM pairs;	   

-- Support, Confidence, Lift
WITH reference_date AS (
    SELECT MAX(gregorian_date) AS ref_date
	FROM invoices_data
),
total_invoices AS (
     SELECT COUNT(DISTINCT invoice_id) AS total_n
	 FROM invoices_data
	 ),
pairs AS (
    SELECT
	      a.invoice_id,
		  a.product_code AS product_a,
		  b.product_code AS product_b
	FROM invoices_data a
	JOIN invoices_data b
	    ON a.invoice_id = b.invoice_id
		AND a.product_code < b.product_code
),
pair_counts AS (
    SELECT
	     product_a,
		 product_b,
		 COUNT(*) AS pair_count
	FROM pairs
	GROUP BY product_a, product_b
),
single_counts AS (
   SELECT
        product_code,
		COUNT(DISTINCT invoice_id) AS product_n
   FROM invoices_data
   GROUP BY product_code
),
metrics AS (
    SELECT
	     pc.product_a,
		 pc.product_b,
		 pc.pair_count,
		 tn.total_n,
		 sc_a.product_n AS count_a,
         sc_b.product_n AS count_b,
         ROUND(pc.pair_count::numeric / tn.total_n, 4)                        AS support,
         ROUND(pc.pair_count::numeric / NULLIF(sc_a.product_n, 0), 4)          AS confidence_a_to_b,
         ROUND(pc.pair_count::numeric / NULLIF(sc_b.product_n, 0), 4)          AS confidence_b_to_a,
         ROUND(
            (pc.pair_count::numeric / tn.total_n) /
            NULLIF((sc_a.product_n::numeric / tn.total_n) *
                   (sc_b.product_n::numeric / tn.total_n), 0),4) AS lift
    FROM pair_counts pc
    CROSS JOIN total_invoices tn
    JOIN single_counts sc_a ON sc_a.product_code = pc.product_a

JOIN single_counts sc_b ON sc_b.product_code = pc.product_b
)
SELECT
    product_a,
    product_b,
    pair_count,
    support,
    confidence_a_to_b,
    confidence_b_to_a,
    lift
FROM metrics
WHERE support     > 0.01    -- at least 
  AND confidence_a_to_b > 0.1
ORDER BY lift DESC, support DESC
LIMIT 50;

-- CLV
WITH reference_date AS (
   SELECT MAX(gregorian_date) AS ref_date
   FROM invoices_date
),
customer_stats AS (
   SELECT 
      customer_code,
	  rd.ref_date,
	  MIN(i.gregorian_date) AS first_purchase,
	  MAX(i.gregorian_date) AS last_purchase,
	  COUNT(DISTINCT i.invoice_id) AS total_orders,
	  SUM(i.total_buy) AS total_revenue,
	  ROUND(SUM(i.total_buy)/NULLIF(COUNT(DISTINCT i.invoice_id),0),2) AS avg_order_value,
	  COUNT(DISTINCT DATE_TRUNC('month', i.gregorian_date)) AS active_months
	  FROM invoices_data i
	  CROSS JOIN reference_date rd
	  GROUP BY customer_code,
	  rd.ref_date
)
SELECT 
     customer_code,
	 first_purchase,
	 last_purchase,
	 total_orders,
	 total_revenue AS clv_6month,
	 avg_order_value,
	 active_months,
	 CASE
	    WHEN total_revenue >= (SELECT PERCENTILE_CONT(0.80) WITHIN
		GROUP(ORDER BY total_revenue)
		FROM customer_stats)
		THEN 'HIGH_VALUE'
		WHEN total_revenue>=(SELECT PERCENTILE_CONT(0.50) WITHIN
		GROUP (ORDER BY total_revenue)
		FROM customer_stats)
		THEN 'MEDIUM_VALUE'
		ELSE 'LOW_VALUE'
	 END AS clv_tier
	 FROM customer_stats
	 ORDER BY clv_6month DESC;

-- Monthly Retention Rate 
WITH first_purchases AS (
    SELECT 
	     customer_code,
		 DATE_TRUNC('month',MIN(gregorian_date)) AS cohort_month
	FROM invoices_data
	GROUP BY customer_code
),
cohort_data AS (
   SELECT 
       i.customer_code,
	   fp.cohort_month,
	   DATE_TRUNC('month',i.gregorian_date) AS activity_month
   FROM invoices_data i
   JOIN first_purchases fp ON
   i.customer_code = fp.customer_code
),
cohort_counts AS (
    SELECT
	   cohort_month,
	   activity_month,
	   COUNT( DISTINCT customer_code) AS customers
	FROM cohort_data
	GROUP BY cohort_month,activity_month
),
cohort_size AS (
   SELECT 
      cohort_month,
	  MAX(CASE WHEN activity_month = cohort_month THEN customers END) AS cohort_size
   FROM cohort_counts
   GROUP BY cohort_month
),
retention_calc AS (
    SELECT
	   cc.cohort_month,
	   cc.activity_month,
	   cc.customers,
	   cs.cohort_size,
	   ROUND(cc.customers::numeric/cs.cohort_size * 100,1) AS retention_pct
	FROM cohort_counts cc 
	JOIN cohort_size cs ON cc.cohort_month = cs.cohort_month
	)
SELECT 
     activity_month AS month,
	 COUNT(DISTINCT cohort_month) AS cohorts_count,
	 SUM(cohort_size) AS total_cohort_size,
	 ROUND(SUM(customers)::numeric/NULLIF(SUM(cohort_size),0)*100,1) AS avg_retention_pct
FROM retention_calc
GROUP BY activity_month
ORDER BY activity_month;
