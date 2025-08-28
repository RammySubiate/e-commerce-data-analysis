CREATE OR REPLACE VIEW view_weekday_sales AS
SELECT
    TO_CHAR(date, 'Day') AS weekday_name,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM fact_sales
GROUP BY weekday_name
ORDER BY MIN(date);
