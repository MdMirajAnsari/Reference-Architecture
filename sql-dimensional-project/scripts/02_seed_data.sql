/*
Retail Dimensional Warehouse - 02_seed_data.sql
Loads dimensions and sample sales facts.
*/

INSERT INTO dw.dim_date (
    date_key, full_date, day_number, day_name, week_number,
    month_number, month_name, quarter_number, year_number, is_weekend
)
VALUES
    (20260101, '2026-01-01', 1, 'Thursday', 1, 1, 'January', 1, 2026, 0),
    (20260102, '2026-01-02', 2, 'Friday', 1, 1, 'January', 1, 2026, 0),
    (20260103, '2026-01-03', 3, 'Saturday', 1, 1, 'January', 1, 2026, 1),
    (20260201, '2026-02-01', 1, 'Sunday', 5, 2, 'February', 1, 2026, 1),
    (20260202, '2026-02-02', 2, 'Monday', 5, 2, 'February', 1, 2026, 0);

INSERT INTO dw.dim_product (
    product_code, product_name, brand_name, category_name,
    subcategory_name, unit_cost, unit_price
)
VALUES
    ('SKU-100', 'Wireless Mouse', 'Northwind', 'Electronics', 'Accessories', 12.00, 24.99),
    ('SKU-200', 'Mechanical Keyboard', 'Northwind', 'Electronics', 'Accessories', 42.00, 89.99),
    ('SKU-300', 'Desk Chair', 'Contoso', 'Furniture', 'Office Seating', 95.00, 179.99),
    ('SKU-400', 'Standing Desk', 'Contoso', 'Furniture', 'Desks', 210.00, 399.99);

INSERT INTO dw.dim_customer (
    customer_id, customer_name, email, city, state_code, customer_segment,
    effective_start_date, effective_end_date, is_current
)
VALUES
    ('CUST-001', 'Ava Patel', 'ava.patel@example.com', 'Austin', 'TX', 'Consumer', '2026-01-01', '9999-12-31', 1),
    ('CUST-002', 'Noah Smith', 'noah.smith@example.com', 'Seattle', 'WA', 'Small Business', '2026-01-01', '9999-12-31', 1),
    ('CUST-003', 'Mia Johnson', 'mia.johnson@example.com', 'Chicago', 'IL', 'Enterprise', '2026-01-01', '9999-12-31', 1);

INSERT INTO dw.dim_store (store_code, store_name, city, state_code, region_name, store_type)
VALUES
    ('STORE-001', 'Austin Central', 'Austin', 'TX', 'South', 'Physical'),
    ('STORE-002', 'Seattle Downtown', 'Seattle', 'WA', 'West', 'Physical'),
    ('STORE-999', 'Online Store', 'Online', 'NA', 'Digital', 'Online');

INSERT INTO dw.dim_channel (channel_code, channel_name)
VALUES
    ('STORE', 'Physical Store'),
    ('WEB', 'Web'),
    ('MOBILE', 'Mobile App');

INSERT INTO dw.dim_promotion (promotion_code, promotion_name, promotion_type, start_date, end_date)
VALUES
    ('PROMO-NEWYEAR', 'New Year Sale', 'Seasonal', '2026-01-01', '2026-01-07'),
    ('PROMO-OFFICE', 'Office Refresh', 'Category', '2026-02-01', '2026-02-28');

INSERT INTO dw.fact_sales (
    order_number, order_line_number, date_key, product_key, customer_key,
    store_key, channel_key, promotion_key, quantity, gross_sales_amount,
    discount_amount, net_sales_amount, cost_amount, margin_amount
)
SELECT
    v.order_number,
    v.order_line_number,
    d.date_key,
    p.product_key,
    c.customer_key,
    s.store_key,
    ch.channel_key,
    pr.promotion_key,
    v.quantity,
    v.gross_sales_amount,
    v.discount_amount,
    v.net_sales_amount,
    v.cost_amount,
    v.net_sales_amount - v.cost_amount AS margin_amount
FROM (VALUES
    ('ORD-1001', 1, '2026-01-01', 'SKU-100', 'CUST-001', 'STORE-999', 'WEB', 'PROMO-NEWYEAR', 2, 49.98, 5.00, 44.98, 24.00),
    ('ORD-1001', 2, '2026-01-01', 'SKU-200', 'CUST-001', 'STORE-999', 'WEB', 'PROMO-NEWYEAR', 1, 89.99, 10.00, 79.99, 42.00),
    ('ORD-1002', 1, '2026-01-02', 'SKU-300', 'CUST-002', 'STORE-002', 'STORE', NULL, 1, 179.99, 0.00, 179.99, 95.00),
    ('ORD-1003', 1, '2026-02-01', 'SKU-400', 'CUST-003', 'STORE-001', 'MOBILE', 'PROMO-OFFICE', 1, 399.99, 50.00, 349.99, 210.00),
    ('ORD-1004', 1, '2026-02-02', 'SKU-200', 'CUST-002', 'STORE-999', 'WEB', 'PROMO-OFFICE', 2, 179.98, 20.00, 159.98, 84.00)
) AS v (
    order_number, order_line_number, full_date, product_code, customer_id,
    store_code, channel_code, promotion_code, quantity, gross_sales_amount,
    discount_amount, net_sales_amount, cost_amount
)
JOIN dw.dim_date d ON d.full_date = v.full_date
JOIN dw.dim_product p ON p.product_code = v.product_code
JOIN dw.dim_customer c ON c.customer_id = v.customer_id AND c.is_current = 1
JOIN dw.dim_store s ON s.store_code = v.store_code
JOIN dw.dim_channel ch ON ch.channel_code = v.channel_code
LEFT JOIN dw.dim_promotion pr ON pr.promotion_code = v.promotion_code;
GO

