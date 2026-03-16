![ATM Network Analysis](atm_network_cover.png)

# ATM Network Analysis – Version 2

This project analyzes ATM withdrawal activity across a simulated national ATM network.

The analysis explores withdrawal demand by terminal, region, and location type to better understand ATM cash usage patterns and performance against expected targets.

## Project Objectives

• Identify high-performing ATM terminals  
• Analyze regional cash demand patterns  
• Evaluate variance between expected and actual withdrawals  

## Tools Used

SQL  
Google Sheets  
Data analysis and visualization

## Dataset Components

cash_target_variance.csv  
highest_withdrawal_atms.csv  
regional_cash_demand.csv  



## Operational Insight

This project demonstrates how ATM network operators can use analytics to monitor withdrawal demand and optimize cash replenishment strategies.

Note: The dataset represents a simulated operational snapshot of ATM network activity used for analytical demonstration purposes.

## Key Insights

### 1. Northeast Region Shows the Highest Cash Demand
The Northeast region recorded the largest total withdrawal volume at **$296,280**, indicating consistently strong ATM usage compared to other regions.

**Operational Meaning:**  
ATM operators should prioritize higher cash loading levels and more frequent replenishment cycles in this region to avoid machine downtime.

---

### 2. Transit and Airport Locations Drive High Withdrawal Activity
ATMs located in **transit stations and airports** appear among the top-performing terminals in total withdrawals.

**Operational Meaning:**  
High-traffic travel hubs generate predictable cash demand and should be monitored closely to ensure machines remain fully stocked during peak travel periods.

---

### 3. Several Terminals Exceed Their Daily Withdrawal Targets
Multiple ATMs show **positive variance between expected and actual withdrawals**, indicating stronger-than-anticipated usage.

**Operational Meaning:**  
These terminals may require revised withdrawal targets and adjusted replenishment schedules to better reflect actual customer demand.

---

### 4. Lower Performing Regions May Allow Replenishment Optimization
Regions such as the **West** recorded lower overall withdrawal totals compared to other regions.

**Operational Meaning:**  
Operators could potentially reduce replenishment frequency or cash allocation in these regions to improve operational efficiency.

## Dashboard

Example dashboard visualizations used to monitor ATM network performance.

## Example SQL Queries

```sql
SELECT region,
       SUM(total_cash_withdrawn_usd) AS total_cash_withdrawn
FROM regional_cash_demand
GROUP BY region
ORDER BY total_cash_withdrawn DESC;
```

## Future Enhancements

- Introduce time-series transaction data
- Forecast ATM cash demand
- Optimize replenishment schedules using predictive analytics

## Data Dictionary

atm_terminal_id – Unique ATM identifier  
region – Geographic service region  
location_type – ATM location category  
portfolio_tier – Operational priority tier  
avg_daily_withdrawal_target – Expected withdrawal volume  
actual_avg_withdrawal – Observed withdrawal volume  
variance – Difference between target and actual

