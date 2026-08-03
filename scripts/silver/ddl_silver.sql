/*
===============================================================================
Create Silver Layer Tables
===============================================================================
Purpose:
    This script creates the Silver layer tables that store cleansed,
    standardized, and conformed data derived from the Bronze layer.
    Data types are corrected here to match the true nature of each column
    (e.g., DECIMAL for money/amount fields, DATE for cleaned date values),
    since Bronze intentionally kept everything as raw/NVARCHAR or unvalidated
    types.

    Each table includes a dwh_create_date column, a system-generated
    metadata field that records when the row was loaded into Silver.

    If a table already exists, it is dropped and recreated to ensure the
    schema stays in sync with this script.

Tables created:
    - silver.crm_cust_info      : Cleansed customer data from CRM
    - silver.crm_prd_info       : Cleansed product data from CRM
    - silver.crm_sales_details  : Cleansed sales transaction data from CRM
    - silver.erp_cust_az12      : Cleansed customer data from ERP
    - silver.erp_loc_a101       : Cleansed customer location data from ERP
    - silver.erp_px_cat_g1v2    : Cleansed product category data from ERP
===============================================================================
*/

-- Drop and recreate CRM customer info table
DROP TABLE IF EXISTS silver.crm_cust_info;
GO
CREATE TABLE silver.crm_cust_info (
	cst_id				INT,
	cst_key				NVARCHAR(50),
	cst_firstname		NVARCHAR(50),
	cst_lastname		NVARCHAR(50),
	cst_marital_status	NVARCHAR(50),
	cst_gndr			NVARCHAR(50),
	cst_create_date		DATE,
	dwh_create_date 	DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop and recreate CRM product info table
DROP TABLE IF EXISTS silver.crm_prd_info;
GO
CREATE TABLE silver.crm_prd_info (
	prd_id			INT,
	prd_key			NVARCHAR(50),
	cat_id			NVARCHAR(50),
	prd_nm			NVARCHAR(50),
	prd_cost		DECIMAL(10,2),
	prd_line		NVARCHAR(50),
	prd_start_dt	DATE,
	prd_end_dt		DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop and recreate CRM sales details table
DROP TABLE IF EXISTS silver.crm_sales_details;
GO
CREATE TABLE silver.crm_sales_details (
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	DATE,
	sls_ship_dt		DATE,
	sls_due_dt		DATE,
	sls_sales		DECIMAL(10,2),
	sls_quantity	INT,
	sls_price		DECIMAL(10,2),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop and recreate ERP customer table
DROP TABLE IF EXISTS silver.erp_cust_az12;
GO
CREATE TABLE silver.erp_cust_az12 (
	cid				NVARCHAR(50),
	bdate			DATE,
	gen				NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop and recreate ERP customer location table
DROP TABLE IF EXISTS silver.erp_loc_a101;
GO
CREATE TABLE silver.erp_loc_a101 (
	cid				NVARCHAR(50),
	cntry			NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop and recreate ERP product category table
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
GO
CREATE TABLE silver.erp_px_cat_g1v2 (
	id				NVARCHAR(50),
	cat				NVARCHAR(50),
	subcat			NVARCHAR(50),
	maintenance 	NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
