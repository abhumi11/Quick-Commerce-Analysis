-- SECTION 1 : SALES ANALYSIS
-- ============================================================
 
-- ── 1.1 Total Orders ────────────────────────────────────────
SELECT
    COUNT(Order_ID)             AS Total_Orders
FROM orders;
 
 -- ── 1.2 Total Revenue ───────────────────────────────────────
SELECT
    ROUND(SUM(Effective_Revenue), 2)  AS Total_Revenue_INR,
    ROUND(SUM(Order_Value), 2)        AS Gross_Order_Value_INR,
    ROUND(SUM(Discount_Amount), 2)    AS Total_Discounts_Given_INR,
    ROUND(SUM(Profit), 2)             AS Total_Profit_INR
FROM orders;

-- ── 1.3 Average Order Value ─────────────────────────────────
SELECT
    ROUND(AVG(Order_Value), 2)        AS Avg_Order_Value,
    ROUND(AVG(Effective_Revenue), 2)  AS Avg_Effective_Revenue,
    ROUND(AVG(Profit), 2)             AS Avg_Profit,
    MIN(Order_Value)                  AS Min_Order_Value,
    MAX(Order_Value)                  AS Max_Order_Value
FROM orders;
 
-- ── 1.4 Monthly Revenue ─────────────────────────────────────
SELECT
    Month_Name,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)  AS Monthly_Revenue,
    ROUND(AVG(Order_Value), 2)        AS Avg_Order_Value,
    ROUND(SUM(Profit), 2)             AS Monthly_Profit
FROM orders
GROUP BY Month_Name
ORDER BY FIELD(Month_Name,
    'January','February','March','April','May','June',
    'July','August','September','October','November','December');
 
-- ── 1.5 Daily Revenue (by Day of Week) ──────────────────────
SELECT
    Weekday_Name                      AS Day_of_Week,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)  AS Daily_Revenue,
    ROUND(AVG(Order_Value), 2)        AS Avg_Order_Value
FROM orders
GROUP BY Weekday_Name
ORDER BY FIELD(Weekday_Name,
    'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');