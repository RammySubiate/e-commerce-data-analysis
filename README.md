# Sales Analytics Dashboard Portfolio

## Project Overview
This project demonstrates an end-to-end data analytics workflow using **Python, SQL, and Power BI**. The goal is to clean, transform, and analyze sales transaction data, and create a dashboard for business insights.

A Python ETL script automates data cleaning, transformation, customer segmentation, revenue calculation, and loading into PostgreSQL for easier updates.

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

## Data Cleaning, Feature Engineering & ETL Automation (Python)

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

### Python ETL Script
A Python script was created to automate the ETL process:
- Reads the raw CSV transaction data
- Cleans and transforms the dataset
- Removes duplicate or cancelled transactions
- Creates calculated fields and customer segments
- Inserts only new rows into the PostgreSQL `flat_sales` table

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

---

## Power BI Dashboard

- **Data Source:** Connected to SQL dim and fact tables.  
- **KPIs and Charts Created:**  
  - KPI Cards: Total Revenue, Total Transactions, Average Basket Size, Average Order Value  
  - Monthly Revenue Trend  
  - Weekday Sales  
  - Top 10 Products by Popularity  
  - Customer Segmentation:  
    - % Revenue and % Customers by Customer Frequency (least → most frequent)  
    - % Revenue and % Customers by Customer Contribution (low → high contributing customers)  
- **Measures Implemented (DAX):**  
  - Total Revenue: Sum of all sales amounts  
  - Total Transactions: Count of distinct transactions  
  - Average Basket Size: Total quantity sold ÷ Total number of transactions  
  - Average Order Value: Total revenue ÷ Total transactions  
  - % Customers and % Revenue: Relative contribution per customer segment, displayed as percentages in charts  
- **Interactivity:**  
  - KPIs update automatically on SQL data refresh  
  - Charts are interactive, allowing filtering by date, product, or customer segment
    
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
├── notebooks/              # Python analysis & SQL validation notebooks
├── raw_data/kaggle_data/   # CSV datasets
├── scripts/                # Python ETL / automation scripts
├── sql/                    # SQL scripts
├── .gitignore
└── requirements.txt

```


