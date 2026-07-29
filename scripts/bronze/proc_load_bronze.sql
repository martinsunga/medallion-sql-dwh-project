/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external 
    CSV files (CRM and ERP source systems).
    Actions Performed:
        - Truncates Bronze tables before loading.
        - Uses BULK INSERT to load data from CSV files into Bronze tables.
        - Logs the result (success/failure), duration, and any error message 
          of each table load into bronze.load_log.
          
Note:
    File paths below are hardcoded to a local machine. Update the paths in 
    the BULK INSERT statements to match your local directory before running.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

USE DWHProject;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	DECLARE @start_time DATETIME2, @end_time DATETIME2, @duration INT;

	PRINT '--------------------------------------';
	PRINT 'CRM tables';

	BEGIN TRY
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Martin\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT 'bronze.crm_cust_info';
		SET @end_time = GETDATE();
		SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

		INSERT INTO bronze.load_log (table_name, load_status, load_duration_seconds)
		VALUES ('bronze.crm_cust_info', 'SUCCESS', @duration);
	END TRY
	BEGIN CATCH
		INSERT INTO bronze.load_log (table_name, load_status, error_message)
		VALUES ('bronze.crm_cust_info', 'FAILED', ERROR_MESSAGE());
	END CATCH

	BEGIN TRY
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Martin\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT 'bronze.crm_prd_info';
		SET @end_time = GETDATE();
		SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

		INSERT INTO bronze.load_log (table_name, load_status, load_duration_seconds)
		VALUES ('bronze.crm_prd_info', 'SUCCESS', @duration);
	END TRY
	BEGIN CATCH
		INSERT INTO bronze.load_log (table_name, load_status, error_message)
		VALUES ('bronze.crm_prd_info', 'FAILED', ERROR_MESSAGE());
	END CATCH

	BEGIN TRY
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Martin\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT 'bronze.crm_sales_details';
		SET @end_time = GETDATE();
		SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

		INSERT INTO bronze.load_log (table_name, load_status, load_duration_seconds)
		VALUES ('bronze.crm_sales_details', 'SUCCESS', @duration);
	END TRY
	BEGIN CATCH
		INSERT INTO bronze.load_log (table_name, load_status, error_message)
		VALUES ('bronze.crm_sales_details', 'FAILED', ERROR_MESSAGE());
	END CATCH

	PRINT '--------------------------------------';
	PRINT 'ERP tables';

	BEGIN TRY
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;

		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Martin\Desktop\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT 'bronze.erp_cust_az12';
		SET @end_time = GETDATE();
		SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

		INSERT INTO bronze.load_log (table_name, load_status, load_duration_seconds)
		VALUES ('bronze.erp_cust_az12', 'SUCCESS', @duration);
	END TRY
	BEGIN CATCH
		INSERT INTO bronze.load_log (table_name, load_status, error_message)
		VALUES ('bronze.erp_cust_az12', 'FAILED', ERROR_MESSAGE());
	END CATCH

	BEGIN TRY
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101;

		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Martin\Desktop\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT 'bronze.erp_loc_a101';
		SET @end_time = GETDATE();
		SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

		INSERT INTO bronze.load_log (table_name, load_status, load_duration_seconds)
		VALUES ('bronze.erp_loc_a101', 'SUCCESS', @duration);
	END TRY
	BEGIN CATCH
		INSERT INTO bronze.load_log (table_name, load_status, error_message)
		VALUES ('bronze.erp_loc_a101', 'FAILED', ERROR_MESSAGE());
	END CATCH

	BEGIN TRY
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Martin\Desktop\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT 'bronze.erp_px_cat_g1v2';
		SET @end_time = GETDATE();
		SET @duration = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT 'Load duration: ' + CAST(@duration AS NVARCHAR) + ' seconds';

		INSERT INTO bronze.load_log (table_name, load_status, load_duration_seconds)
		VALUES ('bronze.erp_px_cat_g1v2', 'SUCCESS', @duration);
	END TRY
	BEGIN CATCH
		INSERT INTO bronze.load_log (table_name, load_status, error_message)
		VALUES ('bronze.erp_px_cat_g1v2', 'FAILED', ERROR_MESSAGE());
	END CATCH

END
