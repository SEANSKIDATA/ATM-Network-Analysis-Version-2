# 📊 ATM Network Analysis — Version 2

SQL Portfolio Project | ATM Operations & Data Analysis  
**Author:** Sean Codner  

---

## 📌 Project Overview

This project analyzes ATM network performance using SQL, focusing on:

- Cash demand  
- Terminal performance  
- Operational efficiency  

The analysis simulates a real-world ATM network environment, where decisions around **cash allocation, servicing frequency, and terminal classification** are driven by data.

### 🎯 Objectives

- Identify high-performing and underperforming ATMs  
- Analyze regional cash demand patterns  
- Evaluate ATM performance against daily cash targets  
- Support operational decision-making using data  

---

## 🧱 Database Structure

The dataset is modeled using relational tables:

| Table | Description |
|------|-------------|
| `transactions` | ATM cash withdrawal activity |
| `atms` | ATM attributes (region, location type, tier, targets, branding) |
| `vendors` | Service providers (Brinks, Loomis, Garda) |

---

## ⚠️ Portfolio Classification Note

In this project, **Bank Branded (BB)** and **Portfolio Tier** are treated as separate concepts.

- **Bank Branded (BB)** refers to ATMs placed under a bank brand (e.g., Chase), where the financial institution selects the terminal location.  
  👉 This is a **branding and placement decision**, not driven by transaction volume.

- **Portfolio Tier** represents the **operational classification** of an ATM based on usage and transaction activity.

📌 A terminal may be **bank branded while belonging to any performance tier**.

---

## 📊 Portfolio Tier Definitions

| Tier | Description |
|------|------------|
| Iron | Fewer than 100 transactions per month |
| Bronze | ~200–250 transactions per month |
| Silver | ~250–500 transactions per month |
| Gold   | ~500–1000 transactions per month |
| Platinum | More than 1,000 transactions per month |

> Portfolio tiers in this project are modeled to reflect real ATM operational classifications.

---

## ❓ Business Questions Answered

- Which regions generate the highest cash demand?  
- Which ATMs dispense the most cash?  
- Which ATMs are overperforming or underperforming relative to targets?  
- What are the top-performing ATMs within each region?  
- How does performance vary across portfolio tiers?  
- Which ATMs require operational attention or reclassification?  

---

## 🔍 Key SQL Techniques Used

- `JOIN` — combining ATM and transaction data  
- `GROUP BY` — aggregating demand and performance metrics  
- `CASE` — generating business-friendly ATM IDs  
- `LPAD` — formatting terminal identifiers  
- `WINDOW FUNCTIONS` (`RANK`, `ROW_NUMBER`) — ranking and segmentation  
- `CTEs` — structuring complex queries  
- Aggregations: `SUM`, `AVG`, `ROUND`  

---

## 📈 Key Insights

- Certain regions consistently drive higher cash demand, requiring **increased funding and servicing frequency**  
- High-performing ATMs are often located in **transit hubs and retail-heavy locations**  
- Some lower-tier ATMs exceed expected demand, indicating potential **tier reclassification opportunities**  
- Underperforming ATMs may indicate **inefficient cash allocation or overfunding**  
- Portfolio tier segmentation supports **tier-based operational strategies**  

---

## 🧠 Example Insight (Operational Thinking)

Several lower-tier ATMs demonstrated sustained demand above their expected targets.

### Recommendation:
Evaluate these units for potential tier upgrades (e.g., Bronze → Silver or Gold), which would allow:

- Higher cash load limits  
- Improved servicing schedules  
- Reduced risk of cash outages  

---

## 🛠️ Assumptions & Notes

- ATM withdrawals are standardized to **$20 denominations**  
- Data represents **aggregated ATM activity**, not individual transactions  
- Portfolio tiers are **modeled classifications**, not calculated directly from raw transaction counts  
- Bank-branded designation is independent of performance  

---

## 📂 Repository Contents

- `analysis.sql` — full SQL analysis  
- Dataset files (`.csv`)  
- Dashboard screenshots (Google Sheets)  
- Project documentation  

---

## 🚀 Future Improvements

- Add time-series analysis (daily / weekly trends)  
- Incorporate outage and servicing data  
- Build an interactive dashboard (Tableau / Power BI)  
- Add predictive modeling for cash demand  

---

## 💼 Business Value

This project demonstrates how SQL can be used to:

- Translate raw transaction data into operational insights  
- Improve ATM network efficiency  
- Support data-driven decision-making  

---

## 📬 Contact

**Sean Codner**  
GitHub: https://github.com/SEANSKIDATA  
LinkedIn: https://www.linkedin.com/in/sean-codner-aa60822b/
