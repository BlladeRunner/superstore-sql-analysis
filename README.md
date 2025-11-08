# 🛒 Superstore Sales Analysis (SQLite + SQL)

## 📊 Project Overview
This is a **SQL portfolio project** based on the classic **Sample Superstore** dataset.  
The goal is to explore and analyze key business questions such as:
- Which customers generate the most profit?
- Which regions and categories perform best?
- How do discounts impact profit margins?

The project demonstrates proficiency in SQL, business analysis, and data storytelling through queries.

---

## 🧱 Dataset
- **Source:** `sample_superstore.csv` (public Kaggle dataset)  
- **Size:** ~10,000 rows  
- **Date Range:** 2014-10-10 → 2017-12-30  
- **Target Table:** `superstore` (created by `setup_superstore.sql`)  
- **Key Columns:**  
  `OrderDate (YYYY-MM-DD)`, `Sales (REAL)`, `Profit (REAL)`, `Discount (0–1)`,  
  `Category`, `SubCategory`, `Segment`, `Region`, `CustomerName`, `ProductName`

---

## ⚙️ How to Reproduce
```bash
# 1️⃣ Build or refresh the SQLite database and load the CSV
sqlite3 superstore.db ".read setup_superstore.sql"

# 2️⃣ Run analysis queries (e.g. queries.sql)
# Inside VS Code with SQLTools: open queries.sql → select a statement → Ctrl+E, Ctrl+E
```

## 🧮 Analysis Highlights
The analysis includes:
🏆 Top-10 customers by total profit and sales volume.
💰 AOV by category (Average Order Value).
🌍 Regional and segment-level performance.
📉 Impact of discounts on margins and profit.
🧩 ABC classification and profitability cohorts.

## 🧠 Key Insights
🔹 The Consumer segment accounts for ~50% of total sales but lower profit margins.
🔹 The Corporate segment is the most profitable overall.
🔹 Furniture category has the lowest profit-to-sales ratio due to high shipping costs.
🔹 Regions West and East outperform others in both revenue and profit.
🔹 Discounts above 30% consistently destroy profit margins.

## 💼 Business Relevance - 
This analysis can help retail and e-commerce managers:
Identify the most profitable customer segments and regions.
Optimize discount strategies to avoid margin erosion.
Focus marketing campaigns on high-value customers.

🔙 [Back to Portfolio](https://github.com/BlladeRunner)
