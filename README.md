# 🛒 Sales Dashboard & Customer Analytics Project (AI-Enhanced)

📌 Project Overview

This project analyzes six months of real transactional data from a retail business to uncover hidden risks and opportunities. The goal was to move beyond basic reporting and deliver actionable insights that could directly improve business performance.

💼 Business Impact

Problem: The business had no clear view of its customer base or sales patterns, making it difficult to identify risks and opportunities. Management lacked the data needed to make informed strategic decisions.

Solution: I built an end-to-end analytics solution, including a PostgreSQL database, an interactive Power BI dashboard, and integrated AI-driven insights to analyze customer behavior, revenue concentration, and sales trends.

Outcomes:

· Risk Mitigation: Identified that the top 3 customers generate 43.36% of total revenue, with the single largest client accounting for 22.79%. This insight is now used to drive a customer diversification strategy.
· Operational Improvement: Discovered that 84.33% of revenue comes from just 20% of customers (Pareto Principle). This has led to the development of a loyalty program for high-value clients.
· Strategic Planning: Pinpointed that Thursdays generate 2x the revenue of Fridays, enabling the business to optimize staffing and marketing efforts around weekly patterns.
· Data-Driven Culture: The Power BI dashboard is now a standard tool used by management for monthly performance reviews, fostering a culture of data-driven decision-making.

🤖 AI-Enhanced Analysis

Using DeepSeek LLM, I generated automated insights from the SQL analysis, which highlighted critical findings such as:

· Customer concentration risk and recommendations for diversification.
· Underperforming weekdays and suggestions for promotional campaigns.
· Top customer behavior and loyalty program opportunities.

## Key Metrics Discovered

| Metric | Value |
|--------|-------|
| Total Revenue | 165,000,000,000 IRR |
| Total Invoices | 484 |
| Unique Customers | 116 |
| Unique Products | 685 |
| Top Customer Share (customer 31) | 22.79% |
| Top 3 Customer Share | 43.36% |
| Pareto (20% customers) | 84.33% of revenue |
| Best Day (Thursday) | 19.63% of revenue |
| Weakest Day (Friday) | 9.57% of revenue |

## Folder Structure

ecommerce_analytics/
├── data/
│ ├── raw/ ← Raw data (not uploaded to GitHub)
│ └── cleaned/ ← Cleaned data
├── python/
│ ├── ecommerce_etl_oop.ipynb ← Data cleaning pipeline
│ ├── ecommerce_analysis.ipynb ← RFM, Cohort, Pareto analysis
│ └── cleaning_history.json
├── powerbi/
│ ├── ecommerce_dashboard.pbix ← Power BI file
│ ├── ecommerce_dashboard.pdf ← PDF export
│ └── dashboard_preview/ ← Dashboard screenshots
├── reports/
│ └── quality_report.json
├── README.md
└── requirements.txt





Sales_Dashboard_Project/
├── data/raw/
│   ├── sales_data.csv
│   └── sales_data.xlsx
├── sql/
│   ├── 01_datacleaning.sql
│   ├── 02_general_sales_kpis.sql
│   ├── 03_customer_analysis.sql
│   └── 04_rfm_analysis.sql
├── reports/
│   ├── powerbi/
│   │   └── sales_dashboard.pbix
│   └── dashboard.pdf
├── ai_insights/
│   └── AI_insights.md
└── README.md




## Database Schema (PostgreSQL)

Table: `invoices_data`

| Column         | Type      | Description                          |
|----------------|-----------|--------------------------------------|
| invoice_id     | integer   | Unique invoice ID                    |
| customer_code  | varchar   | Customer ID                          |
| product_code   | varchar   | Product ID (190 unique products)     |
| quantity       | integer   | Units purchased                      |
| unit_price     | numeric   | Price per unit                       |
| total_buy      | numeric   | quantity * unit_price                |
| gregorian_date | date      | Invoice date (6-month range)         |

> All rows in one invoice share invoice_id, customer_code, gregorian_date.

## Power BI Dashboard Features

### Page 1 – Executive Summary
- KPI cards: Total Revenue, Total Orders, Unique Customers, AOV
- Date slicer (affects both pages)
- Revenue per month (vertical bar chart)
- Top 10 products by revenue (donut chart)

### Page 2 – Customer & Weekly Insights
- Sales by weekday (horizontal bar chart)
- Top 10 customers by revenue & invoice count
- Line chart: Revenue trend by month + weekday legend
- Customer AOV (calculated column)
- Order frequency per customer (clustered bar chart)
- RFM table visual (segment + customer count + RFM score)

## SQL Modules

| File                          | Content                                |
|-------------------------------|----------------------------------------|
| 01_datacleaning.sql           | NULLs, duplicates, negative values     |
| 02_general_sales_kpis.sql     | Revenue, orders, AOV, MoM              |
| 03_customer_analysis.sql      | Customer-level revenue, frequency, AOV |
| 04_rfm_analysis.sql           | Recency, Frequency, Monetary scoring   |

## Raw Data

- File: `data/raw/sales_data.xlsx` and `data/raw/sales_data.csv`
- Rows: 4089 rows
- Period: 6 consecutive months

## How to Reproduce

1. Set up PostgreSQL and run SQL files in order (01 → 04)
2. Connect Power BI Desktop to PostgreSQL
3. Load cleaned data and apply the described dashboard layout
4. Use date slicer for cross-page filtering
5. (Optional) Review AI insights in `/ai_insights/AI_insights.md`

## Deliverables

| File                          | Location                             |
|-------------------------------|--------------------------------------|
| Power BI file                 | reports/powerbi/sales_dashboard.pbix |
| PDF dashboard export          | reports/dashboard.pdf |
| PostgreSQL scripts            | sql/                                 |
| Raw Excel data                | data/raw/sales_data.xlsx and sales_data.csv |
| AI-generated insights         | ai_insights/AI_insights.md |

## Author
Portfolio project – SQL + Power BI + RFM + **AI integration (DeepSeek)** + interactive dashboard.

## License
Educational and portfolio use only. Data is anonymized real business data.
