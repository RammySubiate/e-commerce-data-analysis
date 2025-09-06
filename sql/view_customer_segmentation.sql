-- %Customer vs %Revenue by Customer Frequency
CREATE OR REPLACE VIEW view_customer_vs_revenue_by_frequency AS
WITH total_per_segment AS (
    SELECT 
        customer_frequency,
        ROUND(COUNT(DISTINCT customer_num)::numeric, 2) AS customer_per_segment,
        ROUND(SUM(revenue)::numeric, 2) AS revenue_per_segment
    FROM fact_transactions
    INNER JOIN dim_date
        USING(date_id)
    INNER JOIN dim_product
        USING(product_id)
    INNER JOIN dim_customer
        USING(customer_id)
    GROUP BY customer_frequency
)
SELECT 
    customer_frequency,
    (customer_per_segment / SUM(customer_per_segment) OVER()) * 100 AS perc_customer_per_segment,
    (revenue_per_segment / SUM(revenue_per_segment) OVER()) * 100 AS perc_revenue_per_segment
FROM total_per_segment
ORDER BY customer_frequency;



-- %Customer vs %Revenue by Customer Contribution
CREATE OR REPLACE VIEW view_customer_vs_revenue_by_contribution AS
WITH total_per_segment AS (
    SELECT 
        customer_contribution,
        ROUND(COUNT(DISTINCT customer_num)::numeric, 2) AS customer_per_segment,
        ROUND(SUM(revenue)::numeric, 2) AS revenue_per_segment
    FROM fact_transactions
    INNER JOIN dim_date
        USING(date_id)
    INNER JOIN dim_product
        USING(product_id)
    INNER JOIN dim_customer
        USING(customer_id)
    GROUP BY customer_contribution
)
SELECT 
    customer_contribution,
    (customer_per_segment / SUM(customer_per_segment) OVER()) * 100 AS perc_customer_per_segment,
    (revenue_per_segment / SUM(revenue_per_segment) OVER()) * 100 AS perc_revenue_per_segment
FROM total_per_segment
ORDER BY customer_contribution;

    



