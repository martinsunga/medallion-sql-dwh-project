/*
=============================================================
Create Database and Schemas
=============================================================
Purpose:
    This script creates a new database named 'DWHProject' after 
    checking if it already exists. If the database exists, it is 
    dropped and recreated. The script also sets up three schemas 
    within the database representing the Medallion Architecture 
    layers: 'bronze', 'silver', and 'gold'.

Warning:
    Running this script will permanently drop the entire 'DWHProject' 
    database if it already exists. All data in the database will be 
    deleted. Proceed with caution and ensure you have proper backups 
    before running this script.
=============================================================
*/

USE master;
GO

-- Drop and recreate the DWHProject database if it already exists
DROP DATABASE IF EXISTS DWHProject;
GO

CREATE DATABASE DWHProject;
GO

-- Switch context to the DWHProject database
USE DWHProject;
GO

-- Create schemas for each Medallion Architecture layer
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
