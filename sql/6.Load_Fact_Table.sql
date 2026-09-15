USE SuperstoreDW;
GO

-- ============================================
-- 1. Check duplicate products
-- ============================================

SELECT 
    Product_ID, 
    Product_Name, 
    COUNT(*) AS Occurrences
FROM dbo.dim_Product
GROUP BY Product_ID, Product_Name
HAVING COUNT(*) > 1
ORDER BY Product_ID;
GO


-- ============================================
-- 2. Empty the fact table FIRST
--    This removes FK references to ProductKey
-- ============================================

TRUNCATE TABLE dbo.fact_Sales;
GO


-- ============================================
-- 3. Remove duplicate products
--    Keep the first ProductKey for each Product_ID
-- ============================================

WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Product_ID
            ORDER BY ProductKey
        ) AS RowNum
    FROM dbo.dim_Product
)
DELETE FROM CTE
WHERE RowNum > 1;
GO


-- ============================================
-- 4. Verify duplicate Product_IDs are gone
-- ============================================

SELECT 
    Product_ID, 
    COUNT(*) AS Occurrences
FROM dbo.dim_Product
GROUP BY Product_ID
HAVING COUNT(*) > 1;
-- Should return NO ROWS
GO


-- ============================================
-- 5. Reload fact table
-- ============================================

INSERT INTO dbo.fact_Sales (
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
    CAST(s.Order_ID AS VARCHAR(50)),
    CONVERT( INT,  FORMAT(CAST(s.Order_Date AS DATE), 'yyyyMMdd')) AS OrderDateKey,
    CONVERT( INT,  FORMAT(CAST(s.Ship_Date AS DATE), 'yyyyMMdd')) AS ShipDateKey,

    c.CustomerKey,
    p.ProductKey,
    l.LocationKey,
    sm.ShipModeKey,

    CAST( REPLACE(REPLACE(s.Sales, ',', ''), '$', '') AS DECIMAL(10,2) ),
    CAST( REPLACE(s.Quantity, ',', '') AS INT),
    CAST( REPLACE(s.Discount, ',', '') AS DECIMAL(5,2)),
    CAST(  REPLACE(REPLACE(s.Profit, ',', ''), '$', '')  AS DECIMAL(10,2)),
    CAST(  REPLACE(s.Profit_Margin, ',', '')  AS DECIMAL(10,4)),
    CAST(s.Profit_Status AS VARCHAR(20)),
    CAST(  REPLACE(REPLACE(s.Unit_Price, ',', ''), '$', '') AS DECIMAL(10,2)),
    CAST(s.Shipping_Duration AS INT),
    CAST(s.Order_Month AS INT),
    CAST(s.Order_Year AS INT)

FROM dbo.stg_Orders s

JOIN dbo.dim_Customer c
    ON CAST(s.Customer_ID AS VARCHAR(50)) = c.Customer_ID

JOIN dbo.dim_Product p
    ON CAST(s.Product_ID AS VARCHAR(50)) = p.Product_ID

JOIN dbo.dim_Location l
    ON CAST(s.City AS VARCHAR(100)) = l.City
    AND CAST(s.State AS VARCHAR(100)) = l.State
    AND CAST(s.Postal_Code AS VARCHAR(20)) = l.Postal_Code

JOIN dbo.dim_ShipMode sm
    ON CAST(s.Ship_Mode AS VARCHAR(50)) = sm.Ship_Mode;
GO


-- ============================================
-- 6. Verify fact table
-- ============================================

SELECT COUNT(*) AS Total_Rows
FROM dbo.fact_Sales;
GO
