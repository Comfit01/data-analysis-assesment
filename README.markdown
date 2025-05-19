This assessment evaluates SQL proficiency using a simulated financial dataset. Below are detailed explanations for each query along with any assumptions or challenges encountered.

## Assessment_Q1.sql - High-Value Customers with Multiple Products

**Approach:**
I identify customers who:
- Have at least one **funded savings plan** (`is_regular_savings = 1`, `confirmed_amount > 0`)
- Have at least one **funded investment plan** (`is_a_fund = 1`, `confirmed_amount > 0`)
- Are ranked by total deposits (converted from Kobo to Naira)

**Query Summary:**
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan` on `owner_id`
- Filtered for funded plans only
- Grouped by customer and aggregated counts and deposits

**Challenge:**
- Clarified that “confirmed_amount” refers to inflow, and amounts are in Kobo (converted to Naira by dividing by 100).

## Assessment_2.sql - Transaction Frequency Analysis

**Approach:**
- Counted total savings transactions per customer
- Calculated the number of active months using `DATEDIFF(MAX(created_at), MIN(created_at))`
- Derived average monthly transactions and categorized them

**Query Summary:**
- Three-level CTE: summarize transactions → calculate frequency → categorize
- Grouped final results by frequency category and calculated average per group

**Challenge:**
- Customers with less than one month of activity were floored to 1 month to avoid divide-by-zero errors

## Assessment_3.sql - Account Inactivity Alert

**Approach:**
Identified accounts (savings or investment) with no inflow transactions in the last 365 days.

**Query Summary:**
- Queried both `savings_savingsaccount` and `plans_plan` for latest `created_at`
- Calculated `inactivity_days` using `DATEDIFF(CURRENT_DATE, last_transaction_date)`
- Used `UNION` to merge savings and investment account results

**Challenge:**
- Some plans may lack activity data — ensured only those with a `MAX(created_at)` are included

## Assessment_4.sql - Customer Lifetime Value (CLV) Estimation

**Approach:**
Calculated simplified CLV using:
- Tenure (months since signup)
- Total transactions
- Estimated average profit per transaction

**Formula:**
CLV = (total_transactions / tenure_months) * 12 * (0.001 * avg_transaction_value)

**Query Summary:**
- Used `TIMESTAMPDIFF` to calculate tenure
- Grouped transactions by user to get count and average amount
- Applied formula and ordered by CLV

**Challenge:**
- Handled potential divide-by-zero by excluding customers with zero tenure

## General Notes

- All amount fields are stored in Kobo and were converted to Naira