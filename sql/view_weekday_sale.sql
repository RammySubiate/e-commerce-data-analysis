-- Weekday Sales
CREATE OR REPLACE VIEW view_weekday_sales AS
SELECT
    TO_CHAR(date, 'Day') AS weekday_name,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
    EXTRACT(ISODOW FROM date) AS weekday_order
FROM fact_sales
GROUP BY weekday_name, weekday_order
ORDER BY weekday_order;