-- 1. Top 5 funds by latest AUM
SELECT f.fund_name, a.aum
FROM fact_aum a JOIN dim_fund f ON a.fund_key=f.fund_key
WHERE a.date_key=(SELECT MAX(date_key) FROM fact_aum)
ORDER BY a.aum DESC LIMIT 5;

-- 2. Average NAV per month
SELECT d.year, d.month, f.fund_name, AVG(n.nav) AS avg_nav
FROM fact_nav n JOIN dim_date d ON n.date_key=d.date_key
JOIN dim_fund f ON n.fund_key=f.fund_key
GROUP BY d.year,d.month,f.fund_name ORDER BY d.year,d.month;

-- 3. SIP year-over-year growth (by transaction amount)
WITH yearly AS (
 SELECT d.year, SUM(t.amount) AS sip_amount
 FROM fact_transactions t JOIN dim_date d ON t.date_key=d.date_key
 WHERE t.transaction_type='SIP' GROUP BY d.year
)
SELECT year, sip_amount,
       LAG(sip_amount) OVER (ORDER BY year) AS previous_year,
       ROUND(100.0*(sip_amount-LAG(sip_amount) OVER (ORDER BY year)) /
         NULLIF(LAG(sip_amount) OVER (ORDER BY year),0),2) AS yoy_growth_pct
FROM yearly;

-- 4. Transactions by state
SELECT state, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM fact_transactions GROUP BY state ORDER BY transaction_count DESC;

-- 5. Funds with expense ratio below 1%
SELECT fund_name, expense_ratio FROM dim_fund
WHERE expense_ratio < 1.0 ORDER BY expense_ratio;

-- 6. NAV latest per fund
SELECT f.fund_name, n.nav, d.full_date
FROM fact_nav n JOIN dim_fund f ON n.fund_key=f.fund_key
JOIN dim_date d ON n.date_key=d.date_key
WHERE (n.fund_key,n.date_key) IN
 (SELECT fund_key,MAX(date_key) FROM fact_nav GROUP BY fund_key);

-- 7. Average annual return by fund
SELECT f.fund_name, AVG(p.return_1y) AS avg_1y_return
FROM fact_performance p JOIN dim_fund f ON p.fund_key=f.fund_key
GROUP BY f.fund_name ORDER BY avg_1y_return DESC;

-- 8. Transaction mix by type
SELECT transaction_type, COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM fact_transactions GROUP BY transaction_type;

-- 9. KYC status summary
SELECT kyc_status, COUNT(*) AS customers_or_transactions
FROM fact_transactions GROUP BY kyc_status ORDER BY customers_or_transactions DESC;

-- 10. Funds flagged for performance anomalies
SELECT f.fund_name, p.return_1y, p.return_3y, p.return_5y, p.expense_ratio
FROM fact_performance p JOIN dim_fund f ON p.fund_key=f.fund_key
WHERE p.anomaly_flag=1;
