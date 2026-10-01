SELECT * FROM customer_churn;

-- Q1: Overall churn rate
SELECT ROUND(AVG(churn_risk_score) * 100, 2) AS churn_rate_pct,
COUNT(*) AS total_customer,
SUM(churn_risk_score) AS customer_churn
FROM customer_churn;

-- Q2: Churn rate & revenue at risk by membership tier (KEY INSIGHT)
SELECT 
	membership_category,
    COUNT(*) AS total_cusstomer,
    ROUND(AVG(churn_risk_score) * 100, 2) AS churn_rate_pct,
    ROUND(SUM(revenue_at_risk), 2) AS revenue_at_risk
FROM customer_churn
GROUP BY membership_category
ORDER BY revenue_at_risk DESC;

-- Q3: Churn by region
SELECT 
	region_category,
    COUNT(*) AS total_customer,
    ROUND(AVG(churn_risk_score) * 100, 2) AS churn_rate_pct,
    ROUND(SUM(revenue_at_risk), 2) AS revenue_at_risk
FROM customer_churn
GROUP BY region_category
ORDER BY revenue_at_risk DESC;

-- Q4: Impact of complaints on churn
SELECT 
	past_complaint,
    complaint_status,
    COUNT(*) AS total_customer,
    ROUND(AVG(churn_risk_score) * 100, 2) AS churn_rate_pct
FROM customer_churn
GROUP BY past_complaint, complaint_status
ORDER BY churn_rate_pct DESC;

-- Q5: Engagement level vs churn
SELECT 
	engagement_level,
    COUNT(*) AS total_customer,
    ROUND(AVG(churn_risk_score) * 100, 2) AS churn_rate_pct,
    ROUND(AVG(avg_transaction_value) * 100, 2) AS avg_transaction_value
FROM customer_churn
GROUP BY engagement_level
ORDER BY churn_rate_pct DESC;

-- Q6: Top negative feedback reasons among churned customers
SELECT 
	feedback,
    feedback_sentiment,
    COUNT(*) AS churned_customer,
    ROUND(SUM(revenue_at_risk), 2) AS revenue_at_risk
FROM customer_churn
WHERE churn_risk_score = 1
GROUP BY feedback, feedback_sentiment
ORDER BY churned_customer DESC;

-- Q7: Tenure bucket vs churn (loyalty analysis)
SELECT
	CASE
    WHEN tenure_month < 6 THEN '0-6 month'
    WHEN tenure_month < 12 THEN '6-12 month'
    WHEN tenure_month < 24 THEN '1-2 years'
    ELSE '2+ YEARS'
    END AS tenure,
    COUNT(*) AS churn_customer,
    ROUND(AVG(churn_risk_score) * 100, 2) AS churn_rate_pct
FROM customer_churn
GROUP BY tenure
ORDER BY churn_rate_pct DESC;


-- Q8: Referral impact on retention
SELECT
	joined_through_referral,
    COUNT(*) AS total_customer,
    ROUND(AVG(churn_risk_score) * 100, 2) AS churn_rate_pct
FROM customer_churn
GROUP BY joined_through_referral
ORDER BY churn_rate_pct DESC;

-- Q9: Top high-value churned customers (retention priority list)
SELECT
	security_no,
    membership_category,
    avg_transaction_value,
    tenure_month,
    feedback,
    complaint_status
FROM customer_churn
WHERE churn_risk_score = 1
ORDER BY avg_transaction_value DESC
LIMIT 100;