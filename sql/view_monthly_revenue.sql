-- Monthly Revenue
CREATE OR REPLACE VIEW view_monthly_revenue AS
SELECT 
    date, 
    SUM(revenue) as monthly_revenue
FROM fact_sales
GROUP BY date
ORDER BY date ASC;