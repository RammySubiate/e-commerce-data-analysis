-- Create empty dim_customer schema
CREATE TABLE dim_customer(
    customer_id SERIAL PRIMARY KEY,
    customer_num INT,
    country VARCHAR
);

-- Insert Data
INSERT INTO dim_customer(
            customer_num, 
            country, 
            customer_contribution, 
            customer_frequency
)
SELECT DISTINCT customer_num, country, customer_frequency, customer_contribution
FROM flat_sales;


