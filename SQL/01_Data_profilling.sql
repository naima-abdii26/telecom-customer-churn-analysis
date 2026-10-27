-- =============================================
-- 01- Data Profilling
-- ==============================================
-- 01. Row Count Validation
SELECT 'dim_customers' table_name, COUNT(*) AS Count_rows FROM dim_customers
UNION ALL
SELECT 'dim_plans', COUNT(*) FROM dim_plans
UNION ALL
SELECT 'fact_subscriptions', COUNT(*) FROM fact_subscriptions;


-- 02. Column Names and Data Types

DESCRIBE fact_subscriptions;
DESCRIBE dim_customers;
DESCRIBE dim_plans;


-- 03. Duplicate checks

SELECT Subscription_ID, COUNT(*) AS duplicate_subscription_id
FROM fact_subscriptions
GROUP BY Subscription_ID
HAVING COUNT(*) > 1;



SELECT Customer_ID, COUNT(*) AS duplicate_customer_id
FROM dim_customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


SELECT Plan_ID, COUNT(*) AS duplicate_plan_id
FROM dim_plans
GROUP BY Plan_ID
HAVING COUNT(*) > 1;


-- 04. Missing Value Profiling

SELECT 'fact_subscriptions' AS table_name,
       'Subscription_ID' AS column_name,
       COUNT(*) AS missing_count
FROM fact_subscriptions
WHERE Subscription_ID IS NULL

UNION ALL

SELECT 'fact_subscriptions', 'Customer_ID', COUNT(*)
FROM fact_subscriptions
WHERE Customer_ID IS NULL

UNION ALL

SELECT 'fact_subscriptions', 'Plan_ID', COUNT(*)
FROM fact_subscriptions
WHERE Plan_ID IS NULL

UNION ALL

SELECT 'fact_subscriptions', 'Signup_Date', COUNT(*)
FROM fact_subscriptions
WHERE Signup_Date IS NULL

UNION ALL

SELECT 'fact_subscriptions', 'Monthly_Charges', COUNT(*)
FROM fact_subscriptions
WHERE Monthly_Charges IS NULL

UNION ALL

SELECT 'fact_subscriptions', 'Churn_Status', COUNT(*)
FROM fact_subscriptions
WHERE Churn_Status IS NULL

UNION ALL

SELECT 'dim_customers', 'Customer_ID', COUNT(*)
FROM dim_customers
WHERE Customer_ID IS NULL

UNION ALL

SELECT 'dim_customers', 'Customer_Name', COUNT(*)
FROM dim_customers
WHERE Customer_Name IS NULL

UNION ALL

SELECT 'dim_customers', 'Location', COUNT(*)
FROM dim_customers
WHERE Location IS NULL

UNION ALL

SELECT 'dim_customers', 'Gender', COUNT(*)
FROM dim_customers
WHERE Gender IS NULL

UNION ALL

SELECT 'dim_customers', 'Age', COUNT(*)
FROM dim_customers
WHERE Age IS NULL

UNION ALL

SELECT 'dim_plans', 'Plan_ID', COUNT(*)
FROM dim_plans
WHERE Plan_ID IS NULL

UNION ALL

SELECT 'dim_plans', 'Plan_Name', COUNT(*)
FROM dim_plans
WHERE Plan_Name IS NULL

UNION ALL

SELECT 'dim_plans', 'Service_Type', COUNT(*)
FROM dim_plans
WHERE Service_Type IS NULL;



 -- 05. Churn Status Validation
 SELECT Churn_Status, COUNT(*) AS subscription_count
 FROM fact_subscriptions
 GROUP BY Churn_Status;
 
 -- 06. Service Type Validation
 
 SELECT Service_Type, COUNT(*) AS Count_service_type
 FROM dim_plans
 GROUP BY Service_Type;

-- 07. Numeric Range Validation
SELECT MAX(Age) AS Max_age, Min(Age) AS Min_age, AVG(Age) AS Avg_age
FROM dim_customers;

