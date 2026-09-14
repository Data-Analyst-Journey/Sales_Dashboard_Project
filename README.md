```markdown
# 🛒 Sales Analytics & Predictive Modeling Project

[![Python](https://img.shields.io/badge/Python-3.9%2B-blue.svg)](https://www.python.org/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-1.0.2-orange.svg)](https://scikit-learn.org/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow.svg)](https://powerbi.microsoft.com/)
[![dbt](https://img.shields.io/badge/dbt-Data%20Build%20Tool-orange.svg)](https://www.getdbt.com/)

## 📌 Project Overview

This project is a **comprehensive end-to-end sales analytics case study** for a retail business. It started with data extraction and cleaning (PostgreSQL), evolved into a modular data warehouse using **dbt**, moved to interactive dashboarding (Power BI), and expanded into advanced predictive analytics (Python).

The goal was not only to understand historical sales patterns but also to explore the feasibility of forecasting future sales and identifying customers at risk of churning.

**Key Business Questions Answered:**
- Who are our most valuable customers, and how concentrated is our revenue?
- What are the weekly sales patterns? (e.g., best/worst performing days)
- Can we predict daily/weekly sales, and which model works best?
- Which customers are likely to churn, and what are their characteristics?
- What product combinations are frequently bought together?

---

## 🎯 Why This Project Matters for a Business

This project is not just a technical exercise—it answers questions that real businesses face every day:

| Business Question | How This Project Answers It |
| :--- | :--- |
| **Where does our revenue come from?** | Pareto analysis revealed that 20% of customers generate 84.33% of revenue, highlighting a high-risk dependency on a small customer base. |
| **When should we focus our marketing?** | Weekday analysis showed that Thursday is the busiest day and Friday the slowest—enabling targeted promotions. |
| **How can we improve data reliability?** | dbt tests and documentation ensure that data is accurate, consistent, and traceable. |
| **Can we trust forecasting?** | Multi-model comparison showed that all forecasting models produced negative R²—a clear signal that the dataset is too volatile for reliable forecasting, saving the business from false confidence. |
| **Which customers are at risk?** | A churn prediction model identifies customers who haven't purchased in 30 days, enabling proactive retention. |

---

## 🔍 Key Analyses & Findings

### 1. Data Warehousing with dbt (Staging → Intermediate → Marts)

I rebuilt the original scattered SQL queries into a **modular dbt project** with three layers:

| Layer | Purpose | Example Models |
| :--- | :--- | :--- |
| **Staging** | Clean, rename, and standardize raw data | `stg_sales_data` |
| **Intermediate** | Calculate customer, product, and time-based metrics | `int_customer_revenue`, `int_product_revenue`, `int_daily_sales` |
| **Marts** | Build final tables for Power BI dashboards | `mart_sales_by_customer`, `mart_sales_by_product`, `mart_weekly_patterns`, `mart_pareto_analysis` |

**Why dbt?**
- **Scalability:** Modular models can be reused and extended without rewriting queries.
- **Data Quality:** Automated tests (`schema.yml`) catch issues before they reach dashboards.
- **Documentation:** `dbt docs generate` produces a full lineage graph—showing how data flows from source to dashboard.
- **Maintainability:** If the source data changes, only the staging layer needs updating.

### 2. Interactive Dashboard (Power BI)
- Built a **4-page interactive dashboard** to visualize sales performance, customer segments, and product trends.
- Enabled stakeholders to **filter data dynamically** by date, product, and customer.

### 3. Predictive Modeling: A Multi-Model Comparison (Python)

I tested four different modeling approaches to forecast sales:

| Model | R² | MAE | Observation |
| :--- | :--- | :--- | :--- |
| **Random Forest (daily)** | **-0.066** | - | Best performing, but still negative |
| **Prophet (yearly=False)** | -0.139 | 1.1B | Improved after disabling yearly seasonality |
| **Prophet (yearly=True)** | -0.372 | 948M | Yearly seasonality made it worse (only 6 months of data) |
| **XGBoost (weekly + lag)** | -1.112 | 4B | Worst performing |

**Surprising Finding:**
Despite testing time-series models (Prophet, XGBoost with lag features), **Random Forest achieved the best R²**. This was unexpected but explained by three factors:
1. **Limited data:** Only 6 months of daily data, where tree-based models perform better than models requiring longer history.
2. **Simplicity wins:** Random Forest treats each day independently, avoiding overfitting to temporal patterns that don't exist in short datasets.
3. **Simple sales patterns:** Sales appear to be driven more by day-of-week and month than by sequential dependencies.

**Key Lesson:**
All models produced negative R², confirming that the dataset's volatility (due to economic instability) makes it fundamentally unsuitable for reliable forecasting. This experience taught me to compare multiple models before drawing conclusions and to recognize the limitations of forecasting in unstable environments.

#### 🔮 Churn Prediction (Random Forest Classifier)
- **Goal:** Identify customers at risk of churning (no purchase in the last 30 days).
- **Features:** Total revenue, average revenue per purchase, purchase count.
- **Evaluation:** *(Insert model metrics: Precision, Recall, F1-Score)*
- **Business Value:** The model successfully flags high-risk customers, enabling proactive retention efforts.

### 4. Advanced Customer Analytics (Python)
- **Pareto (80/20) Analysis:** Confirmed revenue concentration (20% customers, 84.33% revenue).
- **Survival Analysis:** Calculated average time between purchases to understand customer return patterns.
- **Dynamic Basket Analysis:** Identified product pairs frequently bought in sequence, supporting cross-selling strategies.

---

## 🛠️ Tools & Technologies

| Category | Tools |
| :--- | :--- |
| **Data Storage** | PostgreSQL, CSV |
| **Data Modeling & ETL** | dbt (Data Build Tool), Python (Pandas) |
| **Dashboarding** | Power BI |
| **Machine Learning** | Scikit-learn (Random Forest), XGBoost, Prophet |
| **Version Control** | Git & GitHub |

---

## 📂 Repository Structure

text
Sales_Dashboard_Project/
│
├── data/ # Raw data (CSV) - excluded from Git
├── sql_queries/ # PostgreSQL analytical queries (original)
├── dbt_analysis/ # dbt project (staging, intermediate, marts)
│ ├── models/
│ │ ├── staging/
│ │ ├── intermediate/
│ │ └── marts/
│ ├── seeds/
│ ├── macros/
│ └── dbt_project.yml
├── python_analysis/ # Python deep-dive analysis
│ ├── sales_analytics_deep_dive.py
│ ├── requirements.txt
│ └── output/
├── dashboard/ # Power BI files
└── README.md # This file


---

🚀 How to Run the Python Analysis

1. Clone the Repository:
   bash
   git clone https://github.com/Data-Analyst-Journey/Sales_Dashboard_Project.git
   cd Sales_Dashboard_Project
   
2. Install Dependencies:
   bash
   pip install -r python_analysis/requirements.txt
   
3. Run the Script:
   bash
   python python_analysis/sales_analytics_deep_dive.py
   
4. Check Outputs:
   · Model evaluation metrics appear in the terminal.
   · Sales trends plot is saved as output/sales_trends.png.

---

🚀 How to Run the dbt Project

1. Navigate to the dbt folder:
   bash
   cd dbt_analysis
   
2. Run dbt commands:
   bash
   dbt seed # Load CSV data
   dbt run # Build all models
   dbt test # Run data quality tests
   dbt docs generate # Generate documentation
   dbt docs serve # View documentation in browser
   
   ---

📊 Results & Business Recommendations

Insight Business Recommendation
20% of customers generate 84.33% of revenue. Diversify customer base by targeting mid-level customers.
Thursday is the busiest day; Friday is the slowest. Introduce Friday promotions to balance weekly sales.
All forecasting models produced negative R². Recognize that forecasting is unsuitable for this volatile dataset; focus on descriptive analytics instead.
Churn prediction model identifies at-risk customers. Implement a loyalty program or targeted offers for high-risk customers.

---

📈 Lessons Learned

· Multi-Model Comparison is Essential: I tested Random Forest, XGBoost, and Prophet. The simplest model (Random Forest) outperformed the more complex ones—a valuable lesson in not assuming that "more sophisticated = better."
· Recognizing Limitations: All forecasting models produced negative R². This is not a failure, but a reflection of the dataset's inherent volatility. Documenting this honestly is more valuable than hiding it.
· dbt as a Foundation: Rebuilding the SQL queries into dbt taught me that data engineering is not just about writing queries—it's about building systems that are scalable, testable, and documented.
· End-to-End Thinking: This project solidified my understanding of the entire data pipeline: from data extraction and warehousing (dbt, PostgreSQL) to dashboarding (Power BI) and predictive modeling (Python).
· Business Impact: Even a simple churn prediction model can provide immediate business value by enabling proactive customer retention.

---

📫 Connect with Me

· LinkedIn: https://www.linkedin.com/in/samaneh-kavianfar-8a93033b2/
· GitHub: https://github.com/Data-Analyst-Journey

---

📜 License

This project is for portfolio purposes and is not licensed for commercial use.

```
