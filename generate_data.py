"""
generate_data.py
Generates realistic fake sales data for the Sales Performance Dashboard project.
Run this script first before opening the Power BI / Excel files.
"""

import csv
import random
from datetime import date, timedelta

random.seed(42)

REGIONS = ["North", "South", "East", "West", "Central"]
PRODUCTS = ["Enterprise Suite", "Pro Plan", "Starter Pack", "Add-On Bundle", "Support Contract"]
REPS = [
    "Alice Johnson", "Bob Martinez", "Carol Lee", "David Kim",
    "Emma Davis", "Frank Patel", "Grace Chen", "Henry Brooks"
]
STATUSES = ["Closed Won", "Closed Won", "Closed Won", "Closed Lost", "In Pipeline"]

def random_date(start, end):
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days))

start_date = date(2022, 1, 1)
end_date = date(2023, 12, 31)

rows = []
for i in range(1, 1001):
    region = random.choice(REGIONS)
    product = random.choice(PRODUCTS)
    rep = random.choice(REPS)
    status = random.choice(STATUSES)
    deal_date = random_date(start_date, end_date)
    base_price = {"Enterprise Suite": 12000, "Pro Plan": 4500, "Starter Pack": 900,
                  "Add-On Bundle": 2200, "Support Contract": 1800}[product]
    revenue = round(base_price * random.uniform(0.8, 1.4), 2) if "Won" in status else 0
    pipeline_value = round(base_price * random.uniform(0.9, 1.2), 2) if status == "In Pipeline" else 0

    rows.append({
        "Deal_ID": f"D{i:04d}",
        "Date": deal_date.strftime("%Y-%m-%d"),
        "Year": deal_date.year,
        "Month": deal_date.strftime("%B"),
        "Quarter": f"Q{(deal_date.month - 1) // 3 + 1}",
        "Region": region,
        "Product": product,
        "Sales_Rep": rep,
        "Status": status,
        "Revenue": revenue,
        "Pipeline_Value": pipeline_value,
        "Deal_Size": "Large" if base_price >= 10000 else ("Medium" if base_price >= 2000 else "Small")
    })

with open("sales_data.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=rows[0].keys())
    writer.writeheader()
    writer.writerows(rows)

print(f"Generated {len(rows)} rows -> sales_data.csv")

# --- Summary stats (mirrors what the dashboard shows) ---
won = [r for r in rows if r["Status"] == "Closed Won"]
total_revenue = sum(r["Revenue"] for r in won)
print(f"\nTotal Revenue (Closed Won): ${total_revenue:,.2f}")
print(f"Total Deals Won: {len(won)}")
print(f"Win Rate: {len(won)/len(rows)*100:.1f}%")

by_region = {}
for r in won:
    by_region[r["Region"]] = by_region.get(r["Region"], 0) + r["Revenue"]
print("\nRevenue by Region:")
for region, rev in sorted(by_region.items(), key=lambda x: -x[1]):
    print(f"  {region}: ${rev:,.2f}")
