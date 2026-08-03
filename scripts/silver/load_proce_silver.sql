/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL process to populate the 'silver' 
    schema tables from the 'bronze' schema.
    Actions Performed:
        - Truncates Silver tables before loading.
        - Cleanses, standardizes, and transforms data from Bronze into Silver.
        - Logs the result (success/failure), duration, and any error message 
          of each table load into silver.load_log.

Usage Example:
    EXEC silver.load_silver;
===============================================================================
*/

USE DWHProject;
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

    DECLARE @start_time DATETIME2, @end_time DATETIME2, @duration INT;

    PRINT '--------------------------------------';
    PRINT 'crm_cust_info';

    BEGIN TRY
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_cust_info;

        WITH cte1 AS (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        )
        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_Date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname) AS cst_firstname,
            TRIM(cst_lastname) AS cst_lastname,
            CASE
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                ELSE 'Unknown'
            END AS cst_marital_status,
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                ELSE 'Unknown'
            END AS cst_gndr,
            cst_create_date
        FROM cte1
        WHERE rn = 1;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
        PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

        INSERT INTO silver.load_log (table_name, load_status, load_duration_seconds)
        VALUES ('silver.crm_cust_info', 'SUCCESS', @duration);
    END TRY
    BEGIN CATCH
        INSERT INTO silver.load_log (table_name, load_status, error_message)
        VALUES ('silver.crm_cust_info', 'FAILED', ERROR_MESSAGE());
    END CATCH


    PRINT '--------------------------------------';
    PRINT 'crm_prd_info';

    BEGIN TRY
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_prd_info;

        INSERT INTO silver.crm_prd_info (
            prd_id,
            prd_key,
            cat_id,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,
            TRIM(SUBSTRING(prd_key, 7, LEN(prd_key))) AS prd_key,
            REPLACE(TRIM(LEFT(prd_key, 5)), '-', '_') AS cat_id,
            prd_nm,
            ISNULL(prd_cost, 0) AS prd_cost,
            CASE UPPER(TRIM(prd_line))
                WHEN 'M' THEN 'Mountain'
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'Unknown'
            END AS prd_line,
            prd_start_dt,
            DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
        FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
        PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

        INSERT INTO silver.load_log (table_name, load_status, load_duration_seconds)
        VALUES ('silver.crm_prd_info', 'SUCCESS', @duration);
    END TRY
    BEGIN CATCH
        INSERT INTO silver.load_log (table_name, load_status, error_message)
        VALUES ('silver.crm_prd_info', 'FAILED', ERROR_MESSAGE());
    END CATCH


    PRINT '--------------------------------------';
    PRINT 'crm_sales_details';

    BEGIN TRY
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_sales_details;

        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
            END AS sls_order_dt,
            CASE
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
            END AS sls_ship_dt,
            CASE
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
            END AS sls_due_dt,
            CASE
                WHEN sls_sales IS NULL
                    OR sls_sales <= 0
                    OR sls_sales != ABS(sls_price) * sls_quantity THEN ABS(sls_price) * sls_quantity
                ELSE sls_sales
            END AS sls_sales,
            sls_quantity,
            CAST(
                CASE
                    WHEN sls_price IS NULL OR sls_price <= 0
                        THEN CAST(sls_sales AS DECIMAL(10,2)) / NULLIF(sls_quantity, 0)
                    ELSE sls_price
                END AS DECIMAL(10,2)
            ) AS sls_price
        FROM bronze.crm_sales_details;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
        PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

        INSERT INTO silver.load_log (table_name, load_status, load_duration_seconds)
        VALUES ('silver.crm_sales_details', 'SUCCESS', @duration);
    END TRY
    BEGIN CATCH
        INSERT INTO silver.load_log (table_name, load_status, error_message)
        VALUES ('silver.crm_sales_details', 'FAILED', ERROR_MESSAGE());
    END CATCH


    PRINT '--------------------------------------';
    PRINT 'erp_cust_az12';

    BEGIN TRY
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_cust_az12;

        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT
            REPLACE(cid, 'NAS', '') AS cid,
            CASE
                WHEN bdate < '1900-01-01' OR bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate,
            CASE
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                ELSE 'Unknown'
            END AS gen
        FROM bronze.erp_cust_az12;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
        PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

        INSERT INTO silver.load_log (table_name, load_status, load_duration_seconds)
        VALUES ('silver.erp_cust_az12', 'SUCCESS', @duration);
    END TRY
    BEGIN CATCH
        INSERT INTO silver.load_log (table_name, load_status, error_message)
        VALUES ('silver.erp_cust_az12', 'FAILED', ERROR_MESSAGE());
    END CATCH


    PRINT '--------------------------------------';
    PRINT 'erp_loc_a101';

    BEGIN TRY
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_loc_a101;

        INSERT INTO silver.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT
            REPLACE(cid, '-', '') AS cid,
            CASE
                WHEN TRIM(cntry) IS NULL OR cntry = '' THEN 'Unknown'
                WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                ELSE TRIM(cntry)
            END AS cntry
        FROM bronze.erp_loc_a101;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
        PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

        INSERT INTO silver.load_log (table_name, load_status, load_duration_seconds)
        VALUES ('silver.erp_loc_a101', 'SUCCESS', @duration);
    END TRY
    BEGIN CATCH
        INSERT INTO silver.load_log (table_name, load_status, error_message)
        VALUES ('silver.erp_loc_a101', 'FAILED', ERROR_MESSAGE());
    END CATCH


    PRINT '--------------------------------------';
    PRINT 'erp_px_cat_g1v2';

    BEGIN TRY
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        INSERT INTO silver.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_px_cat_g1v2;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
        PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

        INSERT INTO silver.load_log (table_name, load_status, load_duration_seconds)
        VALUES ('silver.erp_px_cat_g1v2', 'SUCCESS', @duration);
    END TRY
    BEGIN CATCH
        INSERT INTO silver.load_log (table_name, load_status, error_message)
        VALUES ('silver.erp_px_cat_g1v2', 'FAILED', ERROR_MESSAGE());
    END CATCH

END
