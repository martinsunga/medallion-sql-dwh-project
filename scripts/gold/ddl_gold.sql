/*
===============================================================================
Create Gold Layer Views
===============================================================================
Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star 
    Schema), combining and conforming data from the Silver layer into a 
    business-ready, analytics-friendly model.

    Each view performs the following:
        - Combines relevant tables from the Silver layer.
        - Applies transformations and business logic (e.g. gender fallback 
          rules, filtering to current/active records).
        - Generates surrogate keys for dimension tables using ROW_NUMBER(),
          ordered by a stable natural key to keep keys consistent across 
          reloads.
        - Renames columns to business-friendly, user-facing names.

Usage:
    These views can be queried directly for analytics and reporting.
    Example:
        SELECT * FROM gold.dim_customers;
        SELECT * FROM gold.fact_sales;

Views created:
    - gold.dim_customers  : Customer dimension, combining CRM and ERP data
    - gold.dim_products   : Product dimension, combining CRM and ERP data 
                             (current/active products only)
    - gold.fact_sales     : Sales fact table, linked to the dimensions above
                             via their surrogate keys
===============================================================================
*/

DROP VIEW IF EXISTS gold.dim_customers;
GO
  
CREATE VIEW gold.dim_customers AS
SELECT 
  ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key, -- Surrogate key
  ci.cst_id AS customer_id,
  ci.cst_key AS customer_number,
  ci.cst_firstname AS firstname,
  ci.cst_lastname AS lastname,
  la.cntry AS country,
  ci.cst_marital_status AS civil_status,
  CASE
      WHEN ci.cst_gndr = 'Unknown' THEN ca.gen
      ELSE ci.cst_gndr -- CRM is prioritized as master data for gender
  END AS gender,
  ca.bdate AS birthdate,
  ci.cst_create_date AS creation_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid;
GO

--------------------------------------------------

DROP VIEW IF EXISTS gold.dim_products;
GO
  
CREATE VIEW gold.dim_products AS 
SELECT 
  ROW_NUMBER() OVER (ORDER BY pdi.prd_id) AS product_key, -- Surrogate key
	pdi.prd_id AS product_id,
	pdi.prd_key AS product_number,
	pdi.prd_nm AS name,
	pdi.cat_id AS category_id,
	pdc.cat AS category,
	pdc.subcat AS subcategory,
	pdc.maintenance,
	pdi.prd_cost AS cost,
	pdi.prd_line AS line,
	pdi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pdi
LEFT JOIN silver.erp_px_cat_g1v2 AS pdc
ON pdi.cat_id = pdc.id
WHERE pdi.prd_end_dt IS NULL -- Filter out all historical data
GO

--------------------------------------------------

DROP VIEW IF EXISTS gold.fact_sales;  
GO
  
CREATE VIEW gold.fact_sales AS
SELECT 
	s.sls_ord_num AS order_id,
	c.customer_key,
	p.product_key,
	s.sls_order_dt AS order_date,
	s.sls_ship_dt AS shipping_date,
	s.sls_due_dt AS delivery_date,
	s.sls_sales AS sales_amount,
	s.sls_quantity AS quantity,
	s.sls_price AS price  	
FROM silver.crm_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.sls_cust_id = c.customer_id
LEFT JOIN gold.dim_products AS p
ON s.sls_prd_key = p.product_number
