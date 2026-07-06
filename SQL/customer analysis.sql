-- ============================================================
-- SECTION 3 : CUSTOMER ANALYSIS
-- ============================================================
 
-- ── 3.1 Total Unique Customers (by age proxy) ───────────────
-- Note: No explicit Customer_ID in dataset; Customer_Age used as demographic grouping.
-- Orders per Customer_Age bracket as proxy for customer segmentation.
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_Age) AS Distinct_Age_Groups
FROM orders;
 
-- ── 3.2 Customer Age Segmentation ───────────────────────────
SELECT
    CASE
        WHEN Customer_Age BETWEEN 18 AND 25 THEN '18-25 (Gen Z)'
        WHEN Customer_Age BETWEEN 26 AND 35 THEN '26-35 (Millennial)'
        WHEN Customer_Age BETWEEN 36 AND 45 THEN '36-45 (Gen X)'
        WHEN Customer_Age BETWEEN 46 AND 55 THEN '46-55 (Boomers)'
        ELSE '56+ (Senior)'
    END                                   AS Age_Group,
    COUNT(Order_ID)                       AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)      AS Total_Revenue,
    ROUND(AVG(Order_Value), 2)            AS Avg_Order_Value,
    ROUND(AVG(CLV_Basic), 2)             AS Avg_CLV
FROM orders
GROUP BY Age_Group
ORDER BY Total_Revenue DESC;
 
-- ── 3.3 Repeat Customers (same age ordering multiple times) ─
-- Using Customer_Age as a customer proxy (no Customer_ID available)
SELECT
    Customer_Age,
    COUNT(Order_ID)               AS Times_Ordered,
    ROUND(SUM(Order_Value), 2)    AS Total_Spent,
    ROUND(AVG(Customer_Rating), 2) AS Avg_Rating_Given
FROM orders
GROUP BY Customer_Age
HAVING COUNT(Order_ID) > 1
ORDER BY Times_Ordered DESC;
 
-- ── 3.4 Top Customers by Spending (by Age Group) ────────────
SELECT
    Customer_Age,
    COUNT(Order_ID)               AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2) AS Total_Spending,
    ROUND(AVG(Order_Value), 2)    AS Avg_Order_Value,
    ROUND(MAX(CLV_Basic), 2)      AS Max_CLV
FROM orders
GROUP BY Customer_Age
ORDER BY Total_Spending DESC
LIMIT 20;
 
-- ── 3.5 Customer Rating Distribution ────────────────────────
SELECT
    Customer_Rating,
    COUNT(Order_ID)  AS Total_Orders,
    ROUND(COUNT(Order_ID) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS Pct_of_Orders
FROM orders
GROUP BY Customer_Rating
ORDER BY Customer_Rating DESC;
 
-- ── 3.6 Average CLV by Company ──────────────────────────────
SELECT
    Company,
    ROUND(AVG(CLV_Basic), 2)   AS Avg_CLV,
    ROUND(MAX(CLV_Basic), 2)   AS Max_CLV,
    COUNT(Order_ID)             AS Total_Orders
FROM orders
GROUP BY Company
ORDER BY Avg_CLV DESC;
 
