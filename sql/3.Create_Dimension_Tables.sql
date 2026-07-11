USE SuperstoreDW;
GO

-- Table 1: DimDate
CREATE TABLE dim_Date (
    DateKey         INT PRIMARY KEY,        -- YYYYMMDD format
    FullDate        DATE,
    Day             INT,
    Month           INT,
    MonthName       VARCHAR(20),
    Quarter         INT,
    Year            INT,
    Weekday         VARCHAR(20),
    IsWeekend       BIT
);
GO


-- Table 2: DimCustomer
CREATE TABLE dim_Customer (
    CustomerKey     INT IDENTITY(1,1) PRIMARY KEY,
    Customer_ID     VARCHAR(50),
    Segment         VARCHAR(50)
);
GO


-- Table 3: DimProduct
CREATE TABLE dim_Product (
    ProductKey      INT IDENTITY(1,1) PRIMARY KEY,
    Product_ID      VARCHAR(50),
    Product_Name    VARCHAR(255),
    Category        VARCHAR(50),
    Sub_Category    VARCHAR(50)
);
GO

-- Table 4: DimLocation
CREATE TABLE dim_Location (
    LocationKey     INT IDENTITY(1,1) PRIMARY KEY,
    City            VARCHAR(100),
    State           VARCHAR(100),
    Postal_Code     INT,
    Region          VARCHAR(50),
    Country         VARCHAR(100)
);
GO

-- Table 5: DimShipper
CREATE TABLE dim_ShipMode (
    ShipModeKey      INT IDENTITY(1,1) PRIMARY KEY,
    Ship_Mode       VARCHAR(50),
	Ship_Tier       VARCHAR(50),
);
GO