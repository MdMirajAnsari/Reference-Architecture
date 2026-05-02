/*
Retail Dimensional Warehouse - 04_scd_type_2.sql
Demonstrates SCD Type 2 handling for customer changes.
*/

CREATE OR ALTER PROCEDURE dw.usp_upsert_customer_scd2
    @customer_id varchar(30),
    @customer_name varchar(100),
    @email varchar(150),
    @city varchar(80),
    @state_code varchar(10),
    @customer_segment varchar(40),
    @change_date date
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @current_customer_key int;

    SELECT @current_customer_key = customer_key
    FROM dw.dim_customer
    WHERE customer_id = @customer_id
      AND is_current = 1;

    IF @current_customer_key IS NULL
    BEGIN
        INSERT INTO dw.dim_customer (
            customer_id, customer_name, email, city, state_code, customer_segment,
            effective_start_date, effective_end_date, is_current
        )
        VALUES (
            @customer_id, @customer_name, @email, @city, @state_code, @customer_segment,
            @change_date, '9999-12-31', 1
        );

        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM dw.dim_customer
        WHERE customer_key = @current_customer_key
          AND (
              customer_name <> @customer_name
              OR email <> @email
              OR city <> @city
              OR state_code <> @state_code
              OR customer_segment <> @customer_segment
          )
    )
    BEGIN
        UPDATE dw.dim_customer
        SET effective_end_date = DATEADD(day, -1, @change_date),
            is_current = 0
        WHERE customer_key = @current_customer_key;

        INSERT INTO dw.dim_customer (
            customer_id, customer_name, email, city, state_code, customer_segment,
            effective_start_date, effective_end_date, is_current
        )
        VALUES (
            @customer_id, @customer_name, @email, @city, @state_code, @customer_segment,
            @change_date, '9999-12-31', 1
        );
    END;
END;
GO

-- Example: CUST-002 moves from Seattle to Portland and changes segment.
EXEC dw.usp_upsert_customer_scd2
    @customer_id = 'CUST-002',
    @customer_name = 'Noah Smith',
    @email = 'noah.smith@example.com',
    @city = 'Portland',
    @state_code = 'OR',
    @customer_segment = 'Enterprise',
    @change_date = '2026-03-01';

-- View customer history.
SELECT
    customer_id,
    customer_name,
    city,
    state_code,
    customer_segment,
    effective_start_date,
    effective_end_date,
    is_current
FROM dw.dim_customer
WHERE customer_id = 'CUST-002'
ORDER BY effective_start_date;
GO
