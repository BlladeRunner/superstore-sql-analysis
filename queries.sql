/* =========================
   Superstore — SQL queries
   DB: SQLite (table: superstore)
   Columns: RowID, OrderID, OrderDate, ShipDate, ShipMode, CustomerID, CustomerName, Segment,
            Country, City, State, PostalCode, Region, ProductID, Category, SubCategory,
            ProductName, Sales, Quantity, Discount, Profit
   ========================= */

/* 01) Basic checks */
PRAGMA table_info('superstore');
SELECT COUNT(*) AS rows FROM superstore;
SELECT MIN(OrderDate) AS min_d, MAX(OrderDate) AS max_d FROM superstore;

/* 02) op 10 clients by revenue */
SELECT
  CustomerID, CustomerName,
  ROUND(SUM(Sales), 2)   AS revenue,
  ROUND(SUM(Profit), 2)  AS profit,
  ROUND(SUM(Profit) * 1.0 / NULLIF(SUM(Sales),0), 4) AS margin
FROM superstore
GROUP BY CustomerID, CustomerName
ORDER BY revenue DESC
LIMIT 10;

/* 03) Average receipt (AOV) by category — the average order amount within a category */
WITH cat_order AS (
  SELECT Category, OrderID, SUM(Sales) AS order_value
  FROM superstore
  GROUP BY Category, OrderID
)
SELECT
  Category,
  ROUND(AVG(order_value), 2) AS avg_order_value
FROM cat_order
GROUP BY Category
ORDER BY avg_order_value DESC;

/* 04) Total AOV for all orders (for comparison) */
WITH order_totals AS (
  SELECT OrderID, SUM(Sales) AS order_value
  FROM superstore
  GROUP BY OrderID
)
SELECT ROUND(AVG(order_value), 2) AS overall_aov
FROM order_totals;

/* 05) Monthly sales dynamics (revenue and profit) */
SELECT
  strftime('%Y-%m', OrderDate) AS ym,
  ROUND(SUM(Sales), 2)  AS revenue,
  ROUND(SUM(Profit), 2) AS profit
FROM superstore
GROUP BY ym
ORDER BY ym;

/* 06) Sales and profit by region (with margin) */
SELECT
  Region,
  ROUND(SUM(Sales), 2)  AS revenue,
  ROUND(SUM(Profit), 2) AS profit,
  ROUND(SUM(Profit) * 1.0 / NULLIF(SUM(Sales),0), 4) AS margin
FROM superstore
GROUP BY Region
ORDER BY revenue DESC;

/* 07) Segmentation by Segment (revenue, average discount, profit, number of orders) */
SELECT
  Segment,
  ROUND(SUM(Sales), 2)  AS revenue,
  ROUND(AVG(Discount), 4) AS avg_discount,
  ROUND(SUM(Profit), 2) AS profit,
  COUNT(DISTINCT OrderID) AS orders
FROM superstore
GROUP BY Segment
ORDER BY revenue DESC;

/* 08) Top 10 cities by revenue */
SELECT
  City, State,
  ROUND(SUM(Sales),2)  AS revenue,
  ROUND(SUM(Profit),2) AS profit
FROM superstore
GROUP BY City, State
ORDER BY revenue DESC
LIMIT 10;

/* 09) Products with maximum margin (weighted), with revenue threshold */
WITH prod AS (
  SELECT ProductID, ProductName,
         SUM(Sales)  AS sales_sum,
         SUM(Profit) AS profit_sum
  FROM superstore
  GROUP BY ProductID, ProductName
)
SELECT
  ProductID, ProductName,
  ROUND(sales_sum, 2)  AS revenue,
  ROUND(profit_sum, 2) AS profit,
  ROUND(profit_sum * 1.0 / NULLIF(sales_sum,0), 4) AS margin
FROM prod
WHERE sales_sum >= 1000 
ORDER BY margin DESC, revenue DESC
LIMIT 15;

/* 10) Products sold at a loss */
SELECT
  ProductID, ProductName,
  ROUND(SUM(Sales),2)  AS revenue,
  ROUND(SUM(Profit),2) AS profit
FROM superstore
GROUP BY ProductID, ProductName
HAVING SUM(Profit) < 0
ORDER BY profit ASC
LIMIT 15;

/* 11) Categories with the highest discounts (average discount) */
SELECT
  Category,
  ROUND(AVG(Discount), 4) AS avg_discount,
  ROUND(SUM(Sales), 2)    AS revenue,
  ROUND(SUM(Profit), 2)   AS profit
FROM superstore
GROUP BY Category
ORDER BY avg_discount DESC;

/* 12) TOP-5 products in each category by revenue (window functions) */
WITH prod_cat AS (
  SELECT
    Category,
    ProductID, ProductName,
    SUM(Sales) AS revenue
  FROM superstore
  GROUP BY Category, ProductID, ProductName
),
ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY Category ORDER BY revenue DESC) AS rnk
  FROM prod_cat
)
SELECT Category, rnk, ProductID, ProductName, ROUND(revenue,2) AS revenue
FROM ranked
WHERE rnk <= 5
ORDER BY Category, rnk;

/* 13) ABC-customer analysis (A < 80%, B < 95%, C — the rest) */
WITH cust AS (
  SELECT CustomerID, CustomerName, SUM(Sales) AS revenue
  FROM superstore
  GROUP BY CustomerID, CustomerName
),
ordered AS (
  SELECT
    CustomerID, CustomerName, revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_rev,
    SUM(revenue) OVER () AS total_rev
  FROM cust
),
labeled AS (
  SELECT *,
         cum_rev * 1.0 / total_rev AS cum_share,
         CASE
           WHEN cum_rev * 1.0 / total_rev <= 0.80 THEN 'A'
           WHEN cum_rev * 1.0 / total_rev <= 0.95 THEN 'B'
           ELSE 'C'
         END AS abc_class
  FROM ordered
)
SELECT CustomerID, CustomerName,
       ROUND(revenue,2) AS revenue,
       ROUND(cum_share,3) AS cum_share,
       abc_class
FROM labeled
ORDER BY revenue DESC;

/* 14) The impact of discounts: "theoretical" revenue without discounts vs actual */
SELECT
  ROUND(SUM(Sales), 2)                                            AS revenue_actual,
  ROUND(SUM(Sales * (1 - Discount)), 2)                           AS revenue_without_discount,
  ROUND(SUM(Sales) - SUM(Sales * (1 - Discount)), 2)              AS discount_impact
FROM superstore;

/* 15) ShipMode's share of revenue (structure of delivery channels) */
WITH t AS (
  SELECT ShipMode, SUM(Sales) AS revenue FROM superstore GROUP BY ShipMode
),
tot AS ( SELECT SUM(revenue) AS total_rev FROM t )
SELECT
  t.ShipMode,
  ROUND(t.revenue,2) AS revenue,
  ROUND(t.revenue * 1.0 / tot.total_rev, 4) AS share
FROM t CROSS JOIN tot
ORDER BY revenue DESC;
