/*
Retail Dimensional Warehouse - 06_etl_loads_and_quality_checks.sql
Adds ETL-style loading and data quality checks.
*/

IF SCHEMA_ID('stg') IS NULL
    EXEC('CREATE SCHEMA stg');
GO

DROP TABLE IF EXISTS stg.sales_order_lines;
GO

CREATE TABLE stg.sales_order_lines (
    order_number varchar(40) NOT NULL,
    order_line_number int NOT NULL,
    order_date date NOT NULL,
    product_code varchar(30) NOT NULL,
    customer_id varchar(30) NOT NULL,
    store_code varchar(30) NOT NULL,
    channel_code varchar(30) NOT NULL,
    promotion_code varchar(30) NULL,
    quantity int NOT NULL,
    unit_price decimal(12,2) NOT NULL,
    discount_amount decimal(12,2) NOT NULL
);

INSERT INTO stg.sales_order_lines (
    order_number, order_line_number, order_date, product_code, customer_id,
    store_code, channel_code, promotion_code, quantity, unit_price, discount_amount
)
VALUES
    ('ORD-2001', 1, '2026-02-02', 'SKU-100', 'CUST-001', 'STORE-999', 'WEB', NULL, 1, 24.99, 0.00),
    ('ORD-2002', 1, '2026-02-02', 'SKU-300', 'CUST-003', 'STORE-001', 'STORE', 'PROMO-OFFICE', 1, 179.99, 15.00);
GO

CREATE OR ALTER PROCEDURE dw.usp_load_fact_sales_from_stage
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dw.fact_sales (
        order_number, order_line_number, date_key, product_key, customer_key,
        store_key, channel_key, promotion_key, quantity, gross_sales_amount,
        discount_amount, net_sales_amount, cost_amount, margin_amount
    )
    SELECT
        s.order_number,
        s.order_line_number,
        d.date_key,
        p.product_key,
        c.customer_key,
        st.store_key,
        ch.channel_key,
        pr.promotion_key,
        s.quantity,
        s.quantity * s.unit_price AS gross_sales_amount,
        s.discount_amount,
        (s.quantity * s.unit_price) - s.discount_amount AS net_sales_amount,
        s.quantity * p.unit_cost AS cost_amount,
        ((s.quantity * s.unit_price) - s.discount_amount) - (s.quantity * p.unit_cost) AS margin_amount
    FROM stg.sales_order_lines s
    JOIN dw.dim_date d ON d.full_date = s.order_date
    JOIN dw.dim_product p ON p.product_code = s.product_code
    JOIN dw.dim_customer c
        ON c.customer_id = s.customer_id
       AND s.order_date BETWEEN c.effective_start_date AND c.effective_end_date
    JOIN dw.dim_store st ON st.store_code = s.store_code
    JOIN dw.dim_channel ch ON ch.channel_code = s.channel_code
    LEFT JOIN dw.dim_promotion pr ON pr.promotion_code = s.promotion_code
    WHERE NOT EXISTS (
        SELECT 1
        FROM dw.fact_sales f
        WHERE f.order_number = s.order_number
          AND f.order_line_number = s.order_line_number
    );
END;
GO

EXEC dw.usp_load_fact_sales_from_stage;
GO

-- Quality check 1: duplicate order lines in fact_sales.
SELECT
    order_number,
    order_line_number,
    COUNT(*) AS duplicate_count
FROM dw.fact_sales
GROUP BY order_number, order_line_number
HAVING COUNT(*) > 1;

-- Quality check 2: staged rows that cannot resolve required dimensions.
SELECT
    s.*
FROM stg.sales_order_lines s
LEFT JOIN dw.dim_date d ON d.full_date = s.order_date
LEFT JOIN dw.dim_product p ON p.product_code = s.product_code
LEFT JOIN dw.dim_customer c
    ON c.customer_id = s.customer_id
   AND s.order_date BETWEEN c.effective_start_date AND c.effective_end_date
LEFT JOIN dw.dim_store st ON st.store_code = s.store_code
LEFT JOIN dw.dim_channel ch ON ch.channel_code = s.channel_code
WHERE d.date_key IS NULL
   OR p.product_key IS NULL
   OR c.customer_key IS NULL
   OR st.store_key IS NULL
   OR ch.channel_key IS NULL;

-- Quality check 3: negative margin rows.
SELECT
    order_number,
    order_line_number,
    net_sales_amount,
    cost_amount,
    margin_amount
FROM dw.fact_sales
WHERE margin_amount < 0;

-- Quality check 4: orphan fact rows. These should return zero rows.
SELECT f.sales_key, 'date' AS missing_dimension
FROM dw.fact_sales f
LEFT JOIN dw.dim_date d ON d.date_key = f.date_key
WHERE d.date_key IS NULL
UNION ALL
SELECT f.sales_key, 'product'
FROM dw.fact_sales f
LEFT JOIN dw.dim_product p ON p.product_key = f.product_key
WHERE p.product_key IS NULL
UNION ALL
SELECT f.sales_key, 'customer'
FROM dw.fact_sales f
LEFT JOIN dw.dim_customer c ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL;
GO

