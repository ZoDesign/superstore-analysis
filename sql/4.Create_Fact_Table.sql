USE SuperstoreDW;
GO

CREATE TABLE fact_Sales (
    SalesKey            INT IDENTITY(1,1) PRIMARY KEY,
    Order_ID            VARCHAR(50),
    OrderDateKey        INT           FOREIGN KEY REFERENCES dim_Date(DateKey),
    ShipDateKey         INT           FOREIGN KEY REFERENCES dim_Date(DateKey),
    CustomerKey         INT           FOREIGN KEY REFERENCES dim_Customer(CustomerKey),
    ProductKey          INT           FOREIGN KEY REFERENCES dim_Product(ProductKey),
    LocationKey         INT           FOREIGN KEY REFERENCES dim_Location(LocationKey),
    ShipModeKey         INT           FOREIGN KEY REFERENCES dim_ShipMode(ShipModeKey),
    Sales               DECIMAL(10,2),
    Quantity            INT,
    Discount            DECIMAL(5,2),
    Discount_Pct        VARCHAR(10),
    Profit              DECIMAL(10,2),
    Profit_Margin       DECIMAL(10,4),
    Profit_Status       VARCHAR(20),
    Unit_Price          DECIMAL(10,2),
    Shipping_Duration   INT,
    Order_Month         INT,
    Order_Year          INT
);
GO