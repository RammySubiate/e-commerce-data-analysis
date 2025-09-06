# Sales Analytics Dashboard Portfolio

## Project Overview
This project demonstrates an end-to-end data analytics workflow using **Python, SQL, and Power BI**. The goal is to clean, transform, and analyze sales transaction data, and create a dashboard for business insights.

**Stakeholders questions based on data source (Kaggle)**

1. How was the sales trend over the months?

2. What are the most frequently purchased products?

3. How many products does the customer purchase in each transaction?

4. What are the most profitable segment customers?

5. Based on your findings, what strategy could you recommend to the business to gain more profit?
   

- **Data Source:** Kaggle - Online Retail dataset (https://www.kaggle.com/datasets/gabrielramos87/an-online-shop-business)
- Notebooks: [analysis.ipynb](notebooks/analysis.ipynb), [sql_validation.ipynb](notebooks/sql_validation.ipynb)
- **Tools Used:** Python (`pandas`, `numpy`, `matplotlib`), PostgreSQL / Azure SQL, Power BI
  

---

## Data Cleaning & Feature Engineering (Python)
- Loaded raw transaction data into a Pandas DataFrame.
- Created cleaned columns and engineered features:
  - `revenue = price * quantity`
  - `abs_quantity = absolute value of quantity`
  - `no_C_transaction_num = transaction number without “C”`
  - Standardized `product_name` (lowercase, trimmed spaces)
- Derived temporal features: `day_name`, `month`, `year`, `year_month_dt`, `year_month_str`
- Created customer segments using quantile-based categorization:
  - `customer_frequency` (least → most frequent)
  - `customer_contribution` (least → most contributing)
- Categorized products by price and volume using `qcut`.
- Exported the cleaned DataFrame to Azure PostgreSQL.

---

## SQL Workflow / Data Modeling

### Dimensional Modeling
The raw flat dataset was transformed into a **star schema** to enable efficient reporting and analysis.

**Dimension Tables:**
- `dim_product` → `product_id`, `product_num`, `product_name`, `price`
- `dim_customer` → `customer_id`, `customer_num`, `country`, `customer_frequency`, `customer_contribution`
- `dim_date` → `date_id`, `date`

**Fact Table:**
- `fact_transactions` → `transaction_id`, `transaction_num`, `date_id`, `product_id`, `customer_id`, `quantity`, `revenue`

**Benefits of Dimensional Model:**
- Ensures **consistent unique identifiers (surrogate keys)** across tables.  
- Supports **interactive dashboards** in Power BI through relationships between fact and dimension tables.  
- Improves **query performance** and avoids redundant computations.  

### SQL Validation Checks
- Validated data quality: duplicates, nulls, data types, row counts.  
- Created **views for pre-aggregated metrics and KPIs**:
  - `view_total_revenue`
  - `view_avg_product_per_transaction`
  - `view_total_order_value`
  - `view_total_transaction`
  - `view_top_product`
  - `view_customer_vs_revenue_by_frequency`
  - `view_customer_vs_revenue_by_contribution`
  - `view_weekday_sales`
- Pre-aggregation in views ensures **fast, interactive dashboards** in Power BI without compromising detail.

---

## Power BI Dashboard
- Connected to SQL views, dim and fact table.
- Created KPI cards and charts:
  - Total Revenue, Avg Product Per Transaction, Avg Order Value, Total Transactions, Top Product
  - Monthly Revenue Trend
  - Weekday Sales
  - Top 10 Products by Revenue
  - Segment % Revenue and % Customers by Customer Frequency
  - Segment % Revenue and % Customers by Customer Contribution
- **Interactivity:**
  - KPI cards update automatically on SQL refresh.
  - Charts are interactive.
    
![Power BI Sales Dashboard Overview](dashboards/dashboard_image.png)

---

## Recommendations / Findings
- Transactions concentrated in **UK (~91%)**; peak revenue in **September**.
- Top 25% frequent customers generate ~63% of revenue; top contributors generate ~78%.
- Popular products may not be the most profitable — opportunity for bundling with higher-margin products.
- Midweek sales slump (Wednesdays) — opportunity for flash promotions.
- International growth potential outside the UK.

---

## Folder Structure

```
e-commerce-data-analysis/
├── dashboards/             # Power BI files
├── notebooks/              # Python analysis & SQL Validation check
├── raw_data/kaggle_data    # CSV datasets
├── sql/                    # SQL scripts
├── gitignore
└── requirements.txt
```


