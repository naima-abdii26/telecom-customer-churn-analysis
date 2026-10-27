-- =============================================
-- 03.  Data Analysis
-- ==============================================

-- Question 01: Overall Churn Rate
-- Business Question: What percentage of subscriptions have churned?
SELECT Total_subscriptions,Total_churned, ROUND(Total_churned/Total_subscriptions*100, 2) AS Benchmark_rate
FROM
(
SELECT COUNT(Subscription_ID) AS Total_subscriptions,
SUM(CASE WHEN Churn_Status = 'Churned' THEN 1 ELSE 0 END) AS Total_churned
FROM fact_subscriptions
) AS Overall_Churn_Rate;


-- Question 02: Churn Rate by Plan
SELECT dp.Plan_Name, COUNT(fs.Subscription_ID) AS total_subscriptions,
SUM(CASE WHEN fs.Churn_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned_per_Plan,
ROUND(SUM(CASE WHEN fs.Churn_Status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(fs.Subscription_ID)*100,2) AS  Churn_rate_per_Plan
FROM fact_subscriptions fs
JOIN dim_plans dp ON fs.Plan_ID = dp.Plan_ID
GROUP BY dp.Plan_Name
ORDER BY Churn_rate_per_Plan DESC;


-- Question 03: Monthly Charges Analysis by Plan

SELECT dp.Plan_Name, MAX(fs.Monthly_Charges) AS Max_plan, MIN(fs.Monthly_Charges) AS Min_plan,
ROUND(Avg(fs.Monthly_Charges),2)AS Avg_plan
FROM fact_subscriptions fs
JOIN dim_plans dp ON fs.Plan_ID = dp.Plan_ID
GROUP BY dp.Plan_Name;


-- Question 04: Revenue at Risk from Churn

SELECT ROUND(SUM(Monthly_Charges),2) AS Monthly_Revenue_At_Risk
FROM fact_subscriptions
WHERE Churn_Status = 'Churned';


-- Question 05: Churned Subscriptions by Location
SELECT dc.Location,COUNT(*) AS Chured_by_location
FROM fact_subscriptions fs
JOIN dim_customers dc ON fs.Customer_ID = dc.Customer_ID
WHERE Churn_Status = 'Churned'
GROUP BY  dc.Location
ORDER BY Chured_by_location DESC;

-- Question 05B: Churn Rate by Location
SELECT Location,total_subscriptions, Churned,ROUND(Churned/total_subscriptions*100,2) AS churn_rate
FROM
(
SELECT dc.Location, COUNT(*) total_subscriptions,
SUM(CASE WHEN Churn_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned
FROM fact_subscriptions fs
JOIN dim_customers dc ON fs.Customer_ID = dc.Customer_ID
GROUP BY dc.Location
) AS RATE
ORDER BY  churn_rate DESC;


-- Question 06. Customer Churn by Age Group
SELECT COUNT(*) total_subscriptions,
CASE
    WHEN dc.Age BETWEEN 21 AND 30 THEN 'Young'
    WHEN dc.Age BETWEEN 31 AND 40 THEN 'Middle'
    WHEN dc.Age BETWEEN 41 AND 55 THEN 'Older'
END AS Age_Group,
SUM(CASE WHEN Churn_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn_Status = 'Churned' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_rate
FROM fact_subscriptions fs
JOIN dim_customers dc ON fs.Customer_ID = dc.Customer_ID
GROUP BY Age_Group;



-- Question 07. Which plans do young customers use, and how many have churned?
SELECT dp.Plan_Name, COUNT(*) total_subscriptions,
SUM(CASE WHEN fs.Churn_Status = 'Churned' THEN 1 ELSE 0 END) AS churned,
ROUND(SUM(CASE WHEN fs.Churn_Status = 'Churned' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churned_rate
FROM fact_subscriptions fs
JOIN dim_customers dc ON fs.Customer_ID = dc.Customer_ID
JOIN dim_plans dp ON  fs.Plan_ID = dp.Plan_ID
WHERE dc.Age BETWEEN 21 AND 30
GROUP BY dp.Plan_Name
ORDER BY Churned_rate DESC;


-- Question 08: Churn Rate by Service Type
SELECT Service_Type,total_subscriptions,Churned, 
ROUND(Churned/total_subscriptions*100,2) AS Churn_rate_service_type
FROM
(
SELECT dp.Service_Type, COUNT(*) AS total_subscriptions,
SUM(CASE WHEN Churn_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned
FROM fact_subscriptions fs
JOIN dim_plans dp ON fs.Plan_ID = dp.Plan_ID
GROUP BY dp.Service_Type
) AS Churned_rate
ORDER BY  Churn_rate_service_type DESC ;


-- Question 09. Monthly Revenue at Risk by Plan
SELECT dp.Plan_Name, ROUND(SUM(Monthly_Charges),2)AS Monthly_Revenue_At_Risk,
SUM(CASE WHEN Churn_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned_Subscriptions
FROM fact_subscriptions fs
JOIN dim_plans dp ON fs.Plan_ID = dp.Plan_ID
WHERE fs.Churn_Status = 'Churned'
GROUP BY dp.Plan_Name
ORDER BY Monthly_Revenue_At_Risk DESC ;

