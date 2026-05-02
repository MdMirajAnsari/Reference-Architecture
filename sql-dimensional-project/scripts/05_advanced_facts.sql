/*
Retail Dimensional Warehouse - 05_advanced_facts.sql
Adds periodic snapshot and accumulating snapshot facts.
*/

CREATE TABLE dw.fact_inventory_snapshot (
    inventory_snapshot_key bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    date_key int NOT NULL,
    product_key int NOT NULL,
    store_key int NOT NULL,
    on_hand_quantity int NOT NULL,
    reserved_quantity int NOT NULL,
    available_quantity AS (on_hand_quantity - reserved_quantity),
    inventory_value_amount decimal(12,2) NOT NULL,
    loaded_at datetime2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT uq_inventory_snapshot UNIQUE (date_key, product_key, store_key),
    CONSTRAINT fk_inventory_date FOREIGN KEY (date_key) REFERENCES dw.dim_date(date_key),
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_key) REFERENCES dw.dim_product(product_key),
    CONSTRAINT fk_inventory_store FOREIGN KEY (store_key) REFERENCES dw.dim_store(store_key)
);

CREATE TABLE dw.fact_order_lifecycle (
    order_lifecycle_key bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    order_number varchar(40) NOT NULL,
    order_line_number int NOT NULL,
    product_key int NOT NULL,
    customer_key int NOT NULL,
    order_date_key int NOT NULL,
    paid_date_key int NULL,
    packed_date_key int NULL,
    shipped_date_key int NULL,
    delivered_date_key int NULL,
    cancelled_date_key int NULL,
    quantity int NOT NULL,
    net_sales_amount decimal(12,2) NOT NULL,
    lifecycle_status varchar(30) NOT NULL,
    days_to_ship int NULL,
    days_to_deliver int NULL,
    loaded_at datetime2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at datetime2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT uq_order_lifecycle UNIQUE (order_number, order_line_number),
    CONSTRAINT fk_lifecycle_product FOREIGN KEY (product_key) REFERENCES dw.dim_product(product_key),
    CONSTRAINT fk_lifecycle_customer FOREIGN KEY (customer_key) REFERENCES dw.dim_customer(customer_key),
    CONSTRAINT fk_lifecycle_order_date FOREIGN KEY (order_date_key) REFERENCES dw.dim_date(date_key)
);

INSERT INTO dw.fact_inventory_snapshot (
    date_key, product_key, store_key, on_hand_quantity, reserved_quantity, inventory_value_amount
)
SELECT
    d.date_key,
    p.product_key,
    s.store_key,
    v.on_hand_quantity,
    v.reserved_quantity,
    v.on_hand_quantity * p.unit_cost AS inventory_value_amount
FROM (VALUES
    ('2026-02-01', 'SKU-100', 'STORE-001', 120, 8),
    ('2026-02-01', 'SKU-200', 'STORE-001', 80, 12),
    ('2026-02-01', 'SKU-300', 'STORE-002', 40, 3),
    ('2026-02-01', 'SKU-400', 'STORE-002', 25, 5),
    ('2026-02-02', 'SKU-100', 'STORE-001', 115, 10),
    ('2026-02-02', 'SKU-200', 'STORE-001', 78, 9)
) AS v (full_date, product_code, store_code, on_hand_quantity, reserved_quantity)
JOIN dw.dim_date d ON d.full_date = v.full_date
JOIN dw.dim_product p ON p.product_code = v.product_code
JOIN dw.dim_store s ON s.store_code = v.store_code;

INSERT INTO dw.fact_order_lifecycle (
    order_number, order_line_number, product_key, customer_key, order_date_key,
    paid_date_key, packed_date_key, shipped_date_key, delivered_date_key,
    quantity, net_sales_amount, lifecycle_status, days_to_ship, days_to_deliver
)
SELECT
    'ORD-1004',
    1,
    p.product_key,
    c.customer_key,
    od.date_key,
    pd.date_key,
    pkd.date_key,
    sd.date_key,
    dd.date_key,
    2,
    159.98,
    'Delivered',
    DATEDIFF(day, od.full_date, sd.full_date),
    DATEDIFF(day, od.full_date, dd.full_date)
FROM dw.dim_product p
JOIN dw.dim_date od ON od.full_date = '2026-02-02'
JOIN dw.dim_customer c
    ON c.customer_id = 'CUST-002'
   AND od.full_date BETWEEN c.effective_start_date AND c.effective_end_date
LEFT JOIN dw.dim_date pd ON pd.full_date = '2026-02-02'
LEFT JOIN dw.dim_date pkd ON pkd.full_date = '2026-02-02'
LEFT JOIN dw.dim_date sd ON sd.full_date = '2026-02-02'
LEFT JOIN dw.dim_date dd ON dd.full_date = '2026-02-02'
WHERE p.product_code = 'SKU-200';

-- Inventory aging and value by category.
SELECT
    d.full_date,
    p.category_name,
    SUM(i.on_hand_quantity) AS on_hand_quantity,
    SUM(i.reserved_quantity) AS reserved_quantity,
    SUM(i.available_quantity) AS available_quantity,
    SUM(i.inventory_value_amount) AS inventory_value
FROM dw.fact_inventory_snapshot i
JOIN dw.dim_date d ON d.date_key = i.date_key
JOIN dw.dim_product p ON p.product_key = i.product_key
GROUP BY d.full_date, p.category_name
ORDER BY d.full_date, p.category_name;

-- Order lifecycle performance.
SELECT
    lifecycle_status,
    COUNT(*) AS line_count,
    AVG(CAST(days_to_ship AS decimal(9,2))) AS avg_days_to_ship,
    AVG(CAST(days_to_deliver AS decimal(9,2))) AS avg_days_to_deliver
FROM dw.fact_order_lifecycle
GROUP BY lifecycle_status;
GO