SELECT Subscription_ID, Monthly_Charges
FROM fact_subscriptions
WHERE Monthly_Charges<=0;

-- 08. Signup Date Validation
SELECT MAX(Signup_Date) AS latest_signup_date, 
MIN(Signup_Date) AS earliest_signup_date
FROM fact_subscriptions;

SELECT Subscription_ID, Signup_Date
FROM fact_subscriptions
WHERE STR_TO_DATE(Signup_Date, '%Y-%m-%d') IS NULL;

SELECT Subscription_ID, Signup_Date
FROM fact_subscriptions
WHERE STR_TO_DATE(Signup_Date, '%Y-%m-%d') IS NULL;


-- 08. Future Signup Date Val
SELECT Subscription_ID, Signup_Date
FROM fact_subscriptions
WHERE STR_TO_DATE(Signup_Date, '%Y-%m-%d')> '2026-10-12';

-- 09. Plan Referential Integrity Validation

SELECT dc.Customer_ID, fs.Customer_ID
FROM fact_subscriptions fs
LEFT JOIN dim_customers dc ON fs.Customer_ID= dc.Customer_ID
WHERE dc.Customer_ID IS NULL;

SELECT dp.Plan_ID, fs.Customer_ID
FROM fact_subscriptions fs
LEFT JOIN dim_plans dP ON fs.Plan_ID = dp.Plan_ID
WHERE dp.Plan_ID IS NULL;


-- 10. Empty Strings and Whitespace

SELECT*
FROM dim_plans;

SELECT 'dim_customers' AS table_name, 'Customer_ID' AS column_name, COUNT(*) AS blank_counts
FROM dim_customers WHERE TRIM(Customer_ID) = ''
UNION ALL
SELECT 'dim_customers', 'Customer_Name', COUNT(*) FROM dim_customers WHERE TRIM(Customer_Name)= ''
UNION ALL
SELECT 'dim_customers', 'Location', COUNT(*) FROM dim_customers WHERE TRIM(Location)= ''
UNION ALL
SELECT 'dim_customers', 'Gender', COUNT(*) FROM dim_customers WHERE TRIM(gender)= ''
UNION ALL
SELECT 'dim_customers', 'Age', COUNT(*) FROM dim_customers WHERE TRIM(Age)= ''
UNION ALL
SELECT 'fact_subscriptions', 'Subscription_ID', COUNT(*) FROM fact_subscriptions WHERE TRIM(Subscription_ID)= ''
UNION ALL
SELECT 'fact_subscriptions', 'Customer_ID', COUNT(*) FROM fact_subscriptions WHERE TRIM(Customer_ID) = ''
UNION ALL
SELECT 'fact_subscriptions', 'Plan_ID', COUNT(*) FROM fact_subscriptions WHERE TRIM(Plan_ID) = ''
UNION ALL
SELECT 'fact_subscriptions', 'Signup_Date', COUNT(*) FROM fact_subscriptions WHERE TRIM(Signup_Date) = ''
UNION ALL
SELECT 'fact_subscriptions', 'Monthly_Charges', COUNT(*) FROM fact_subscriptions WHERE TRIM(Monthly_Charges) = ''
UNION ALL
SELECT 'fact_subscriptions', 'Churn_Status', COUNT(*) FROM fact_subscriptions WHERE TRIM(Churn_Status) = ''
UNION ALL
SELECT 'dim_plans', 'Plan_ID', COUNT(*) FROM dim_plans WHERE TRIM(Plan_ID) = ''
UNION ALL
SELECT 'dim_plans', 'Plan_Name', COUNT(*) FROM dim_plans WHERE TRIM(Plan_Name) = ''
UNION ALL
SELECT 'dim_plans', 'Service_Type', COUNT(*) FROM dim_plans WHERE TRIM(Service_Type) = ''

