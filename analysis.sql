-- ============================================================
-- Sales Performance Dashboard — SQL Analysis
-- Tool: SQLite / PostgreSQL / any SQL engine
-- Data: sales_data.csv (load into a table called `sales`)
-- ============================================================

-- ── 1. TOTAL REVENUE BY YEAR ──────────────────────────────
-- KPI: Year-over-Year revenue growth
SELECT
    Year,
    COUNT(*)                         AS total_deals,
    SUM(Revenue)                     AS total_revenue,
    ROUND(AVG(Revenue), 2)           AS avg_deal_value
FROM sales
WHERE Status = 'Closed Won'
GROUP BY Year
ORDER BY Year;


-- ── 2. REVENUE BY REGION ─────────────────────────────────
-- KPI: Which regions are driving the most revenue?
SELECT
    Region,
    COUNT(*)                                        AS deals_won,
    ROUND(SUM(Revenue), 2)                          AS total_revenue,
    ROUND(SUM(Revenue) * 100.0 / SUM(SUM(Revenue)) OVER (), 1) AS revenue_pct
FROM sales
WHERE Status = 'Closed Won'
GROUP BY Region
ORDER BY total_revenue DESC;


-- ── 3. TOP SALES REPS BY REVENUE ─────────────────────────
SELECT
    Sales_Rep,
    COUNT(*)                    AS deals_won,
    ROUND(SUM(Revenue), 2)      AS total_revenue,
    ROUND(AVG(Revenue), 2)      AS avg_deal_size
FROM sales
WHERE Status = 'Closed Won'
GROUP BY Sales_Rep
ORDER BY total_revenue DESC
LIMIT 5;


-- ── 4. WIN RATE BY PRODUCT ───────────────────────────────
-- KPI: Which products close most reliably?
SELECT
    Product,
    COUNT(*)                                                   AS total_deals,
    SUM(CASE WHEN Status = 'Closed Won' THEN 1 ELSE 0 END)    AS won,
    ROUND(
        SUM(CASE WHEN Status = 'Closed Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                          AS win_rate_pct,
    ROUND(SUM(Revenue), 2)                                     AS total_revenue
FROM sales
GROUP BY Product
ORDER BY win_rate_pct DESC;


-- ── 5. MONTHLY REVENUE TREND ─────────────────────────────
-- KPI: Month-by-month trend for line chart in dashboard
SELECT
    Year,
    Month,
    ROUND(SUM(Revenue), 2)   AS monthly_revenue,
    COUNT(*)                 AS deals_won
FROM sales
WHERE Status = 'Closed Won'
GROUP BY Year, Month
ORDER BY Year,
    CASE Month
        WHEN 'January'   THEN 1  WHEN 'February'  THEN 2
        WHEN 'March'     THEN 3  WHEN 'April'     THEN 4
        WHEN 'May'       THEN 5  WHEN 'June'      THEN 6
        WHEN 'July'      THEN 7  WHEN 'August'    THEN 8
        WHEN 'September' THEN 9  WHEN 'October'   THEN 10
        WHEN 'November'  THEN 11 WHEN 'December'  THEN 12
    END;


-- ── 6. PIPELINE VALUE AT RISK ────────────────────────────
-- KPI: How much revenue is still in pipeline (not yet closed)?
SELECT
    Region,
    COUNT(*)                          AS open_deals,
    ROUND(SUM(Pipeline_Value), 2)     AS pipeline_value
FROM sales
WHERE Status = 'In Pipeline'
GROUP BY Region
ORDER BY pipeline_value DESC;


-- ── 7. QUARTERLY PERFORMANCE SUMMARY ────────────────────
SELECT
    Year,
    Quarter,
    ROUND(SUM(Revenue), 2)            AS quarterly_revenue,
    COUNT(*)                          AS deals_won,
    ROUND(AVG(Revenue), 2)            AS avg_deal_value
FROM sales
WHERE Status = 'Closed Won'
GROUP BY Year, Quarter
ORDER BY Year, Quarter;
