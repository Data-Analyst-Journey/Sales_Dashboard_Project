```markdown
# 🛒 Sales Analytics & Predictive Modeling Project

[![Python](https://img.shields.io/badge/Python-3.9%2B-blue.svg)](https://www.python.org/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-1.0.2-orange.svg)](https://scikit-learn.org/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow.svg)](https://powerbi.microsoft.com/)
[![dbt](https://img.shields.io/badge/dbt-Data%20Build%20Tool-orange.svg)](https://www.getdbt.com/)

## 📌 Project Overview

This project is a **comprehensive end-to-end sales analytics case study** for a retail business. It started with data extraction and cleaning (PostgreSQL), moved to interactive dashboarding (Power BI), and evolved into advanced predictive analytics (Python). The goal was to not only understand historical sales patterns but also to forecast future sales and identify customers at risk of churning.

**Key Business Questions Answered:**
- Who are our most valuable customers, and how concentrated is our revenue?
- What are the weekly sales patterns? (e.g., best/worst performing days)
- Can we predict daily sales for the next week?
- Which customers are likely to churn, and what are their characteristics?
- What product combinations are frequently bought together?

---

## 🔍 Key Analyses & Findings

### 1. Data Warehousing & Descriptive Analytics (PostgreSQL)
- Designed a **data model** and wrote complex SQL queries to extract insights.
- **Key Finding:** Identified that **20% of customers contribute to 84.33% of total revenue**, exceeding the Pareto principle. This high dependency on a small customer base poses a significant business risk.

### 2. Interactive Dashboard (Power BI)
- Built a **4-page interactive dashboard** to visualize sales performance, customer segments, and product trends.
- Enabled stakeholders to **filter data dynamically** by date, product, and customer.

### 3. Predictive Modeling (Python & Scikit-learn)

#### 📈 Sales Forecasting (Random Forest Regressor)
- **Goal:** Forecast daily sales for the upcoming week.
- **Features:** Temporal variables (day of week, month, day of year).
- **Evaluation:** R² = -0.066, MAE = [X].
- **Interpretation:** The model underperforms compared to a simple average baseline. This highlights the **high volatility** of daily sales and the need for additional features (e.g., promotions, holidays, external economic indicators) for better accuracy. This is a valuable lesson in feature engineering and model limitations.

#### 🔮 Churn Prediction (Random Forest Classifier)
- **Goal:** Identify customers at risk of churning (no purchase in the last 30 days).
- **Features:** Total revenue, average revenue per purchase, purchase count.
- **Evaluation:** *(Insert model metrics: Precision, Recall, F1-Score)*
- **Business Value:** The model successfully flags high-risk customers, enabling proactive retention efforts (e.g., special offers, personalized outreach).

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
| **Machine Learning** | Scikit-learn (Random Forest) |
| **Version Control** | Git & GitHub |

---

## 📂 Repository Structure


Sales_Dashboard_Project/
│
├── data/ # Raw data (CSV) - excluded from Git
├── sql_queries/ # PostgreSQL analytical queries
├── python_analysis/ # Python deep-dive analysis
│ ├── sales_analytics_deep_dive.py
│ ├── requirements.txt
│ └── output/ # Saved plots (sales_trends.png)
├── dashboard/ # Power BI files
└── README.md # This file


---

🚀 How to Run the Python Analysis

1. Clone the Repository:
   
   git clone https://github.com/Data-Analyst-Journey/Sales_Dashboard_Project.git
   cd Sales_Dashboard_Project
   
2. Install Dependencies:
   
   pip install -r python_analysis/requirements.txt
   
3. Run the Script:
   
   python python_analysis/sales_analytics_deep_dive.py
   
4. Check Outputs:
   · Model evaluation metrics appear in the terminal.
   · Sales trends plot is saved as output/sales_trends.png.

---

📊 Results & Business Recommendations

Insight Business Recommendation
20% of customers generate 84.33% of revenue. Diversify customer base by targeting mid-level customers.
Thursday is the busiest day; Friday is the slowest. Introduce Friday promotions to balance weekly sales.
Sales forecasting model needs improvement. Incorporate external data (holidays, promotions, weather).
Churn prediction model identifies at-risk customers. Implement a loyalty program or targeted offers for high-risk customers.

---

📈 Lessons Learned

· Feature Engineering is Key: The poor performance of the sales forecasting model (R² = -0.066) was a humbling reminder that good models require good features. Future work should focus on incorporating external, business-relevant variables.
· Business Impact: Even a simple churn prediction model can provide immediate business value by enabling proactive customer retention.
· End-to-End Thinking: This project solidified my understanding of the entire data pipeline: from data extraction and warehousing to dashboarding and predictive modeling.

---

📫 Connect with Me

· LinkedIn: linkedin.com/in/samaneh-kavianfar
· GitHub: github.com/Data-Analyst-Journey

---

📜 License

This project is for portfolio purposes and is not licensed for commercial use.


