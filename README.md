# Data Warehouse & Analytics Project

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

### BI: Analytics & Reporting

#### Objective
Develop SQL-based analytical queries to provide insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**
