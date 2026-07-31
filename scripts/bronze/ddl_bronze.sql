/*
=============================================================
Create Bronze Layer Tables
=============================================================
Purpose:
    This script creates the Bronze layer tables that store raw, 
    unprocessed data loaded directly from the source CRM and ERP 
    CSV files. No transformations are applied at this stage — 
    column data types are chosen to safely hold the source data 
    as-is (NVARCHAR used for all string columns as a flexible, 
    Unicode-safe default for raw ingestion).

    If a table already exists, it is dropped and recreated to 
    ensure the schema stays in sync with this script.

Tables created:
    - bronze.crm_cust_info      : Raw customer data from CRM
    - bronze.crm_prd_info       : Raw product data from CRM
    - bronze.crm_sales_details  : Raw sales transaction data from CRM
    - bronze.erp_cust_az12      : Raw customer data from ERP
    - bronze.erp_loc_a101       : Raw customer location data from ERP
    - bronze.erp_px_cat_g1v2    : Raw product category data from ERP
=============================================================
*/

-- Drop and recreate CRM customer info table
DROP TABLE IF EXISTS bronze.crm_cust_info;
GO
CREATE TABLE bronze.crm_cust_info (
	cst_id				INT,
	cst_key				NVARCHAR(50),
	cst_firstname		NVARCHAR(50),
	cst_lastname		NVARCHAR(50),
	cst_marital_status	NVARCHAR(50),
	cst_gndr			NVARCHAR(50),
	cst_create_date		DATE
);
GO

-- Drop and recreate CRM product info table
DROP TABLE IF EXISTS bronze.crm_prd_info;
GO
CREATE TABLE bronze.crm_prd_info (
	prd_id			INT,
	prd_key			NVARCHAR(50),
	prd_nm			NVARCHAR(50),
	prd_cost		DECIMAL(10,2),
	prd_line		NVARCHAR(50),
	prd_start_dt	DATETIME2,
	prd_end_dt		DATETIME2
);
GO

-- Drop and recreate CRM sales details table
DROP TABLE IF EXISTS bronze.crm_sales_details;
GO
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	INT,
	sls_ship_dt		INT,
	sls_due_dt		INT,
	sls_sales		DECIMAL(10,2),
	sls_quantity	INT,
	sls_price		DECIMAL(10,2)
);
GO

-- Drop and recreate ERP customer table
DROP TABLE IF EXISTS bronze.erp_cust_az12;
GO
CREATE TABLE bronze.erp_cust_az12 (
	cid		NVARCHAR(50),
	bdate	DATE,
	gen		NVARCHAR(50)
);
GO

-- Drop and recreate ERP customer location table
DROP TABLE IF EXISTS bronze.erp_loc_a101;
GO
CREATE TABLE bronze.erp_loc_a101 (
	cid		NVARCHAR(50),
	cntry	NVARCHAR(50)
);
GO

-- Drop and recreate ERP product category table
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
GO
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id			NVARCHAR(50),
	cat			NVARCHAR(50),
	subcat		NVARCHAR(50),
	maintenance NVARCHAR(50)
);
GO
