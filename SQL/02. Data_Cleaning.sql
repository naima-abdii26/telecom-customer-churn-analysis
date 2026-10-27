-- ==========================================
-- 02. Data Cleaning
-- ==========================================

-- Creating Dataset Back_ups

CREATE TABLE fact_subscriptions_backup
 AS SELECT* FROM fact_subscriptions;
 
 
 CREATE TABLE dim_plans_backup
 AS SELECT* FROM dim_plans;
 
  CREATE TABLE dim_customers_backup
 AS SELECT* FROM dim_customers;
 
 
 SELECT COUNT(*) AS rows_count
FROM fact_subscriptions_backup;

SELECT COUNT(*) AS rows_count
FROM dim_customers_backup;


SELECT COUNT(*) AS rows_count
FROM dim_plans_backup;


-- TASK 2: CHECKING INCONSISTENT TEXT VALUES

SELECT Location, TRIM(Location) AS trimed_location
FROM dim_customers;


SELECT*
FROM dim_customers
WHERE lower(Location) <> Location;

SELECT*
FROM dim_customers
WHERE UPPER(Location) <> Location;


SELECT*
FROM dim_customers
WHERE TRIM(Customer_Name) = '';



SELECT*
FROM dim_customers
WHERE LOWER(Customer_Name) <> Customer_Name;

SELECT*
FROM dim_customers
WHERE UPPER(Customer_Name) <> Customer_Name;


SELECT Customer_Name, TRIM(Customer_Name) AS trimed_Name
FROM dim_customers;




SELECT Plan_Name, TRIM(Plan_Name) AS trimmed_plan, Service_Type, 
TRIM(Service_Type) AS trimmed_service
FROM dim_plans;



SELECT*
FROM dim_plans
WHERE LOWER(Plan_Name) <> Plan_Name OR LOWER(Service_Type) <> Service_Type;


SELECT*
FROM dim_plans
WHERE UPPER(Plan_Name) <> Plan_Name OR UPPER(Service_Type) <> Service_Type;


SELECT DISTINCT  Gender
FROM dim_customers;


SELECT Gender, TRIM(Gender) AS trimmed_gender
FROM dim_customers;


SELECT*
FROM dim_customers
WHERE LOWER(Gender) <> Gender;

SELECT*
FROM dim_customers
WHERE UPPER(Gender) <> Gender;


SELECT*
FROM fact_subscriptions
WHERE TRIM(Subscription_ID) <> Subscription_ID;


SELECT*
FROM dim_customers
WHERE TRIM(Customer_ID) <> Customer_ID;

SELECT*
FROM dim_plans
WHERE TRIM(Plan_ID) <> Plan_ID;


SELECT DISTINCT Churn_Status
FROM fact_subscriptions;


SELECT Churn_Status, TRIM(Churn_Status) AS trimmed_status
FROM fact_subscriptions;


SELECT*
FROM fact_subscriptions
WHERE LOWER(Churn_Status) <> Churn_Status OR UPPER(Churn_Status) <> Churn_Status;


-- 03. Standardizing Signup Date

SELECT Subscription_ID, STR_TO_DATE(Signup_Date, '%Y-%m-%d')AS Converted_date
FROM fact_subscriptions;

SELECT Subscription_ID, STR_TO_DATE(Signup_Date, '%Y-%m-%d')AS Converted_date
FROM fact_subscriptions
WHERE STR_TO_DATE(Signup_Date, '%Y-%m-%d') IS NULL;


ALTER TABLE fact_subscriptions
ADD COLUMN Signup_Date_Clean DATE;


SELECT*
FROM fact_subscriptions;



UPDATE fact_subscriptions
SET Signup_Date_Clean = STR_TO_DATE(Signup_Date, '%Y-%m-%d')
WHERE Subscription_ID IS NOT NULL;


SELECT COUNT(*) AS count_rows
FROM fact_subscriptions
WHERE  Signup_Date_Clean IS NULL;


SELECT COUNT( Signup_Date_Clean) AS Signup_Date_Clean
FROM fact_subscriptions;

-- checking the backup Date
SELECT COUNT(Signup_Date) AS original_table
FROM fact_subscriptions_backup;


ALTER TABLE fact_subscriptions
RENAME COLUMN Signup_Date_Clean TO Signup__Date;

ALTER TABLE fact_subscriptions
RENAME COLUMN Signup__Date TO Signup_Date;

ALTER TABLE fact_subscriptions
DROP COLUMN Signup_Date;


SELECT COUNT(Signup__Date)
FROM fact_subscriptions;

SELECT*
FROM fact_subscriptions;

-- 04. Checking Monthly Charges

SELECT MIN(Monthly_Charges) AS min_charge, Max(Monthly_Charges) AS max_charge
FROM fact_subscriptions;

SELECT Subscription_ID, Monthly_Charges, ROUND(Monthly_Charges,2) AS rounded_charge
FROM fact_subscriptions
WHERE Monthly_Charges <> ROUND(Monthly_Charges,2);

SELECT Monthly_Charges
FROM fact_subscriptions
WHERE Monthly_Charges IS NULL OR Monthly_Charges <=0;

 -- 05.Validate Churn
 
 SELECT DISTINCT Churn_Status
 FROM fact_subscriptions;
 
SELECT*
FROM fact_subscriptions
WHERE TRIM(Churn_Status) <> Churn_Status;


-- 06.Validate Churn

SELECT *
FROM dim_customers
WHERE TRIM(Customer_Name) <> Customer_Name
   OR TRIM(Location) <> Location
   OR TRIM(Gender) <> Gender;

-- 07. Validate dim_plans

SELECT *
FROM dim_plans
WHERE TRIM(Plan_Name) <> Plan_Name
   OR TRIM(Service_Type) <> Service_Type;
   
   
   -- Final verification
   SELECT 'dim_customers' AS table_name, COUNT(*) AS rows_count FROM dim_customers
   UNION ALL
   SELECT 'fact_subscriptions', COUNT(*) FROM fact_subscriptions
   UNION ALL
   SELECT 'dim_plans', COUNT(*) FROM dim_plans;
