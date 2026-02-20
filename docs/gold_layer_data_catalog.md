# Data Catalog — Gold Layer

## Overview
The Gold Layer represents the business-ready data model designed for analytics and reporting.  
It follows a **star schema architecture** consisting of dimension tables and a central fact table to support business intelligence and performance analysis.

This layer enables efficient analysis of customers, products, and sales transactions for reporting and decision-making.

---

## Data Model Structure
The Gold Layer contains:

- **Dimension Tables** → descriptive business entities  
- **Fact Table** → measurable transactional data  

Tables included:
- gold.dim_customers
- gold.dim_products
- gold.fact_sales

---

## 1. gold.dim_customers
**Purpose:** Stores enriched customer information for demographic and geographic analysis.

| Column Name | Data Type | Description |
|---|---|---|
| customer_key | INT | Surrogate key uniquely identifying each customer record |
| customer_id | INT | Source system customer identifier |
| customer_number | NVARCHAR(50) | Business customer reference |
| first_name | NVARCHAR(50) | Customer first name |
| last_name | NVARCHAR(50) | Customer last name |
| country | NVARCHAR(50) | Customer country of residence |
| marital_status | NVARCHAR(50) | Marital status |
| gender | NVARCHAR(50) | Customer gender |
| birthdate | DATE | Date of birth |
| create_date | DATE | Record creation date |

---

## 2. gold.dim_products
**Purpose:** Stores product attributes for product-level analysis.

| Column Name | Data Type | Description |
|---|---|---|
| product_key | INT | Surrogate key for product |
| product_id | INT | Source system product identifier |
| product_number | NVARCHAR(50) | Product reference code |
| product_name | NVARCHAR(50) | Product description |
| category_id | NVARCHAR(50) | Category identifier |
| category | NVARCHAR(50) | Product category |
| subcategory | NVARCHAR(50) | Product subcategory |
| maintenance_required | NVARCHAR(50) | Maintenance indicator |
| cost | INT | Product cost |
| product_line | NVARCHAR(50) | Product line |
| start_date | DATE | Product launch date |

---

## 3. gold.fact_sales
**Purpose:** Stores transactional sales records for revenue and performance analysis.

| Column Name | Data Type | Description |
|---|---|---|
| order_number | NVARCHAR(50) | Unique sales order identifier |
| product_key | INT | Foreign key to product dimension |
| customer_key | INT | Foreign key to customer dimension |
| order_date | DATE | Order date |
| shipping_date | DATE | Shipping date |
| due_date | DATE | Payment due date |
| sales_amount | INT | Total sales value |
| quantity | INT | Units sold |
| price | INT | Unit price |

---

## Table Relationships
The fact table connects to dimension tables using surrogate keys:

- fact_sales.product_key → dim_products.product_key
- fact_sales.customer_key → dim_customers.customer_key

This structure enables multidimensional analysis across customers, products, and time.

---

## Analytical Use Cases
The Gold Layer supports:

- Revenue analysis by product and category
- Customer demographic segmentation
- Sales trend analysis over time
- Product performance tracking
- Regional sales comparison
