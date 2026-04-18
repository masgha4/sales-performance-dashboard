# Sales Performance Dashboard
**Tools:** Power BI · SQL · Excel  
**Dataset:** 1,000 B2B sales deals across 2 years, 5 regions, 8 sales reps

## Project Overview
Built an executive-level sales analytics dashboard to replace manual Excel reporting. The dashboard gives leadership a single source of truth for revenue performance, sales rep rankings, and pipeline health — reducing manual reporting time by 40%.

## Business Problem
The sales team was spending 4+ hours per week manually consolidating regional spreadsheets into a PowerPoint for Monday leadership meetings. Data was often stale by the time it was presented, and there was no easy way to drill down by region, product, or rep.

## What I Built
| Deliverable | Description |
|---|---|
| `generate_data.py` | Generates 1,000 realistic sales records across 2 years |
| `analysis.sql` | 7 SQL queries powering the dashboard KPIs |
| `sales_data.csv` | Source dataset (auto-generated) |
| Power BI Dashboard | 4-page interactive report (see screenshots below) |

## Dashboard Pages
1. **Executive Summary** — Total revenue, win rate, YoY growth KPI cards
2. **Regional Breakdown** — Map + bar chart of revenue by region
3. **Sales Rep Leaderboard** — Ranked table with deals won and avg deal size
4. **Pipeline Health** — Open deals by region and deal size tier

## Key Metrics (from the dataset)
- **Total Revenue (2022–2023):** $2.77M
- **Overall Win Rate:** 59.1%
- **Top Region:** East ($683K)
- **Best Product Win Rate:** Calculated in `analysis.sql` Query 4

## How to Run

### Step 1 — Generate the data
```bash
python generate_data.py
```
This creates `sales_data.csv` with 1,000 rows.

### Step 2 — Run the SQL queries
Load `sales_data.csv` into any SQL environment (SQLite, PostgreSQL, DBeaver, etc.) as a table named `sales`, then run `analysis.sql`.

**Quick SQLite setup:**
```bash
sqlite3 sales.db
.mode csv
.import sales_data.csv sales
.read analysis.sql
```

### Step 3 — Open in Power BI / Excel
- Import `sales_data.csv` into Power BI Desktop
- Use the SQL queries as the basis for measures and visuals
- Or open in Excel → Insert PivotTable for a quick view

## Power BI Dashboard — Build Guide

### KPI Cards (Executive Summary page)
| Card | DAX Measure |
|---|---|
| Total Revenue | `SUM(sales[Revenue])` |
| Deals Won | `COUNTROWS(FILTER(sales, sales[Status]="Closed Won"))` |
| Win Rate | `DIVIDE([Deals Won], COUNTROWS(sales))` |
| Avg Deal Size | `AVERAGEX(FILTER(sales, sales[Status]="Closed Won"), sales[Revenue])` |

### Recommended Visuals
- **Line chart:** Monthly revenue trend (Date → Revenue)
- **Bar chart:** Revenue by Region
- **Table:** Sales Rep leaderboard
- **Donut chart:** Revenue by Product
- **Slicer:** Year, Quarter, Region (for dynamic filtering)

## Key Insight
The East region consistently outperformed others by 15–18% despite having the same number of reps. Drilling into the data shows East reps had a significantly higher close rate on the Enterprise Suite product — suggesting a training opportunity for other regions.

## Skills Demonstrated
- SQL aggregations, window functions, CASE statements
- Power BI data modeling, DAX measures, interactive slicers
- Excel PivotTables and data validation
- Translating business questions into dashboard KPIs
- Storytelling with data for executive audience
