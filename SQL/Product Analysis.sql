-- ============================================================
-- SECTION 2 : PRODUCT ANALYSIS
-- ============================================================
 
-- ── 2.1 Top 10 Selling Product Categories by Orders ─────────
SELECT
    Product_Category,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)  AS Total_Revenue,
    ROUND(AVG(Order_Value), 2)        AS Avg_Order_Value,
    ROUND(AVG(Customer_Rating), 2)    AS Avg_Rating,
    ROUND(SUM(Profit), 2)             AS Total_Profit
FROM orders
GROUP BY Product_Category
ORDER BY Total_Orders DESC
LIMIT 10;
 
-- ── 2.2 Top Categories by Revenue ───────────────────────────
SELECT
    Product_Category,
    ROUND(SUM(Effective_Revenue), 2)  AS Total_Revenue,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Profit), 2)             AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Effective_Revenue) * 100, 2) AS Profit_Margin_Pct
FROM orders
GROUP BY Product_Category
ORDER BY Total_Revenue DESC;
 
-- ── 2.3 Least Selling Product Categories ────────────────────
SELECT
    Product_Category,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)  AS Total_Revenue,
    ROUND(AVG(Customer_Rating), 2)    AS Avg_Rating
FROM orders
GROUP BY Product_Category
ORDER BY Total_Orders ASC
LIMIT 10;
 
-- ── 2.4 Category Performance by Company ─────────────────────
SELECT
    Company,
    Product_Category,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(SUM(Effective_Revenue), 2)  AS Revenue
FROM orders
GROUP BY Company, Product_Category
ORDER BY Company, Revenue DESC;