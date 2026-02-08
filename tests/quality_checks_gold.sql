/*
===============================================================================
Quality Checks – Gold Layer
===============================================================================
Purpose:
    This script performs quality checks on the Gold layer to verify
    data integrity, consistency, and accuracy.

    The checks focus on:
    - Ensuring surrogate keys in dimension tables are unique.
    - Verifying referential integrity between fact and dimension tables.
    - Validating relationships in the data model used for analytics.

Usage Notes:
    - Run these checks after creating the Gold layer views.
    - Any returned rows indicate issues that should be reviewed
      and resolved before reporting or analysis.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check referential integrity between fact and dimension tables
-- Expectation: No results 
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
