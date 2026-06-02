# 🛒 Sales Dashboard & Customer Analytics Project (AI-Enhanced)

## Project Overview
This project analyzes six months of real transactional data from a retail business, including:
- PostgreSQL database (`invoices_data` table) with data cleaning, KPIs, customer analysis, and RFM segmentation
- Interactive Power BI dashboard (2 pages, dynamic filtering)
- **DeepSeek AI integration** for automated business insights (Pareto analysis, day-of-week patterns, customer concentration)
- Raw Excel data (your row count here rows)

## Folder Structure
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

## AI-Enhanced Analysis (`/ai_insights/AI_insights.md`)

Using DeepSeek LLM, I generated automated business insights from the SQL analysis results:

**Key AI-Generated Findings:**
- **Pareto Principle:** 20% of customers generate 84.33% of total revenue (24 customers out of 120)
- **Customer concentration risk:** Top 3 customers (31, 58, 13) account for 43.36% of revenue
- **Day-of-week pattern:** Friday generates 19.63% of revenue (2x Thursday's 9.57%)
- **Top customer behavior:** Customer 31 alone represents 22.79% of total revenue
- **Product concentration:** Top product represents 18.75% of total revenue

**AI Recommendations:**
- Create loyalty program for top 20% customers (avg 10.3 invoices each, 207 units per purchase)
- Investigate Thursday's weak performance (50% lower than Friday)
- Develop customer acquisition strategy to reduce dependency on top 3 customers

*Full AI output available in [`/ai_insights/AI_insights.md`](./ai_insights/AI_insights.md)*

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
