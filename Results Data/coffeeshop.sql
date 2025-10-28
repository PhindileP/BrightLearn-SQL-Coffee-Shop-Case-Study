-- ===========================================
--  Bright Coffee Shop Sales Analysis
-- Objective: Explore and prepare data for analysis
-- Author: Phindile Mnisi
-- ===========================================

-- 1️ Explore dataset
SELECT *
FROM brightlearn.analytics.coffeeshop
LIMIT 15;

-- 2️ Check distinct product categories
SELECT DISTINCT product_category
FROM brightlearn.analytics.coffeeshop;

-- 3️ Check distinct product details
SELECT DISTINCT product_detail
FROM brightlearn.analytics.coffeeshop;

-- 4️ Check distinct store locations
SELECT DISTINCT store_location
FROM brightlearn.analytics.coffeeshop;

-- 5️ Get the operating date range
SELECT 
    MIN(transaction_date) AS min_operating_date,
    MAX(transaction_date) AS max_operating_date
FROM brightlearn.analytics.coffeeshop;

-- 6️ Identify earliest and latest purchase times
SELECT 
    MIN(transaction_time) AS earliest_time,
    MAX(transaction_time) AS latest_time
FROM brightlearn.analytics.coffeeshop;

-- 7️ View weekdays from transaction dates
SELECT DISTINCT 
    DAYNAME(transaction_date) AS day_name
FROM brightlearn.analytics.coffeeshop
ORDER BY day_name;

-- 8️ Create final aggregated view with time buckets
SELECT 
    transaction_date,
    DAYNAME(transaction_date) AS day_name,
    CASE
        WHEN DAYNAME(transaction_date) IN ('Sat', 'Sun') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification,
    MONTHNAME(transaction_date) AS month_name,
    transaction_time,
    CASE 
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ELSE 'Night' 
    END AS time_bucket,
    HOUR(transaction_time) AS hour_of_day,
    store_location,
    product_category,
    product_detail,
    product_type,
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    COUNT(DISTINCT product_id) AS unique_products_sold,
    
    --   computing total_amount
    SUM(transaction_qty * TRY_TO_DECIMAL(REPLACE(unit_price, ',', '.'), 10, 2)) AS total_amount,
    
FROM brightlearn.analytics.coffeeshop

--  Group by relevant fields
GROUP BY 
    transaction_date,
    DAYNAME(transaction_date),
    MONTHNAME(transaction_date),
    transaction_time,
    HOUR(transaction_time),
    store_location,
    product_category,
    product_detail,
    product_type
ORDER BY transaction_date, store_location, product_category;
