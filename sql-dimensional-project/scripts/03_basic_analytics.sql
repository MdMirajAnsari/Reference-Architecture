/*
Retail Dimensional Warehouse - 03_basic_analytics.sql
Basic and intermediate analytical queries.
*/

-- 1. Monthly sales summary
SELECT
    d.year_number,
    d.month_number,
    d.month_name,
    SUM(f.quantity) AS units_sold,
    SUM(f.net_sales_amount) AS net_sales,
    SUM(f.margin_amount) AS margin,
    CAST(SUM(f.margin_amount) / NULLIF(SUM(f.net_sales_amount), 0) AS decimal(9,4)) AS margin_rate
FROM dw.fact_sales f
JOIN dw.dim_date d ON d.date_key = f.date_key
GROUP BY d.year_number, d.month_number, d.month_name
ORDER BY d.year_number, d.month_number;

-- 2. Product category performance
SELECT
    p.category_name,
    p.subcategory_name,
    SUM(f.quantity) AS units_sold,
    SUM(f.net_sales_amount) AS net_sales,
    SUM(f.margin_amount) AS margin
FROM dw.fact_sales f
JOIN dw.dim_product p ON p.product_key = f.product_key
GROUP BY p.category_name, p.subcategory_name
ORDER BY net_sales DESC;

-- 3. Customer sales ranking
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_segment,
    SUM(f.net_sales_amount) AS net_sales,
    RANK() OVER (ORDER BY SUM(f.net_sales_amount) DESC) AS sales_rank
FROM dw.fact_sales f
JOIN dw.dim_customer c ON c.customer_key = f.customer_key
GROUP BY c.customer_id, c.customer_name, c.customer_segment;

-- 4. Promotion effectiveness
SELECT
    COALESCE(pr.promotion_name, 'No Promotion') AS promotion_name,
    SUM(f.gross_sales_amount) AS gross_sales,
    SUM(f.discount_amount) AS discount,
    SUM(f.net_sales_amount) AS net_sales,
    CAST(SUM(f.discount_amount) / NULLIF(SUM(f.gross_sales_amount), 0) AS decimal(9,4)) AS discount_rate
FROM dw.fact_sales f
LEFT JOIN dw.dim_promotion pr ON pr.promotion_key = f.promotion_key
GROUP BY COALESCE(pr.promotion_name, 'No Promotion')
ORDER BY net_sales DESC;

-- 5. Channel contribution
SELECT
    ch.channel_name,
    COUNT(DISTINCT f.order_number) AS order_count,
    SUM(f.net_sales_amount) AS net_sales,
    CAST(SUM(f.net_sales_amount) * 100.0 / SUM(SUM(f.net_sales_amount)) OVER () AS decimal(9,2)) AS sales_share_pct
FROM dw.fact_sales f
JOIN dw.dim_channel ch ON ch.channel_key = f.channel_key
GROUP BY ch.channel_name
ORDER BY net_sales DESC;
GO

