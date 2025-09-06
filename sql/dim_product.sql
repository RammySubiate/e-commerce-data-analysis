-- Create empty dim_product schema
CREATE TABLE dim_product(
    product_id SERIAL PRIMARY KEY,
    product_num VARCHAR,
    product_name VARCHAR,
    price NUMERIC
);

-- Insert Data
INSERT INTO dim_product(product_num, product_name, price)
SELECT DISTINCT product_num, product_name, price
FROM flat_sales;


