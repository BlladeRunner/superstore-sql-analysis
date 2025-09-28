# 🛒 Superstore Sales Analysis (SQLite + SQL)

## Overview

A compact SQL portfolio project on the classic **Sample Superstore** dataset.  
Goal: identify top customers, profitable products/segments, regional performance, time trends, and the impact of discounts on margins.

## Dataset

- Source: `sample_superstore.csv` (public Superstore sample)
- Size: ~10k rows (your import may vary slightly)
- Date range: `<fill after running> e.g., 2014-10-10 → 2017-12-30`
- Target table: `superstore` (built by `setup_superstore.sql`)
- Key columns: `OrderDate (YYYY-MM-DD), Sales (REAL), Profit (REAL), Discount (0–1), Category, SubCategory, Segment, Region, CustomerName, ProductName, ...`

## How to reproduce

```bash
# Build/refresh the SQLite DB and load the CSV (CLI is required for .mode/.import)
sqlite3 superstore.db ".read setup_superstore.sql"

# Run analysis queries in VS Code with SQLTools:
# open queries.sql → select a statement → Ctrl+E, Ctrl+E

```
