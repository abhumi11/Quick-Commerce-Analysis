-- ============================================================
-- SECTION 4 : DELIVERY ANALYSIS
-- ============================================================
 
-- ── 4.1 Average Delivery Time ────────────────────────────────
SELECT
    ROUND(AVG(Delivery_Time_Min), 2)   AS Avg_Delivery_Time_Min,
    MIN(Delivery_Time_Min)             AS Fastest_Delivery_Min,
    MAX(Delivery_Time_Min)             AS Slowest_Delivery_Min,
    ROUND(AVG(Distance_Km), 2)         AS Avg_Distance_Km
FROM orders;
 
-- ── 4.2 Average Delivery Time by Company ────────────────────
SELECT
    Company,
    ROUND(AVG(Delivery_Time_Min), 2)  AS Avg_Delivery_Min,
    ROUND(AVG(Distance_Km), 2)        AS Avg_Distance_Km,
    ROUND(AVG(Delivery_Partner_Rating), 2) AS Avg_Partner_Rating,
    COUNT(Order_ID)                   AS Total_Orders
FROM orders
GROUP BY Company
ORDER BY Avg_Delivery_Min ASC;
 
-- ── 4.3 Late Deliveries (> 30 minutes defined as late) ──────
SELECT
    COUNT(Order_ID)    AS Late_Deliveries,
    ROUND(COUNT(Order_ID) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS Late_Pct,
    ROUND(AVG(Delivery_Time_Min), 2) AS Avg_Late_Time_Min
FROM orders
WHERE Delivery_Time_Min > 30;
 
-- ── 4.4 Late Deliveries by Company ──────────────────────────
SELECT
    Company,
    COUNT(Order_ID)   AS Late_Deliveries,
    ROUND(AVG(Delivery_Time_Min), 2) AS Avg_Late_Time_Min,
    ROUND(COUNT(Order_ID) * 100.0 / (SELECT COUNT(*) FROM orders WHERE Delivery_Time_Min > 30), 2) AS Share_of_Late_Pct
FROM orders
WHERE Delivery_Time_Min > 30
GROUP BY Company
ORDER BY Late_Deliveries DESC;
 
-- ── 4.5 Cancelled Orders ────────────────────────────────────
-- Orders with Customer_Rating = 1 treated as highly dissatisfied / proxy for cancellation risk
SELECT
    COUNT(Order_ID) AS Dissatisfied_Orders,
    ROUND(COUNT(Order_ID) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS Pct_of_Total,
    ROUND(AVG(Delivery_Time_Min), 2) AS Avg_Delivery_Min
FROM orders
WHERE Customer_Rating = 1;
 
-- ── 4.6 Delivery Speed Buckets ──────────────────────────────
SELECT
    CASE
        WHEN Delivery_Time_Min <= 10  THEN '≤ 10 min (Express)'
        WHEN Delivery_Time_Min <= 20  THEN '11-20 min (Fast)'
        WHEN Delivery_Time_Min <= 30  THEN '21-30 min (Standard)'
        ELSE '> 30 min (Delayed)'
    END AS Delivery_Bucket,
    COUNT(Order_ID)                   AS Total_Orders,
    ROUND(AVG(Customer_Rating), 2)    AS Avg_Rating,
    ROUND(SUM(Effective_Revenue), 2)  AS Total_Revenue
FROM orders
GROUP BY Delivery_Bucket
ORDER BY FIELD(Delivery_Bucket,
    '≤ 10 min (Express)','11-20 min (Fast)','21-30 min (Standard)','> 30 min (Delayed)');
 
-- ── 4.7 Delivery Partner Performance ────────────────────────
SELECT
    Delivery_Partner_Rating,
    COUNT(Order_ID)                    AS Total_Orders,
    ROUND(AVG(Delivery_Time_Min), 2)   AS Avg_Delivery_Min,
    ROUND(AVG(Customer_Rating), 2)     AS Avg_Customer_Rating
FROM orders
GROUP BY Delivery_Partner_Rating
ORDER BY Delivery_Partner_Rating DESC;
 
 