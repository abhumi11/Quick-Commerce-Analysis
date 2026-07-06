-- ============================================================
-- SECTION 5 : CITY ANALYSIS
-- ============================================================
 
-- ── 5.1 Revenue by City ──────────────────────────────────────
SELECT
    City,
    ROUND(SUM(Effective_Revenue), 2)  AS Total_Revenue,
    ROUND(SUM(Profit), 2)             AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Effective_Revenue) * 100, 2) AS Profit_Margin_Pct
FROM orders
GROUP BY City
ORDER BY Total_Revenue DESC;
 
-- ── 5.2 Orders by City ──────────────────────────────────────
SELECT
    City,
    COUNT(Order_ID)                    AS Total_Orders,
    ROUND(AVG(Order_Value), 2)         AS Avg_Order_Value,
    ROUND(AVG(Delivery_Time_Min), 2)   AS Avg_Delivery_Min,
    ROUND(AVG(Customer_Rating), 2)     AS Avg_Rating
FROM orders
GROUP BY City
ORDER BY Total_Orders DESC;
 
-- ── 5.3 Best Performing City ────────────────────────────────
SELECT
    City,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)  AS Total_Revenue,
    ROUND(AVG(Order_Value), 2)        AS Avg_Order_Value,
    ROUND(AVG(Customer_Rating), 2)    AS Avg_Rating,
    ROUND(AVG(Delivery_Time_Min), 2)  AS Avg_Delivery_Min,
    ROUND(SUM(Profit), 2)             AS Total_Profit
FROM orders
GROUP BY City
ORDER BY Total_Revenue DESC
LIMIT 5;
 
-- ── 5.4 Company Market Share by City ────────────────────────
SELECT
    City,
    Company,
    COUNT(Order_ID)  AS Orders,
    ROUND(SUM(Effective_Revenue), 2) AS Revenue
FROM orders
GROUP BY City, Company
ORDER BY City, Revenue DESC;
 