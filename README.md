# ATM Network Analysis — Version 2
### SQL Portfolio Project — Sean Codner | Operations & Data Analyst

![ATM Network Analysis](atm_network_cover.png)

> *This project extends the ATM Network Operations Analysis by introducing a multi-table relational structure across three datasets — simulating how enterprise ATM network data is actually stored, queried, and analyzed across operational systems.*

---

## 📌 Project Overview

This project analyzes ATM withdrawal performance, cash target variance, and regional demand across a simulated national ATM network using a **three-table relational SQL structure**.

The analysis identifies high-performing terminals, evaluates variance between expected and actual withdrawal activity, calculates regional market share, and ranks ATMs within location types — replicating the kind of multi-source analysis performed daily in live ATM network operations.

---

## 🗄️ Database Structure

Three datasets are modeled as relational tables with `atm_terminal_id` and `region` as shared keys:

| Table | Description |
|-------|-------------|
| `regional_cash_demand` | Total cash withdrawn by region across the network |
| `highest_withdrawal_atms` | Top performing ATM terminals by total withdrawal volume |
| `cash_target_variance` | Expected vs. actual withdrawal performance per terminal |

### Entity Relationship

```
regional_cash_demand          cash_target_variance
─────────────────────         ────────────────────────────
region (PK)          ◄────── region
                              atm_terminal_id (PK)
                                    │
highest_withdrawal_atms             │
───────────────────────             │
atm_terminal_id (PK)  ◄────────────┘
region
location_type
portfolio_tier
total_cash_withdrawn
```

---

## ❓ Business Questions Answered

| # | Business Question | SQL Technique |
|---|-------------------|---------------|
| 1 | Which regions generate the highest total cash demand? | Aggregation + ORDER BY |
| 2 | Which ATMs exceed or miss their daily withdrawal targets? | JOIN + Variance Analysis |
| 3 | Which terminals are top performers AND over their targets? | Multi-table JOIN + Filtering |
| 4 | What percentage of network volume does each region control? | Subquery + Percentage Calculation |
| 5 | Which location types drive the highest withdrawal volume? | GROUP BY + RANK Window Function |

---

## 📊 Key Query Results

### 1. Regional Cash Demand Ranking

Identifies which regions drive the most total ATM withdrawal volume across the network.

```sql
SELECT
    region,
    total_cash_withdrawn_usd,
    ROUND(
        total_cash_withdrawn_usd * 100.0 /
        SUM(total_cash_withdrawn_usd) OVER(), 1
    ) AS pct_of_network
FROM regional_cash_demand
ORDER BY total_cash_withdrawn_usd DESC;
```

| Region    | Total Cash Withdrawn | % of Network |
|-----------|:--------------------:|:------------:|
| Northeast | $296,280             | 23.0%        |
| Southwest | $281,860             | 21.9%        |
| Southeast | $273,000             | 21.2%        |
| Midwest   | $225,160             | 17.5%        |
| West      | $179,900             | 14.0%        |
| **Total** | **$1,256,200**       | **100%**     |

**Operational Insight:** The Northeast leads network volume at 23% of total withdrawals. The top 3 regions (Northeast, Southwest, Southeast) account for 66% of all cash demand — meaning two-thirds of replenishment resources should be concentrated in these markets.

---

### 2. ATM Target Variance Analysis

Compares expected vs. actual withdrawal performance for each terminal — identifying which machines are exceeding targets and which are underperforming.

```sql
SELECT
    atm_terminal_id,
    region,
    location_type,
    portfolio_tier,
    avg_daily_withdrawal_target,
    actual_avg_withdrawal,
    variance,
    CASE
        WHEN variance > 0 THEN 'EXCEEDING TARGET'
        WHEN variance = 0 THEN 'ON TARGET'
        ELSE 'BELOW TARGET'
    END AS performance_status
FROM cash_target_variance
ORDER BY variance DESC;
```

