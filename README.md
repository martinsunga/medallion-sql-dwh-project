# Data Warehouse Project

## 📖 Overview

This project follows the **Medallion Architecture** pattern using **Microsoft SQL Server** that demonstrates the implementation of a modern data warehouse. It features ETL pipelines, dimensional data modeling, and a star schema to support analytical reporting.

## 🏗️ Architecture

<img width="982" height="389" alt="DWH Diagram-Page-1" src="https://github.com/user-attachments/assets/709a0829-1eee-4e5c-9398-19eaaff35fd1" />

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files into a SQL Server database.
2. **Silver Layer**: Cleanses, standardizes, and normalizes data to prepare it for analysis.
3. **Gold Layer**: Stores business-ready data modeled as a star schema optimized for reporting and analytics.

---

## 🚀 Project Requirements

### Building the Data Warehouse

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

📂 Repository Structure
```
│
├── datasets/                            # Raw source CSV files (ERP and CRM), based on Microsoft AdventureWorks
│   ├── CRM/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   └── ERP/
│       ├── cust_az12.csv
│       ├── loc_a101.csv
│       └── px_cat_g1v2.csv
│
├── docs/                                 # Documentation and architecture diagrams
│   ├── data_flow_diagram.gif             # Data flow across Bronze → Silver → Gold
│   ├── data_warehouse_diagram.gif        # Data warehouse diagram Bronze → Silver → Gold
│   ├── entity_relationship_diagram.png   # Star schema (Gold layer) ERD
│   └── data_catalog.md                   # Naming standards for schemas, tables, and columns
│
├── scripts/                              # SQL scripts, organized by Medallion layer
│   ├── init_database.sql                 # Creates the DWHProject database and bronze/silver/gold schemas
│   ├── bronze/
│   │   ├── ddl_bronze.sql                # Table definitions for the Bronze layer
│   │   ├── ddl_load_log_bronze.sql       # DDL for bronze log
│   │   └── load_proc_bronze.sql          # bronze.load_bronze procedure (BULK INSERT + load_log)
│   ├── gold/
│   │   └── ddl_gold.sql                  # Gold layer views (dim_customers, dim_products, fact_sales)
│   │   
│   └── silver/
│       ├── ddl_silver.sql                # Table definitions for the Silver layer / load_silver.sql               
│       ├── ddl_load_log_silver.sql       # DDL for silver log
│       └── load_proc_silver.sql          # silver.load_silver procedure (cleansing/transform + load_log)
│ 
├── tests/                                # Data quality / validation checks
│
├── LICENSE
└── README.md
```


---

## 🚀 Quickstart

1. **Clone the repository** to your local machine.
2. **Setup Environment:** Install [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) (Express Edition) and **SSMS**.
3. **Get Data:** Download the CSV files from the `datasets/` directory.
4. **Run Scripts in Order:**
   * `init_database.sql`
   * `ddl_bronze.sql` ➔ `load_log_bronze.sql` ➔ `load_proc_bronze.sql`
   * `ddl_silver.sql` ➔ `load_log_silver.sql` ➔ `load_proc_silver.sql`
   * `ddl_gold.sql`

## 📊 Sample Insights

A few example queries you can run directly against the Gold layer:

**Total sales and orders by country**
```sql
SELECT 
    c.country,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sales DESC;
```

**Top 5 best-selling products**
```sql
SELECT TOP 5
    p.name,
    p.category,
    SUM(f.quantity) AS total_units_sold,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.name, p.category
ORDER BY total_revenue DESC;
```

**Monthly sales trend**
```sql
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS order_month,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY order_month;
```

*(Replace with your own actual query results/screenshots once you've run these against your loaded data — real output numbers make this section much stronger for reviewers.)*

---

## 🗺️ Data Flow Diagram

Shows how data moves through the Medallion Architecture, from source CSVs through Bronze, Silver, and into the Gold-layer dimension and fact tables.

<img width="748" height="449" alt="Data Flow Diagram" src="https://github.com/user-attachments/assets/3311eccf-20db-47a1-b8ee-6e74d46aa55e" />

---

## 🧩 Entity Relationship Diagram (Gold Layer)

The Gold layer is modeled as a star schema: `fact_sales` sits at the center, connected to `dim_customers` and `dim_products` via their surrogate keys (`customer_key`, `product_key`).

<img width="900" height="550" alt="Entity Relationship Diagram" src="https://github.com/user-attachments/assets/46b459de-18ce-4bad-89bf-b001e2815756" />

