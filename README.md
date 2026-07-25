# Medallion SQL Server Data Warehouse & Analytics Project

## 📖 Overview

This project demonstrates the implementation of a modern data warehouse using SQL Server and the Medallion Architecture. It features ETL pipelines, dimensional data modeling, and a star schema to support analytical reporting. The project is designed as a portfolio piece showcasing data engineering and analytics best practices.

## 🏗️ Architecture

<img width="923" height="569" alt="DWH Diagram" src="https://github.com/user-attachments/assets/910537bc-e911-4c31-9cac-af0766b6c992" />

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files into a SQL Server database.
2. **Silver Layer**: Cleanses, standardizes, and normalizes data to prepare it for analysis.
3. **Gold Layer**: Stores business-ready data modeled as a star schema optimized for reporting and analytics.

---

## 📂 Repository Structure

```
data-warehouse-project/
│
├── datasets/                      # Raw source CSV files (ERP and CRM)
│   ├── erp/
│   └── crm/
│
├── docs/
│   ├── dwh_architecture.png       # Medallion architecture diagram
│   └── star_schema.png            # Fact/Dimension model diagram (Gold layer)
│
├── scripts/
│   ├── bronze/                    # Scripts to load raw data as-is
│   ├── silver/                    # Scripts to clean, standardize, transform
│   └── gold/                      # Scripts to build star schema views
│
├── tests/                         # Data quality checks / validation queries
│
└── README.md
```

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytical queries to provide insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

---

## ⚙️ How to Run

1. Clone this repository.
2. Open SQL Server Management Studio (SSMS) and connect to your local SQL Server instance.
3. Run `scripts/init_database.sql` to create the database and schemas (bronze, silver, gold).
4. Run all scripts in `scripts/bronze/` to load raw CSV data.
5. Run all scripts in `scripts/silver/` to clean and standardize the data.
6. Run all scripts in `scripts/gold/` to build the final star schema views.
7. Explore the analytical queries in `scripts/gold/analytics/` or connect a BI tool (e.g. Power BI) to the Gold layer views.

---

## ⭐ Data Model (Gold Layer)

*Star schema diagram to be added here once the Gold layer is finalized — Fact table(s) surrounded by Dimension tables (e.g. FactSales, DimCustomer, DimProduct, DimDate).*

---

## 📊 Sample Insights

*To be added once analytical queries are complete — example: "Top 5 products by revenue," "Monthly sales trend," "Customer segments by total spend," with example output tables or screenshots.*

---

## 🛠️ Tech Stack
- SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- GitHub

---

## 💡 What I Learned

*A short personal reflection — e.g. challenges faced designing the grain, decisions made when modeling dimensions, or SQL concepts (window functions, CTEs) applied during the Silver/Gold transformations.*



