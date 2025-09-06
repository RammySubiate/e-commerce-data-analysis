CREATE TABLE fact_transactions(
    transaction_id SERIAL PRIMARY KEY,
    transaction_num INTEGER,
    date_id INTEGER REFERENCES dim_date(date_id),
    product_id INTEGER REFERENCES dim_product(product_id),
    customer_id INTEGER REFERENCES dim_customer(customer_id),
    quantity INTEGER,
    revenue NUMERIC
);

INSERT INTO fact_transactions(
    transaction_num,
    date_id,
    product_id,
    customer_id,
    quantity,
    revenue
)
SELECT
    f.transaction_num::INTEGER,
    d.date_id,
    p.product_id,
    c.customer_id,
    f.quantity,
    (f.price * f.quantity) AS revenue
FROM flat_sales AS f
INNER JOIN dim_date AS d
ON f.date = d.date
INNER JOIN dim_product AS p 
    ON f.product_num = p.product_num
    AND f.product_name = p.product_name
    AND f.price = p.price
INNER JOIN dim_customer AS c 
    ON f.customer_num = c.customer_num
    AND f.country = c.country