| ATM ID  | Region    | Location       | Tier     | Target   | Actual   | Variance | Status           |
|---------|-----------|----------------|----------|:--------:|:--------:|:--------:|------------------|
| WA00001 | Northeast | Retail         | Platinum | $14,500  | $14,820  | +$320    | ✅ EXCEEDING     |
| BP00004 | Northeast | Transit Station| Platinum | $15,800  | $15,960  | +$160    | ✅ EXCEEDING     |
| WA00016 | Southwest | Retail         | BB       | $12,600  | $12,740  | +$140    | ✅ EXCEEDING     |
| WA00006 | Southeast | Retail         | BB       | $12,400  | $12,520  | +$120    | ✅ EXCEEDING     |
| SE00008 | Southeast | Bank Branch    | Platinum | $14,100  | $14,100  | $0       | ➡️ ON TARGET    |
| CV00002 | Northeast | Bank Branch    | BB       | $13,250  | $13,140  | -$100    | ⚠️ BELOW TARGET |
| SH00020 | Southwest | Airport        | BB       | $14,750  | $14,700  | -$60     | ⚠️ BELOW TARGET |

**Operational Insight:** WA00001 in the Northeast shows the highest positive variance at +$320 above daily target — this terminal likely needs its cash target revised upward and may warrant more frequent replenishment. CV00002 is the worst underperformer at -$100 below target despite being a Bank Branch location.

---

### 3. Top Performers Exceeding Their Targets (Multi-Table JOIN)

Joins the highest withdrawal ATMs with their target variance data to identify machines that are both high-volume AND beating expectations — the most operationally critical terminals in the network.

```sql
SELECT
    h.atm_terminal_id,
    h.region,
    h.location_type,
    h.portfolio_tier,
    h.total_cash_withdrawn,
    c.avg_daily_withdrawal_target,
    c.actual_avg_withdrawal,
    c.variance
FROM highest_withdrawal_atms h
JOIN cash_target_variance c
    ON h.atm_terminal_id = c.atm_terminal_id
WHERE c.variance >= 0
ORDER BY h.total_cash_withdrawn DESC;
```

| ATM ID  | Region    | Location        | Total Withdrawn | Daily Target | Actual Daily | Variance |
|---------|-----------|-----------------|:---------------:|:------------:|:------------:|:--------:|
| BP00004 | Northeast | Transit Station | $79,840         | $15,800      | $15,960      | +$160    |
| SH00010 | Southeast | Airport         | $74,720         | $14,900      | $14,940      | +$40     |
| WA00001 | Northeast | Retail          | $74,140         | $14,500      | $14,820      | +$320    |
| SE00008 | Southeast | Bank Branch     | $70,540         | $14,100      | $14,100      | $0       |
| SH00015 | Midwest   | Bank Branch     | $69,280         | $13,850      | $13,860      | $0       |
| WA00016 | Southwest | Retail          | $63,680         | $12,600      | $12,740      | +$140    |
| WA00006 | Southeast | Retail          | $62,560         | $12,400      | $12,520      | +$120    |

**Operational Insight:** BP00004 — a Transit Station in the Northeast — is the single most critical terminal in the network. It leads all ATMs in total cash withdrawn at $79,840 while also exceeding its daily target by $160. This machine should be the first priority for replenishment scheduling and cash level monitoring.

---

### 4. Regional Market Share with Network Totals (Subquery)

Calculates each region's percentage contribution to total network withdrawal volume using a subquery to derive the network total dynamically.

```sql
SELECT
    r.region,
    r.total_cash_withdrawn_usd,
    ROUND(
        r.total_cash_withdrawn_usd * 100.0 /
        (SELECT SUM(total_cash_withdrawn_usd) FROM regional_cash_demand), 1
    ) AS network_share_pct
FROM regional_cash_demand r
ORDER BY network_share_pct DESC;
```

| Region    | Total Withdrawn | Network Share |
|-----------|:---------------:|:-------------:|
| Northeast | $296,280        | 23.6%         |
| Southwest | $281,860        | 22.4%         |
| Southeast | $273,000        | 21.7%         |
| Midwest   | $225,160        | 17.9%         |
| West      | $179,900        | 14.3%         |

