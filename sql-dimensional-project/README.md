# Retail Dimensional Warehouse Project

This project designs a complete SQL data warehouse using dimensions and facts. It starts with the basics of star schema modeling and gradually adds advanced warehouse patterns such as conformed dimensions, slowly changing dimensions, snapshot facts, accumulating snapshot facts, and analytical queries.

Target platform: SQL Server / T-SQL.

## Business Scenario

Build a retail analytics warehouse for a company that sells products through physical stores and online channels. Business users want to analyze:

- Sales by date, product, customer, store, channel, and promotion
- Gross sales, discounts, net sales, cost, margin, and quantity
- Inventory levels over time
- Order lifecycle performance from order placed to shipped to delivered
- Customer history even when customer attributes change

## Learning Path

1. Basic: Create dimensions and a transaction fact table.
2. Intermediate: Load seed data and write star-schema analytical queries.
3. Advanced: Add SCD Type 2 customer history.
4. Advanced: Add snapshot and accumulating snapshot facts.
5. Advanced: Add ETL-style load procedures and quality checks.

## Folder Structure

```text
sql-dimensional-project/
  README.md
  scripts/
    01_schema.sql
    02_seed_data.sql
    03_basic_analytics.sql
    04_scd_type_2.sql
    05_advanced_facts.sql
    06_etl_loads_and_quality_checks.sql
```

## Star Schema

Core transaction model:

```text
dim_date
dim_product
dim_customer
dim_store
dim_channel
dim_promotion
        |
        v
fact_sales
```

Advanced fact models:

- `fact_inventory_snapshot`: periodic snapshot fact, one row per product/store/date.
- `fact_order_lifecycle`: accumulating snapshot fact, one row per order line lifecycle.

## Dimension Tables

- `dim_date`: calendar attributes for reporting.
- `dim_product`: product hierarchy and product cost.
- `dim_customer`: customer profile with SCD Type 2 columns.
- `dim_store`: store and region attributes.
- `dim_channel`: online, store, marketplace, or partner sales channel.
- `dim_promotion`: promotion attributes.

## Fact Tables

### fact_sales

Transaction fact table. Grain: one row per sold order line.

Measures:

- `quantity`
- `gross_sales_amount`
- `discount_amount`
- `net_sales_amount`
- `cost_amount`
- `margin_amount`

### fact_inventory_snapshot

Periodic snapshot fact table. Grain: one row per product, store, and date.

Measures:

- `on_hand_quantity`
- `reserved_quantity`
- `available_quantity`
- `inventory_value_amount`

### fact_order_lifecycle

Accumulating snapshot fact table. Grain: one row per order line.

Tracks milestone dates:

- order date
- paid date
- packed date
- shipped date
- delivered date
- cancelled date

Measures:

- `days_to_ship`
- `days_to_deliver`
- `lifecycle_status`

## How To Run

Run scripts in this order:

1. `scripts/01_schema.sql`
2. `scripts/02_seed_data.sql`
3. `scripts/03_basic_analytics.sql`
4. `scripts/04_scd_type_2.sql`
5. `scripts/05_advanced_facts.sql`
6. `scripts/06_etl_loads_and_quality_checks.sql`

## Suggested Enhancements

- Add a staging layer for raw source tables.
- Add incremental loads using high-watermark timestamps.
- Add partitioning for large fact tables.
- Add indexes by common reporting paths.
- Add Power BI dashboards on top of the model.
- Add SQL Agent jobs for scheduled loads.

