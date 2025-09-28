.mode csv
.headers on

DROP TABLE IF EXISTS superstore_raw;
CREATE TABLE superstore_raw (
    RowID        INTEGER,
    OrderID      TEXT,
    OrderDate    TEXT,
    ShipDate     TEXT,
    ShipMode     TEXT,
    CustomerID   TEXT,
    CustomerName TEXT,
    Segment      TEXT,
    Country      TEXT,
    City         TEXT,
    State        TEXT,
    PostalCode   TEXT,
    Region       TEXT,
    ProductID    TEXT,
    Category     TEXT,
    SubCategory  TEXT,
    ProductName  TEXT,
    Sales        REAL,
    Quantity     INTEGER,
    Discount     REAL,
    Profit       REAL
);

.mode csv
.headers on
.import "./sample_superstore.csv" superstore_raw

DROP TABLE IF EXISTS superstore;
CREATE TABLE superstore AS
SELECT
  CAST(RowID AS INTEGER) AS RowID,
  OrderID,
  date(substr(OrderDate,7,4)||'-'||substr(OrderDate,1,2)||'-'||substr(OrderDate,4,2)) AS OrderDate,
  date(substr(ShipDate,7,4) ||'-'||substr(ShipDate,1,2) ||'-'||substr(ShipDate,4,2))  AS ShipDate,
  ShipMode,
  CustomerID,
  CustomerName,
  Segment,
  Country,
  City,
  State,
  PostalCode,
  Region,
  ProductID,
  Category,
  SubCategory,
  ProductName,
  CAST(Sales    AS REAL)    AS Sales,
  CAST(Quantity AS INTEGER) AS Quantity,
  CAST(Discount AS REAL)    AS Discount,
  CAST(Profit   AS REAL)    AS Profit
FROM superstore_raw;

CREATE INDEX IF NOT EXISTS idx_superstore_orderdate ON superstore(OrderDate);
CREATE INDEX IF NOT EXISTS idx_superstore_customer  ON superstore(CustomerID);
CREATE INDEX IF NOT EXISTS idx_superstore_region    ON superstore(Region);
CREATE INDEX IF NOT EXISTS idx_superstore_category  ON superstore(Category);
SELECT 'rows_in_superstore', COUNT(*) FROM superstore;
SELECT 'min_max_orderdate', MIN(OrderDate), MAX(OrderDate) FROM superstore;
