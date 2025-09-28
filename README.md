# 🛒 Superstore Sales Analysis (SQLite + SQL)

## Overview

A compact SQL portfolio project on the classic **Sample Superstore** dataset.  
Goal: answer key business questions — who our best customers are, which products/segments are profitable, how revenue trends over time and across regions, and how discounts affect margins.

## Dataset

- Input file: `sample_superstore.csv` (~10k rows)
- Target table: `superstore` (created via `setup_superstore.sql`)
- Dates normalized to `YYYY-MM-DD`
- Columns: `RowID, OrderID, OrderDate, ShipDate, ShipMode, CustomerID, CustomerName, Segment, Country, City, State, PostalCode, Region, ProductID, Category, SubCategory, ProductName, Sales, Quantity, Discount, Profit`
