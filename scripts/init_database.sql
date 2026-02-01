/*
==============================================================
Database & Schema Initialization
==============================================================

Purpose:
Creates a fresh 'DataWarehouse' database.

Steps:
- Drops the database if it already exists
- Recreates the database
- Creates three schemas:
    bronze  – raw data
    silver  – cleaned data
    gold    – final data

Warning:
Existing 'DataWarehouse' data will be
permanently deleted.

Use only when a full reset is required.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

