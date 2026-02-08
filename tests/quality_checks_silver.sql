/*
===============================================================================
Silver Layer – Quality Checks
===============================================================================
Purpose:
    Perform data quality validation on Silver layer tables after
    transformation from Bronze.

Scope:
    - Primary key integrity
    - Trimming and standardization checks
    - Business rule validation
    - Date consistency
    - ERP defensive cleansing validation
    - Sales consistency checks

Usage Notes:
    - Execute after running: EXEC silver.load_silver;
    - All checks are written with clear expectations.
    - Any returned rows indicate data quality issues.
===============================================================================
*/

-- ====================================================================
-- Checking: silver.crm_cust_info
-- ====================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
-- Expectation: Only 'Single', 'Married', 'n/a'
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- Gender Standardization
-- Expectation: Only 'Male', 'Female', 'n/a'
SELECT DISTINCT 
    cst_gndr
FROM silver.crm_cust_info;

-- ====================================================================
-- Checking: silver.crm_prd_info
-- ====================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces in Product Name
-- Expectation: No Results
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Cost
-- Expectation: No Results
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Product Line Standardization
-- Expectation: Only mapped descriptive values
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Invalid Date Ranges
-- Expectation: No Results
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking: silver.crm_sales_details
-- ====================================================================

-- Invalid Date Conversion Check (Bronze reference)
-- Expectation: No invalid raw date values
SELECT 
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
   OR LEN(sls_due_dt) != 8 
   OR sls_due_dt > 20500101 
   OR sls_due_dt < 19000101;

-- Order Date Logic Validation
-- Expectation: Order date <= Ship date and Due date
SELECT 
    * 
FROM silver.crm_sales_details
WHERE (sls_ship_dt IS NOT NULL AND sls_order_dt > sls_ship_dt)
   OR (sls_due_dt  IS NOT NULL AND sls_order_dt > sls_due_dt);

-- Sales Consistency Check
-- Expectation: sls_sales = sls_quantity * sls_price
SELECT 
    *
FROM silver.crm_sales_details
WHERE sls_sales    != sls_quantity * sls_price
   OR sls_sales    <= 0
   OR sls_quantity <= 0
   OR sls_price    <= 0
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL;

-- ====================================================================
-- Checking: silver.erp_cust_az12
-- ====================================================================

-- Birthdate Range Validation
-- Expectation:
--   - Birthdate must not be in the future
--   - Very old historical dates may exist and are flagged for review, not treated as errors

SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate IS NOT NULL
  AND (bdate < '1924-01-01' OR bdate > GETDATE());

-- Gender Standardization
-- Expectation: Only 'Male', 'Female', 'n/a'
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- Hidden Character Validation (Post-Cleansing)
-- Expectation: No hidden characters remain
SELECT *
FROM silver.erp_cust_az12
WHERE cid LIKE '%' + CHAR(9)  + '%'
   OR cid LIKE '%' + CHAR(10) + '%'
   OR cid LIKE '%' + CHAR(13) + '%'
   OR cid LIKE '%' + CHAR(160)+ '%';

-- ====================================================================
-- Checking: silver.erp_loc_a101
-- ====================================================================

-- CID Normalization Check
-- Expectation: No hyphens remain
SELECT *
FROM silver.erp_loc_a101
WHERE cid LIKE '%-%';

-- Country Standardization
-- Expectation: Clean country names, no blanks
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- Hidden Character & Trimming Validation
-- Expectation: No unwanted spaces or hidden characters
SELECT *
FROM silver.erp_loc_a101
WHERE cntry != TRIM(cntry)
   OR cntry LIKE '%' + CHAR(9)  + '%'
   OR cntry LIKE '%' + CHAR(10) + '%'
   OR cntry LIKE '%' + CHAR(13) + '%'
   OR cntry LIKE '%' + CHAR(160)+ '%';

-- ====================================================================
-- Checking: silver.erp_px_cat_g1v2
-- ====================================================================

-- Trimming & Hidden Character Validation
-- Expectation: All category fields are clean
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat         != TRIM(cat)
   OR subcat      != TRIM(subcat)
   OR maintenance != TRIM(maintenance)
   OR cat         LIKE '%' + CHAR(9)  + '%'
   OR subcat      LIKE '%' + CHAR(10) + '%'
   OR maintenance LIKE '%' + CHAR(160)+ '%';

-- Maintenance Field Standardization
-- Expectation: Limited, meaningful values only
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
