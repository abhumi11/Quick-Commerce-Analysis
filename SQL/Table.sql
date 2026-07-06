CREATE TABLE orders (
    Order_ID                INT PRIMARY KEY,
    Company                 VARCHAR(100) NOT NULL,
    City                    VARCHAR(100) NOT NULL,
    Customer_Age            INT,
    Product_Category        VARCHAR(100),
    Payment_Method          VARCHAR(100),
    Order_Value             DECIMAL(10,2) NOT NULL,
    Discount_Applied        TINYINT,
    Discount_Amount         DECIMAL(10,2),
    Discount_Pct            DECIMAL(5,2),
    Effective_Revenue       DECIMAL(10,2),
    Cost                    DECIMAL(10,2),
    Profit                  DECIMAL(10,2),
    Delivery_Duration       VARCHAR(20),
    Distance_Km             DECIMAL(6,2),
    Items_Count             INT,
    Customer_Rating         INT,
    Delivery_Partner_Rating INT,
    Order_Hour              INT,
    Weekday_Name            VARCHAR(20),
    Month_Name              VARCHAR(20),
    CLV_Basic               DECIMAL(10,2)
);

UPDATE orders
SET
    Discount_Amount   = ROUND(CASE WHEN Discount_Applied = 1 THEN Order_Value * 0.10 ELSE 0 END, 2),
    Effective_Revenue = ROUND(Order_Value - CASE WHEN Discount_Applied = 1 THEN Order_Value * 0.10 ELSE 0 END, 2),
    Profit            = ROUND(
                            (Order_Value - CASE WHEN Discount_Applied = 1 THEN Order_Value * 0.10 ELSE 0 END)
                            - Order_Value * 0.65, 2),          -- 65 % assumed cost ratio
    Discount_Pct      = ROUND(CASE WHEN Discount_Applied = 1 THEN 10.00 ELSE 0 END, 2),
    -- Synthetic hour bucketed from Order_ID for demo (replace with real timestamp if available)
    Order_Hour        = MOD(Order_ID, 24),
    Weekday_Name      = ELT(MOD(Order_ID, 7) + 1, 'Monday','Tuesday','Wednesday',
                            'Thursday','Friday','Saturday','Sunday'),
    Month_Name        = ELT(MOD(Order_ID, 12) + 1,
                            'January','February','March','April','May','June',
                            'July','August','September','October','November','December'),
    CLV_Basic         = ROUND(Order_Value * 24 * (Customer_Rating / 5.0), 2);
 
-- Verify a few rows
SELECT Order_ID, Order_Value, Discount_Amount, Effective_Revenue,
       Profit, Order_Hour, Weekday_Name, Month_Name, CLV_Basic
FROM orders
LIMIT 5;

ALTER TABLE orders
ADD COLUMN Delivery_Time_Min INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE orders
SET Delivery_Time_Min =
CASE
    WHEN Delivery_Duration = 'Fast' THEN FLOOR(15 + RAND() * 6)      -- 15–20 min
    WHEN Delivery_Duration = 'Medium' THEN FLOOR(21 + RAND() * 15)   -- 21–35 min
    WHEN Delivery_Duration = 'Slow' THEN FLOOR(36 + RAND() * 25)     -- 36–60 min
END;

SET SQL_SAFE_UPDATES = 1;

SELECT Order_ID,
       Delivery_Duration,
       Delivery_Time_Min
FROM orders
LIMIT 10;

SELECT DISTINCT Delivery_Duration
FROM orders;

SET SQL_SAFE_UPDATES = 0;

UPDATE orders
SET Delivery_Time_Min = Delivery_Duration
WHERE Order_ID > 0;

SET SQL_SAFE_UPDATES = 1;

SELECT Order_ID,
       Delivery_Duration,
       Delivery_Time_Min
FROM orders
LIMIT 10;