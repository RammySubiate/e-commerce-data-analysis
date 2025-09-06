-- Total Revenue
CREATE OR REPLACE VIEW view_total_revenue AS
SELECT
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM fact_transactions
INNER JOIN dim_date
    USING(date_id)
INNER JOIN dim_product
    USING(product_id)
INNER JOIN dim_customer
    USING(customer_id);



-- Average Product Per Transaction
CREATE OR REPLACE VIEW view_avg_product_per_transaction AS
WITH product_per_transaction AS (
    SELECT 
        transaction_num, 
        COUNT(DISTINCT product_num) AS product_count
    FROM fact_transactions
    INNER JOIN dim_date
        USING(date_id)
    INNER JOIN dim_product
        USING(product_id)
    INNER JOIN dim_customer
        USING(customer_id)
    GROUP BY transaction_num
)

SELECT 
    ROUND(AVG(product_count)::numeric, 2) AS avg_product_per_transaction
FROM product_per_transaction;



-- Total Order Value
CREATE OR REPLACE VIEW view_total_order_value AS
SELECT 
    ROUND((SUM(revenue) / COUNT(DISTINCT transaction_num))::numeric, 2) as total_order_value
FROM fact_transactions
INNER JOIN dim_date
    USING(date_id)
INNER JOIN dim_product
    USING(product_id)
INNER JOIN dim_customer
    USING(customer_id);



--Total Transactions
CREATE OR REPLACE VIEW view_total_transaction AS
SELECT 
    COUNT(DISTINCT transaction_num) AS total_transaction
FROM fact_transactions
INNER JOIN dim_date
    USING(date_id)
INNER JOIN dim_product
    USING(product_id)
INNER JOIN dim_customer
    USING(customer_id);



--Top product
CREATE OR REPLACE VIEW view_top_product AS
WITH top_product AS (
    SELECT 
        product_name, SUM(revenue) AS total_revenue_per_product
    FROM fact_transactions
    INNER JOIN dim_date
        USING(date_id)
    INNER JOIN dim_product
        USING(product_id)
    INNER JOIN dim_customer
        USING(customer_id)
    GROUP BY product_name
    ORDER BY total_revenue_per_product DESC
    LIMIT 1
)
SELECT product_name
FROM top_product;


