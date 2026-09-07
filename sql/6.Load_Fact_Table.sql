-- See exactly what's different between the duplicate products
SELECT Product_ID, Product_Name, COUNT(*) AS Occurrences
FROM dim_Product
GROUP BY Product_ID, Product_Name
HAVING COUNT(*) > 1
ORDER BY Product_ID;
GO

-- Remove duplicates from dim_Product keeping the first name only
WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Product_ID
            ORDER BY ProductKey
        ) AS RowNum
    FROM dim_Product
)
DELETE FROM CTE WHERE RowNum > 1;
GO

-- Verify no more duplicates
SELECT Product_ID, COUNT(*) AS Occurrences
FROM dim_Product
GROUP BY Product_ID
HAVING COUNT(*) > 1;
-- Should return no rows
GO

TRUNCATE TABLE fact_Sales;
GO


INSERT INTO fact_Sales (
    Order_ID,
    OrderDateKey,
    ShipDateKey,
    CustomerKey,
    ProductKey,
    LocationKey,
    ShipModeKey,
    Sales,
    Quantity,
    Discount,
    Profit,
    Profit_Margin,
    Profit_Status,
    Unit_Price,
    Shipping_Duration,
    Order_Month,
    Order_Year
)
SELECT
    CAST(s.Order_ID         AS VARCHAR(50)),
    CONVERT(INT, FORMAT(CAST(s.Order_Date AS DATE), 'yyyyMMdd'))    AS OrderDateKey,
    CONVERT(INT, FORMAT(CAST(s.Ship_Date  AS DATE), 'yyyyMMdd'))    AS ShipDateKey,
    c.CustomerKey,
    p.ProductKey,
    l.LocationKey,
    sm.ShipModeKey,
    CAST(REPLACE(REPLACE(s.Sales,           ',', ''), '$', '') AS DECIMAL(10,2)),
    CAST(REPLACE(s.Quantity,                ',', '')            AS INT),
    CAST(REPLACE(s.Discount,                ',', '')            AS DECIMAL(5,2)),
    CAST(REPLACE(REPLACE(s.Profit,          ',', ''), '$', '') AS DECIMAL(10,2)),
    CAST(REPLACE(s.Profit_Margin,           ',', '')            AS DECIMAL(10,4)),
    CAST(s.Profit_Status    AS VARCHAR(20)),
    CAST(REPLACE(REPLACE(s.Unit_Price,      ',', ''), '$', '') AS DECIMAL(10,2)),
    CAST(s.Shipping_Duration                                    AS INT),
    CAST(s.Order_Month                                          AS INT),
    CAST(s.Order_Year                                           AS INT)
FROM stg_Orders s
JOIN dim_Customer c     ON  CAST(s.Customer_ID  AS VARCHAR(50))  = c.Customer_ID
JOIN dim_Product  p     ON  CAST(s.Product_ID   AS VARCHAR(50))  = p.Product_ID
JOIN dim_Location l     ON  CAST(s.City         AS VARCHAR(100)) = l.City
                        AND CAST(s.State         AS VARCHAR(100)) = l.State
                        AND CAST(s.Postal_Code   AS VARCHAR(20))  = l.Postal_Code
JOIN dim_ShipMode sm    ON  CAST(s.Ship_Mode     AS VARCHAR(50))  = sm.Ship_Mode;
GO

-- Verify
SELECT COUNT(*) AS Total_Rows FROM fact_Sales;
GO