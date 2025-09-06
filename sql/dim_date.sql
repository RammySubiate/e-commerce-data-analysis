-- Create empty dim_date schema
CREATE TABLE dim_date(
    date_id SERIAL PRIMARY KEY,
    date DATE UNIQUE
);

-- Insert Data
INSERT INTO dim_date (date)
SELECT DISTINCT date
FROM flat_sales;