**Operational Insight:** The West region controls just 14.3% of network volume — the lowest market share. This suggests an opportunity to either reduce cash replenishment frequency in this region or investigate whether lower-performing terminals need to be relocated to higher-traffic sites.

---

### 5. Location Type Performance Ranking (Window Function)

Ranks withdrawal performance by location type to identify which venue categories drive the most ATM activity — informing future ATM placement strategy.

```sql
SELECT
    location_type,
    COUNT(DISTINCT atm_terminal_id) AS atm_count,
    SUM(total_cash_withdrawn) AS total_withdrawn,
    ROUND(AVG(total_cash_withdrawn), 0) AS avg_per_atm,
    RANK() OVER (ORDER BY SUM(total_cash_withdrawn) DESC) AS location_rank
FROM highest_withdrawal_atms
GROUP BY location_type;
```

| Location Type   | ATM Count | Total Withdrawn | Avg Per ATM | Rank |
|-----------------|:---------:|:---------------:|:-----------:|:----:|
| Bank Branch     | 3         | $212,300        | $70,767     | #1   |
| Transit Station | 1         | $79,840         | $79,840     | #2   |
| Airport         | 2         | $148,180        | $74,090     | #3   |
| Retail          | 3         | $200,380        | $66,793     | #4   |

**Operational Insight:** Bank Branch locations generate the highest total volume across the top-performing ATM set. However, Transit Station ATMs average the highest withdrawal volume *per machine* at $79,840 — making them the most individually productive terminal type in the network. Placement strategy should prioritize transit and airport locations for maximum per-unit performance.

---

## 🛠️ SQL Skills Demonstrated

| Skill | Applied In |
|-------|------------|
| Multi-table `JOIN` | Query 3 — linking withdrawal volume to variance data |
| `GROUP BY` + `ORDER BY` | Queries 1, 5 — regional and location aggregations |
| `SUM`, `COUNT`, `AVG`, `ROUND` | All queries |
| `CASE WHEN` | Query 2 — performance status classification |
| Subquery | Query 4 — dynamic network total calculation |
| Window Function — `RANK()` | Query 5 — location type ranking |
| Percentage Calculation | Queries 1, 4 — regional network share |

---

## 📈 Dashboard

![ATM Network Dashboard](atm_network_dashboard.png)

---

## 📁 Dataset Components

| File | Description |
|------|-------------|
| `regional_cash_demand.csv` | Total withdrawal volume by region |
| `highest_withdrawal_atms.csv` | Top 10 ATM terminals by total cash withdrawn |
| `cash_target_variance.csv` | Daily target vs. actual performance per terminal |

---

## 📖 Data Dictionary

| Field | Description |
|-------|-------------|
| `atm_terminal_id` | Unique ATM terminal identifier |
| `region` | Geographic service region |
| `location_type` | ATM venue category (Retail, Airport, Transit Station, etc.) |
| `portfolio_tier` | Operational priority tier (Platinum, BB, Standard) |
| `avg_daily_withdrawal_target` | Expected average daily withdrawal volume |
| `actual_avg_withdrawal` | Observed average daily withdrawal volume |
| `variance` | Difference between actual and target withdrawal |
| `total_cash_withdrawn` | Total cash withdrawn across the analysis period |

---

## 🔮 Future Enhancements

- Introduce time-series transaction data for trend analysis
- Build predictive cash demand forecasting model
- Optimize replenishment schedules using variance patterns
- Expand portfolio tier analysis across full network

---

## 👤 About the Author

**Sean Codner** — Operations & Data Analyst
Houston, Texas

Background in ATM network operations at **Cardtronics**, supporting performance monitoring across a network of 45,000+ machines nationwide. This project applies that operational experience to a structured multi-table SQL analysis framework.

**Connect:**
- 🔗 [LinkedIn](https://linkedin.com/in/sean-codner-aa60822b)
- 💻 [GitHub](https://github.com/SEANSKIDATA)

---

*Tools used: MySQL · SQL · Google Sheets · GitHub*


