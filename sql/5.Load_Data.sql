USE SuperstoreDW;
GO


-- POPULATE: dim_Date
WITH DateRange AS (
    SELECT CAST('2014-01-01' AS DATE) AS d
    UNION ALL
    SELECT DATEADD(DAY, 1, d)
    FROM DateRange
    WHERE d < '2018-01-31'  -- extended to cover Jan 2018 ship dates
)
INSERT INTO dim_Date (
    DateKey, FullDate, Day, Month, MonthName,
    Quarter, Year, Weekday, IsWeekend
)
SELECT
    CONVERT(INT, FORMAT(d, 'yyyyMMdd'))                             AS DateKey,
    d                                                               AS FullDate,
    DAY(d)                                                          AS Day,
    MONTH(d)                                                        AS Month,
    DATENAME(MONTH, d)                                              AS MonthName,
    DATEPART(QUARTER, d)                                            AS Quarter,
    YEAR(d)                                                         AS Year,
    DATENAME(WEEKDAY, d)                                            AS Weekday,
    CASE WHEN DATEPART(WEEKDAY, d) IN (1,7) THEN 1 ELSE 0 END      AS IsWeekend
FROM DateRange
OPTION (MAXRECURSION 2000);
GO

-- Verify the date range
SELECT
    COUNT(*)        AS Total_Dates,
    MIN(FullDate)   AS First_Date,
    MAX(FullDate)   AS Last_Date
FROM dim_Date;
GO

-------------------------------------
-- 2.Populating dim_Customer

INSERT INTO dim_Customer (Customer_ID, Segment)
SELECT DISTINCT
    CAST(Customer_ID    AS VARCHAR(50)),
    CAST(Segment        AS VARCHAR(50))
FROM stg_Orders
WHERE Customer_ID IS NOT NULL;
GO

-- Verify
SELECT TOP 5 * FROM dim_Customer;
GO

------------------------------------
-- 3.Populating dim_Product

INSERT INTO dim_Product (Product_ID, Product_Name, Category, Sub_Category)
SELECT DISTINCT
    CAST(Product_ID     AS VARCHAR(50)),
    CAST(Product_Name   AS VARCHAR(255)),
    CAST(Category       AS VARCHAR(50)),
    CAST(Sub_Category   AS VARCHAR(50))
FROM stg_Orders
WHERE Product_ID IS NOT NULL;
GO

-- Verify
SELECT TOP 5 * FROM dim_Product;
GO

----------------------------------
-- 4.Populating dim_Location
INSERT INTO dim_Location (City, State, Postal_Code, Region, Country)
SELECT DISTINCT
    CAST(City           AS VARCHAR(100)),
    CAST(State          AS VARCHAR(100)),
    CAST(Postal_Code    AS VARCHAR(20)),
    CAST(Region         AS VARCHAR(50)),
    CAST(Country        AS VARCHAR(100))
FROM stg_Orders
WHERE City IS NOT NULL;
GO

-- Verify
SELECT TOP 5 * FROM dim_Location;
GO

------------------------------
--5.Populating dim_ShipMode
INSERT INTO dim_ShipMode (Ship_Mode, Ship_Tier)
SELECT DISTINCT
    CAST(Ship_Mode AS VARCHAR(50)),
    CASE Ship_Mode
        WHEN 'Same Day'         THEN 'Express'
        WHEN 'First Class'      THEN 'Premium'
        WHEN 'Second Class'     THEN 'Standard'
        WHEN 'Standard Class'   THEN 'Economy'
        ELSE 'Unknown'
    END AS Ship_Tier
FROM stg_Orders
WHERE Ship_Mode IS NOT NULL;
GO

-- Verify
SELECT * FROM dim_ShipMode;
GO

