/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ============================================================================
-- Check for Uniqueness in 'gold.dim_customers'
-- ============================================================================

-- Expectation: No duplicate customer_key values
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ============================================================================
-- Check for Uniqueness in 'gold.dim_products'
-- ============================================================================

-- Expectation: No duplicate product_key values
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ============================================================================
-- Check Referential Integrity in 'gold.fact_sales'
-- ============================================================================

-- Expectation: All foreign keys in fact_sales should match existing keys in dimension tables
SELECT 
    f.*
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p ON f.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;
