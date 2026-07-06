-- ============================================================
-- SECTION 6 : BUSINESS ANALYTICS
-- ============================================================
 
-- ── 6.1 Peak Ordering Hours ─────────────────────────────────
SELECT
    Order_Hour,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)  AS Revenue,
    ROUND(AVG(Order_Value), 2)        AS Avg_Order_Value
FROM orders
GROUP BY Order_Hour
ORDER BY Total_Orders DESC;
 
-- ── 6.2 Peak Hours – Top 5 ──────────────────────────────────
SELECT
    Order_Hour,
    COUNT(Order_ID) AS Total_Orders
FROM orders
GROUP BY Order_Hour
ORDER BY Total_Orders DESC
LIMIT 5;
 
-- ── 6.3 Weekend vs Weekday Sales ────────────────────────────
SELECT
    CASE
        WHEN Weekday_Name IN ('Saturday','Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END                                   AS Day_Type,
    COUNT(Order_ID)                       AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)      AS Total_Revenue,
    ROUND(AVG(Order_Value), 2)            AS Avg_Order_Value,
    ROUND(AVG(Delivery_Time_Min), 2)      AS Avg_Delivery_Min,
    ROUND(AVG(Customer_Rating), 2)        AS Avg_Rating
FROM orders
GROUP BY Day_Type;
 
-- ── 6.4 Discount Impact Analysis ────────────────────────────
SELECT
    CASE WHEN Discount_Applied = 1 THEN 'Discounted' ELSE 'Full Price' END AS Order_Type,
    COUNT(Order_ID)                        AS Total_Orders,
    ROUND(SUM(Order_Value), 2)             AS Gross_Value,
    ROUND(SUM(Effective_Revenue), 2)       AS Net_Revenue,
    ROUND(SUM(Discount_Amount), 2)         AS Total_Discount_Given,
    ROUND(AVG(Order_Value), 2)             AS Avg_Order_Value,
    ROUND(AVG(Customer_Rating), 2)         AS Avg_Rating,
    ROUND(AVG(Items_Count), 2)             AS Avg_Items_Per_Order,
    ROUND(SUM(Profit), 2)                  AS Total_Profit
FROM orders
GROUP BY Order_Type;
 
-- ── 6.5 Discount Impact by Category ─────────────────────────
SELECT
    Product_Category,
    SUM(CASE WHEN Discount_Applied = 1 THEN 1 ELSE 0 END) AS Discounted_Orders,
    SUM(CASE WHEN Discount_Applied = 0 THEN 1 ELSE 0 END) AS Full_Price_Orders,
    ROUND(AVG(CASE WHEN Discount_Applied = 1 THEN Customer_Rating END), 2) AS Avg_Rating_Discounted,
    ROUND(AVG(CASE WHEN Discount_Applied = 0 THEN Customer_Rating END), 2) AS Avg_Rating_Full_Price,
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount_INR
FROM orders
GROUP BY Product_Category
ORDER BY Total_Discount_INR DESC;
 
-- ── 6.6 Cancellation Analysis ───────────────────────────────
-- Low rating (1 or 2) + long delivery = likely cancellation/bad experience proxy
SELECT
    CASE
        WHEN Customer_Rating = 1 THEN 'Very Dissatisfied (1★)'
        WHEN Customer_Rating = 2 THEN 'Dissatisfied (2★)'
        WHEN Customer_Rating = 3 THEN 'Neutral (3★)'
        WHEN Customer_Rating = 4 THEN 'Satisfied (4★)'
        ELSE 'Very Satisfied (5★)'
    END AS Rating_Category,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(AVG(Delivery_Time_Min), 2) AS Avg_Delivery_Min,
    ROUND(AVG(Order_Value), 2)       AS Avg_Order_Value,
    ROUND(COUNT(Order_ID) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS Pct_of_Total
FROM orders
GROUP BY Rating_Category
ORDER BY Customer_Rating;
 
-- ── 6.7 Cancellation Risk by Company ────────────────────────
SELECT
    Company,
    COUNT(CASE WHEN Customer_Rating <= 2 THEN 1 END) AS High_Risk_Orders,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(COUNT(CASE WHEN Customer_Rating <= 2 THEN 1 END) * 100.0 / COUNT(Order_ID), 2) AS Risk_Rate_Pct,
    ROUND(AVG(Delivery_Time_Min), 2) AS Avg_Delivery_Min
FROM orders
GROUP BY Company
ORDER BY Risk_Rate_Pct DESC;
 
-- ── 6.8 Refund Analysis ─────────────────────────────────────
-- Proxy: orders with low rating AND discount applied (likely refund requested)
SELECT
    'Potential Refund Orders'          AS Category,
    COUNT(Order_ID)                    AS Count,
    ROUND(SUM(Order_Value), 2)         AS Gross_Value_At_Risk,
    ROUND(AVG(Delivery_Time_Min), 2)   AS Avg_Delivery_Min,
    ROUND(AVG(Customer_Rating), 2)     AS Avg_Rating
FROM orders
WHERE Customer_Rating <= 2 AND Discount_Applied = 1;
 
-- ── 6.9 Refund Risk by Product Category ─────────────────────
SELECT
    Product_Category,
    COUNT(Order_ID)                   AS Refund_Risk_Orders,
    ROUND(SUM(Order_Value), 2)        AS Revenue_At_Risk,
    ROUND(AVG(Delivery_Time_Min), 2)  AS Avg_Delivery_Min
FROM orders
WHERE Customer_Rating <= 2 AND Discount_Applied = 1
GROUP BY Product_Category
ORDER BY Refund_Risk_Orders DESC;
 
-- ── 6.10 Payment Method Analysis ────────────────────────────
SELECT
    Payment_Method,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)  AS Total_Revenue,
    ROUND(AVG(Order_Value), 2)        AS Avg_Order_Value,
    ROUND(AVG(Customer_Rating), 2)    AS Avg_Rating,
    ROUND(COUNT(Order_ID) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS Order_Share_Pct
FROM orders
GROUP BY Payment_Method
ORDER BY Total_Orders DESC;
 
-- ── 6.11 Company Overall Leaderboard ────────────────────────
SELECT
    Company,
    COUNT(Order_ID)                    AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)   AS Total_Revenue,
    ROUND(SUM(Profit), 2)              AS Total_Profit,
    ROUND(AVG(Order_Value), 2)         AS Avg_Order_Value,
    ROUND(AVG(Customer_Rating), 2)     AS Avg_Rating,
    ROUND(AVG(Delivery_Time_Min), 2)   AS Avg_Delivery_Min,
    SUM(CASE WHEN Discount_Applied=1 THEN 1 ELSE 0 END) AS Discounted_Orders,
    COUNT(CASE WHEN Customer_Rating <= 2 THEN 1 END)    AS At_Risk_Orders
FROM orders
GROUP BY Company
ORDER BY Total_Revenue DESC;