
WITH transaction_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        DATEDIFF(MAX(created_at), MIN(created_at)) / 30.0 AS active_months
    FROM savings_savingsaccount
    GROUP BY owner_id
),
monthly_frequency AS (
    SELECT 
        owner_id,
        CASE 
            WHEN active_months < 1 THEN 1
            ELSE ROUND(active_months, 2)
        END AS months,
        total_transactions,
        ROUND(total_transactions / 
              CASE 
                  WHEN active_months < 1 THEN 1 
                  ELSE active_months 
              END, 2) AS transactions_per_month
    FROM transaction_summary
),
categorized AS (
    SELECT 
        CASE 
            WHEN transactions_per_month >= 10 THEN 'High Frequency'
            WHEN transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        transactions_per_month
    FROM monthly_frequency
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(transactions_per_month), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;
