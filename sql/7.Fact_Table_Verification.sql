USE SuperstoreDW;
GO

-- 1. Row counts across all tables
SELECT 'stg_Orders'     AS TableName, COUNT(*) AS Rows FROM stg_Orders
UNION ALL
SELECT 'fact_Sales',                  COUNT(*)         FROM fact_Sales
UNION ALL
SELECT 'dim_Date',                    COUNT(*)         FROM dim_Date
UNION ALL
SELECT 'dim_Customer',                COUNT(*)         FROM dim_Customer
UNION ALL
SELECT 'dim_Product',                 COUNT(*)         FROM dim_Product
UNION ALL
SELECT 'dim_Location',                COUNT(*)         FROM dim_Location
UNION ALL
SELECT 'dim_ShipMode',                COUNT(*)         FROM dim_ShipMode;
GO

-- 2. Orphaned FK checks (all should return 0)
SELECT 'Orphaned CustomerKey'   AS Check_Name, COUNT(*) AS Issues
FROM fact_Sales WHERE CustomerKey  NOT IN (SELECT CustomerKey  FROM dim_Customer)
UNION ALL
SELECT 'Orphaned ProductKey',          COUNT(*)
FROM fact_Sales WHERE ProductKey   NOT IN (SELECT ProductKey   FROM dim_Product)
UNION ALL
SELECT 'Orphaned LocationKey',         COUNT(*)
FROM fact_Sales WHERE LocationKey  NOT IN (SELECT LocationKey  FROM dim_Location)
UNION ALL
SELECT 'Orphaned ShipModeKey',         COUNT(*)
FROM fact_Sales WHERE ShipModeKey  NOT IN (SELECT ShipModeKey  FROM dim_ShipMode)
UNION ALL
SELECT 'Orphaned OrderDateKey',        COUNT(*)
FROM fact_Sales WHERE OrderDateKey NOT IN (SELECT DateKey      FROM dim_Date)
UNION ALL
SELECT 'Orphaned ShipDateKey',         COUNT(*)
FROM fact_Sales WHERE ShipDateKey  NOT IN (SELECT DateKey      FROM dim_Date);
GO

-- 3. Measure sanity checks
SELECT
    COUNT(*)                AS Total_Orders,
    SUM(Sales)              AS Total_Sales,
    SUM(Profit)             AS Total_Profit,
    SUM(Quantity)           AS Total_Units,
    AVG(Discount)           AS Avg_Discount,
    AVG(Profit_Margin)      AS Avg_Profit_Margin,
    AVG(Shipping_Duration)  AS Avg_Ship_Days
FROM fact_Sales;
GO

SELECT
    COUNT(*) AS TotalFactRows,
    COUNT(OrderDateKey) AS OrderDates,
    COUNT(ShipDateKey) AS ShipDates,
    COUNT(CustomerKey) AS Customers,
    COUNT(ProductKey) AS Products,
    COUNT(LocationKey) AS Locations,
    COUNT(ShipModeKey) AS ShipModes
FROM dbo.fact_Sales;