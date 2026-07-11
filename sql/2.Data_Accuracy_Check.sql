USE SuperstoreDW;
GO

-- 1. Total row count (Superstore should be ~9,994)
SELECT COUNT(*) AS Total_Rows FROM stg_Orders;

-- 2. Verify Sales values look reasonable
SELECT TOP 10 Order_ID, Sales, Product_Name,Profit, Discount FROM stg_Orders;

--3. Verify highest selling products 
SELECT TOP 10 Product_Name,
SUM(CAST(Quantity AS INT)) AS TotalQuantitySold
FROM stg_Orders
GROUP BY Product_Name
ORDER BY TotalQuantitySold DESC;

-- 4. Verify date range 
SELECT 
    MIN(Order_Date) AS Earliest_Order,
    MAX(Order_Date) AS Latest_Order
FROM stg_Orders;

--5. Verify Product Categories 
SELECT COUNT (DISTINCT Product_Name) AS unique_products
FROM stg_Orders;

--6. Verify that there aren't NULLS 
SELECT * 
FROM stg_Orders
WHERE Order_ID is null 
OR Order_Date is null
OR Ship_Date is null 
OR Ship_Mode is null 
OR Customer_ID is null 
OR Segment is null 
OR Country is null 
OR City is null 
OR State is null
OR Postal_Code is null;
