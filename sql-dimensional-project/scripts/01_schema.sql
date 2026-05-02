/*
Retail Dimensional Warehouse - 01_schema.sql
Target: SQL Server / T-SQL

Creates a dimensional model with core dimensions and a transaction fact.
*/

IF SCHEMA_ID('dw') IS NULL
    EXEC('CREATE SCHEMA dw');
GO

DROP TABLE IF EXISTS dw.fact_sales;
DROP TABLE IF EXISTS dw.fact_inventory_snapshot;
DROP TABLE IF EXISTS dw.fact_order_lifecycle;
DROP TABLE IF EXISTS dw.dim_promotion;
DROP TABLE IF EXISTS dw.dim_channel;
DROP TABLE IF EXISTS dw.dim_store;
DROP TABLE IF EXISTS dw.dim_customer;
DROP TABLE IF EXISTS dw.dim_product;
DROP TABLE IF EXISTS dw.dim_date;
GO

CREATE TABLE dw.dim_date (
    date_key int NOT NULL PRIMARY KEY, -- YYYYMMDD
    full_date date NOT NULL UNIQUE,
    day_number tinyint NOT NULL,
    day_name varchar(10) NOT NULL,
    week_number tinyint NOT NULL,
    month_number tinyint NOT NULL,
    month_name varchar(10) NOT NULL,
    quarter_number tinyint NOT NULL,
    year_number smallint NOT NULL,
    is_weekend bit NOT NULL
);

CREATE TABLE dw.dim_product (
    product_key int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    product_code varchar(30) NOT NULL UNIQUE,
    product_name varchar(100) NOT NULL,
    brand_name varchar(60) NOT NULL,
    category_name varchar(60) NOT NULL,
    subcategory_name varchar(60) NOT NULL,
    unit_cost decimal(12,2) NOT NULL,
    unit_price decimal(12,2) NOT NULL,
    is_active bit NOT NULL DEFAULT 1
);

CREATE TABLE dw.dim_customer (
    customer_key int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    customer_id varchar(30) NOT NULL,
    customer_name varchar(100) NOT NULL,
    email varchar(150) NOT NULL,
    city varchar(80) NOT NULL,
    state_code varchar(10) NOT NULL,
    customer_segment varchar(40) NOT NULL,
    effective_start_date date NOT NULL,
    effective_end_date date NOT NULL,
    is_current bit NOT NULL,
    CONSTRAINT uq_dim_customer_version UNIQUE (customer_id, effective_start_date)
);

CREATE TABLE dw.dim_store (
    store_key int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    store_code varchar(30) NOT NULL UNIQUE,
    store_name varchar(100) NOT NULL,
    city varchar(80) NOT NULL,
    state_code varchar(10) NOT NULL,
    region_name varchar(60) NOT NULL,
    store_type varchar(40) NOT NULL
);

CREATE TABLE dw.dim_channel (
    channel_key int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    channel_code varchar(30) NOT NULL UNIQUE,
    channel_name varchar(60) NOT NULL
);

CREATE TABLE dw.dim_promotion (
    promotion_key int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    promotion_code varchar(30) NOT NULL UNIQUE,
    promotion_name varchar(100) NOT NULL,
    promotion_type varchar(40) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);

CREATE TABLE dw.fact_sales (
    sales_key bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    order_number varchar(40) NOT NULL,
    order_line_number int NOT NULL,
    date_key int NOT NULL,
    product_key int NOT NULL,
    customer_key int NOT NULL,
    store_key int NOT NULL,
    channel_key int NOT NULL,
    promotion_key int NULL,
    quantity int NOT NULL,
    gross_sales_amount decimal(12,2) NOT NULL,
    discount_amount decimal(12,2) NOT NULL,
    net_sales_amount decimal(12,2) NOT NULL,
    cost_amount decimal(12,2) NOT NULL,
    margin_amount decimal(12,2) NOT NULL,
    loaded_at datetime2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT uq_fact_sales_order_line UNIQUE (order_number, order_line_number),
    CONSTRAINT fk_fact_sales_date FOREIGN KEY (date_key) REFERENCES dw.dim_date(date_key),
    CONSTRAINT fk_fact_sales_product FOREIGN KEY (product_key) REFERENCES dw.dim_product(product_key),
    CONSTRAINT fk_fact_sales_customer FOREIGN KEY (customer_key) REFERENCES dw.dim_customer(customer_key),
    CONSTRAINT fk_fact_sales_store FOREIGN KEY (store_key) REFERENCES dw.dim_store(store_key),
    CONSTRAINT fk_fact_sales_channel FOREIGN KEY (channel_key) REFERENCES dw.dim_channel(channel_key),
    CONSTRAINT fk_fact_sales_promotion FOREIGN KEY (promotion_key) REFERENCES dw.dim_promotion(promotion_key)
);

CREATE INDEX ix_fact_sales_date ON dw.fact_sales(date_key);
CREATE INDEX ix_fact_sales_product ON dw.fact_sales(product_key);
CREATE INDEX ix_fact_sales_customer ON dw.fact_sales(customer_key);
GO

