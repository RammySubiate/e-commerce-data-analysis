-- Top 10 Products
CREATE OR REPLACE VIEW view_top_10_products AS
SELECT 
    product_name, 
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue_per_product
FROM fact_sales
GROUP BY product_name
ORDER BY total_revenue_per_product DESC
LIMIT 10;


